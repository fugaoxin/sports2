//
//  VerifyView.swift
//  NGSprots
//
//  Created by Jean on 25/12/2023.
//

import UIKit
enum VerifyType{
    case emailVerify
    case phoneVerify
    case emailBind
    case phoneBind
}
class VerifyView: UIView,UITextFieldDelegate {

    var confirmBlock : ((_ checkToken : String?)->Void)?
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var titleLBTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var phoneOrEmailPromptLB: UILabel!
    
    @IBOutlet weak var phoneOrEmailBgView: UIView!
    
    @IBOutlet weak var phoneOrEmailTF: UITextField!
    
    @IBOutlet weak var phoneOrEmailTFLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var phoneAreaLB: UILabel!
    
    @IBOutlet weak var phoneOrEmailErrorLB: UILabel!
    
    @IBOutlet weak var codePromptLB: UILabel!
    
    @IBOutlet weak var codeBgView: UIView!
    
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    
    @IBOutlet weak var codeErrorLB: UILabel!
    
    @IBOutlet weak var codeBgViewTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var oneView: UIView!
    
    @IBOutlet weak var twoView: UIView!
    var type : VerifyType? {
        didSet{
            switch type{
            case .emailVerify:
                do {
                    self.imageV.isHidden = true
                    self.titleLBTopSpace.constant = 31
                    self.titleLB.text = "verify your identity"
                    self.phoneOrEmailPromptLB.text = "Email"
                    self.phoneOrEmailTF.placeholder = "Email"
                    self.phoneAreaLB.isHidden = true
                    self.phoneOrEmailTFLeftSpace.constant = 11
                }
                break
            case .phoneVerify:
                do {
                    self.imageV.isHidden = true
                    self.titleLBTopSpace.constant = 31
                    self.titleLB.text = "verify your identity"
                    self.phoneOrEmailPromptLB.text = "Mobile number"
                    self.phoneOrEmailTF.placeholder = "Mobile number"
                    self.phoneAreaLB.isHidden = false
                    self.phoneOrEmailTFLeftSpace.constant = 61
                }
                break
            case .emailBind:
                do {
                    self.imageV.isHidden = false
                    self.imageV.image = UIImage(named:"bindEmail")
                    self.titleLBTopSpace.constant = 84
                    self.titleLB.text = "Bind your Email"
                    self.phoneOrEmailPromptLB.text = "Email"
                    self.phoneOrEmailTF.placeholder = "Email"
                    self.phoneAreaLB.isHidden = true
                    self.phoneOrEmailTFLeftSpace.constant = 11
                }
                break
            case .phoneBind:
                do {
                    self.imageV.isHidden = false
                    self.imageV.image = UIImage(named:"bindPhone")
                    self.titleLBTopSpace.constant = 84
                    self.titleLB.text = "Bind your mobile number"
                    self.phoneOrEmailTF.placeholder = "Mobile number"
                    self.phoneOrEmailPromptLB.text = "Mobile number"
                    self.phoneAreaLB.isHidden = false
                    self.phoneOrEmailTFLeftSpace.constant = 61
                }
                break
            case .none:
                break
            }
        }
    }
    
    var checkToken : String = ""
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("VerifyView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    
    func setUpUI(){
        
        phoneOrEmailTF.delegate = self
        codeTF.delegate = self
        
//        self.phoneOrEmailBgView.layer.cornerRadius = 8
//        self.phoneOrEmailBgView.layer.borderWidth = 0.5
//        self.phoneOrEmailBgView.layer.borderColor = UIColor.hexColor(hex: "B8B8B8").cgColor
//        self.phoneOrEmailBgView.layer.masksToBounds = true
//
//        self.codeBgView.layer.cornerRadius = 8
//        self.codeBgView.layer.borderWidth = 0.5
//        self.codeBgView.layer.borderColor = UIColor.hexColor(hex: "B8B8B8").cgColor
//        self.codeBgView.layer.masksToBounds = true
        
        self.checkRegistBtnStatus()
    }

    
    @IBAction func sendCodeClick(_ sender: Any) {
        var param : LoginParam = LoginParam()
        if self.type == .phoneBind || self.type == .phoneVerify {
            param.areaCode = "234"
            param.phoneNum = phoneOrEmailTF.text
            if Tool.checkPhone(str:(phoneAreaLB?.text)! + phoneOrEmailTF.text!) == false{
                return
            }
        }else{
            param.email = phoneOrEmailTF.text
            if Tool.checkEmailAddress(str: phoneOrEmailTF.text!) == false{
                return
            }
        }
        Tool.countDown(60, btn: sender as! UIButton)
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = (self.type == .phoneBind || self.type == .phoneVerify) == true ? wxApi.getPhoneCode(param: param) : wxApi.getEmailCode(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                Tool.keyWindow().showTextSBimg("Sent successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    @IBAction func closeClick(_ sender: Any) {
        if self.type == .phoneBind || self.type == .emailBind{
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
        }else{
            Tool.keyWindow().hiddenInWindow()
        }
    }
    
    @IBAction func sureClick(_ sender: Any) {
        self.endEditing(true)
        switch type{
        case .emailVerify, .phoneVerify:
            requestVerify()
            break
        case .emailBind , .phoneBind:
            requestBind()
            break
        case .none:
            break
        }
        
    }
    func requestVerify(){
        var param : CheckUserIdentityParam = CheckUserIdentityParam()
        if self.type == .phoneVerify{
            param.phoneNum = phoneOrEmailTF.text
        }else{
            param.email = phoneOrEmailTF.text
        }
        param.optCode = codeTF.text
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = self.type == .phoneVerify ? wxApi.checkUserByPhone(param: param) : wxApi.checkUserByEmail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<CheckUserIdentityModel>.deserialize(from: data)
            if(result?.code == 0){
                Tool.keyWindow().showTextSBimg("Verify successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    if self.confirmBlock != nil{
                        self.confirmBlock!(result?.data?.accessToken)
                    }
                }
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                    if self.confirmBlock != nil{
//                        self.confirmBlock!(nil)
//                    }
//                }
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestBind(){
        var param : BindParam = BindParam()
        if self.type == .phoneBind{
            param.phoneNum = phoneOrEmailTF.text
        }else{
            param.email = phoneOrEmailTF.text
        }
        param.optCode = codeTF.text
        param.accessToken = self.checkToken
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = self.type == .phoneBind ? wxApi.bindPhone(param: param) : wxApi.bindEmail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                Tool.keyWindow().showTextSBimg("Bind successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    if self.confirmBlock != nil{
                        self.confirmBlock!(nil)
                    }
                }
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                    if self.confirmBlock != nil{
//                        self.confirmBlock!(nil)
//                    }
//                }
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkRegistBtnStatus()
        if textField == phoneOrEmailTF || textField == codeTF{
            if textField.text!.isEmpty{
                self.textFieldDidEndEditing(textField)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneOrEmailTF {
            if !textField.text!.isEmpty{
                var result : Bool = false
                if self.type == .phoneBind || self.type == .phoneVerify{
                    result = Tool.checkPhone(str: (self.phoneAreaLB.text)! + textField.text!)
                    phoneOrEmailErrorLB.text = "The Mobile is incorrect"
                }else{
                    result = Tool.checkEmailAddress(str: textField.text!)
                    phoneOrEmailErrorLB.text = "The Email Address is incorrect"
                }
                phoneOrEmailErrorLB.isHidden = result
                codeBgViewTopSpace.constant = result ? 27 : 46
                phoneOrEmailPromptLB.textColor = result  ? .hexColor(hex: "101010") : .hexColor(hex: "FF3344")
                if result == false{
                    oneView.backgroundColor = UIColor.hexColor(hex: "FF3344")
                }else{
                    oneView.backgroundColor = UIColor.hexColor(hex: "B8B8B8")
                }
            }else{
                phoneOrEmailPromptLB.textColor = .hexColor(hex: "101010")
                phoneOrEmailErrorLB.isHidden = true
                codeBgViewTopSpace.constant =  27
                oneView.backgroundColor = UIColor.hexColor(hex: "B8B8B8")
            }
        }else{
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
                    twoView.backgroundColor = UIColor.hexColor(hex: "B8B8B8")
                }
            }else{
                codeErrorLB.isHidden = true
                codePromptLB.textColor = .hexColor(hex: "101010")
                twoView.backgroundColor = UIColor.hexColor(hex: "B8B8B8")
            }
        }
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkRegistBtnStatus(){
        if self.type == .phoneVerify || self.type == .phoneBind{
            if Tool.checkPhone(str:(self.phoneAreaLB.text)! + phoneOrEmailTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }else{
            if Tool.checkEmailAddress(str: phoneOrEmailTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }
        if codeTF.text?.isEmpty == true || codeTF.text?.count ?? 0 < 6{
            self.changeRegistBtn(enable: false)
            return
        }
        
        self.changeRegistBtn(enable: true)
    }
    func changeRegistBtn(enable:Bool){
        confirmBtn.isEnabled = enable
        confirmBtn.backgroundColor = !enable ? .kRgbColor(red: 119, green: 234, blue: 162) : .hexColor(hex: "0CD664")
    }
}
