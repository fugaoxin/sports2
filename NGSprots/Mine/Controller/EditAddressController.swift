//
//  EditAddressController.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit

class EditAddressController: BaseViewController,UITextViewDelegate {
    var saveAddressBlock : ((_ address: String)->Void)?
    
    @IBOutlet weak var addressTV: UITextView!

    @IBOutlet weak var textViewPromptLB: UILabel!
    
    @IBOutlet weak var enterTextLengthLB: UILabel!
    
    var address : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Address"
        self.addNavBar(.white)
        let btn = self.addRightItemText(normal: "Done", select: "Done", textColor: .hexColor(hex: "0CD664"), selectTextColor: .hexColor(hex: "0CD664"))
        btn.addTarget(self, action: #selector(clickSaveItem), for: .touchUpInside)
        setUpUI()
    }
    func setUpUI(){
        self.addressTV.backgroundColor = .white
        self.addressTV.delegate = self
        if self.address == ""{
            self.textViewPromptLB.isHidden = false
        }else{
            self.textViewPromptLB.isHidden = true
        }
        self.addressTV.text = self.address
        self.enterTextLengthLB.text = "\(self.addressTV.text.count)/200"
    }
    func requestEditAddress(){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.address = addressTV.text
        let api = wxApi.editUserAddress(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                if self.saveAddressBlock != nil{
                    self.saveAddressBlock!(self.addressTV.text ?? "")
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            self.textViewPromptLB.isHidden = false
        }else{
            self.textViewPromptLB.isHidden = true
        }
        
        let selectedRange = textView.markedTextRange
        let pos = textView.position(from: textView.beginningOfDocument, offset: 0)
        
        if (selectedRange != nil) && (pos != nil) {
            return
        }
        if textView.text.count >= 200 {
            self.showTextSB("Exceed word limit", dismissAfterDelay: 1)
            textView.text = String(textView.text.prefix(200))
        }
        self.enterTextLengthLB.text = "\(textView.text.count)/200"
    }
    @objc func clickSaveItem(){
        if((addressTV.text ?? "").isEmpty){
            self.showTextSB("Please enter", dismissAfterDelay: 1.5)
            return
        }
        self.requestEditAddress()
    }
}
