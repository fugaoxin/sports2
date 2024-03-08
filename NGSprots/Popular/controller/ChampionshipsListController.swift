//
//  ChampionshipsListController.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/26.
//

import UIKit
import MJRefresh
import AVKit

class ChampionshipsListController: BaseViewController {

    
    @IBOutlet weak var collectionview: UICollectionView!
    
    private var curPage = 1
    private var limitSize = 30
    
    var leagueTitle = "Championships"
    var leagueType = "1"
    var sportId = "1"
    var leagueId = "1"
    
    var gameType = "FF"
    private var isRequesting = false
    
    private var orderTimers:Timer?
    private var opodTimers:Timer?
    
    private var insertTimers:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = leagueTitle
        self.addNavBar(.white)
        self.navTitleColor = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "BasketballListCell", bundle: nil), forCellWithReuseIdentifier: "BasketballListCell")
        collectionview.register(UINib(nibName: "VolleyballListCell", bundle: nil), forCellWithReuseIdentifier: "VolleyballListCell")
        collectionview.register(UINib(nibName: "FootballListCell", bundle: nil), forCellWithReuseIdentifier: "FootballListCell")
        collectionview.register(UINib(nibName: "PortraitViewCell", bundle: nil), forCellWithReuseIdentifier: "PortraitViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTime), name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
        collectionview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(lmlviewHeaderRefresh))
        collectionview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(lmlviewFooterRefresh))
    }
    
    private func loadVirtualUI(){
        self.insertTimers?.invalidate()
        self.insertTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            if self.gameType == "virtual"{
                self.virtualMatchGetList(leagueId:Int(self.leagueId) ?? 0)
            }else{
                if self.leagueType == "1"{
                    self.matchGetList(current: "\(self.curPage)", type: self.leagueType, sportId: self.sportId, leagueId: self.leagueId)
                }
            }
        })
    }
    
    @objc func lmlviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        if gameType == "virtual"{
            virtualMatchGetList(leagueId:Int(leagueId) ?? 0)
        }else{
            matchGetList(current: "\(curPage)", type: leagueType, sportId: sportId, leagueId: leagueId)
        }
    }
    
    @objc func lmlviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        if gameType == "virtual"{
            virtualMatchGetList(leagueId:Int(leagueId) ?? 0)
        }else{
            endRefreshing()
        }
    }
    
    @objc func invalidateTime(){
        orderTimers?.invalidate()
        opodTimers?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.setTipsDelegate(vc: self)
        if gameType == "virtual"{
            virtualMatchGetList(leagueId:Int(leagueId) ?? 0)
        }else{
            matchGetList(current: "\(curPage)", type: leagueType, sportId: sportId, leagueId: leagueId)
        }
        loadVirtualUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
    }
    
    private var listModels = Array<recordModel>()
    private func loadUI(models: [recordModel]){
        self.listModels = models
        if listModels.count > 0{
            collectionview.hiddenEmptyView()
            collectionview.reloadData()
        }else{
            collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
    }
    
    private func loadVirtualUI(models: [virtualMatchGetListModel]){
        self.listModels.removeAll()
        for items in models{
            for model in items.ms ?? [recordModel](){
                var newModel = model
                newModel.lurl = items.lurl
                newModel.na = items.na
                newModel.bnm = items.bnm
                newModel.cd = items.cd
                self.listModels.append(newModel)
            }
        }
        if listModels.count > 0{
            collectionview.hiddenEmptyView()
            collectionview.reloadData()
        }else{
            collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
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
    
    private func endRefreshing(){
        if self.collectionview.mj_header != nil{
            self.collectionview.mj_header?.endRefreshing()
        }
        if self.collectionview.mj_footer != nil{
            self.collectionview.mj_footer?.endRefreshing()
        }
        self.isRequesting = false
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

}

extension ChampionshipsListController{
    //获取赛事列表信息
    private func matchGetList(current: String, type: String, sportId: String, leagueId:String){
        self.getCollectGame (completion: { colletSportArr in
            //self.showHUD(text: "Loading...")
            var param = MatchGetListParam()
            param.current = current
            param.size = "\(self.limitSize)"
            param.languageType = "ENG"
            param.type = type
            if sportId.count > 0 && sportId != "看什么看,打爆眼睛"{
                param.sportId = sportId
            }
            param.orderBy = "1"
            if self.leagueTitle != "View All" {
                param.leagueIds = [leagueId]
            }
            let api = wxApi.matchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                //self.hudHide()
                self.endRefreshing()
                var result = RequestCallBackViewModel<matchGetListModel>.deserialize(from: data)
                if(result?.code == 0){
                    for i in 0..<(result?.data?.records?.count ?? 0){
                        let model : recordModel = result?.data?.records?[i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?.records?[i].sctype = isCollect
                    }
                    self.loadUI(models: result?.data?.records ?? [recordModel]())
                }else{
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
                
            }) { (error) in
                //self.hudHide()
                self.endRefreshing()
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
    }
    
    //virtual获取赛事列表信息
    private func virtualMatchGetList(leagueId:Int){
        self.getCollectGame (completion: { colletSportArr in
            //self.showHUD(text: "Loading...")
            var param = VirtualMatchGetListParam()
            param.languageType = "ENG"
            param.leagueId = leagueId
            let api = wxApi.virtualMatchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                //self.hudHide()
                self.endRefreshing()
                let result = RequestCallBackViewModel<[virtualMatchGetListModel]>.deserialize(from: data)
                if(result?.code == 0){
                    self.loadVirtualUI(models: result?.data ?? [virtualMatchGetListModel]())
                }else{
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
            }) { (error) in
                //self.hudHide()
                self.endRefreshing()
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
    }
    
    func loadOrderBetSinglePass(param: singlePassParam, model: opModel){
        let api = wxApi.orderBetSinglePass(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderBetSinglePassResponseModel]>.deserialize(from: data)
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
    
    func loadVirtualOrderBetSinglePass(param: VirtualSinglePassParam, model: opModel){
        let api = wxApi.virtualOrderSingleBet(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderBetSinglePassResponseModel]>.deserialize(from: data)
            if(result?.code == 0){
                Tool.requestGetUserInfo{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "balance"), object: nil)
                }
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 0 || st == 1{
                        self.loadOrderStatus(Id: result?.data?[0].id ?? "", model: model, money: param.options?[0].unitStake ?? "0")
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.options?[0].unitStake ?? "0")
                    }else if st == 4{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: param.options?[0].unitStake ?? "0")
                    }else{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.options?[0].unitStake ?? "0")
                    }
                }else{
                    self.orderTimers?.invalidate()
                    self.opodTimers?.invalidate()
                    self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.options?[0].unitStake ?? "0")
                }
            }else{
                self.orderTimers?.invalidate()
                self.opodTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.options?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.opodTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.options?[0].unitStake ?? "0")
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
    
    func loadOrderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        self.showHUDNO()
        let api = gameType == "virtual" ? wxApi.virtualOrderOddsCartRefresh(param: param) : wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
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
        let api = gameType == "virtual" ? wxApi.virtualOrderOddsCartRefresh(param: param) : wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
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
    
}

extension ChampionshipsListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FootballListCellDelegate, BasketballListCellDelegate, VolleyballListCellDelegate, NewStakeViewDelegate,NYTipsViewDelegate,PortraitViewCellDelegate{
    func topUpAccount() {
        self.view.hiddenNewBetView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func clickLeftBtn() {
        self.view.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.view.hiddenTipsView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func settleAccounts(money: String, model: opModel) {
        if gameType == "virtual"{
            var opmodel = optionsModel()
            opmodel.marketId = "\(model.mksId ?? 0)"
            opmodel.odds = model.od
            opmodel.oddsFormat = "1"
            opmodel.optionType = "\(model.ty ?? 0)"
            opmodel.unitStake = money
            
            var param = VirtualSinglePassParam()
            param.languageType = "ENG"
            param.currencyId = "20"
            param.oddsChange = "1"
            param.options = [opmodel]
            loadVirtualOrderBetSinglePass(param: param, model: model)
        }else{
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
        getCollectGame (completion: {_ in
            let item = self.listModels[index - 200]
            let vc = MatchDetailsViewController()
            vc.titleStr = item.lg?.na ?? ""
            vc.matchId = "\(item.id ?? 0)"
            vc.isCollect = item.sctype ?? false
            vc.beginTime = item.bt
            vc.gameType = self.gameType
            vc.isVirtual = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func popularVideoBtn(index: Int) {
        let item = listModels[index - 2000]
        if item.vs?.m3u8SD != nil{
            guard let playUrl = URL(string: item.vs?.m3u8SD ?? "") else {
                return
            }
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: playUrl)
            self.present(vc, animated: true) {
                vc.player?.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = listModels[indexPath.item]
        let imgbgstr = getSportsName(Id: model.sid ?? 0)
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitViewCell", for: indexPath) as! PortraitViewCell
            cell.saidateil.isHidden = true
            cell.model = model
            
            if gameType == "virtual"{
                cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.titleLabel.text = (model.na ?? "") + " (\(model.bnm ?? ""))"
                if model.ms == 5{
                    cell.tipsImg.isHidden = false
                    cell.timeLabel.isHidden = false
                    cell.timeLabel.text = "LIVE"
                    cell.dateLabel.isHidden = true
                }else{
                    cell.tipsImg.isHidden = true
                    cell.timeLabel.isHidden = true
                    cell.dateLabel.isHidden = false
                    cell.dateLabel.text = miaozhuanLanqiu(time: (model.cd ?? 0)/1000)
                    cell.dateLabel.textColor = .hexColor(hex: "0CD664")
                    let (fen,miao) = virtualMiaozhuanLanqiu(time: (model.cd ?? 0)/1000)
                    if (Int(fen) ?? 0) == 0 && (Int(miao) ?? 0) <= 9 {
                        cell.dateLabel.textColor = .hexColor(hex: "F01717")
                    }
                }
                
                if model.nsg?.count ?? 0 > 0{
                    cell.leftScore.text = "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[0] ?? 0)"
                    cell.rightScore.text = "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[1] ?? 0)"
                }else{
                    cell.leftScore.text = "-"
                    cell.rightScore.text = "-"
                }
                
            }else{
                cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.titleLabel.text = model.lg?.na
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
                
                if sportId == "3" && leagueType == "1"{
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
                
                if model.nsg?.count ?? 0 > 0{
                    cell.leftScore.text = "\(model.nsg?[0].sc?[0] ?? 0)"
                    cell.rightScore.text = "\(model.nsg?[0].sc?[1] ?? 0)"
                }else{
                    cell.leftScore.text = "-"
                    cell.rightScore.text = "-"
                }
                
            }

            cell.numberLabel.text = "\(model.tms ?? 0)"
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
            }else{
                cell.leftLabel.text = "-"
                cell.rightLabel.text = "-"
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
            cell.videoBtn.tag = 2000 + indexPath.row
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            
            cell.detailBtn.tag = 200 + indexPath.row
            cell.delegate = self
            
            cell.collectBlock = {[weak self] isCollect in
                self?.listModels[indexPath.item].sctype = isCollect
                self?.collectionview.reloadData()
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketballListCell", for: indexPath) as! BasketballListCell
            cell.model = model
            
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
            }
            
            if gameType == "virtual"{
                cell.logoImage.sd_setImage(with: URL(string: model.lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.titleLabel.text = model.na
                if model.ms == 5{
                    cell.saitime.text = model.bnm
                    cell.overtime.text = "LIVE"
                    cell.overtime.isHidden = false
                    cell.virturaBgview.isHidden = true
                    cell.liveimg.isHidden = false
                }else{
                    cell.overtime.isHidden = true
                    cell.virturaBgview.isHidden = false
                    cell.liveimg.isHidden = true
                    let (fen,miao) = virtualMiaozhuanLanqiu(time: (model.cd ?? 0)/1000)
                    cell.fenLabel.text = fen
                    cell.miaoLabel.text = miao
                    cell.saitime.text = model.bnm
                    cell.fenLabel.backgroundColor = .hexColor(hex: "0CD664")
                    cell.miaoLabel.backgroundColor = .hexColor(hex: "0CD664")
                    if (Int(fen) ?? 0) == 0 && (Int(miao) ?? 0) <= 9 {
                        cell.fenLabel.backgroundColor = .hexColor(hex: "F01717")
                        cell.miaoLabel.backgroundColor = .hexColor(hex: "F01717")
                    }
                }
                
                if model.nsg?.count ?? 0 > 0{
                    cell.VSLabel.text = "-"
                    cell.leftScore.text = "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[0] ?? 0)"
                    cell.rightScore.text = "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[1] ?? 0)"
                    cell.VSLabel2.isHidden = true
                }else{
                    cell.leftScore.text = ""
                    cell.rightScore.text = ""
                    cell.VSLabel.text = ""
                    cell.VSLabel2.isHidden = false
                }
                
            }else{
                cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: imgbgstr))
                cell.titleLabel.text = model.lg?.na
                
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
                    cell.saitimeTop.constant = 23
                }else{
                    cell.overtime.isHidden = true
                    cell.saitime.text = timeDate(time: "\((model.bt ?? 0)/1000)")
                    cell.saitimeTop.constant = 17
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
            cell.videoBtn.tag = 2000 + indexPath.row
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            
            cell.detailBtn.tag = 200 + indexPath.row
            cell.delegate = self
            
            cell.collectBlock = {[weak self] isCollect in
                self?.listModels[indexPath.item].sctype = isCollect
                self?.collectionview.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            //return CGSize(width: kScreenW - 20, height: 162)//纵向
            if sportId == "3" && leagueType == "1"{
                return CGSize(width: kScreenW - 20, height: 162)
            }
            return CGSize(width: kScreenW - 20, height: 150)
        }else{
            return CGSize(width: kScreenW - 20, height: 190)//横向
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
