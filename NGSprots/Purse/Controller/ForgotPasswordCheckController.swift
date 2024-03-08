//
//  ForgotPasswordCheckController.swift
//  NGSprots
//
//  Created by Jean on 25/12/2023.
//

import UIKit

class ForgotPasswordCheckController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var phoneOrEmailPromptLB: UILabel!
    
    @IBOutlet weak var phoneOrEmailBgView: UIView!
    
    @IBOutlet weak var phoneOrEmailTF: UITextField!
    
    @IBOutlet weak var codeBgView: UIView!
    
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var codePromptLB: UILabel!
    @IBOutlet weak var codeErrorLB: UILabel!
    @IBOutlet weak var twoView: UIView!
    var applySetPasswordModel : ApplyChangePayPassWordModel?
    
    lazy var setPayPasswordView : SetPayPasswordView = {
        let view = SetPayPasswordView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 500))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    func setUpUI(){
        codeTF.delegate = self
        
        let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
//        if loginType == 0{
            self.phoneOrEmailPromptLB.text = "Mobile number"
            self.phoneOrEmailTF.text = account.phoneNum
//        }else{
//            self.phoneOrEmailPromptLB.text = "Email"
//            self.phoneOrEmailTF.text = account.email
//        }
        
        self.checkConfirmBtnStatus()
        
        self.setPayPasswordView.completeSetPassWordBlock = {[weak self]password in
            self!.sureChangePassWord(password: password)
        }
    }

    @IBAction func sendCodeClick(_ sender: Any) {
        var param : LoginParam = LoginParam()
        let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
//        if loginType == 0{
            param.areaCode = "234"
            param.phoneNum = phoneOrEmailTF.text
//        }else{
//            param.email = phoneOrEmailTF.text
//        }
        Tool.countDown(60, btn: sender as! UIButton)
        self.showHUD(text: "Loading...")
        
//        let api = loginType == 0 ? wxApi.getPhoneCode(param: param) : wxApi.getEmailCode(param: param)
        let api = wxApi.getPhoneCode(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSB("Sent successfully", dismissAfterDelay: 1.5)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    @IBAction func confirmClick(_ sender: Any) {
        self.view.endEditing(true)
        self.requestApplySetPassword()
    }
    func requestApplySetPassword(){
        var param : ApplyChangePayPassWordParam = ApplyChangePayPassWordParam()
        param.phoneNum = phoneOrEmailTF.text
        param.optCode = codeTF.text
        self.showHUD(text: "Loading...")

        let api = wxApi.applyEditPayPassword(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<ApplyChangePayPassWordModel>.deserialize(from: data)
            if(result?.code == 0){
                self.applySetPasswordModel = result?.data
                self.showSetPasswordView()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func sureChangePassWord(password:String){
        var param : SetPayPassWordParam = SetPayPassWordParam()
        param.accessToken = self.applySetPasswordModel?.accessToken
        param.password = Int(password)
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.sureEditPayPassword(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<ApplyChangePayPassWordModel>.deserialize(from: data)
            if(result?.code == 0){
                Tool.keyWindow().showTextSBimg("Set successfully", dismissAfterDelay: 1.5,imgstr: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.dismissSetPasswordView()
                }
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func showSetPasswordView(){
        Tool.keyWindow().showInWindow(functionView: self.setPayPasswordView)
        self.setPayPasswordView.isChangePassword = true
        self.setPayPasswordView.removePassWord()
        UIView.animate(withDuration: 0.5) {
            self.setPayPasswordView.transform = CGAffineTransformMakeTranslation(0, -500)
        }
    }
    func dismissSetPasswordView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.setPayPasswordView.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
            self.navigationController?.popViewController(animated: true)
        })
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkConfirmBtnStatus()
        if textField == codeTF{
            if textField.text!.isEmpty{
                self.textFieldDidEndEditing(textField)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == codeTF {
            if !textField.text!.isEmpty{
                var result : Bool = true
                if codeTF.text?.isEmpty == true || codeTF.text?.count ?? 0 < 6{
                   result = false
                }
                codeErrorLB.isHidden = result
                codePromptLB.textColor = result  ? .hexColor(hex: "101010") : .hexColor(hex: "FF3344")
                if result == false{
                    twoView.backgroundColor = UIColor.hexColor(hex: "FF3344")
                }else{
                    twoView.backgroundColor = UIColor.hexColor(hex: "D5D5D5")
                }
            }else{
                codeErrorLB.isHidden = true
                codePromptLB.textColor = .hexColor(hex: "101010")
                twoView.backgroundColor = UIColor.hexColor(hex: "D5D5D5")
            }
        }
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkConfirmBtnStatus(){
        if codeTF.text?.isEmpty == true || codeTF.text?.count ?? 0 < 6{
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
            return
        }
        
        confirmBtn.isEnabled = true
        confirmBtn.backgroundColor =  .hexColor(hex: "0CD664")
    }
   
}
