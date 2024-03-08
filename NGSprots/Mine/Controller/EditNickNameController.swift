//
//  EditNickNameViewController.swift
//  SportsDemo
//
//  Created by Jean on 3/11/2023.
//

import UIKit

class EditNickNameController: BaseViewController {
    var saveNickNameBlock : ((_ nickName : String)->Void)?
    
    @IBOutlet weak var promptTV: UITextView!
    @IBOutlet weak var nickNameTF: UITextField!
    var nickName : String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nickname"
        self.addNavBar(.white)
        let btn = self.addRightItemText(normal: "Done", select: "Done", textColor: .hexColor(hex: "0CD664"),selectTextColor: .hexColor(hex: "0CD664"))
        btn.addTarget(self, action: #selector(clickSaveItem), for: .touchUpInside)
       
        setUpUI()
    }

    func requestEditNickName(){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.nickName = nickNameTF.text
        let api = wxApi.editUserNickname(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                if self.saveNickNameBlock != nil{
                    self.saveNickNameBlock!(self.nickNameTF.text ?? "")
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
    func setUpUI(){
        nickNameTF.placeholder = "Please enter"
        nickNameTF.text = self.nickName
        promptTV.text = "Modification of nicknames needs to comply with the following norms: \n\nLegitimacy: Nicknames must comply with national and regional laws and regulations, and must not contain illegal, undesirable, insulting, pornographic and other undesirable content. \n\nSimple and clear: nicknames should be simple and clear, easy to remember and recognize, avoiding the use of overly complex or difficult to understand the vocabulary. \n\nAvoid infringement: Nicknames should avoid infringing on the rights and interests of others, such as trademarks, patents, copyrights, etc. \n\nDo not contain private information: Nicknames should not contain the user’s real name, ID number, phone number and other private information. \n\nDo not use sensitive words: Avoid using words that may cause controversy or political sensitivity to avoid unnecessary trouble. \n\nSecurity: Nicknames should meet the security requirements of the website, such as length, character types, etc. \n\nCompliance with website guidelines: Different websites may have different guidelines and regulations, and users need to comply with the website’s regulations and not use nicknames that violate them. \n\nIf your nickname regulates the website rules, we have the right to deal with it, thanks for your cooperation."
    }
    @objc func clickSaveItem(){
        if((nickNameTF.text ?? "").isEmpty){
            self.showTextSB("Please enter", dismissAfterDelay: 1.5)
            return
        }
        self.requestEditNickName()
    }

}
