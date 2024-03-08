//
//  HowToPlayController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/10.
//

import UIKit

class HowToPlayController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = "How To Play"
        addNavBar(.white)
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch(sender.tag){
        case 11:
            goimgvc(name: "How To Register", HH: (kScreenW - 20)*2.08)
            break
        case 12:
            goimgvc(name: "How To Login", HH: (kScreenW - 20)*2.18)
            break
        case 13:
            goimgvc(name: "How To Change Your Password", HH: (kScreenW - 20)*2.1)
            break
        case 14:
            goimgvc(name: "How To Deposit", HH: (kScreenW - 20)*2.2)
            break
        default:
            goimgvc(name: "How To Withdraw", HH: (kScreenW - 20)*8)
            break
        }
    }
    
    private func goimgvc(name: String, HH:CGFloat){
        let vc = HelpImgController()
        vc.str = name
        vc.svcHH = HH
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
