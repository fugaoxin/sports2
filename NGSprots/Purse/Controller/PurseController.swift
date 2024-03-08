//
//  PurseController.swift
//  NGSprots
//
//  Created by Jean on 22/12/2023.
//

import UIKit

class PurseController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    
    var isRecharge : Bool = true
    
    lazy var purseHeaderView : PurseHeaderView = {
        let bgH = (kScreenW-20) * 410 / 710
        let view = PurseHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: bgH + 310 + 65))
        return view
    }()
    lazy var bankCardNodataView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 300))
        return view
    }()
    lazy var purseFooterView : PurseFooterView = {
        let view = PurseFooterView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 180))
        return view
    }()
    lazy var withdrawFooterView : WithdrawFooterView = {
        let view = WithdrawFooterView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 145))
        return view
    }()
    lazy var verifyView : VerifyView = {
        let view = VerifyView(frame: CGRect(x: 0, y: kScreenH-500, width: kScreenW, height: 500))
        return view
    }()
    lazy var bindView : VerifyView = {
        let view = VerifyView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 500))
        return view
    }()
    lazy var setPayPasswordView : SetPayPasswordView = {
        let view = SetPayPasswordView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 500))
        return view
    }()
    lazy var selectMyBankCardView : SelectMyBankCardView = {
        let view = SelectMyBankCardView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 500))
        return view
    }()
    lazy var numberCustomKeyboardView : NumberCustomKeyboardView = {
        let view = NumberCustomKeyboardView(frame: CGRect(x: 0, y: kScreenH-kbottomSafeH-ktabBarH, width: kScreenW, height: 240))
        return view
    }()
    
    var checkToken : String = ""
    
    var dataArr : [PayTypeItemModel] = []
    var selectBankCardModel : BankCardModel?
    
    var selectCouponModel : itemModel?
    
    var canUseWalletModel : WalletModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Deposit"
        let recordBtn = self.addRightTwoItemsImage(oneImageName: "customerService", twoImageName: "payRecord")
        recordBtn.addTarget(self, action: #selector(gotoRecord), for: .touchUpInside)
        self.addNavBar(.white)
        
        self.setUpUI()
        self.setUpBlock()
        
        if self.isRecharge == true{
            self.requestPayTypeList {
                self.requestGetUseCouponCount()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutRefresh), name: NSNotification.Name(rawValue: LogoutNotice), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshBalance()
        self.requestPayTypeList {
        }
        self.requestMyBankCardList()
        
        self.requestGetCanWithdrawNumber()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popGestureClose()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popGestureOpen()
    }
    func setUpUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PurseTypeCell", bundle: nil), forCellReuseIdentifier: "PurseTypeCell")
        tableView.tableHeaderView = self.purseHeaderView
        tableView.tableFooterView = self.purseFooterView
    }
    func setUpBlock(){
        self.purseHeaderView.changeBlock = {[weak self]type in
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.25) {
                self?.tableView.transform = CGAffineTransform.identity
                self?.numberCustomKeyboardView.transform = CGAffineTransform.identity
            }
            self?.isRecharge = type == 0 ? true : false
            let bgH = (kScreenW-20) * 410 / 710
            if type == 0{
//                self?.purseHeaderView.numberBgH.constant = 213.5
//                self?.purseHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: bgH + 310)
                self?.purseHeaderView.couponBgView.isHidden = false
                self?.changeHeaderView()
                self?.purseHeaderView.promptLB.text = "Method of payment"
                self?.tableView.tableFooterView = self?.purseFooterView
                self?.sureBtn.setTitle("Top Up Now", for: .normal)
                self?.bottomView.isHidden = false
                self?.tableViewBottomSpace.constant = 70
            }else{
                //提现需校验信息是否完整
                self?.sureClick(nil)
                self?.purseHeaderView.numberBgH.constant = 0.01
                self?.purseHeaderView.couponBgView.isHidden = true
                self?.purseHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: bgH + 85)
                self?.purseHeaderView.promptLB.text = "Receiving Card"
                self?.sureBtn.setTitle("Withdraw", for: .normal)
                self?.withDrawIsHaveBankCardUI()
            }
            self?.purseHeaderView.setUpFrame()
            self?.tableView.tableHeaderView = self?.purseHeaderView
            self?.tableView.reloadData()
            
            self?.changeBottomBtnStatus()
        }
        self.purseHeaderView.selectCouponBlock = {[weak self] in
            if Tool.getuserInfoModel() == nil{
                self?.showTextSB("Please Login", dismissAfterDelay: 1.5)
                return
            }
            let vc = CouponController()
            vc.selectCoupon = true
            vc.selectCouponBlock = {model in
                self?.selectCouponModel = model
                if model.type == 1{
                    self?.purseHeaderView.couponNumberLB.text = "+₦" + ((Tool.StringIsEmpty(value: model.mainValue) ? "0" : model.mainValue)!)
                }else{
                    self?.purseHeaderView.couponNumberLB.text = "+" + ((Tool.StringIsEmpty(value: model.mainValue) ? "0" : model.mainValue)!) + "%"
                }
                self?.purseHeaderView.couponNumberLB.textColor = .hexColor(hex: "0CD664")
                self?.purseHeaderView.couponNumberLB.font = UIFont(name: "PingFangSC-Semibold",size: 12)
            }
            vc.selectCouponModel = self?.selectCouponModel
            vc.rechargeNum = Tool.StringIsEmpty(value: self?.purseHeaderView.numberTF.text) ? "0" : self?.purseHeaderView.numberTF.text
            self?.pushVC(vc: vc)
        }
        self.purseHeaderView.textFiledEndEditBlock = {[weak self] in
            self?.requestGetUseCouponCount()
        }
        self.purseHeaderView.textFiledWillEditBlock = {[weak self] in
            self?.purseHeaderView.isNoFastNumber = true
        }
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {
            Tool.keyWindow().endEditing(true)
            if self.bindView.superview == nil && self.setPayPasswordView.superview == nil && self.selectMyBankCardView.superview == nil{
                Tool.keyWindow().hiddenInWindow()
            }else{
                if self.bindView.superview != nil{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.bindView.transform = CGAffineTransform.identity
                    },completion:  { _ in
                        Tool.keyWindow().hiddenInWindow()
                    })
                }else if self.setPayPasswordView.superview != nil{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.setPayPasswordView.transform = CGAffineTransform.identity
                    },completion:  { _ in
                        Tool.keyWindow().hiddenInWindow()
                    })
                }else{
                    if self.selectMyBankCardView.superview != nil{
                        UIView.animate(withDuration: 0.25, animations: {
                            self.selectMyBankCardView.transform = CGAffineTransform.identity
                        },completion:  { _ in
                            Tool.keyWindow().hiddenInWindow()
                        })
                    }
                }
            }
        }
        
        self.verifyView.confirmBlock = {[weak self]token in
            self?.checkToken = token ?? ""
            if self?.checkUserInfo(isNeedShowBindView: true) == true && Tool.getuserInfoModel()?.hasPayPassword == true{
                if self?.isRecharge == true{
                    self?.requestApplyRecharge()
                }else{
                    self?.requestApplyWithDraw()
                }
            }
        }
        self.bindView.confirmBlock = {[weak self]_ in
            UIView.animate(withDuration: 0.25, animations: {
                self!.bindView.transform = CGAffineTransform.identity
            },completion:  { _ in
                self!.setPayPassWord()
            })
        }
        self.setPayPasswordView.completeSetPassWordBlock = {[weak self]password in
            
        }
        self.selectMyBankCardView.addBankCardBlock = {[weak self] in
            self!.addBankCardCheck()
        }
        self.selectMyBankCardView.selectBankCardBlock = {[weak self]model in
            self!.selectBankCardModel = model
            self!.tableView.reloadData()
        }
    
        self.withdrawFooterView.withDrawEnterNumberBlock = {[weak self] in
            self?.view.addSubview(self!.numberCustomKeyboardView)
            self?.numberCustomKeyboardView.numberStr = self?.withdrawFooterView.numberLB.text ?? ""
            self?.numberCustomKeyboardView.walletModel = self?.canUseWalletModel
            let offset = CGPoint(x:0, y:self!.tableView.contentSize.height - self!.tableView.bounds.size.height)
            UIView.animate(withDuration: 0.5) {
                self!.numberCustomKeyboardView.transform = CGAffineTransformMakeTranslation(0, -240)
                let frame = self?.withdrawFooterView.convert((self?.withdrawFooterView.oneNumberLB.frame)!, to: Tool.keyWindow())
                let keyBoardToWindowY = kScreenH - 240 - kbottomSafeH - ktabBarH
                if CGRectGetMaxY(frame!) > keyBoardToWindowY{
                    let y = keyBoardToWindowY -  CGRectGetMaxY(frame!) - 8
                    if y<0{
                        if y < -170{
                            self!.tableView.transform = CGAffineTransformMakeTranslation(0, -170)
                            self!.tableView.setContentOffset(offset, animated: true)
                        }else{
                            self!.tableView.transform = CGAffineTransformMakeTranslation(0, y)
                        }
                    }
                }
            }
        }
    
        self.numberCustomKeyboardView.closeBlock = {[weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.tableView.transform = CGAffineTransform.identity
                self?.numberCustomKeyboardView.transform = CGAffineTransform.identity
            }
        }
        self.numberCustomKeyboardView.enterBlock = {[weak self]enterStr in
            self?.withdrawFooterView.numberLB.text = enterStr
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            if Float(enterStr) ?? 0 > Float(self?.canUseWalletModel?.balance ?? "0") ?? 0{
                self?.withdrawFooterView.errorLB.isHidden = false
                self?.withdrawFooterView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 163)
            }else{
                self?.withdrawFooterView.errorLB.isHidden = true
                self?.withdrawFooterView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 145)
            }
            self?.withdrawFooterView.updateFrame()
            self?.tableView.tableFooterView = self?.withdrawFooterView
            self?.tableView.reloadData()
            
            self?.changeBottomBtnStatus()
        }
        self.numberCustomKeyboardView.withDrawBlock = {[weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.tableView.transform = CGAffineTransform.identity
                self?.numberCustomKeyboardView.transform = CGAffineTransform.identity
            }
            self?.requestApplyWithDraw()
        }
    }
    func refreshBalance(){
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            if account.wallets?.first?.balance == nil || account.wallets?.first?.balance?.count == 0{
                self.purseHeaderView.balanceNumberLB.text = "0.00"
                self.purseHeaderView.mainBalanceLB.text = "0.00"
                self.purseHeaderView.bonusBalanceLB.text = "0.00"
            }else{
                self.purseHeaderView.balanceNumberLB.text = account.wallets?.first?.balance
                self.purseHeaderView.mainBalanceLB.text = account.wallets?.first?.balance
                self.purseHeaderView.bonusBalanceLB.text = account.wallets?.first?.bonus == nil ? "0.00" : account.wallets?.first?.bonus
            }
            self.changeBottomBtnStatus()
        }
    }
    @objc func gotoRecord(){
        self.pushVC(vc: PurseRecordController())
    }
    func changeBottomBtnStatus(){
        if self.isRecharge == true{
            self.sureBtn.backgroundColor = .hexColor(hex: "0CD664")
            self.sureBtn.isEnabled = true
        }else{
            if self.canUseWalletModel == nil || self.canUseWalletModel?.status == 2{
                self.sureBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                self.sureBtn.isEnabled = false
                return
            }
            let numberStr = self.withdrawFooterView.numberLB.text ?? ""
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            if Tool.StringIsEmpty(value: numberStr){
                self.sureBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                self.sureBtn.isEnabled = false
            }else{
                if Float(numberStr)! > 0 && Float(numberStr)! <= Float(self.canUseWalletModel?.balance ?? "0")!{
                    self.sureBtn.backgroundColor = .hexColor(hex: "0CD664")
                    self.sureBtn.isEnabled = true
                }else{
                    self.sureBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                    self.sureBtn.isEnabled = false
                }
            }
        }
    }
    //根据选择的支付方式快捷金额调整UI
    func changeHeaderView(){
        if self.isRecharge == true{
            var selectPayTypeModel : PayTypeItemModel?
            for model in dataArr {
                if  model.isSelect == true{
                    selectPayTypeModel = model
                }
            }
            let bgH = (kScreenW-20) * 410 / 710
            if selectPayTypeModel == nil{
                self.purseHeaderView.numberBgH.constant = 74
                self.purseHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: bgH + 160 + 65)
            }else{
                var line = (selectPayTypeModel?.amountQuick?.count ?? 0) / 3
                let cul = (selectPayTypeModel?.amountQuick?.count ?? 0) % 3
                if cul > 0{
                    line = line + 1
                }
                let totalNumberH = 70 * line
                if line == 0{
                    self.purseHeaderView.numberBgH.constant = CGFloat(74 + totalNumberH + 5)
                }else{
                    self.purseHeaderView.numberBgH.constant = CGFloat(74 + totalNumberH)
                }
                self.purseHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: bgH + 165 + CGFloat(totalNumberH) + 65)
            }
            self.purseHeaderView.setUpFrame()
            self.tableView.tableHeaderView = self.purseHeaderView
            self.tableView.reloadData()
        }
    }
    //提现与充值
    @IBAction func sureClick(_ sender: Any?) {
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        
        if self.isRecharge == false{
            Tool.requestGetUserInfo {
                let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
                if self.checkUserInfo(isNeedShowBindView: false) == true && account.hasPayPassword == true{
                    if sender != nil{
                        self.requestApplyWithDraw()
                    }
                    return
                }
                Tool.keyWindow().showInWindow(functionView: self.verifyView)
                let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
                if account.phoneNum != nil && account.phoneNum?.count ?? 0 > 0 && account.email != nil && account.email?.count ?? 0 > 0{
                    self.verifyView.type = .phoneVerify
                }else{
                    if loginType == 0{
                        self.verifyView.type = .phoneVerify
                    }else{
                        self.verifyView.type = .emailVerify
                    }
                }
            }
        }else{
            if Tool.StringIsEmpty(value: self.purseHeaderView.numberTF.text) == true{
                self.showTextSB("Please enter amount", dismissAfterDelay: 1)
                return
            }
            self.requestApplyRecharge()
        }
    }
    //切换充值 判断是否有卡
    func withDrawIsHaveBankCardUI(){
        if self.isRecharge == false{
            if self.selectBankCardModel == nil{
                let bgH = (kScreenW-20) * 410 / 710 + 85
                bankCardNodataView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - bgH - kStatusBarH - kNavigationBarH - ktabBarH)
                self.tableView.tableFooterView = self.bankCardNodataView
                let addBankCardBtn : UIButton = self.bankCardNodataView.showEmptyView(image: "bankCardNoData", title: "Add bank card", subtitle: "To withdraw money, you need to add a bank card", btnStr: "Add Bank Card") ?? UIButton()
                addBankCardBtn.frame.size.height = 45
                addBankCardBtn.layer.cornerRadius = 22.5
                addBankCardBtn.layer.masksToBounds = true
                addBankCardBtn.addTarget(self, action: #selector(self.addBankCardCheck), for: .touchUpInside)
                self.bankCardNodataView.emptyView?.backgroundColor = UIColor.white
                self.bottomView.isHidden = true
                self.tableViewBottomSpace.constant = 0
            }else{
                self.tableView.tableFooterView = self.withdrawFooterView
                self.bottomView.isHidden = false
                self.tableViewBottomSpace.constant = 70
            }
        }else{
            self.tableViewBottomSpace.constant = 70
        }
    }
    //验证此登陆帐号是否绑定手机或者邮箱
    @discardableResult
    func checkUserInfo(isNeedShowBindView : Bool)->Bool{
        self.verifyView.isHidden = true
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.phoneNum != nil && account.phoneNum?.count ?? 0 > 0 && account.email != nil && account.email?.count ?? 0 > 0{
            if account.hasPayPassword == true{
                Tool.keyWindow().hiddenInWindow()
            }else{
                Tool.keyWindow().showInWindow(functionView: self.setPayPasswordView)
                self.setPayPasswordView.removePassWord()
                UIView.animate(withDuration: 0.5) {
                    self.setPayPasswordView.transform = CGAffineTransformMakeTranslation(0, -500)
                }
            }
            return true
        }
        if isNeedShowBindView == false{
            return false
        }
        Tool.keyWindow().showInWindow(functionView: self.bindView)
        self.bindView.checkToken = self.checkToken
        if account.phoneNum != nil && account.phoneNum?.count == 0{
            self.bindView.type = .phoneBind
        }else{
            self.bindView.type = .emailBind
        }
        UIView.animate(withDuration: 0.5) {
            self.bindView.transform = CGAffineTransformMakeTranslation(0, -500)
        }
        return false
    }
    //设置交易密码
    func setPayPassWord(){
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.hasPayPassword == true{
            Tool.keyWindow().hiddenInWindow()
        }else{
            Tool.keyWindow().showInWindow(functionView: self.setPayPasswordView)
            self.setPayPasswordView.checkToken = self.checkToken
            self.setPayPasswordView.removePassWord()
            UIView.animate(withDuration: 0.5) {
                self.setPayPasswordView.transform = CGAffineTransformMakeTranslation(0, -500)
            }
        }
    }
    //添加银行卡
    @objc func addBankCardCheck(){
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            if self.checkUserInfo(isNeedShowBindView: false) == false || account.hasPayPassword == false{
                self.sureClick(UIButton())
                return
            }
            if self.checkUserInfo(isNeedShowBindView: false) == true {
                if account.hasPayPassword == true{
                    self.pushVC(vc: EnterPasswordController())
                }
            }
        }
    }
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRecharge == true{
            return dataArr.count
        }
        return self.selectBankCardModel == nil ? 0 : 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PurseTypeCell! = tableView.dequeueReusableCell(withIdentifier: "PurseTypeCell") as? PurseTypeCell
        if isRecharge == true{
            let model = self.dataArr[indexPath.item]
            cell.typeIV.sd_setImage(with: URL(string: model.logoUrl ?? ""),placeholderImage: UIImage(named: model.name ?? ""))
            cell.typeLB.text = model.name
            cell.promptLB.isHidden = true
            cell.selectIV.image = model.isSelect == true ?  UIImage(named: "paySelect") : UIImage(named: "payUnSelect")
            cell.selectIVWidth.constant = 20
        }else{
            cell.typeIV.sd_setImage(with: URL(string: self.selectBankCardModel?.bankIcon ?? ""),placeholderImage: UIImage(named: "bankCardPlaceholder"))
            cell.typeLB.text = "\(self.selectBankCardModel?.bankName ?? "")\(self.selectBankCardModel?.accountNum ?? "")"
            cell.promptLB.isHidden = false
            cell.selectIV.image = UIImage(named: "changeBankCard")
            cell.selectIVWidth.constant = 12
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRecharge == true{
            if dataArr[indexPath.item].isSelect == true{
                return
            }
            for i in 0..<dataArr.count{
                dataArr[i].isSelect = false
            }
            dataArr[indexPath.item].isSelect = true
            self.changeHeaderView()
            self.purseHeaderView.isAutoChangeNumber = true
            self.purseHeaderView.isNoFastNumber = false
            self.purseHeaderView.dataArr = self.dataArr
            self.purseHeaderView.setNumberUI()
            self.tableView.reloadData()
        }else{
            Tool.keyWindow().showInWindow(functionView: self.selectMyBankCardView)
            UIView.animate(withDuration: 0.5) {
                self.selectMyBankCardView.transform = CGAffineTransformMakeTranslation(0, -500)
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension PurseController{
    @objc func loginRefresh(){
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.wallets?.first?.balance == nil || account.wallets?.first?.balance?.count == 0{
            self.purseHeaderView.balanceNumberLB.text = "0.00"
            self.purseHeaderView.mainBalanceLB.text = "0.00"
            self.purseHeaderView.bonusBalanceLB.text = "0.00"
        }else{
            self.purseHeaderView.balanceNumberLB.text = account.wallets?.first?.balance
            self.purseHeaderView.mainBalanceLB.text = account.wallets?.first?.balance
            self.purseHeaderView.bonusBalanceLB.text = account.wallets?.first?.bonus == nil ? "0.00" : account.wallets?.first?.bonus
        }
        self.requestPayTypeList {
            self.requestGetUseCouponCount()
        }
        self.requestMyBankCardList()
    }
    @objc func logOutRefresh(){
        self.purseHeaderView.couponNumberLB.text = "0"
        self.purseHeaderView.couponNumberLB.textColor = .hexColor(hex: "B8B8B8")
        self.purseHeaderView.couponNumberLB.font = UIFont(name: "PingFangSC-Regular",size: 12)
    }
    //获取绑定银行卡
    func requestMyBankCardList(){
        self.showHUD(text: "Loading...")
        let api = wxApi.getMyBankCard
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[BankCardModel]>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.count ?? 0){
                    if i == 0{
                        result?.data?[i].isSelect = true
                    }else{
                        result?.data?[i].isSelect = false
                    }
                }
                self.selectBankCardModel = result?.data?.first
                self.selectMyBankCardView.dataArr = result?.data ?? []
                self.tableView.reloadData()
                self.withDrawIsHaveBankCardUI()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
           
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //获取支付方式
    func requestPayTypeList(completion : @escaping()->Void){
        var id = -1
        for model in self.dataArr{
            if model.isSelect == true{
                id = model.id ?? 0
            }
        }
        self.showHUD(text: "Loading...")
        let param : GetPayTypeParam = GetPayTypeParam()
        let api = wxApi.getPayTypes(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<PayTypeModel>.deserialize(from: data)
            if(result?.code == 0){
                if self.dataArr.count == result?.data?.list?.count{
                    self.purseHeaderView.isAutoChangeNumber = false
                }else{
                    self.purseHeaderView.isAutoChangeNumber = true
                }
                self.dataArr = result?.data?.list ?? []
                for i in 0..<self.dataArr.count{
                    if id != -1{
                        let model = self.dataArr[i]
                        if model.id == id{
                            self.dataArr[i].isSelect = true
                        }else{
                            self.dataArr[i].isSelect = false
                        }
                    }else{
                        if i == 0{
                            self.dataArr[i].isSelect = true
                        }else{
                            self.dataArr[i].isSelect = false
                        }
                    }
                }
                self.changeHeaderView()
                self.purseHeaderView.dataArr = self.dataArr
                self.purseHeaderView.setNumberUI()
                self.tableView.reloadData()
                completion()
            }else{
                self.changeHeaderView()
                self.purseHeaderView.isAutoChangeNumber = false
                self.purseHeaderView.dataArr = self.dataArr
                self.purseHeaderView.setNumberUI()
                self.tableView.reloadData()
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion()
            }
        }) { error in
            self.hudHide()
            self.changeHeaderView()
            self.purseHeaderView.isAutoChangeNumber = false
            self.purseHeaderView.dataArr = self.dataArr
            self.purseHeaderView.setNumberUI()
            self.tableView.reloadData()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            completion()
        }
    }
    
    //充值申请
    func requestApplyRecharge(){
        if self.dataArr.count == 0 || Float(self.purseHeaderView.numberTF.text ?? "") ?? 0 <= 0 {
            self.showTextSB("Please enter correct amount", dismissAfterDelay: 1)
            return
        }
        self.showHUD(text: "Loading...")
        var param : ApplyRechargeParam = ApplyRechargeParam()
        for model in self.dataArr{
            if model.isSelect == true{
                param.wayId = model.id
            }
        }
        param.orderAmount = self.purseHeaderView.numberTF.text
        if self.selectCouponModel != nil{
            param.couponId = String(self.selectCouponModel?.id ?? 0)
        }
        let api = wxApi.applyRecharge(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<ApplyRechargeModel>.deserialize(from: data)
            if(result?.code == 0){
                if result?.data?.showStatus != 3 && Tool.StringIsEmpty(value: result?.data?.redirect?.url) == false{
                    let vc : PublicWebController = PublicWebController()
                    vc.url = result?.data?.redirect?.url
                    self.pushVC(vc: vc)
                }else{
                    self.showTextSB("Deposit failure", dismissAfterDelay: 1.5)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //提现申请
    func requestApplyWithDraw(){
        if self.selectBankCardModel == nil || Float(self.withdrawFooterView.numberLB.text ?? "") ?? 0 <= 0 {
            return
        }
        self.showHUD(text: "Loading...")
        var param : ApplyWithdrawParam = ApplyWithdrawParam()
        param.receiveId = self.selectBankCardModel?.id
        param.orderAmount = self.withdrawFooterView.numberLB.text
        let api = wxApi.applyWithdraw(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<ApplyWithdrawModel>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSBimg("Withdraw successfully", dismissAfterDelay: 1.5, imgstr: nil)
                self.withdrawFooterView.numberLB.text = ""
                self.refreshBalance()
                self.requestGetCanWithdrawNumber()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestGetUseCouponCount(){
        var param = CouponListParam()
        param.amount = self.purseHeaderView.numberTF.text == "" ? "0" : self.purseHeaderView.numberTF.text
        param.scenario = "recharge"
        param.current = 1
        CouponRequest.getCouponAvailable(param: param) { model in
            self.purseHeaderView.gotoSelectCouponBtn.isEnabled = true
            self.selectCouponModel = nil
            if model != nil{
                self.purseHeaderView.couponNumberLB.text = String(model?.total ?? 0)
            }else{
                self.purseHeaderView.couponNumberLB.text = "0"
            }
            self.purseHeaderView.couponNumberLB.textColor = .hexColor(hex: "B8B8B8")
            self.purseHeaderView.couponNumberLB.font = UIFont(name: "PingFangSC-Regular",size: 12)
        }
    }
    
    func requestGetCanWithdrawNumber(){
        self.showHUD(text: "Loading...")
        let api = wxApi.getWalletData(param: BaseSystemParam())
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<WalletModel>.deserialize(from: data)
            if(result?.code == 0){
                self.canUseWalletModel = result?.data ?? WalletModel()
                self.withdrawFooterView.oneNumberLB.text = self.canUseWalletModel?.balance
                self.withdrawFooterView.twoNumberLB.text = self.canUseWalletModel?.block
            }else{
//                self.canUseWalletModel = WalletModel()
//                self.canUseWalletModel?.balance = "60"
//                self.canUseWalletModel?.block = "20"
//                self.canUseWalletModel?.status = 1
//                self.withdrawFooterView.oneNumberLB.text = self.canUseWalletModel?.balance
//                self.withdrawFooterView.twoNumberLB.text = self.canUseWalletModel?.block
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            self.changeBottomBtnStatus()
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            self.changeBottomBtnStatus()
        }
    }
}
