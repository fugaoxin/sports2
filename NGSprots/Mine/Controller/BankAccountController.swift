//
//  BankAccountController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class BankAccountController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var addBankView : AddBankView = {
        let view = AddBankView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 70))
        return view
    }()
    lazy var deleteBankCardView : DeleteBankCardView = {
        let view = DeleteBankCardView(frame: CGRect(x: (kScreenW-300)/2, y: (kScreenH-210)/2, width: 300, height: 190))
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
    
    var dataArr : [BankCardModel] = []
    var checkToken : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bank Account"
        self.addNavBar(.white)
        
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMyBankCardList()
    }
    func setUpUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = self.addBankView
        tableView.register(UINib(nibName: "BankAccountCell", bundle: nil), forCellReuseIdentifier: "BankAccountCell")
        
        self.addBankView.addBankCardBlock = {[weak self] in
            if Tool.getuserInfoModel() == nil{
                Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
                return
            }
            Tool.requestGetUserInfo {
                let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
                if self?.checkUserInfo(isNeedShowBindView: false) == false || account.hasPayPassword == false{
                    Tool.keyWindow().showInWindow(functionView: self!.verifyView)
                    let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
                    if account.phoneNum != nil && account.phoneNum?.count ?? 0 > 0 && account.email != nil && account.email?.count ?? 0 > 0{
                        self?.verifyView.type = .phoneVerify
                    }else{
                        if loginType == 0{
                            self?.verifyView.type = .phoneVerify
                        }else{
                            self?.verifyView.type = .emailVerify
                        }
                    }
                    return
                }
                if self?.checkUserInfo(isNeedShowBindView: false) == true {
                    if account.hasPayPassword == true{
                        self?.pushVC(vc: EnterPasswordController())
                    }
                }
            }
        }
        self.deleteBankCardView.deleteBankCardBlock = {[weak self]bank in
            self?.requestDeleteBankCard(id: bank?.id ?? 0)
        }
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {
            Tool.keyWindow().endEditing(true)
            if self.bindView.superview == nil && self.setPayPasswordView.superview == nil{
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
                }
            }
        }
        
        self.verifyView.confirmBlock = {[weak self]token in
            self?.checkToken = token ?? ""
            self?.checkUserInfo(isNeedShowBindView: true)
        }
        self.bindView.confirmBlock = {[weak self]_ in
            UIView.animate(withDuration: 0.25, animations: {
                self!.bindView.transform = CGAffineTransform.identity
            },completion:  { _ in
                self!.setPayPassWord()
            })
        }
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
    //获取绑定银行卡
    func requestMyBankCardList(){
        self.dataArr.removeAll()
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
                self.dataArr = result?.data ?? []
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
           
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //删除银行卡
    func requestDeleteBankCard(id:Int){
        self.showHUD(text: "Loading...")
        var param = DeleteBankOrAddressParam()
        param.id = id
        let api = wxApi.deleteBankCard(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[BankCardModel]>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSBimg("Delete successfully", dismissAfterDelay: 1.5, imgstr: nil)
                self.requestMyBankCardList()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataArr.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BankAccountCell = tableView.dequeueReusableCell(withIdentifier: "BankAccountCell") as! BankAccountCell
        let model : BankCardModel = self.dataArr[indexPath.row]
        cell.bankIV.sd_setImage(with: URL(string: model.bankIcon ?? ""),placeholderImage: UIImage(named: "bankCardPlaceholder"))
        cell.bankNameLB.text = model.bankName
        cell.bankCardNumLB.text = model.accountNum
        cell.deleteBlock = {[weak self] in
            Tool.keyWindow().showInWindow(functionView: self!.deleteBankCardView)
            self?.deleteBankCardView.model = model
            self?.deleteBankCardView.cardNumLB.text = (model.accountNum ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 123
    }
}
