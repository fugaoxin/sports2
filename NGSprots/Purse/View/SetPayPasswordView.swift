//
//  SetPayPasswordView.swift
//  NGSprots
//
//  Created by Jean on 25/12/2023.
//

import UIKit

class SetPayPasswordView: UIView,PasswordViewDelegate {
    var completeSetPassWordBlock : ((_ password : String)->Void)?
    
    @IBOutlet weak var onePassWordView: PasswordView!
    
    @IBOutlet weak var twoPassWordView: PasswordView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var firstPassWord  = ""
    var secondPassWord  = ""
    
    
    
    //是否是重置密码 重置密码与第一次设置密码 接口不同
    var isChangePassword  = false
    
    var checkToken : String = ""
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SetPayPasswordView", owner: self, options: nil)?.first as! UIView
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
        onePassWordView.delegate = self
        twoPassWordView.delegate = self
        self.changeConfirmBtn()
    }
    func removePassWord(){
        self.firstPassWord = ""
        self.secondPassWord = ""
        onePassWordView.text = ""
        twoPassWordView.text = ""
        self.changeConfirmBtn()
    }
    @IBAction func closeClick(_ sender: Any) {
        self.endEditing(true)
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
    }

    @IBAction func sureClick(_ sender: Any) {
        self.endEditing(true)
        if self.isChangePassword == true{
            if self.completeSetPassWordBlock != nil{
                self.completeSetPassWordBlock!(self.firstPassWord)
            }
        }else{
            var param : SetPayPassWordParam = SetPayPassWordParam()
            param.password = Int(self.firstPassWord)
            param.accessToken = self.checkToken
            Tool.keyWindow().showHUD(text: "Loading...")
            let api = wxApi.setPayPassword(param: param)
            AdHttpRequest(url: api, successCallBack: { data in
                print("\(data)")
                Tool.keyWindow().hudHide()
                let result = RequestCallBackViewModel<LoginModel>.deserialize(from: data)
                if(result?.code == 0){
                    Tool.keyWindow().showTextSB("Set successfully", dismissAfterDelay: 1.5)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        self.closeClick(UIButton())
                        if self.completeSetPassWordBlock != nil{
                            self.completeSetPassWordBlock!(self.firstPassWord)
                        }
                    }
                }else{
                    Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        self.closeClick(UIButton())
                        if self.completeSetPassWordBlock != nil{
                            self.completeSetPassWordBlock!(self.firstPassWord)
                        }
                    }
                }
            }) { error in
                Tool.keyWindow().hudHide()
                Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
            }
        }
    }
    
    func passwordView(view: PasswordView, textFinished: String) {
        if view == onePassWordView{
            firstPassWord = textFinished
        }else{
            secondPassWord = textFinished
        }
        self.changeConfirmBtn()
    }
    func passwordView(view: PasswordView, textChanged: String, length: Int) {
        if view == onePassWordView{
            firstPassWord = textChanged
        }else{
            secondPassWord = textChanged
        }
        self.changeConfirmBtn()
    }
    func changeConfirmBtn(){
        var enable = false
        if firstPassWord == secondPassWord && firstPassWord != ""{
            enable = true
        }
        confirmBtn.isEnabled = enable
        confirmBtn.backgroundColor = !enable ? .kRgbColor(red: 119, green: 234, blue: 162) : .hexColor(hex: "0CD664")
    }
}
