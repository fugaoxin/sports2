//
//  BetSlipController.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/12.
//

import UIKit

class BetSlipController: BaseViewController {
   
    @IBOutlet weak var singleBetBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    
    private var accumulatorViewNew:AccumulatorViewNew!
    private var bethistoryview:BetHistoryView!
    private var betview:BetSlipBetView!
    
    private var activityView:BonusActivityView!
    private var bounsRuleView:BounsRuleView!
    
    private var opodTimers:Timer?
    private var betbgview = UIView()
    
    private var betslipDelectTips:BetslipDelectTips!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        
        let snview = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kStatusBarH + kNavigationBarH))
        snview.backgroundColor = .white
        self.view.insertSubview(snview, at: 0)
        
        //collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        let tabbarH:CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 0
        let YY = kStatusBarH + 60 + 5
        let HH = kScreenH - YY - tabbarH
        
        accumulatorViewNew = AccumulatorViewNew.init(frame: CGRect(x: 0, y: YY, width: kScreenW, height: HH))
        view.addSubview(accumulatorViewNew)
        accumulatorViewNew.delegate = self
        accumulatorViewNew.viewWillLoadUI(type: true)
        //accumulatorViewNew.isHidden = true
        
        bethistoryview = BetHistoryView.init(frame: CGRect(x: 0, y: YY, width: kScreenW, height: HH))
        view.addSubview(bethistoryview)
        bethistoryview.delegate = self
        bethistoryview.isHidden = true
        bethistoryview.listviewHeaderRefresh()
        
        betbgview.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        betbgview.backgroundColor = .black
        betbgview.alpha = 0.5
        UIApplication.shared.windows.last?.addSubview(betbgview)
        betbgview.isHidden = true
        betbgview.isUserInteractionEnabled = true
        let bttap = UITapGestureRecognizer(target: self, action: #selector(clickBetbgview))
        betbgview.addGestureRecognizer(bttap)
        let tophh:CGFloat = 20//tabbarH
        betview = BetSlipBetView.init(frame: CGRect(x: 0, y: kScreenH - tophh - 485, width: kScreenW, height: 485 + tophh))
        //view.addSubview(betview)
        UIApplication.shared.windows.last?.addSubview(betview)
        betview.delegate = self
        betview.isHidden = true
//        betview.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(clickBetview))
//        betview.addGestureRecognizer(tap)
        betview.clickDone = {
            self.betview.jpHH.constant = 0
            self.betview.frame = CGRect(x: 0, y: kScreenH - tophh - 345, width: kScreenW, height: 345 + tophh)
        }
        
        betview.clickMoneyBgview = {
            if self.betview.jpHH.constant == 0{
                self.betview.jpHH.constant = 120
                self.betview.frame = CGRect(x: 0, y: kScreenH - tophh - 485, width: kScreenW, height: 485 + tophh)
            }else{
                self.betview.jpHH.constant = 0
                self.betview.frame = CGRect(x: 0, y: kScreenH - tophh - 345, width: kScreenW, height: 345 + tophh)
            }
        }
        
        betview.clickTopUp = {
            self.clickBetbgview()
            self.tabBarController?.selectedIndex = 3
        }
        
        betview.bounsTips = {
            self.bounsRuleView.isHidden = false
        }
        
        setBetEndView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(endBetHistory), name: NSNotification.Name(rawValue: "history2"), object: nil)
        
        activityView = BonusActivityView.init(frame: CGRect(x: (kScreenW - 300)/2, y: (kScreenH - tabbarH - 400)/2, width: 300, height: 400))
        UIApplication.shared.windows.last?.addSubview(activityView)
        activityView.isHidden = true
        activityView.close = {
            self.clickBetbgview()
        }
        
        activityView.goLearnMore = {
            self.clickBetbgview()
//            let vc = AccumulatorBonusVC()
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.hidesBottomBarWhenPushed = false
            
            let vc = PublicWebController()
            vc.titleStr = self.TaskReqModel.name
            vc.url = self.TaskReqModel.linkH5
            self.pushVC(vc: vc)
        }
        
        bounsRuleView = BounsRuleView.init(frame: CGRect(x: 0, y: kScreenH - tophh - 585, width: kScreenW, height: 400))
        UIApplication.shared.windows.last?.addSubview(bounsRuleView)
        bounsRuleView.isHidden = true
        bounsRuleView.close = {
            self.bounsRuleView.isHidden = true
        }
        
        betslipDelectTips = BetslipDelectTips.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        UIApplication.shared.windows.last?.addSubview(betslipDelectTips)
        betslipDelectTips.isHidden = true
        betslipDelectTips.close = {
            self.betslipDelectTips.isHidden = true
            self.showBonusActivity()
        }
        
        showBetslipDelectTips()
        lodaAwardTaskAccaBonusList()
    }
    
    private func showBetslipDelectTips(){
        let value = UserDefaults.standard.object(forKey: "betslipDelectTips")
        if value == nil{
            betslipDelectTips.isHidden = false
            UserDefaults.standard.set("betslipDelectTips", forKey: "betslipDelectTips")
        }else{
            showBonusActivity()
        }
    }
    
    @objc func clickBetbgview(){
        betbgview.isHidden = true
        betview.isHidden = true
        activityView.isHidden = true
        bounsRuleView.isHidden = true
    }
    
    private var TaskReqModel = awardTaskReqModel()
    private func showBonusActivity(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentDate = dateFormatter.string(from: Date())
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.id != nil{
            let value = UserDefaults.standard.object(forKey: currentDate + "\(account.id ?? 0)")
            if value == nil{
                Tool.lodaAwardTaskReq(id: 4) { model in
                    if model?.status == 1{
                        self.TaskReqModel = model ?? awardTaskReqModel()
                        self.betbgview.isHidden = false
                        self.activityView.isHidden = false
                        UserDefaults.standard.set(4, forKey: currentDate + "\(account.id ?? 0)")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if chuanguanArray.count > 1{
            singleBetBtn.setTitle("Accumulator", for: .normal)
        }else{
            singleBetBtn.setTitle("Single bet", for: .normal)
        }

        lodaCartBetSlipList()
        //self.loadData()
        loadPeilv()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.opodTimers?.invalidate()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func loadPeilv(){
        self.opodTimers?.invalidate()
        self.opodTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(3), repeats: true, block: { (timer) in
            self.loadData()
        })
    }
    
    private func loadData(){
        if Tool.getFBModel()?.token?.count ?? 0 > 0{
            if chuanguanArray.count > 0{
                var param = BatchBetMatchMarketOfJumpLineParam()
                param.languageType = "ENG"
                param.currencyId = "20"
                var arr = Array<betMatchMarketListModel>()
                for model in chuanguanArray{
                    if model.selectType ?? true {
                        var bmmodel = betMatchMarketListModel()
                        bmmodel.marketId = "\(model.mksId ?? 0)"
                        bmmodel.matchId = "\(model.recordsId ?? 0)"
                        bmmodel.oddsType = "1"
                        bmmodel.type = "\(model.ty ?? 0)"
                        arr.append(bmmodel)
                    }
                }
                if arr.count > 0{
                    param.betMatchMarketList = arr
                    if chuanguanArray.count > 1{
                        param.isSelectSeries = "true"
                    }else{
                        param.isSelectSeries = "false"
                    }
                    loadOrderBatchBetMatchMarketOfJumpLine(param: param)
                }
            }
        }
    }
    
    private var beBGview:UILabel!
    private var betendview:BetEndView!
    private func setBetEndView(){
        beBGview = UILabel(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        UIApplication.shared.windows.last?.addSubview(beBGview)
        beBGview.backgroundColor = .black
        beBGview.alpha = 0.5
        beBGview.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenBeBGview))
        beBGview.addGestureRecognizer(tap)
        
        betendview = BetEndView.init(frame: CGRect(x: 0, y: kScreenH - 320, width: kScreenW, height: 320))
        UIApplication.shared.windows.last?.addSubview(betendview)
        betendview.delegate = self
        
        beBGview.isHidden = true
        betendview.isHidden = true
    }
    
    @objc func hiddenBeBGview(){
        beBGview.isHidden = true
        betendview.isHidden = true
    }
    
    @objc func clickBetview(){
        betview.isHidden = true
        betbgview.isHidden = true
    }
    
    @IBAction func clickSingleBet(_ sender: UIButton) {
        singleBetBtn.setTitleColor(.hexColor(hex: "FFFFFF"), for: .normal)
        historyBtn.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        singleBetBtn.backgroundColor = .hexColor(hex: "0CD664")
        historyBtn.backgroundColor = .hexColor(hex: "F5F6F9")
        
        accumulatorViewNew.viewWillLoadUI(type: true)
        bethistoryview.isHidden = true
        loadPeilv()
    }
    
    @IBAction func clickHistory(_ sender: UIButton) {
        selectHistory()
    }
    
    private func selectHistory(){
        singleBetBtn.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        historyBtn.setTitleColor(.hexColor(hex: "FFFFFF"), for: .normal)
        historyBtn.backgroundColor = .hexColor(hex: "0CD664")
        singleBetBtn.backgroundColor = .hexColor(hex: "F5F6F9")
        
        betbgview.isHidden = true
        betview.isHidden = true
        accumulatorViewNew.isHidden = true
        bethistoryview.isHidden = false
   
        bethistoryview.backgroundColor = .hexColor(hex: "F5F5F7")
        
        bethistoryview.listviewHeaderRefresh()
        self.opodTimers?.invalidate()
    }
    
    @IBAction func PLBet(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func endBetHistory(){
        self.hiddenBeBGview()
        self.selectHistory()
    }
    
    private var jumpLineModel:marketOfJumpLineModel?
    private func betEndView(param: orderBetMultipleParam, msg: String, PotentialBonus: String){
        if msg == "Lose a bet"{
            self.betendview.endBtn.setImage(UIImage(named: "组 780"), for: .normal)
        }else{
            self.betendview.endBtn.setImage(UIImage(named: "组 124424"), for: .normal)
        }
        self.betendview.endLabel.text = msg
        self.betbgview.isHidden = true
        self.betview.isHidden = true
        self.betview.cleardata()
        self.beBGview.isHidden = false
        self.betendview.isHidden = false
        self.betendview.bg1.isHidden = true
        self.betendview.bg2.isHidden = false
        self.betendview.number.text = "\(param.betOptionList?.count ?? 0)"
        self.betendview.peilv2.text = "@" + "\(self.jumpLineModel?.sos?[0].sodd ?? 0)"
        self.betendview.benjin.text = "₦ " + (param.betMultipleData?[0].unitStake ?? "")
        let db1 = Float(param.betMultipleData?[0].unitStake ?? "0")
        let db2 = Float(self.jumpLineModel?.sos?[0].sodd ?? 0)
        self.betendview.keying.text = "₦ " + String(format: "%.2f", ((db1 ?? 0) * (db2 )))
        self.betendview.bonusLabel.text = PotentialBonus
    }
    
    private func betEndSingleView(param: singlePassParam, msg: String){
        if msg == "Lose a bet"{
            self.betendview.endBtn.setImage(UIImage(named: "组 780"), for: .normal)
        }else{
            self.betendview.endBtn.setImage(UIImage(named: "组 124424"), for: .normal)
        }
        self.betendview.endLabel.text = msg
        self.betbgview.isHidden = true
        self.betview.isHidden = true
        self.betview.cleardata()
        self.beBGview.isHidden = false
        self.betendview.isHidden = false
        self.betendview.bg1.isHidden = true
        self.betendview.bg2.isHidden = false
        self.betendview.number.text = "1"
        self.betendview.peilv2.text = "@" + "\(jumpLineModel?.bms?[0].op?.od ?? "0")"
        self.betendview.benjin.text = "₦ " + (param.singleBetList?[0].unitStake ?? "")
        let db1 = Float(param.singleBetList?[0].unitStake ?? "0")
        let db2 = Float(jumpLineModel?.bms?[0].op?.od ?? "0")
        self.betendview.keying.text = "₦ " + String(format: "%.2f", ((db1 ?? 0) * (db2 ?? 0 )))
    }
    
    private func setChuangArray(lists: [carListModel]){
        chuanguanArray.removeAll()
        for item in lists{
            var model = opModel()
            model.recordsId = item.matchId
            model.mksId = item.marketId
            model.recordsnm = (item.hTName ?? ".") + " - " + (item.aTName ?? ".")
            model.recordsbt = Int(item.beginTime ?? "0")
            let kk = item.marketName?.components(separatedBy: " : ")
            if (kk?.count ?? 0) > 2{
                model.ngnm = kk?[0]
                model.ty = Int(kk?[1] ?? "0")
                model.opsOnm = kk?[2]
            }else{
                model.ngnm = ""
                model.ty = 1
                model.opsOnm = ""
            }
            model.tps = item.marketTag
            chuanguanArray.append(model)
        }
        self.loadData()
    }
    
}

extension BetSlipController{
    func loadOrderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam){
        //self.showHUDNO()
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            //self.hudHide()
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                self.jumpLineModel = result?.data
                self.betview.number.text = "\(result?.data?.bms?.count ?? 0)"
                if (self.jumpLineModel?.bms?.count ?? 0) > 1{
                    self.accumulatorViewNew.peilv.text = "@" + "\(result?.data?.sos?[0].sodd ?? 0)"
                    self.betview.loadsos(sosmodel: result?.data?.sos?[0] ?? sosModel(), bmsmodels: result?.data?.bms ?? [bmsModel]())
                }else{
                    self.accumulatorViewNew.peilv.text = "@" + "\(result?.data?.bms?[0].op?.od ?? "0")"
                    self.betview.loadBms(bmsmodel: result?.data?.bms?[0] ?? bmsModel())
                }
                self.accumulatorViewNew.loadData(model: self.jumpLineModel ?? marketOfJumpLineModel())
                
                if (self.jumpLineModel?.bms?.count ?? 0) > 0{
                    var arr = Array<String>()
                    for item in result?.data?.bms ?? [bmsModel](){
                        arr.append(item.op?.od ?? "0")
                    }
                    self.lodaAwardTaskAccaBonusStatus(arr: arr)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { (error) in
            //self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //串关投注
    func loadOrderBetMultiple(param: orderBetMultipleParam, PotentialBonus: String){
        let api = wxApi.orderBetMultiple(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
                Tool.requestGetUserInfo{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "balance"), object: nil)
                }
                self.betEndView(param: param, msg: "Bet Placed successfully", PotentialBonus: PotentialBonus)
            }else{
                self.betEndView(param: param, msg: "Lose a bet", PotentialBonus: "₦0")
            }
        }) { (error) in
            self.betEndView(param: param, msg: "Lose a bet", PotentialBonus: "₦0")
        }
    }
    
    //单关投注
    func loadOrderBetSinglePass(param: singlePassParam, model: opModel){
        let api = wxApi.orderBetSinglePass(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<[orderBetSinglePassResponseModel]>.deserialize(from: data)
            if(result?.code == 0){
                Tool.requestGetUserInfo{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "balance"), object: nil)
                }
                if result?.data?.count ?? 0 > 0{
                    self.betEndSingleView(param: param, msg: "Bet Placed successfully")
                }else{
                    self.betEndSingleView(param: param, msg: "Lose a bet")
                }
            }else{
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
        }
    }
    
    //加入购物车
    func cartBetSlipAdd(param: carListModel){
        self.showHUD(text: "Loading...")
        let api = wxApi.cartBetSlipAdd(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            //print("cartBetSlipAdd===\(result?.data)")
            if(result?.code == 0){
               
            }else{
                
            }
        }) { (error) in
            self.hudHide()
        }
    }
    
    //购物车列表
    func lodaCartBetSlipList(){
        self.showHUD(text: "Loading...")
        let api = wxApi.cartBetSlipList
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<CarList>.deserialize(from: data)
            //print("cartBetSlipList===\(result?.data)")
            if(result?.code == 0){
                if result?.data?.list != nil{
                    self.setChuangArray(lists: result?.data?.list ?? [carListModel]())
                    if self.accumulatorViewNew != nil{
                        self.accumulatorViewNew.viewWillLoadUI(type: self.bethistoryview.isHidden)
                    }
                }
            }else{
                self.accumulatorViewNew.viewWillLoadUI(type: false)
            }
        }) { (error) in
            self.hudHide()
        }
    }
    
    //移出购物车
    func cartBetSlipRemove(param: carListModel){
        self.showHUD(text: "Loading...")
        let api = wxApi.cartBetSlipRemove(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            //print("cartBetSlipRemove===\(result?.data)")
            if(result?.code == 0){
               
            }else{
                
            }
        }) { (error) in
            self.hudHide()
        }
    }
    
    //累积奖金：奖励详情表
    func lodaAwardTaskAccaBonusList(){
        let api = wxApi.awardTaskAccaBonusList
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<accaBonusListModel>.deserialize(from: data)
            if(result?.code == 0){
                self.bounsRuleView.loadUI(models: result?.data?.items ?? [accaBonusListItemModel]())
            }else{}
        }) { (error) in }
    }
    
    //累积奖金：奖励详情表
    func lodaAwardTaskAccaBonusStatus(arr: [String]){
        var param = accaBonusStatusParam()
        param.odds = arr
        let api = wxApi.awardTaskAccaBonusStatus(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<accaBonusStatusModel>.deserialize(from: data)
            if(result?.code == 0){
                if result?.data?.status == 1 && (result?.data?.result ?? 0) > 0{
                    self.accumulatorViewNew.tipsimg.isHidden = false
                    self.accumulatorViewNew.tipslabel.isHidden = false
                    self.accumulatorViewNew.bottomViewHH.constant = 120
                    self.accumulatorViewNew.tipslabel.text = "Have access to " + "\(result?.data?.result ?? 0)" + "% Accumulator Bonus"
                }else{
                    self.accumulatorViewNew.tipsimg.isHidden = true
                    self.accumulatorViewNew.tipslabel.isHidden = true
                    self.accumulatorViewNew.bottomViewHH.constant = 90
                }
            }else{}
        }) { (error) in }
    }
    
}

extension BetSlipController: AccumulatorViewNewDelegate, BetSlipBetViewDelegate, BetEndViewDelegate, BetHistoryViewDelegate{
    func uploadBetBg() {
        loadData()
    }
    
    func delectList(index: Int, matchId: Int, marketId: Int) {
        if index > 2{
            singleBetBtn.setTitle("Accumulator", for: .normal)
        }else{
            singleBetBtn.setTitle("Single bet", for: .normal)
        }
        
        var param = carListModel()
        param.gameId = 1
        param.matchId = matchId
        param.marketId = marketId
        cartBetSlipRemove(param: param)
    }
    
    func btshowHUD() {
        self.showHUD(text: "Loading...")
    }
    
    func bthudHide() {
        self.hudHide()
    }
    
    func btshowTextSB(msg: String) {
        self.showTextSB(msg, dismissAfterDelay: 1.5)
    }
    
    func CalculatorEndViewLeftTarget() {
        hiddenBeBGview()
        selectHistory()
    }
    
    func CalculatorEndViewRightTarget() {
        hiddenBeBGview()
    }
    
    func settleAccounts(money: String, model: opModel, PotentialBonus: String, relatedId: String) {
        if (jumpLineModel?.bms?.count ?? 0) > 1{
            var bolArr = Array<betOptionListModel>()
            for item in jumpLineModel?.bms ?? [bmsModel]() {
                var bolmodel = betOptionListModel()
                bolmodel.marketId = "\(item.mid ?? 0)"
                bolmodel.odds = item.op?.od
                bolmodel.oddsFormat = "1"
                bolmodel.optionType = "\(item.op?.ty ?? 0)"
                bolArr.append(bolmodel)
            }

            var bmlmodel = betMultipleDataModel()
            bmlmodel.oddsChange = "1"
            bmlmodel.seriesValue = jumpLineModel?.sos?[0].sn
            bmlmodel.unitStake = money
            //bmlmodel.relatedId = relatedId

            var param = orderBetMultipleParam()
            param.languageType = "ENG"
            param.currencyId = "20"
            param.betOptionList = bolArr
            param.betMultipleData = [bmlmodel]
            
            loadOrderBetMultiple(param: param, PotentialBonus: PotentialBonus)
        }else{
            
            var blmodel = betOptionListModel()
            blmodel.marketId = "\(jumpLineModel?.bms?[0].mid ?? 0)"
            blmodel.odds = "\(jumpLineModel?.bms?[0].op?.od ?? "0")"
            blmodel.oddsFormat = "1"
            blmodel.optionType = "\(jumpLineModel?.bms?[0].op?.ty ?? 0)"
            
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
    
    func accumulatorViewNewBet() {
        if Tool.getFBModel()?.token?.count ?? 0 > 0{
            if chuanguanArray.count > 0{
                var index = 0
                for item in chuanguanArray{
                    if item.selectType ?? false{
                        index += 1
                    }
                }
                if index == 0{
                    return
                }
            }else{
                return
            }
            
            if self.jumpLineModel?.sos != nil{
                betbgview.isHidden = false
                betview.isHidden = false
                betview.cleardata()
            }else{
                if (self.jumpLineModel?.bms?.count ?? 0) > 1{
                    self.showTextSB("Delete the no-bet list first", dismissAfterDelay: 1.5)
                }else{
                    if self.jumpLineModel?.bms?[0].ss == -1{
                        self.showTextSB("Delete the no-bet list first", dismissAfterDelay: 1.5)
                    }else{
                        betbgview.isHidden = false
                        betview.isHidden = false
                        betview.cleardata()
                    }
                }
            }
        }else{
            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
        }
    }
    
    
}
