//
//  LoginController.swift
//  NGSprots
//
//  Created by Jean on 27/11/2023.
//

import UIKit
let LoginType = "LoginType"  // 0 代表手机登陆 1 代表邮箱
class LoginController: BaseViewController,UITextFieldDelegate {
   
    @IBOutlet weak var areaBtn: UIButton!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var areaCodePromptLB: UILabel!
    
    @IBOutlet weak var phoneBgView: UIView!
    
    @IBOutlet weak var emailBgView: UIView!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var emailBgViewLeftSpace: NSLayoutConstraint!
    ///忘记密码
    lazy var forgotPasswordView : ForgotPasswordView = {
        return ForgotPasswordView(frame: CGRect(x: 25, y: (kScreenH-355)/2.0, width: kScreenW-50, height: 335))
    }()
    ///修改密码
    lazy var resetPasswordView : ResetPasswordView = {
        return ResetPasswordView(frame: CGRect(x: kScreenW, y: (kScreenH-250)/2.0, width: kScreenW-50, height: 250))
    }()
    ///修改密码成功
    lazy var resetPasswordSuccessView : ResetPasswordSuccessView = {
        return ResetPasswordSuccessView(frame: CGRect(x: kScreenW, y: (kScreenH-355)/2.0, width: kScreenW-50, height: 355))
    }()
    
    var loginSuccessBlock : (()->Void)?
    
    //MARK: - access_token 为修改密码时需要的入参，在申请修改密码时返回
    var access_token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNavBar(.init(white: 1, alpha: 0))
        self.navTitleColor = .white
       
        setBlock()
        
        self.phoneTF.keyboardType = .numberPad
        self.phoneTF.delegate = self
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.checkRegistBtnStatus()
        
        self.emailBgViewLeftSpace.constant = kScreenW
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registSuccessGotoLogin()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set("", forKey: "accountRecord")
        UserDefaults.standard.synchronize()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popGestureClose()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popGestureOpen()
    }
    func setBlock(){
        
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {
            if self.resetPasswordView.superview == nil && self.resetPasswordSuccessView.superview == nil{
                Tool.keyWindow().hiddenInWindow()
            }else{
                if self.resetPasswordSuccessView.superview == nil{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.resetPasswordView.transform = CGAffineTransform.identity
                    },completion:  { _ in
                        Tool.keyWindow().hiddenInWindow()
                    })
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.resetPasswordSuccessView.transform = CGAffineTransform.identity
                    },completion:  { _ in
                        Tool.keyWindow().hiddenInWindow()
                    })
                }
            }
        }
        
        self.forgotPasswordView.nextBlock = {[weak self] in
            self?.requestApplyResetpassword()
        }
        self.resetPasswordView.resetPasswordBlock = {[weak self] in
            self?.requestResetPassWordConfirm()
        }
    }
    func registSuccessGotoLogin(){
        let account  =  UserDefaults.standard.object(forKey:"accountRecord")
        if account != nil{
            if !(account as! String).isEmpty{
                if Tool.checkEmailAddress(str: account as! String){
                    self.emailTF.text = account as? String
                    self.emailLoginClick(UIButton())
                }else{
                    self.phoneTF.text = account as? String
                }
            }
        }
    }
    @IBAction func emailLoginClick(_ sender: Any) {
        phoneTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        areaCodePromptLB.isHidden = true
        phoneBgView.isHidden = true
        UIView.animate(withDuration: 0.25) {
            self.emailBgView?.transform = CGAffineTransformMakeTranslation(15-kScreenW, 0)
        }
        self.checkRegistBtnStatus()
    }
    
    @IBAction func phoneLoginClick(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.emailBgView.transform = CGAffineTransform.identity
        },completion:  { _ in
            self.areaCodePromptLB.isHidden = false
            self.phoneBgView.isHidden = false
            self.checkRegistBtnStatus()
        })
    }
    
    @IBAction func loginClick(_ sender: Any) {
        if areaCodePromptLB.isHidden == true{//邮箱登陆
            requestEmailLogin()
        }else{
            requestPhoneLogin()
        }
    }
   
    //MARK: -手机号登陆
    func requestPhoneLogin(){
        var param = LoginParam()
        param.areaCode = "234"
        param.phoneNum = phoneTF.text
        param.password = passwordTF.text
        self.showHUD(text: "Loading..")
        let api = wxApi.phoneLogin(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            print("login===\(data)")
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                let login : LoginModel = (result?.data)!
                ///保存token 及用户数据
                Tool.saveUserInfoModel(model:login.`self`!)
                UserDefaults.standard.set(login.token, forKey: "token")
                
                Tool.saveFBModel(model: login.fb!)
                matchUrl = login.fb?.baseUrl ?? "https://iapi.ccapykdsd.com"
                virtualMatchUrl = login.fb?.virtualUrl ?? "https://virtualapi.server.newsportspro.com"
                self.showTextSBimg("login successful", dismissAfterDelay: 1.5, imgstr: "tipsV")
                if self.loginSuccessBlock != nil{
                    self.loginSuccessBlock!()
                }
                UserDefaults.standard.set(0, forKey: LoginType)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotice), object: nil, userInfo: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endLogin"), object: nil, userInfo: nil)
                    self.dismiss(animated: true)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //MARK: -邮箱登陆
    func requestEmailLogin(){
        var param = LoginParam()
        param.email = emailTF.text
        param.password = passwordTF.text
        self.showHUD(text: "Loading..")
        let api = wxApi.emailLogin(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            print("login===\(data)")
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                let login : LoginModel = (result?.data)!
                Tool.saveUserInfoModel(model:login.`self`!)
                Tool.saveFBModel(model: login.fb!)
                UserDefaults.standard.set(login.token, forKey: "token")
                
                self.showTextSBimg("login successful", dismissAfterDelay: 1.5, imgstr: "tipsV")
                if self.loginSuccessBlock != nil{
                    self.loginSuccessBlock!()
                }
                UserDefaults.standard.set(1, forKey: LoginType)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotice), object: nil, userInfo: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endLogin"), object: nil, userInfo: nil)
                    self.dismiss(animated: true)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
     
    //MARK: -重置密码申请
    func requestApplyResetpassword(){
        var param : ResetPassWordParam = ResetPassWordParam()
        if self.forgotPasswordView.phoneBtn.isSelected == true{
            param.areaCode = "234"
            param.phoneNum = self.forgotPasswordView.phoneOrEmailTF.text
            param.optCode = self.forgotPasswordView.codeTF.text
        }else{
            param.email = self.forgotPasswordView.phoneOrEmailTF.text
            param.optCode = self.forgotPasswordView.codeTF.text
        }
        
        Tool.keyWindow().showHUD(text: "Loading...")
        
        let api = self.forgotPasswordView.phoneBtn.isSelected == true ? wxApi.applyResetPassWordByPhone(param: param) : wxApi.applyResetPassWordByEmail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
//                let login : LoginModel = result?.data ?? LoginModel()
//                self.access_token = login.access_token
                if let dict = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as? NSDictionary {
                    if dict["data"] != nil{
                        let vtData = dict["data"] as! NSDictionary
                        if vtData["access-token"] != nil{
                            self.access_token = vtData["access-token"] as? String
                        }
                    }
                }
                self.showResetPasswordView()
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func showResetPasswordView(){
        self.forgotPasswordView.isHidden = true
        Tool.keyWindow().showInWindow(functionView: self.resetPasswordView)
        UIView.animate(withDuration: 0.5) {
            self.resetPasswordView.transform = CGAffineTransformMakeTranslation(-(kScreenW-25), 0)
        }
    }
    //MARK: -确认重置密码
    func requestResetPassWordConfirm(){
        var param : ResetPassWordParam = ResetPassWordParam()
        param.password = self.resetPasswordView.passwordTF.text
        param.access_token = self.access_token
        Tool.keyWindow().showHUD(text: "Loading...")
        let api =  wxApi.resetPassWordConfirm(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                self.showResetPasswordSuccessView()
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func showResetPasswordSuccessView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.resetPasswordView.transform = CGAffineTransform.identity
        },completion:  { _ in
            self.resetPasswordView.isHidden = true
            Tool.keyWindow().showInWindow(functionView: self.resetPasswordSuccessView)
            UIView.animate(withDuration: 0.5) {
                self.resetPasswordSuccessView.transform = CGAffineTransformMakeTranslation(-(kScreenW-25), 0)
            }
        })
    }
    @IBAction func lookPasswordClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        Tool.keyWindow().showInWindow(functionView: self.forgotPasswordView)
    }
    
    @IBAction func registClick(_ sender: Any) {
        self.pushVC(vc: RegisterController())
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkRegistBtnStatus()
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkRegistBtnStatus(){
        if areaCodePromptLB.isHidden == true{
            if Tool.checkEmailAddress(str: emailTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }else{
            if Tool.checkPhone(str:(areaBtn.titleLabel?.text)! + phoneTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }
        if (Tool.checkContainLowerAndUpper(str: passwordTF.text!) && Tool.checkContainNumber(str: passwordTF.text!) && passwordTF.text!.count>=8) == false{
            self.changeRegistBtn(enable: false)
            return
        }
       
        self.changeRegistBtn(enable: true)
    }
    func changeRegistBtn(enable:Bool){
        loginBtn.isEnabled = enable
        loginBtn.backgroundColor = !enable ? .kRgbColor(red: 12, green: 214, blue: 100, alpha: 0.5) : .hexColor(hex: "0CD664")
        loginBtn.setTitleColor(!enable ? .init(white: 1, alpha: 0.5) : .white, for: .normal)
    }
}
