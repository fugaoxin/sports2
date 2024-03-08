//
//  ChangeLoginPasswordController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class ChangePasswordCheckController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var promptLB: UILabel!
    
    @IBOutlet weak var phoneOrEmailTF: UITextField!
    
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var codePromptLB: UILabel!
    
    @IBOutlet weak var oneView: UIView!
    
    @IBOutlet weak var twoView: UIView!
    
    
    @IBOutlet weak var phoneOrEmailErrorLB: UILabel!
    
    @IBOutlet weak var codeErrorLB: UILabel!
    
    var isLoginType : Bool?
    var access_token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBar(.white)
        if self.isLoginType == true{
            self.titleLB.text = "Change Login Password"
        }else{
            self.titleLB.text = "Change Payment Password"
        }
        phoneOrEmailTF.delegate = self
        codeTF.delegate = self
        codeTF.keyboardType = .numberPad

        let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
//        if loginType == 0{
            self.promptLB.text = "Mobile number"
            self.phoneOrEmailTF.text = account.phoneNum
//        }else{
//            self.promptLB.text = "Email"
//            self.phoneOrEmailTF.text = account.email
//        }
        
        self.checkRegistBtnStatus()
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
                self.showTextSBimg("Sent successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //MARK: -重置密码申请
    func requestApplyResetpassword(){
        var param : ResetPassWordParam = ResetPassWordParam()
        let loginType : Int = UserDefaults.standard.object(forKey: LoginType) as! Int
//        if loginType == 0{
            param.areaCode = "234"
            param.phoneNum = phoneOrEmailTF.text
            param.optCode = codeTF.text
//        }else{
//            param.email = phoneOrEmailTF.text
//            param.optCode = codeTF.text
//        }
        self.showHUD(text: "Loading...")
//        let api = loginType == 0 ? wxApi.applyResetPassWordByPhone(param: param) : wxApi.applyResetPassWordByEmail(param: param)
        let api = wxApi.applyResetPassWordByPhone(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                if let dict = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as? NSDictionary {
                    if dict["data"] != nil{
                        let vtData = dict["data"] as! NSDictionary
                        if vtData["access-token"] != nil{
                            self.access_token = vtData["access-token"] as? String
                        }
                    }
                }
                let vc = ResetLoginPasswordController()
                vc.access_token = self.access_token
                self.pushVC(vc: vc)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
        }
    }

    @IBAction func sureClick(_ sender: Any) {
        self.view.endEditing(true)
        if self.isLoginType == true{
            requestApplyResetpassword()
        }else{
            self.requestApplySetPayPassword()
        }
    }
    func requestApplySetPayPassword(){
        var param : ApplyChangePayPassWordParam = ApplyChangePayPassWordParam()
        param.phoneNum = phoneOrEmailTF.text
        param.optCode = codeTF.text
        self.showHUD(text: "Loading...")

        let api = wxApi.applyEditPayPassword(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<ApplyChangePayPassWordModel>.deserialize(from: data)
            if(result?.code == 0){
                let vc = ResetPayPasswordController()
                vc.applySetPasswordModel = result?.data
                self.pushVC(vc: vc)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
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
                if promptLB.text == "Mobile number"{
                    result = Tool.checkPhone(str: "+234" + textField.text!)
                    phoneOrEmailErrorLB.text = "The Mobile is incorrect"
                }else{
                    result = Tool.checkEmailAddress(str: textField.text!)
                    phoneOrEmailErrorLB.text = "The Email Address is incorrect"
                }
                phoneOrEmailErrorLB.isHidden = result
                promptLB.textColor = result  ? .hexColor(hex: "101010") : .hexColor(hex: "FF3344")
                if result == false{
                    oneView.backgroundColor = UIColor.hexColor(hex: "FF3344")
                }else{
                    oneView.backgroundColor = UIColor.hexColor(hex: "D5D5D5")
                }
            }else{
                promptLB.textColor = .hexColor(hex: "101010")
                phoneOrEmailErrorLB.isHidden = true
                oneView.backgroundColor = UIColor.hexColor(hex: "D5D5D5")
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
    func checkRegistBtnStatus(){
        if promptLB.text == "Mobile number"{
            if Tool.checkPhone(str:"+234" + phoneOrEmailTF.text!) == false{
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
        sureBtn.isEnabled = enable
        sureBtn.backgroundColor = !enable ? .kRgbColor(red: 119, green: 234, blue: 162) : .hexColor(hex: "0CD664")
    }
}
