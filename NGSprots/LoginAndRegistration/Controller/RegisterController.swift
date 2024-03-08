//
//  RegisterController.swift
//  NGSprots
//
//  Created by Jean on 28/11/2023.
//

import UIKit

class RegisterController: BaseViewController,UITextFieldDelegate,SelectDateDelegate {

    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var promotionCodeIV: UIImageView!
    
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var numberOrEmailBgView: UIView!
    @IBOutlet weak var numberOrEmailTF: UITextField!
    @IBOutlet weak var numberOrEmailTFLeftSpace: NSLayoutConstraint!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var phoneOrEmailPromptLB: UILabel!
    
    @IBOutlet weak var phoneOrEmailBottomLineView: UIView!
    /// 手机号或者邮箱不符合规则
    @IBOutlet weak var phoneOrEmailBadErrorIV: UIImageView!
    @IBOutlet weak var phoneOrEmailBadErrorLB: UILabel!
    
    @IBOutlet weak var codePromptLB: UILabel!
    @IBOutlet weak var codeBgView: UIView!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var codeFromPromptLB: UILabel!
    ///phoneOrEmailBadError 调整codePromptLB frame
    @IBOutlet weak var codePromptLBTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var passwordPromptLB: UILabel!
    @IBOutlet weak var passwordBgView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
   
    @IBOutlet weak var datePromptLB: UILabel!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    
    ///密码提示规则出现 调整datePromptLB frame
    @IBOutlet weak var datePromptLBTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var promotionCodeBgView: UIView!
    @IBOutlet weak var promotionCodeTF: UITextField!
    @IBOutlet weak var promotionCodeBgViewH: NSLayoutConstraint!
    @IBOutlet weak var promotionCodeBottomLineView: UIView!
    
    @IBOutlet weak var registBtn: UIButton!
    
    @IBOutlet weak var introPromptLB: ActiveLabel!
    
    var selectPhoneOrEmailBtn : UIButton?
    
    var gotoLoginBlock : (()->Void)?
    ///选择生日
    lazy var selectDateView : SelectDateView = {
        let view = SelectDateView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 350))
        view.dateDelegate = self
        return view
    }()
    ///注册成功
    lazy var resetPasswordSuccessView : ResetPasswordSuccessView = {
        let view = ResetPasswordSuccessView(frame: CGRect(x: 25, y: (kScreenH-355)/2.0, width: kScreenW-50, height: 355))
        view.promptLB.text = "Successful"
        view.introLB.text = "You’ve successfully created an account."
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNavBar(.init(white: 1, alpha: 0))
        self.navTitleColor = .white
        
        setUpUI()
        self.bgScrollView.contentInsetAdjustmentBehavior = .never
    }
    func setUpUI(){
        selectPhoneOrEmailBtn = phoneBtn
        ///首次进入是没有phoneOrEmailBadError 和 密码规则提示
        self.codePromptLBTopSpace.constant = 15
        self.datePromptLBTopSpace.constant = 15
        
        numberOrEmailTF.keyboardType = .numberPad
        codeTF.keyboardType = .numberPad
        
        promotionCodeBgViewH.constant = 0.01
        promotionCodeBottomLineView.isHidden = true
        promotionCodeIV.layer.borderWidth = 1
        promotionCodeIV.layer.borderColor = UIColor.hexColor(hex: "#4D4D4D").cgColor
        
        phoneBtn.isSelected = true
        tipView.frame.size = CGSize(width: 15, height: 2.5)
        tipView.center.y = CGRectGetMaxY(phoneBtn.frame)+1.2
        tipView.center.x = kScreenW/4
        
//        numberOrEmailBgView.layer.borderWidth = 1
//        numberOrEmailBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
//        codeBgView.layer.borderWidth = 1
//        codeBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
//        passwordBgView.layer.borderWidth = 1
//        passwordBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
        dayBtn.layer.borderWidth = 1
        dayBtn.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
        monthBtn.layer.borderWidth = 1
        monthBtn.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
        yearBtn.layer.borderWidth = 1
        yearBtn.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
//        promotionCodeBgView.layer.borderWidth = 1
//        promotionCodeBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
        
        phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Mobile number *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        codePromptLB.attributedText = Tool.changeLableAttributeString(total: "OTP Code *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        passwordPromptLB.attributedText = Tool.changeLableAttributeString(total: "Password *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        datePromptLB.attributedText = Tool.changeLableAttributeString(total: "Date of Birth *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        
        let customType = ActiveType.custom(pattern: "Terms & Conditon")
        introPromptLB.enabledTypes.append(customType)
        introPromptLB.customize { label in
            label.text = "By creating an account you agree to our Terms & Conditon and confirm that you are least 18 years old or Over and all information given is true"
            label.numberOfLines = 0
            //Custom types
            label.customColor[customType] = .hexColor(hex: "848484")
            label.customSelectedColor[customType] = .hexColor(hex: "848484")
            label.handleCustomTap(for: customType) { _ in
                let vc = HelpImgController()
                vc.str = "Terms & Conditions"
                vc.svcHH = (kScreenW - 20)*2.5
                self.pushVC(vc: vc)
            }
        }
        
        passwordTF.delegate = self
        numberOrEmailTF.delegate = self
        codeTF.delegate = self
        
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {
            UIView.animate(withDuration: 0.25, animations: {
                self.selectDateView.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
        }
        self.resetPasswordSuccessView.gotoLoginBlock = {
            self.gotoLoginClick(UIButton())
        }
        
        self.checkRegistBtnStatus()
    }

    //选择邀请码
    @IBAction func promotionCodeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected == true{
            promotionCodeIV.layer.borderColor = UIColor.clear.cgColor
            promotionCodeIV.image = UIImage(named: "otherPromotionCode")
            promotionCodeBgViewH.constant = 40
            promotionCodeBottomLineView.isHidden = false
        }else{
            promotionCodeIV.layer.borderColor = UIColor.hexColor(hex: "#4D4D4D").cgColor
            promotionCodeIV.image = UIImage(named: "")
            promotionCodeBgViewH.constant = 0.01
            promotionCodeBottomLineView.isHidden = true
        }
    }
    
    ///切换注册方式
    @IBAction func changeTypeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        if selectPhoneOrEmailBtn == btn{
            return
        }
        btn.isSelected = true
        selectPhoneOrEmailBtn = btn
        //需要手动调用textFieldDidEndEditing改变baderror状态
        numberOrEmailTF.text = ""
        self.textFieldDidEndEditing(numberOrEmailTF)
        numberOrEmailTF.resignFirstResponder()
        codeTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        if btn == phoneBtn{
            numberOrEmailTF.keyboardType = .numberPad
            emailBtn.isSelected = false
            phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Mobile number *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
            codeFromPromptLB.text = "Please enter the SMS verification code"
            numberOrEmailTF.placeholder = "Mobile number"
            areaBtn.isHidden = false
            numberOrEmailTFLeftSpace.constant = 45
        }else{
            numberOrEmailTF.keyboardType = .default
            phoneBtn.isSelected = false
            phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Email *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
            codeFromPromptLB.text = "Please enter your email verification code"
            numberOrEmailTF.placeholder = "Email"
            areaBtn.isHidden = true
            numberOrEmailTFLeftSpace.constant = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.tipView.center.x = btn.center.x
        }
    }
    
    ///明暗文切换
    @IBAction func lookPasswordClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    ///发送验证码
    @IBAction func sendCodeClick(_ sender: Any) {
        if phoneBtn.isSelected == true {
            if Tool.checkPhone(str:(areaBtn.titleLabel?.text)! + numberOrEmailTF.text!) == false{
                return
            }
        }else{
            if Tool.checkEmailAddress(str: numberOrEmailTF.text!) == false{
                return
            }
        }
        Tool.countDown(60, btn: sender as! UIButton)
        var param : LoginParam = LoginParam()
        if phoneBtn.isSelected == true{
            param.areaCode = "234"
            param.phoneNum = numberOrEmailTF.text
        }else{
            param.email = numberOrEmailTF.text
        }
        self.showHUD(text: "Loading...")
        
        let api = phoneBtn.isSelected == true ? wxApi.getPhoneCode(param: param) : wxApi.getEmailCode(param: param)
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
    
    ///选择生日
    @IBAction func selectDateClick(_ sender: Any) {
        Tool.keyWindow().showInWindow(functionView: selectDateView)
        UIView.animate(withDuration: 0.25) {
            self.selectDateView.transform = CGAffineTransformMakeTranslation(0, -350)
        }
    }
    //注册
    @IBAction func registerClick(_ sender: Any) {
        var param : RegisterParam = RegisterParam()
        if phoneBtn.isSelected == true{
            param.areaCode = "234"
            param.phoneNum = numberOrEmailTF.text
        }else{
            param.email = numberOrEmailTF.text
        }
        param.optCode = codeTF.text
        param.password = passwordTF.text
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd-MMMM-yyyy"
        let str =  "\(dayBtn.titleLabel?.text ?? "")-\(monthBtn.titleLabel?.text ?? "")-\(yearBtn.titleLabel?.text ?? "")"
        let date = dformatter.date(from: str) ?? Date()
        
        dformatter.dateFormat = "dd-MM-yyyy"
        let datestr = dformatter.string(from: date)
        let result = datestr.components(separatedBy: "-")
        
        param.yearOfBirth = Int(yearBtn.titleLabel?.text ?? "0")
        param.monthOfBirth = Int(result[1] )
        param.dayOfBirth = Int(dayBtn.titleLabel?.text ?? "0")
        param.inviteCode = promotionCodeTF.text
        self.showHUD(text: "Loading...")
        
        let api = phoneBtn.isSelected == true ? wxApi.phoneRegist(param: param) : wxApi.emailRegist(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                let login : LoginModel = (result?.data)!
//                Tool.saveUserInfoModel(model:login.`self`!)
                Tool.keyWindow().showInWindow(functionView: self.resetPasswordSuccessView)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    ///去登陆
    @IBAction func gotoLoginClick(_ sender: Any) {
        //注册成功 返回登陆时 自动补充注册账号
        UserDefaults.standard.set(numberOrEmailTF.text, forKey: "accountRecord")
        UserDefaults.standard.synchronize()
        var isJump : Bool = false
        for i in 0..<(self.navigationController?.viewControllers.count)! {
            let vc = self.navigationController?.viewControllers[i]
            if vc is LoginController{
               _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! LoginController, animated: true)
               isJump = true
                break
           }
        }
        if isJump == false{
            self.dismiss(animated: true)
            if self.gotoLoginBlock != nil{
                self.gotoLoginBlock!()
            }
        }
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkRegistBtnStatus(){
        if phoneBtn.isSelected == true{
            if Tool.checkPhone(str:(areaBtn.titleLabel?.text)! + numberOrEmailTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }else{
            if Tool.checkEmailAddress(str: numberOrEmailTF.text!) == false{
                self.changeRegistBtn(enable: false)
                return
            }
        }
        if codeTF.text?.isEmpty == true{
            self.changeRegistBtn(enable: false)
            return
        }
        if (Tool.checkContainLowerAndUpper(str: passwordTF.text!) && Tool.checkContainNumber(str: passwordTF.text!) && passwordTF.text!.count>=8) == false{
            self.changeRegistBtn(enable: false)
            return
        }
        if dayBtn.titleLabel?.text == "DD"{
            self.changeRegistBtn(enable: false)
            return
        }
        self.changeRegistBtn(enable: true)
    }
    func changeRegistBtn(enable:Bool){
        registBtn.isEnabled = enable
        registBtn.backgroundColor = !enable ? .kRgbColor(red: 12, green: 214, blue: 100, alpha: 0.5) : .hexColor(hex: "0CD664")
        registBtn.setTitleColor(!enable ? .init(white: 1, alpha: 0.5) : .white, for: .normal)
    }
    //MARK: -SelectDateDelegate
    func dateSureClick(day: String, month: String, year: String) {
        dayBtn.setTitle(day, for: .normal)
        monthBtn.setTitle(month, for: .normal)
        yearBtn.setTitle(year, for: .normal)
        dayBtn.setTitleColor(.white, for: .normal)
        monthBtn.setTitleColor(.white, for: .normal)
        yearBtn.setTitleColor(.white, for: .normal)
        checkRegistBtnStatus()
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkRegistBtnStatus()
        if textField == passwordTF { // 校验密码
            if !textField.text!.isEmpty{
                let lowerAndUpperResult = Tool.checkContainLowerAndUpper(str: textField.text ?? "")
                let numberResult = Tool.checkContainNumber(str: textField.text ?? "")
                self.datePromptLBTopSpace.constant = 78
                for i in 100...105{
                    let view = self.bgView.viewWithTag(i)
                    view?.isHidden = false
                    if i < 103{
                        let checkIV : UIImageView = self.bgView.viewWithTag(i) as! UIImageView
                        if i == 100{
                            checkIV.image = lowerAndUpperResult ? UIImage(named:"passwordPass"):UIImage(named: "passwordUnPass")
                        }else if i == 101{
                            checkIV.image = numberResult ? UIImage(named:"passwordPass"):UIImage(named: "passwordUnPass")
                        }else{
                            checkIV.image = (textField.text?.count ?? 0)>=8 ? UIImage(named:"passwordPass"):UIImage(named: "passwordUnPass")
                        }
                    }
                }
            }else{
                for i in 100...105{
                    let view = self.bgView.viewWithTag(i)
                    view?.isHidden = true
                }
                self.datePromptLBTopSpace.constant = 15
            }
        }else if textField == numberOrEmailTF{
            if textField.text!.isEmpty{
                self.textFieldDidEndEditing(textField)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == numberOrEmailTF {
            if !textField.text!.isEmpty{
                var result : Bool = false
                if phoneBtn.isSelected == true{
                    result = Tool.checkPhone(str: (areaBtn.titleLabel?.text)! + textField.text!)
                    phoneOrEmailBadErrorLB.text = "The Mobile is incorrect"
                }else{
                    result = Tool.checkEmailAddress(str: textField.text!)
                    phoneOrEmailBadErrorLB.text = "The Email Address is incorrect"
                }
                phoneOrEmailBadErrorIV.isHidden = result
                phoneOrEmailBadErrorLB.isHidden = result
                codePromptLBTopSpace.constant = result ? 15 : 35
                phoneOrEmailBottomLineView.backgroundColor = result ? .hexColor(hex: "4D4D4D") : .hexColor(hex: "FF0000")
//                if result == false{
//                    numberOrEmailBgView.layer.borderColor = UIColor.hexColor(hex: "FF0000").cgColor
//                }else{
//                    numberOrEmailBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
//                }
            }else{
                phoneOrEmailBadErrorIV.isHidden = true
                phoneOrEmailBadErrorLB.isHidden = true
                codePromptLBTopSpace.constant =  15
//                numberOrEmailBgView.layer.borderColor = UIColor.hexColor(hex: "808080").cgColor
                phoneOrEmailBottomLineView.backgroundColor =  .hexColor(hex: "4D4D4D")
            }
        }
    }
}
