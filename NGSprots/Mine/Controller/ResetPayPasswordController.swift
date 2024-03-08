//
//  ResetPayPasswordController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class ResetPayPasswordController: BaseViewController,PasswordViewDelegate {
    @IBOutlet weak var onePassWordView: PasswordView!
    
    @IBOutlet weak var twoPassWordView: PasswordView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var applySetPasswordModel : ApplyChangePayPassWordModel?
    
    var firstPassWord  = ""
    var secondPassWord  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBar(.white)
        onePassWordView.delegate = self
        twoPassWordView.delegate = self
        self.changeConfirmBtn()
    }
    @IBAction func sureClick(_ sender: Any) {
        self.view.endEditing(true)
        self.sureChangePassWord()
    }
   
    func sureChangePassWord(){
        var param : SetPayPassWordParam = SetPayPassWordParam()
        param.accessToken = self.applySetPasswordModel?.accessToken
        param.password = Int(self.firstPassWord)
        self.showHUD(text: "Loading...")
        let api = wxApi.sureEditPayPassword(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<ApplyChangePayPassWordModel>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSB("Set successfully", dismissAfterDelay: 1.5)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.firstPassWord = ""
                    self.secondPassWord = ""
                    self.onePassWordView.text = ""
                    self.twoPassWordView.text = ""
                    self.changeConfirmBtn()
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
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
