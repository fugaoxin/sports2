//
//  HelpController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/10.
//

import UIKit

class HelpController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }


    private func setUI(){
        title = "Help"
        addNavBar(.white)
        
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch(sender.tag){
        case 11:
            self.pushVC(vc: AboutUsController())
            break
        case 12:
            self.pushVC(vc: HowToPlayController())
            break
        case 13:
            goimgvc(name: "Tutorials", HH: (kScreenW - 20)*11.55)
            break
        case 14:
            goimgvc(name: "Terms & Conditions", HH: (kScreenW - 20)*2.5)
            break
        case 15:
            goimgvc(name: "Responsible Gambling", HH: (kScreenW - 20)*2.5)
            break
        default:
            goimgvc(name: "FAQs", HH: (kScreenW - 20)*3.3)
            break
        }
    }
    
    private func goimgvc(name: String, HH:CGFloat){
        let vc = HelpImgController()
        vc.str = name
        vc.svcHH = HH
        self.pushVC(vc: vc)
    }

}

