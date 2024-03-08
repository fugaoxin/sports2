//
//  ResetPasswordView.swift
//  NGSprots
//
//  Created by Jean on 28/11/2023.
//

import UIKit

class ResetPasswordView: UIView,UITextFieldDelegate {

    @IBOutlet weak var promptLB: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    var resetPasswordBlock : (()->Void)?
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("ResetPasswordView", owner: self, options: nil)?.first as! UIView
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
        promptLB.attributedText = Tool.changeLableAttributeString(total: "New password *", changeStr: "*", changeColor: .hexColor(hex: "FF0000"),changeFont: nil)
    }
    @IBAction func closeClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
    }
    
    @IBAction func lookPasswordClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    
    @IBAction func nextClick(_ sender: Any) {
        if (Tool.checkContainLowerAndUpper(str: passwordTF.text!) && Tool.checkContainNumber(str: passwordTF.text!) && passwordTF.text!.count>=8) == false{
            Tool.keyWindow().showTextSB("1.Includes lower and upper case 2.At least 1 number 3.Minimum 8 characters", dismissAfterDelay: 2)
            return
        }
        if self.resetPasswordBlock != nil{
            self.resetPasswordBlock!()
        }
    }
}
