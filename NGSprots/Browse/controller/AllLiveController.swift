//
//  AllLiveController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/25.
//

import UIKit
import MJRefresh

class AllLiveController: BaseViewController {
    
    var typeTitle = "Live Events"
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    private var classArray = [("Football","Soccer_icon","1","1"), ("Basketball","Basketball_icon","3","0"), ("Tennis","Tennis_icon","5","0"),("Ice Hockey","Ice Hockey_icon","2","0"),
                              ("Football","Soccer_icon","1","0"), ("Basketball","Basketball_icon","3","0"), ("Tennis","Tennis_icon","5","0"),("Ice Hockey","Ice Hockey_icon","3","0")]
    private var classTitleArr1 = ["IceHockey","Basketball","TableTennis","E-Basketball"]
    
    private var curPage = 1
    //每页显示数量
    private var limitSize = 30
    private var isRequesting = false
    var matchPlayType = "1"
    private var sportId = "1"
    //头部赛事种类model
    var sportsModel : SportsModel?
    
    private var insertTimers:Timer?
    private var orderTimers:Timer?
    private var opodTimers:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }


    private func setUI(){
        self.addNavBar(.white)
        self.navTitleColor = .black
        title = typeTitle
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = UICollectionView.ScrollDirection.horizontal
        classCollectionView.setCollectionViewLayout(layout1, animated: true)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.alwaysBounceHorizontal = true
        classCollectionView.showsHorizontalScrollIndicator = false
        classCollectionView.register(UINib(nibName: "HLClassCell", bundle: nil), forCellWithReuseIdentifier: "HLClassCell")
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout2.minimumLineSpacing = 0
        layout2.minimumInteritemSpacing = 0
        listCollectionView.setCollectionViewLayout(layout2, animated: true)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.alwaysBounceVertical = true
        listCollectionView.showsVerticalScrollIndicator = false
        listCollectionView.register(UINib(nibName: "BasketballListCell", bundle: nil), forCellWithReuseIdentifier: "BasketballListCell")
        listCollectionView.register(UINib(nibName: "FavouritesNoDataCell", bundle: nil), forCellWithReuseIdentifier: "FavouritesNoDataCell")
        listCollectionView.register(UINib(nibName: "OtherSportViewCell", bundle: nil), forCellWithReuseIdentifier: "OtherSportViewCell")
        listCollectionView.register(UINib(nibName: "BrowseGameCell", bundle: nil), forCellWithReuseIdentifier: "BrowseGameCell")
        listCollectionView.register(UINib(nibName: "PortraitViewCell", bundle: nil), forCellWithReuseIdentifier: "PortraitViewCell")
        listCollectionView.register(UINib(nibName: "OtherSportViewCell", bundle: nil), forCellWithReuseIdentifier: "OtherSportViewCell")
        listCollectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(lmlviewHeaderRefresh))
        listCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(lmlviewFooterRefresh))
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTime), name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
        self.view.setNewBet()
        self.view.setTipsView()

        //countDown(interval:1)
    }
    
    @objc func invalidateTime(){
        orderTimers?.invalidate()
        opodTimers?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.setTipsDelegate(vc: self)
        if matchPlayType == "1"{
            requestAllSport(type: 3)
        }else{
            requestAllSport(type: 2)
        }
        matchStatisticalRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.insertTimers?.invalidate()
        invalidateTime()
    }
    
    @objc func lmlviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        curPage = 1
        matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
    }
    
    @objc func lmlviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        self.curPage += 1
        matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
    }
    
    private func roadClassData(sl: [slModel]){
        classArray.removeAll()
        for model in sl{
            if "\(model.ty ?? 0)" == self.matchPlayType{
                var index = 0
                for ssl in model.ssl ?? [sslModel](){
                    let sid:Int = ssl.sid ?? 0
                    let c:Int = ssl.c ?? 0
                    if c > 0{
                        if "\(sid)" == self.sportId{
                            classArray.append((getSportsName(Id: sid),"Soccer_icon", "\(sid)", "1"))
                            index = 0
                        }else{
                            classArray.append((getSportsName(Id: sid),"Soccer_icon", "\(sid)", "0"))
                            index += 1
                        }
                    }
                }
                if classArray.count > 0{
                    if index == classArray.count{
                        classArray[0].3 = "1"
                        self.sportId = classArray[0].2
                    }
                }
            }
            
//            if model.ty ?? 0 == 1{
//                for ssl in model.ssl ?? [sslModel](){
//                    let c:Int = ssl.c ?? 0
//                    if c > 0{
//                        liveNumber = liveNumber + c
//                    }
//                }
//            }
        }
        if classArray.count > 1{
            if self.sportsModel != nil{
                if (self.sportsModel?.all?.count ?? 0) > 0{
                    var index = 0
                    for item in self.sportsModel?.all ?? [SportsItemModel](){
                        var index2 = 0
                        if index < classArray.count{
                            for item2 in classArray{
//                                if getSportsID(type: item.name ?? "") == item2.2{
//                                    classArray.insert(item2, at: index)
//                                    classArray.remove(at: index2 + 1)
//                                    index += 1
//                                    break
//                                }
                                if item.games?.count ?? 0 > 0{
                                    if "\(item.games?[0].sportId ?? 0)" == item2.2{
                                        classArray.insert(item2, at: index)
                                        classArray.remove(at: index2 + 1)
                                        index += 1
                                        break
                                    }
                                }
                                index2 += 1
                            }
                        }
                    }
                }
            }else{
                if classArray[0].2 == "1"{
                    var index = 0
                    for md in classArray{
                        if md.2 == "3"{
                            classArray.insert(md, at: 1)
                            classArray.remove(at: index + 1)
                            break
                        }
                        index += 1
                    }
                }
            }
        }
        classCollectionView.reloadData()
        matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
        if self.matchPlayType == "1"{
            self.loadUITimers()
        }else{
            self.insertTimers?.invalidate()
        }
    }
    
    private var listModels = Array<recordModel>()
    private var listModelsOld = Array<recordModel>()
    private var time = 0
    private func loadUI(models: [recordModel]){
        for md in models{
            if self.matchPlayType == "3"{
                time = Int(Date().timeIntervalSince1970*1000)
                if md.bt ?? 0 <= time + 3600000{
                    listModels.append(md)
                }
            }else{
                listModels.append(md)
            }
        }
        if listModels.count > 0{
            self.listCollectionView.hiddenEmptyView()
            listCollectionView.reloadData()
        }else{
            self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MMM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }
    
    private func miaozhuanLanqiu(time: Int) -> String{
        if time == 0{
            return "00:00"
        }
        let mm = "\(time/60)"
        let ss = "\(time%60)"
        return "\(mm.count > 1 ? mm : ("0" + mm))" + ":" + "\(ss.count > 1 ? ss : ("0" + ss))"
    }
    
    private func virtualMiaozhuanLanqiu(time: Int) -> (String,String){
        if time == 0{
            return ("00","00")
        }
        let mm = "\(time/60)"
        let ss = "\(time%60)"
        return ("\(mm.count > 1 ? mm : ("0" + mm))","\(ss.count > 1 ? ss : ("0" + ss))")
    }
    
    private func getgundongIndex(id: Int) -> Int{
        if gundongIndexArray.count > 0{
            var index = 0
            for item in gundongIndexArray{
                if item.0 == id{
                    return gundongIndexArray[index].1
                 }
                index += 1
            }
            if index == gundongIndexArray.count{
                return 0
            }
        }
        return 0
    }
    
    private func loadOrderStatus(Id: String, model: opModel, money: String){
        self.orderTimers?.invalidate()
        self.orderTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            self.loadOrderGetStakeOrderStatus(orderIds: [Id], model: model, money: money)
        })
    }
    
    private func loadOPOD(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        self.opodTimers?.invalidate()
        self.opodTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            //print("刷新赔率")
            self.loadOrderBatchBetMatchMarketOfJumpLine2(param: param, model: model)
        })
    }
    
    private func loadUITimers(){
        self.insertTimers?.invalidate()
        if self.matchPlayType == "1"{
            self.insertTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(3), repeats: true, block: { (timer) in
                self.uploadUI()
            })
        }
    }
    
    private func uploadUI(){
        print("刷新")
        matchGetList2(current: "\(curPage)", size:"\(limitSize * (curPage))", type: self.matchPlayType, sportId: self.sportId)
    }
    
    var timeCount = 180
    func countDown(interval:TimeInterval) -> Void {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (timer) in
            if self.timeCount != 0 {
                self.timeCount -= 1
                let (fen,miao) = self.virtualMiaozhuanLanqiu(time: self.timeCount)
                self.title = "\(fen) : " + "\(miao)"
            }else if self.timeCount == 0 {
                timer.invalidate()
                self.title = "获取验证码"
            }
        });
    }


}

extension AllLiveController{
    //赛事统计matchStatistical
    private func matchStatisticalRequest(){
        var param = MatchDetailParam()
        param.languageType = "ENG"
        let api = wxApi.matchStatistical(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            //print("matchStatisticalRequest===\(data)")
            let result = RequestCallBackViewModel<matchStatisticalModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadClassData(sl: result?.data?.sl ?? [slModel]())
            }else{
                self.loadUI(models: [])
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.loadUI(models: [])
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //MARK: -获取所有sport
    func requestAllSport(type:Int){
        var param = BaseSystemParam()
        param.navType = type
        let api = wxApi.getAllSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                self.sportsModel = result?.data
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func getCollectGame(completion : @escaping(Array<CollectGameItemModel>)->Void){
        if Tool.getuserInfoModel() == nil{
            completion([])
            return
        }
        let isRequest : Bool? = UserDefaults.standard.value(forKey: IsNeedGetCollect) as? Bool
        if isRequest == true || isRequest == nil{
            let api = wxApi.getCollectGame
            AdHttpRequest(url: api, successCallBack: { data in
                print("------\(data)")
                self.hudHide()
                let result = RequestCallBackViewModel<CollectGameModel>.deserialize(from: data)
                if(result?.code == 0){
                    let model : CollectGameModel = result?.data ?? CollectGameModel()
                    let modelData = NSKeyedArchiver.archivedData(withRootObject: model.list)
                    UserDefaults.standard.set(false, forKey: IsNeedGetCollect)
                    UserDefaults.standard.set(modelData, forKey: CollectGameID)
                    UserDefaults.standard.synchronize()
                    completion(model.list ?? [])
                }else{
                    if Tool.getuserInfoModel() == nil{
                        UserDefaults.standard.set(false, forKey: IsNeedGetCollect)
                        UserDefaults.standard.synchronize()
                    }
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                    completion([])
                }
            }) { error in
                self.hudHide()
                self.showTextSB(error, dismissAfterDelay: 1.5)
                completion([])
            }
        }else{
            let data  = UserDefaults.standard.value(forKey: CollectGameID)
            var arr : Array<CollectGameItemModel> = []
            if data != nil{
                arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
            }
            completion(arr)
        }
    }
    
    //获取赛事列表信息
    private func matchGetList(current: String, size: String, type: String, sportId: String){
        self.getCollectGame (completion: { colletSportArr in
            self.showHUD(text: "Loading...")
            var param = MatchGetListParam()
            param.current = current
            param.size = size
            param.languageType = "ENG"
            param.type = type
            param.sportId = sportId
            param.orderBy = "0"
            if type == "0"{
                param.matchIds = []
                let data  = UserDefaults.standard.value(forKey: CollectGameID)
                var arr : Array<CollectGameItemModel> = []
                if data != nil{
                    arr  = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                }
                for i in 0..<arr.count{
                    let model = arr[i]
                    param.matchIds?.append("\(model.mId ?? 0)")
                }
            }
            let api = wxApi.matchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                self.hudHide()
                if self.listCollectionView.mj_header != nil{
                    self.listCollectionView.mj_header?.endRefreshing()
                }
                if self.listCollectionView.mj_footer != nil{
                    self.listCollectionView.mj_footer?.endRefreshing()
                }
                self.isRequesting = false
                if self.curPage == 1 {
                    self.listModels.removeAll()
                }
                var result = RequestCallBackViewModel<matchGetListModel>.deserialize(from: data)
                if(result?.code == 0){
                    //print("matchGetList===\(result?.data)")
                    for i in 0..<(result?.data?.records!.count ?? 0){
                        let model : recordModel = result?.data?.records![i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?.records![i].sctype = isCollect
                    }
                    self.loadUI(models: result?.data?.records ?? [recordModel]())
                    
                    let num: Int = result?.data?.total ?? 0
                    if self.curPage * self.limitSize < num{
                        self.listCollectionView.mj_footer?.endRefreshing()
                    }else{
                        self.listCollectionView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    self.loadUI(models: [])
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
                
            }) { (error) in
                self.hudHide()
                self.isRequesting = false
                if self.listCollectionView.mj_header != nil{
                    self.listCollectionView.mj_header?.endRefreshing()
                }
                if self.listCollectionView.mj_footer != nil{
                    self.listCollectionView.mj_footer?.endRefreshing()
                }
                self.loadUI(models: [])
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
    }
    
    func loadOrderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        self.showHUDNO()
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("result?.data===\(result?.data)")
                if result?.data?.bms?.count ?? 0 > 0{
                    if result?.data?.bms?[0].ss == 1{
                        self.view.showNewBetView(model: model)
                        self.view.setDelegate(view: self)
                        self.view.loadBms(bsmodel: result?.data?.bms?[0] ?? bmsModel())
                        self.loadOPOD(param: param, model: model)
                    }else if result?.data?.bms?[0].ss == -1{
                        self.showTextSB("Not available for sale", dismissAfterDelay: 1.5)
                    }else{
                        self.showTextSB("pause", dismissAfterDelay: 1.5)
                    }
                }else{
                    self.showTextSB("Do not bet", dismissAfterDelay: 1.5)
                }
                
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func loadOrderBatchBetMatchMarketOfJumpLine2(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("result?.data===\(result?.data)")
                if result?.data?.bms?.count ?? 0 > 0{
                    if result?.data?.bms?[0].ss == 1{
                        self.view.loadBms(bsmodel: result?.data?.bms?[0] ?? bmsModel())
                    }else if result?.data?.bms?[0].ss == -1{
                        self.opodTimers?.invalidate()
                    }else{
                        self.opodTimers?.invalidate()
                    }
                }else{
                    self.opodTimers?.invalidate()
                }
            }else{
                self.opodTimers?.invalidate()
            }
        }) { (error) in
            self.opodTimers?.invalidate()
        }
    }
    
    func loadOrderGetStakeOrderStatus(orderIds: [String], model: opModel, money: String){
        var param = StakeOrderStatusParam()
        param.languageType = "ENG"
        param.orderIds = orderIds
        let api = wxApi.orderGetStakeOrderStatus(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderGetStakeOrderStatusModel]>.deserialize(from: data)
            if(result?.code == 0){
                //print("result==OrderStatus==\(result?.data)")
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 4{
                        self.invalidateTime()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: money)
                    }else if st == 0 || st == 1{
                        if self.orderTimers == nil{
                            self.loadOrderStatus(Id: result?.data?[0].oid ?? "", model: model, money: money)
                        }
                    }else{
                        self.invalidateTime()
                        self.view.showCalculatorEndView(model: model, msg: result?.data?[0].rjs ?? "Lose a bet", money: money)
                    }
                }
            }else{
                self.invalidateTime()
                self.view.showCalculatorEndView(model: model, msg: result?.message ?? "Lose a bet", money: money)
            }
        }) { (error) in
            self.invalidateTime()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: money)
        }
    }
    
    func loadOrderBetSinglePass(param: singlePassParam, model: opModel){
        let api = wxApi.orderBetSinglePass(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderBetSinglePassResponseModel]>.deserialize(from: data)
            //print("loadOrderBetSinglePass===\(result?.data)")
            if(result?.code == 0){
                Tool.requestGetUserInfo{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "balance"), object: nil)
                }
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 0 || st == 1{
                        self.loadOrderStatus(Id: result?.data?[0].id ?? "", model: model, money: param.singleBetList?[0].unitStake ?? "0")
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }else if st == 4{
                        self.invalidateTime()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: param.singleBetList?[0].unitStake ?? "0")
                    }else{
                        self.invalidateTime()
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }
                }else{
                    self.invalidateTime()
                    self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
                }
            }else{
                self.invalidateTime()
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.invalidateTime()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
        }
    }
    
    private func matchGetList2(current: String, size: String, type: String, sportId: String){
        self.getCollectGame (completion: { colletSportArr in
            var param = MatchGetListParam()
            param.current = current
            param.size = size
            param.languageType = "ENG"
            param.type = type
            param.sportId = sportId
            param.orderBy = "0"
            if type == "0"{
                param.matchIds = []
                let data  = UserDefaults.standard.value(forKey: CollectGameID)
                let arr : Array<CollectGameItemModel> = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                for i in 0..<arr.count{
                    let model = arr[i]
                    param.matchIds?.append("\(model.mId ?? 0)")
                }
            }
            let api = wxApi.matchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                var result = RequestCallBackViewModel<matchGetListModel>.deserialize(from: data)
                if(result?.code == 0){
                    self.listModelsOld = self.listModels
                    self.listModels.removeAll()
                    
                    for i in 0..<(result?.data?.records!.count ?? 0){
                        let model : recordModel = result?.data?.records![i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?.records![i].sctype = isCollect
                    }
                    
                    self.loadUI(models: result?.data?.records ?? [recordModel]())
                }
            }) { (error) in}
        })
    }
    
}

extension AllLiveController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BasketballListCellDelegate, PortraitViewCellDelegate, NewStakeViewDelegate,NYTipsViewDelegate{
    func topUpAccount() {
        self.view.hiddenNewBetView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func settleAccounts(money: String, model: opModel) {
        var blmodel = betOptionListModel()
        blmodel.marketId = "\(model.mksId ?? 0)"
        blmodel.odds = model.od
        blmodel.oddsFormat = "1"
        blmodel.optionType = "\(model.ty ?? 0)"
        
        var sbmodel = singleBetListModel()
        sbmodel.unitStake = money
        sbmodel.oddsChange = "1"
        sbmodel.betOptionList = [blmodel]
        
        var param = singlePassParam()
        param.languageType = "ENG"
        param.currencyId = "20"
        param.singleBetList = [sbmodel]
        loadOrderBetSinglePass(param: param, model: model)
    }
    
    func clickLeftBtn() {
        self.view.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.view.hiddenTipsView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func footballListOd(model: opModel) {
        if Tool.getFBModel()?.token?.count ?? 0 == 0{
            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
            if balance < 600{
                self.view.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
            }else{
                if model.ss == 1{
                    var bmmodel = betMatchMarketListModel()
                    bmmodel.marketId = "\(model.mksId ?? 0)"
                    bmmodel.matchId = "\(model.recordsId ?? 0)"
                    bmmodel.oddsType = "1"
                    bmmodel.type = "\(model.ty ?? 0)"
                    
                    var param = BatchBetMatchMarketOfJumpLineParam()
                    param.languageType = "ENG"
                    param.currencyId = "20"
                    param.isSelectSeries = "false"
                    param.betMatchMarketList = [bmmodel]
                    self.loadOrderBatchBetMatchMarketOfJumpLine(param: param, model: model)
                }
            }
        }
    }
    
    func LMVGodetail(index: Int) {
        //进入详情页先获取一次收藏的game ID
        self.getCollectGame (completion: { [weak self] colletSportArr in
            let vc = MatchDetailsViewController()
            var item : recordModel?
            item = self!.listModels[index - 100]
            vc.titleStr = item?.lg?.na ?? ""
            vc.matchId = "\(item?.id ?? 0)"
            vc.isCollect = item?.sctype ?? false
            vc.beginTime = item?.bt
            vc.isVirtual = false
            self?.hidesBottomBarWhenPushed = true
            self!.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func popularVideoBtn(index: Int) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView{
            return classArray.count
        }
        return listModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HLClassCell", for: indexPath) as! HLClassCell
            let dic = classArray[indexPath.item]
            cell.titleLabel.text = dic.0
            if dic.3 == "0" {
                cell.bgLabel.backgroundColor = UIColor.hexColor(hex: "F5F6F9")
                cell.titleLabel.textColor = .hexColor(hex: "19263C")
                cell.logoimg.image = UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0))?.withTintColor(.hexColor(hex: "19263C"))
            }else{
                cell.bgLabel.backgroundColor = UIColor.hexColor(hex: "0CD664")
                cell.titleLabel.textColor = .white
                cell.logoimg.image = UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0))?.withTintColor(.hexColor(hex: "FFFFFF"))
            }
            return cell
        }
        
        var model = recordModel()
        var modelOld = recordModel()
        if indexPath.item < listModels.count{
            model = listModels[indexPath.item]
            if listModels.count == listModelsOld.count{
                modelOld = listModelsOld[indexPath.item]
            }
        }
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitViewCell", for: indexPath) as! PortraitViewCell
            if sportId == "3" && matchPlayType == "1"{
                cell.saidateil.isHidden = false
                if model.ms == 5{
                    var scoreStr = ""
                    var index = 0
                    if model.nsg?.count ?? 0 > 0{
                        for nsg in model.nsg ?? [nsgModel](){
                            if (nsg.pe == 3005 || nsg.pe == 3006 || nsg.pe == 3007 || nsg.pe == 3008) && nsg.tyg == 5{
                                if scoreStr.count > 0{
                                    scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }else{
                                    scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }
                                index += 1
                            }
                        }
                    }
                    if index == 0{
                        for nsg in model.nsg ?? [nsgModel](){
                            if (nsg.pe == 3003 || nsg.pe == 3004 || nsg.pe == 3009) && nsg.tyg == 5{
                                if scoreStr.count > 0{
                                    scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }else{
                                    scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }
                                index += 1
                            }
                        }
                    }
                    
                    if scoreStr.count > 0{
                        scoreStr = " (" + scoreStr + ")"
                    }
                    cell.saidateil.text = "including Overtime " + "\(index) Quarter, " + scoreStr
                }else{
                    cell.saidateil.text = "----"
                }
            }else{
                cell.saidateil.isHidden = true
            }
            
            cell.model = model
            cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            cell.titleLabel.text = model.lg?.na
            cell.numberLabel.text = "\(model.tms ?? 0)"
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            }
            
            if model.nsg?.count ?? 0 > 0{
                cell.leftScore.text = "\(model.nsg?[0].sc?[0] ?? 0)"
                cell.rightScore.text = "\(model.nsg?[0].sc?[1] ?? 0)"
            }else{
                cell.leftScore.text = "-"
                cell.rightScore.text = "-"
            }
            
            if model.ms == 5{
                cell.tipsImg.isHidden = false
                cell.timeLabel.isHidden = false
                cell.timeLabel.text = miaozhuanLanqiu(time: model.mc?.s ?? 0) + "  " + MatchPeriod(key: model.mc?.pe ?? 0)
                cell.dateLabel.isHidden = true
            }else{
                cell.tipsImg.isHidden = true
                cell.timeLabel.isHidden = true
                cell.dateLabel.isHidden = false
                cell.dateLabel.text = timeDate(time: "\((model.bt ?? 0)/1000)")
            }
            
            if model.vs?.m3u8SD != nil{
                cell.videoBtn.setImage(UIImage(named: "warn_icon-2"), for: .normal)
                cell.videoBtn.isHidden = false
            }else{
                if model.as?.count ?? 0 > 0{
                    cell.videoBtn.setImage(UIImage(named: "donghua_icon3"), for: .normal)
                    cell.videoBtn.isHidden = false
                }else{
                    cell.videoBtn.isHidden = true
                }
            }
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            if listModels.count == listModelsOld.count{
                cell.loadUIold(mgModels: modelOld.mg ?? [mgModel]())
            }
            
            if indexPath.section == 0{
                cell.detailBtn.tag = 100 + indexPath.row
            }else{
                cell.detailBtn.tag = 200 + indexPath.row
            }
            cell.delegate = self

            cell.collectBlock = {[weak self] isCollect in
                self!.listModels[indexPath.item].sctype = isCollect
                self!.listCollectionView.reloadData()
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketballListCell", for: indexPath) as! BasketballListCell
            cell.model = model
            cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            cell.titleLabel.text = model.lg?.na
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            }
            
            if model.nsg?.count ?? 0 > 0{
                cell.VSLabel.text = "-"
                cell.leftScore.text = "\(model.nsg?[0].sc?[0] ?? 0)"
                cell.rightScore.text = "\(model.nsg?[0].sc?[1] ?? 0)"
                cell.VSLabel2.isHidden = true
            }else{
                cell.leftScore.text = ""
                cell.rightScore.text = ""
                cell.VSLabel.text = ""
                cell.VSLabel2.isHidden = false
            }
            
            if model.ms == 5{
                var scoreStr = ""
                var index = 0
                if model.nsg?.count ?? 0 > 0{
                    for nsg in model.nsg ?? [nsgModel](){
                        if (nsg.pe == 3005 || nsg.pe == 3006 || nsg.pe == 3007 || nsg.pe == 3008) && nsg.tyg == 5{
                            if scoreStr.count > 0{
                                scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }else{
                                scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }
                            index += 1
                        }
                    }
                }
                if index == 0{
                    for nsg in model.nsg ?? [nsgModel](){
                        if (nsg.pe == 3003 || nsg.pe == 3004 || nsg.pe == 3009) && nsg.tyg == 5{
                            if scoreStr.count > 0{
                                scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }else{
                                scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }
                            index += 1
                        }
                    }
                }
                if scoreStr.count > 0{
                    scoreStr = " (" + scoreStr + ")"
                }
                cell.overtime.isHidden = false
                cell.saitime.text = MatchPeriod(key: model.mc?.pe ?? 0) + "  " + miaozhuanLanqiu(time: model.mc?.s ?? 0) + scoreStr
            }else{
                cell.overtime.isHidden = true
                cell.saitime.text = timeDate(time: "\((model.bt ?? 0)/1000)")
            }
            
            if model.vs?.m3u8SD != nil{
                cell.videoBtn.setImage(UIImage(named: "warn_icon-2"), for: .normal)
                cell.videoBtn.isHidden = false
            }else{
                if model.as?.count ?? 0 > 0{
                    cell.videoBtn.setImage(UIImage(named: "donghua_icon3"), for: .normal)
                    cell.videoBtn.isHidden = false
                }else{
                    cell.videoBtn.isHidden = true
                }
            }
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            if listModels.count == listModelsOld.count{
                cell.loadUIold(mgModels: modelOld.mg ?? [mgModel]())
            }
            
            cell.detailBtn.tag = 100 + indexPath.row
            cell.delegate = self
            cell.collectBlock = {[weak self] isCollect in
                self!.listModels[indexPath.item].sctype = isCollect
                self!.listCollectionView.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == classCollectionView{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == classCollectionView{
            let dic = classArray[indexPath.item]
            let labelW = Tool.getLabelWith(text: dic.0, font: UIFont.systemFont(ofSize: 10), labelH: 12)
            return CGSize(width: 35 + labelW, height: 20)
        }

        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            if sportId == "3" && matchPlayType == "1"{
                return CGSize(width: kScreenW - 20, height: 162)//纵向
            }
            return CGSize(width: kScreenW - 20, height: 150)
        }else{
            return CGSize(width: kScreenW - 20, height: 190)//横向
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView{
            var index = 0
            for _ in classArray {
                classArray[index].3 = "0"
                index += 1
            }
            classArray[indexPath.row].3 = "1"
            classCollectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            
            curPage = 1
            self.sportId = classArray[indexPath.row].2
            matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
        }
        
    }
    
    
    
        
        
}
