//
//  BrowseViewController.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/27.
//

import UIKit
import SDWebImage

class BrowseViewController: MyNavigationController {

    @IBOutlet weak var sousuo: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    
    private var classArray = [[("Live Events","Live Events_icon","67"),("Starting Soon","Starting Soon_icon","0")],
                              [],
                              [("Live Events","Live Events_icon","0"),("Starting Soon","Starting Soon_icon","0"),("World Cup 2026 Qualification Africa","Basketball_icon","0"),("UEFA European Under-19 …","Ice Hockey_icon","0"),("WC Qualiflcation,AFC","Basketball_icon","0"),("View All","Soccer_icon","0")],
                              [("Live Events","Live Events_icon","0"),("Starting Soon","Starting Soon_icon","0"),("Basketball","Basketball_icon","0"),("View All","Basketball_icon","0")],
                              [("Live Events","Live Events_icon","0"),("Starting Soon","Starting Soon_icon","0"),("Tennis","Tennis_icon","0"),("View All","Tennis_icon","0")],
                              [("Live Events","Live Events_icon","0"),("Starting Soon","Starting Soon_icon","0"),("Ice Hockey","Ice Hockey_icon","0"),("View All","Ice Hockey_icon","0")],
                              [("Live Events","Live Events_icon","0"),("Starting Soon","Starting Soon_icon","0"),("Cricket","Cricket_icon","0"),("View All","Cricket_icon","0")],
                              [],//[("Football","Soccer_icon","0"),("Basketball","Basketball_icon","0"),("Tennis","Tennis_icon","0"),("Ice Hockey","Ice Hockey_icon","0")],
                              []]
    
    //第四个id
    private var classHeads = [("Top Sports","",false,0),
                              ("Football","Soccer_icon",true,1),("Basketball","Basketball_icon",false,3),("Tennis","Tennis_icon",false,5),("Ice Hockey","Ice Hockey_icon",false,2),("Cricket","Cricket_icon",false,14),
                               ("All Sports","Soccer_icon",false,0),("Promotions","youhui_icon",false,0)]
    
    private var searchview:SearchView!
    private var searchendview:SearchEndView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popGestureClose()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popGestureOpen()
    }
    private var rbtn: UIButton!
    private func setUI() {
        sousuo.layer.borderColor = UIColor.hexColor(hex: "EDEDEF").cgColor
        sousuo.layer.borderWidth = 0.5
        sousuo.placeHolderColor = .hexColor(hex: "969696")
        
        //设置左侧放大镜
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 37, height: 22)
        let imgV = UIImageView()
        imgV.contentMode = .scaleToFill
        imgV.image = UIImage(named: "sousuo_icon")
        imgV.frame = CGRect(x: 15, y: 0, width: 22, height: 22)
        leftView.addSubview(imgV)
        sousuo.leftView = leftView
        //设置为空内容才显示放大镜，输入时不显示放大镜.unlessEditing  如要一直显示设置.always
        sousuo.leftViewMode = .always
        sousuo.contentVerticalAlignment = .center
        sousuo.returnKeyType = .search
        sousuo.delegate = self
        sousuo.addTarget(self, action: #selector(searchDidChange(textField:)), for: .editingChanged)
        sousuo.isUserInteractionEnabled = true
        //sousuo.clearButtonMode = .always
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: 37, height: 22)
        rbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        rightView.addSubview(rbtn)
        rbtn.setImage(UIImage(named: "qingchu2_icon"), for: .normal)
        rbtn.isHidden = true
        sousuo.rightView = rightView
        sousuo.rightViewMode = .always
        rbtn.addTarget(self, action: #selector(clickQingchu), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "BrowseViewCell", bundle: nil), forCellWithReuseIdentifier: "BrowseViewCell")
        collectionview.register(UINib(nibName: "BrowseReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BrowseReusableView")
        
        let HH = kStatusBarH + kNavigationBarH + 70
        searchendview = SearchEndView.init(frame: CGRect(x: 0, y: HH, width: kScreenW, height: kScreenH - HH))
        view.addSubview(searchendview)
        searchendview.isHidden = true
        searchendview.currentvc = self
        
        searchview = SearchView.init(frame: CGRect(x: 0, y: HH - 1, width: kScreenW, height: kScreenH - HH))
        view.addSubview(searchview)
        searchview.isHidden = true
        searchview.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTime), name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
        
        requestAllSport()
    }
    
    @objc func invalidateTime(){
        orderTimers?.invalidate()
        opodTimers?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classArray[0][0].2 = "\(liveNumber)"
        setRightBtn()
        collectionview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
    }
    
    @objc func clickQingchu(){
        sousuo.text = ""
        rbtn.isHidden = true
        searchview.isHidden = true
        sousuo.isEnabled = false
        sousuo.isEnabled = true
        searchendview.isHidden = true
        collectionview.isHidden = false
    }

    private var searchLists:Array<String>?
    
    private func loadSearchList(lists: [String]){
        //print("lists===\(lists)")
        searchLists = lists
        searchview.loadUI(arr: searchLists ?? Array())
    }
    
    private var orderTimers:Timer?
    private var opodTimers:Timer?
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
    
    private var hotlist = Array<hlsModel>()
    private func loadLeagueMatchs(models:[hlsModel], index: Int){
        hotlist = models
        if hotlist.count > 1{
            hotlist = hotlist.filter({ md in
                return md.hot == true
            })
            hotlist = hotlist.sorted { (md1:hlsModel , md2: hlsModel) in
                return md1.or! < md2.or!
            }
        }
        var i = 0
        for item in hotlist{
            //fb wnba数据有问题，过滤掉
            if !(item.na ?? "").contains("WNBA"){
                classArray[index + 1].insert((item.na ?? "", item.lurl ?? "", "\(item.id ?? 0)"), at: classArray[index + 1].count - 1)
                i += 1
                if i >= 3{
                    break
                }
            }
        }
        collectionview.reloadData()
    }
    
    private func loadData(models: [SportsItemModel]){
        if models.count > 0{
            classHeads.removeAll()
            classHeads.append(("Top Sports","",false,0))
            classArray.removeAll()
            classArray.append([("Live Events","Live Events_icon","\(liveNumber)"),("Starting Soon","Starting Soon_icon","0")])
            classArray.append([])
            for item in models{
                if item.games?.count ?? 0 > 0{
                    let dict = item.games?[0]
                    classHeads.append((item.name ?? "", getClassSportsImg(Id: dict?.sportId ?? 0), (dict?.sportId ?? 0) == 1 ? true : false, dict?.sportId ?? 0))
                    let arr = [("Live Events","Live Events_icon","\(dict?.sportId ?? 0)"),("Starting Soon","Starting Soon_icon","0"),("View All",getClassSportsImg(Id: dict?.sportId ?? 0),"0")]
                    classArray.append(arr)
                }
            }
            classHeads.append(("All Sports","Soccer_icon",false,0))
            classArray.append([])
            classHeads.append(("Promotions","youhui_icon",false,0))
            classArray.append([])
            //collectionview.reloadData()
            matchGetOnSaleLeagues(sportId: "\(classHeads[1].3)", type: "0", index: 1)
        }
    }
    
}

extension BrowseViewController {
    private func getSearchList(){
        self.showHUD(text: "Loading...")
        let api = (Tool.getFBModel()?.token?.count ?? 0) > 0 ? wxApi.searchRecentKeyList : wxApi.searchHotKeyList
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<searchModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadSearchList(lists: result?.data?.list ?? [String]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    private func searchKeyAdd(key: String){
        self.showHUD(text: "Loading...")
        var param = searchModel()
        param.key = key
        let api = wxApi.searchKeyAdd(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    private func searchKeyClear(){
        self.showHUD(text: "Loading...")
        let api = wxApi.searchKeyClear
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
                self.searchLists?.removeAll()
                self.searchview.loadUI(arr: self.searchLists ?? Array())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    private func searchKeyRemove(key: String){
        self.showHUD(text: "Loading...")
        var param = searchModel()
        param.key = key
        let api = wxApi.searchKeyRemove(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    private func getMatchQueryMatchByRecommend(key: String){
        self.getCollectGame (completion: { colletSportArr in
            self.showHUD(text: "Loading...")
            var param = queryMatchByRecommendParam()
            param.recommend = key
            let api = wxApi.matchQueryMatchByRecommend(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                self.hudHide()
                var result = RequestCallBackViewModel<[recordModel]>.deserialize(from: data)
                if(result?.code == 0){
                    for i in 0..<(result?.data?.count ?? 0){
                        let model : recordModel = result?.data?[i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?[i].sctype = isCollect
                    }
                    self.searchendview.loadUIData(models: result?.data ?? [recordModel]())
                }else{
                    self.searchendview.collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
            }) { (error) in
                self.searchendview.collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
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
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: param.singleBetList?[0].unitStake ?? "0")
                    }else{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }
                }else{
                    self.orderTimers?.invalidate()
                    self.opodTimers?.invalidate()
                    self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
                }
            }else{
                self.orderTimers?.invalidate()
                self.opodTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.opodTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
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
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 4{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: money)
                    }else if st == 0 || st == 1{
                        if self.orderTimers == nil{
                            self.loadOrderStatus(Id: result?.data?[0].oid ?? "", model: model, money: money)
                        }
                    }else{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: result?.data?[0].rjs ?? "Lose a bet", money: money)
                    }
                }
            }else{
                self.orderTimers?.invalidate()
                self.opodTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: result?.message ?? "Lose a bet", money: money)
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.opodTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: money)
        }
    }
    
    //获取联赛列表
    private func matchGetOnSaleLeagues(sportId: String, type: String, index: Int){
        CollectRequest.getCollectLeagueMatch (completion: { colletLeagueMatchArr in
            self.showHUD(text: "Loading...")
            var param = MatchGetOnSaleLeaguesParam()
            param.sportId = sportId
            param.type = type
            param.languageType = "ENG"
            let api = wxApi.matchGetOnSaleLeagues(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                self.hudHide()
                //print("matchGetOnSaleLeagues===\(data)")
                var result = RequestCallBackViewModel<[hlsModel]>.deserialize(from: data)
                if(result?.code == 0){
                    for i in 0..<(result?.data?.count ?? 0){
                        let model : hlsModel = result?.data![i] ?? hlsModel()
                        var isCollect = false
                        for j in 0..<colletLeagueMatchArr.count{
                            let leagueMatchModel = colletLeagueMatchArr[j]
                            if model.id == leagueMatchModel.lId{
                                isCollect = true
                            }
                        }
                        result?.data?[i].isCollect = isCollect
                    }
                    
                    self.loadLeagueMatchs(models: result?.data ?? [hlsModel](), index: index)
                }else{
                    if result?.code == 14010 {
                        Tool.gameAccessTokenRequest{
                            self.matchGetOnSaleLeagues(sportId: sportId, type: type, index: index)
                        }
                    }else{
                        self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                    }
                }
            }) { (error) in
                self.hudHide()
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
    }
    
    func requestAllSport(){
        var param = BaseSystemParam()
        param.navType = 5
        let api = wxApi.getAllSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadData(models: result?.data?.all ?? [SportsItemModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
}

extension BrowseViewController: UITextFieldDelegate, SearchViewdelegate, NewStakeViewDelegate {
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
    
    func clearSearchTitle() {
        searchKeyClear()
    }
    
    func delectSearchTitle(str: String) {
        searchKeyRemove(key: str)
    }
    
    func searchTitle(str: String) {
        sousuo.text = str
        rbtn.isHidden = false
        collectionview.isHidden = true
        searchendview.isHidden = false
        searchview.isHidden = true
        sousuo.resignFirstResponder()
        getMatchQueryMatchByRecommend(key: str)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        rbtn.isHidden = false
        searchview.isHidden = false

        getSearchList()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 > 2{
            rbtn.isHidden = false
            collectionview.isHidden = true
            searchendview.isHidden = false
            searchview.isHidden = true
            if (searchLists?.contains(textField.text!)) == false{
                searchKeyAdd(key: textField.text!)
            }
            getMatchQueryMatchByRecommend(key: textField.text!)
        }else{
            self.showTextSB("Search requires at least 3 characters.", dismissAfterDelay: 1.5)
            rbtn.isHidden = true
            searchview.isHidden = true
            collectionview.isHidden = false
            searchendview.isHidden = true
        }
        sousuo.resignFirstResponder()
        return true
    }
    
    @objc func searchDidChange(textField: UITextField) {
        rbtn.isHidden = false
        searchview.isHidden = false
        sousuo.text = textField.text
    }
}

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BrowseReusabledelegate{
    func browseRightBtn(btn: UIButton) {
        let sarr = [0,1,classHeads.count - 1,classHeads.count]
        if !sarr.contains(btn.tag - 100){
            if btn.isSelected{
                classHeads[btn.tag - 100 - 1].2 = true
                if classArray[btn.tag - 100].count <= 3{
                    matchGetOnSaleLeagues(sportId: "\(classHeads[btn.tag - 100 - 1].3)", type: "0", index: btn.tag - 100 - 1)
                }
            }else{
                classHeads[btn.tag - 100 - 1].2 = false
            }
            collectionview.reloadData()
        }
        
        if classHeads.count - 1 == btn.tag - 100{
            self.pushVC(vc: ALLViewController())
        }
        
        if classHeads.count == btn.tag - 100{
            self.pushVC(vc: PromotionsController())
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return classHeads.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section != 0 && !classHeads[section - 1].2{
            return 0
        }
        return classArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseViewCell", for: indexPath) as! BrowseViewCell
        cell.layer.cornerRadius = 0
        let dict = classArray[indexPath.section]
        cell.titleLabel.text = dict[indexPath.item].0
        if dict[indexPath.item].1.contains("http") {
            cell.logoimg.sd_setImage(with: URL(string: dict[indexPath.item].1), placeholderImage: UIImage(named: getClassSportsImg(Id: Int(dict[0].2) ?? 1)))
        }else{
            cell.logoimg.image = UIImage(named: dict[indexPath.item].1)
        }
        if indexPath.item == dict.count - 1{
            cell.lineLabel.isHidden = false
        }else{
            cell.lineLabel.isHidden = true
        }
        if indexPath.section == 0{
            cell.line2label.isHidden = false
        }else{
            cell.line2label.isHidden = true
        }
        if indexPath.section == 0{
            cell.layer.cornerRadius = 15
            if indexPath.item == 0{
                cell.numLabel.isHidden = false
                cell.numLabel.text = dict[indexPath.item].2
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else{
                cell.numLabel.isHidden = true
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            cell.leftW.constant = 15
        }else{
            cell.numLabel.isHidden = true
            cell.leftW.constant = 38
        }
        
        let arr = [classHeads.count - 2 ,classHeads.count - 1]
        if arr.contains(indexPath.section){
            if classHeads[indexPath.section-1].2{
                if indexPath.item == dict.count - 1{
                    cell.layer.cornerRadius = 15
                    cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                }else{
                    cell.layer.cornerRadius = 0
                }
            }else{
                cell.layer.cornerRadius = 0
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if section > 0 && section < classHeads.count - 2{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenW - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if kind == UICollectionView.elementKindSectionHeader{
            if indexPath.section == 0{
                return UICollectionReusableView()
            }
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BrowseReusableView", for: indexPath) as! BrowseReusableView
            reusableview.layer.cornerRadius = 0
            let arr = [classHeads.count - 1 ,classHeads.count]//最后两个
            if arr.contains(indexPath.section){
                reusableview.layer.cornerRadius = 15
                reusableview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }

            if indexPath.section == 1{
                reusableview.logoimg.isHidden = true
                reusableview.titleLabel1.isHidden = true
                reusableview.titleLabel2.isHidden = false
                reusableview.titleLabel2.text = classHeads[indexPath.section-1].0
                reusableview.rightBtn.isHidden = true
                reusableview.line1.isHidden = false
                reusableview.line2.isHidden = true
                reusableview.layer.cornerRadius = 15
                reusableview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else{
                reusableview.logoimg.isHidden = false
                reusableview.titleLabel1.isHidden = false
                reusableview.titleLabel2.isHidden = true
                reusableview.rightBtn.isHidden = false
                reusableview.logoimg.image = UIImage(named: classHeads[indexPath.section-1].1)
                reusableview.titleLabel1.text = classHeads[indexPath.section-1].0
                reusableview.line1.isHidden = true
                reusableview.line2.isHidden = !classHeads[indexPath.section-1].2
                if indexPath.section == (classHeads.count - 2){
                    if classHeads[classHeads.count - 3].2{
                        reusableview.layer.cornerRadius = 0
                    }else{
                        reusableview.layer.cornerRadius = 15
                        reusableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    }
                }
            }
            reusableview.bgbtn.tag = 100 + indexPath.section
            reusableview.delegate = self
            reusableview.bgbtn.isSelected = classHeads[indexPath.section-1].2
            reusableview.rightBtn.isSelected = classHeads[indexPath.section-1].2
            return reusableview
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: kScreenW - 20, height: 0)
        }else{
            return CGSize(width: kScreenW - 20, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            let vc = AllLiveController()
            if indexPath.item == 0{
                vc.typeTitle = "Live Events" + "（" + "\(liveNumber)）"
                vc.matchPlayType = "1"
            }else{
                vc.typeTitle = "Starting Soon"
                vc.matchPlayType = "3"
            }
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        
        let sarr = [0,classHeads.count - 1,classHeads.count]
        if !sarr.contains(indexPath.section){
            let itemarr = [0,1,classArray.count - 1]
            if itemarr.contains(indexPath.item){
                let vc = ChampionshipsViewController()
                vc.sportDict = (classHeads[indexPath.section-1].0,classHeads[indexPath.section-1].0,getSportsID(type: classHeads[indexPath.section-1].0),"0",false,"")
                vc.liveStr = "Live Events"
                vc.sportsStr = "Starting Soon"
                if indexPath.item == 1{
                    vc.leagueType = "3"
                }else{
                    vc.leagueType = "1"
                }
                self.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else{
                let dict = classArray[indexPath.section][indexPath.item]
                let vc = ChampionshipsListController()
                vc.leagueTitle = dict.0
                vc.leagueType = "0"
                vc.sportId = classArray[indexPath.section][0].2
                vc.leagueId = dict.2
                self.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }

    }
    
}


