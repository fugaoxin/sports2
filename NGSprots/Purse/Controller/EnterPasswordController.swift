//
//  EnterPasswordController.swift
//  NGSprots
//
//  Created by Jean on 25/12/2023.
//

import UIKit

class EnterPasswordController: BaseViewController,PasswordViewDelegate {

    @IBOutlet weak var passwordView: PasswordView!
    
    @IBOutlet weak var finishBtn: UIButton!
    
    var passWord  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.delegate = self
        self.changeConfirmBtn()
    }
    
    @IBAction func finishClick(_ sender: Any) {
        self.checkPassword()
    }
    
    @IBAction func forgotClick(_ sender: Any) {
        self.pushVC(vc: ForgotPasswordCheckController())
    }
    
    func checkPassword(){
        var param : SetPayPassWordParam = SetPayPassWordParam()
        param.password = Int(passWord)
        self.showHUD(text: "Loading...")
        let api = wxApi.checkPayPassword(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<SetPayPassWordModel>.deserialize(from: data)
            if(result?.code == 0){
                let vc = AddBankCardController()
                vc.setPasswordModel = result?.data
                self.pushVC(vc: vc)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func passwordView(view: PasswordView, textFinished: String) {
        passWord = textFinished
        self.changeConfirmBtn()
    }
    func passwordView(view: PasswordView, textChanged: String, length: Int) {
        passWord = textChanged
        self.changeConfirmBtn()
    }
    func changeConfirmBtn(){
        finishBtn.isEnabled = passWord.count != 6 ? false : true
        finishBtn.backgroundColor = passWord.count != 6 ? .kRgbColor(red: 119, green: 234, blue: 162) : .hexColor(hex: "0CD664")
    }
}
