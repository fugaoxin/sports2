//
//  ResetLoginPasswordController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class ResetLoginPasswordController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var firstPassWordTF: UITextField!
    
    @IBOutlet weak var secondPassWordTF: UITextField!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipIV: UIImageView!
    @IBOutlet weak var tipLB: UILabel!
    @IBOutlet weak var tipCloseBtn: UIButton!
    var access_token:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBar(.white)
        firstPassWordTF.delegate = self
        secondPassWordTF.delegate = self
        firstPassWordTF.isSecureTextEntry = true
        self.checkRegistBtnStatus()
    }

    @IBAction func sureClick(_ sender: Any) {
        if firstPassWordTF.text != secondPassWordTF.text{
            self.showTextSB("The two passwords do not match", dismissAfterDelay: 1.5)
            return
        }
        setPassword(password: secondPassWordTF.text ?? "")
    }
    @IBAction func closeTipClick(_ sender: Any) {
        self.tipView.isHidden = true
    }
    @IBAction func lookPasswordClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        secondPassWordTF.isSecureTextEntry = !btn.isSelected
    }
    func showTip(){
        self.tipView.removeFromSuperview()
        self.tipView.frame = CGRect(x: 10, y: kNavigationBarH+kStatusBarH+20-53, width: kScreenW-20, height: 50)
        Tool.keyWindow().addSubview(self.tipView)
        
        self.tipIV.frame = CGRect(x: 16, y: 12.5, width: 25, height: 25)
        self.tipCloseBtn.frame = CGRect(x: kScreenW-92, y: 0, width: 64, height: 50)
        self.tipLB.frame = CGRect(x: CGRectGetMaxX(self.tipIV.frame)+16, y: 0, width: kScreenW-57-77, height: 50)
        
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkRegistBtnStatus()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (Tool.checkContainLowerAndUpper(str: textField.text!) && Tool.checkContainNumber(str: textField.text!) && textField.text!.count>=8) == false && !Tool.StringIsEmpty(value: textField.text){
            Tool.keyWindow().showTextSB("1.Includes lower and upper case 2.At least 1 number 3.Minimum 8 characters", dismissAfterDelay: 3)
        }
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkRegistBtnStatus(){
        if (Tool.checkContainLowerAndUpper(str: firstPassWordTF.text!) && Tool.checkContainNumber(str: firstPassWordTF.text!) && firstPassWordTF.text!.count>=8) == false{
            self.changeRegistBtn(enable: false)
            return
        }
        if (Tool.checkContainLowerAndUpper(str: secondPassWordTF.text!) && Tool.checkContainNumber(str: secondPassWordTF.text!) && secondPassWordTF.text!.count>=8) == false{
            self.changeRegistBtn(enable: false)
            return
        }
        self.changeRegistBtn(enable: true)
    }
    func changeRegistBtn(enable:Bool){
        sureBtn.isEnabled = enable
        sureBtn.backgroundColor = !enable ? .kRgbColor(red: 119, green: 234, blue: 162) : .hexColor(hex: "0CD664")
    }
    
    private func setPassword(password: String){
        var param : ResetPassWordParam = ResetPassWordParam()
        param.password = password
        param.access_token = access_token
        self.showHUD(text: "Loading...")
        let api =  wxApi.resetPassWordConfirm(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSBimg("Modified successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
        }
    }

}
