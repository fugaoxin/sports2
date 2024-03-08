//
//  ForgotPasswordView.swift
//  NGSprots
//
//  Created by Jean on 28/11/2023.
//

import UIKit
import MBProgressHUD
class ForgotPasswordView: UIView {
   
    @IBOutlet weak var phoneBtn: UIButton!
    
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var phoneOrEmailTFLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var phoneAreaBtn: UIButton!
    
    @IBOutlet weak var phoneOrEmailTF: UITextField!
    
    @IBOutlet weak var phoneOrEmailPromptLB: UILabel!
    
    @IBOutlet weak var codePromptLB: UILabel!
  
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var phoneBgView: UIView!
    
    @IBOutlet weak var codeBgView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var codeBgBottomLineView: UIView!
    
//    var phoneStr : String?
//    var emailStr : String?
    
    var nextBlock : (()->Void)?
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("ForgotPasswordView", owner: self, options: nil)?.first as! UIView
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
        phoneBtn.isSelected = true
        phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Mobile number *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        codePromptLB.attributedText = Tool.changeLableAttributeString(total: "OTP Code *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
        
        tipView.frame.size = CGSize(width: 15, height: 2.5)
        tipView.center.y = 47
        tipView.center.x = (kScreenW-78-50)/4 + 39
        
        phoneOrEmailTF.keyboardType = .numberPad
        codeTF.keyboardType = .numberPad
        
//        phoneBgView.layer.borderWidth = 0.5
//        phoneBgView.layer.borderColor = UIColor.hexColor(hex: "DEDEDE").cgColor
//        phoneBgView.layer.masksToBounds = true
//        
//        codeBgView.layer.borderWidth = 0.5
//        codeBgView.layer.borderColor = UIColor.hexColor(hex: "DEDEDE").cgColor
//        codeBgView.layer.masksToBounds = true
    }
   
    @IBAction func changeTypeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        if btn.isSelected == true{
            return
        }
        btn.isSelected = true
        phoneOrEmailTF.resignFirstResponder()
        codeTF.resignFirstResponder()
        phoneOrEmailTF.text = ""
        codeTF.text = ""
        if btn == phoneBtn{
            phoneOrEmailTF.keyboardType = .numberPad
            emailBtn.isSelected = false
            phoneAreaBtn.isHidden = false
            phoneBtn.isSelected = true
            phoneOrEmailTFLeftSpace.constant = 44
//            emailStr = phoneOrEmailTF.text
//            phoneOrEmailTF.text = phoneStr
            phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Mobile number *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
           
            self.codeBgView.isHidden = false
            self.codePromptLB.isHidden = false
            self.frame = CGRect(x: 25, y: (kScreenH-365)/2.0, width: kScreenW-50, height: 335)
            self.codeBgBottomLineView.isHidden = false
            nextBtn.setTitle("Next", for: .normal)
        }else{
            phoneOrEmailTF.keyboardType = .default
            phoneBtn.isSelected = false
            phoneAreaBtn.isHidden = true
            phoneOrEmailTFLeftSpace.constant = 0
//            phoneStr = phoneOrEmailTF.text
//            phoneOrEmailTF.text = emailStr
            phoneOrEmailPromptLB.attributedText = Tool.changeLableAttributeString(total: "Email *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
//            self.codeBgView.isHidden = true
//            self.codePromptLB.isHidden = true
//            self.frame = CGRect(x: 25, y: (kScreenH-275)/2.0, width: kScreenW-50, height: 255)
//            self.codeBgBottomLineView.isHidden = true
//            nextBtn.setTitle("Send Email", for: .normal)
            
        }
        self.view.frame = self.bounds
        UIView.animate(withDuration: 0.5) {
            self.tipView.center.x = btn.center.x
        }
    }
    
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func sendCodeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        Tool.countDown(60, btn: btn)
        var param : LoginParam = LoginParam()
//        param.areaCode = "234"
//        param.phoneNum = phoneOrEmailTF.text
//        Tool.keyWindow().showHUD(text: "Loading...")
//        let api = wxApi.getPhoneCode(param: param)
        if phoneBtn.isSelected == true{
            param.areaCode = "234"
            param.phoneNum = phoneOrEmailTF.text
        }else{
            param.email = phoneOrEmailTF.text
        }
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = phoneBtn.isSelected == true ? wxApi.getPhoneCode(param: param) : wxApi.getEmailCode(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            Tool.keyWindow().hideHUD()
            let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
            if(result?.code == 0){
                
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    @IBAction func nextClick(_ sender: Any) {
        if phoneBtn.isSelected == true{
            if Tool.checkPhone(str:"+234\(phoneOrEmailTF.text!)") == false{
                Tool.keyWindow().showTextSB("The Mobile is incorrect", dismissAfterDelay: 2)
                return
            }
            if codeTF.text!.count == 0{
                Tool.keyWindow().showTextSB("The Code cannot be empty", dismissAfterDelay: 2)
                return
            }
        }else{
            if Tool.checkEmailAddress(str: phoneOrEmailTF.text!) == false{
                Tool.keyWindow().showTextSB("The Email Address is incorrect", dismissAfterDelay: 2)
                return
            }
            if codeTF.text!.count == 0{
                Tool.keyWindow().showTextSB("The Code cannot be empty", dismissAfterDelay: 2)
                return
            }
        }
        if self.nextBlock != nil{
            self.nextBlock!()
        }
    }
}
