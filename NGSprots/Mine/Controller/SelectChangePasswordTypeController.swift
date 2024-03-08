//
//  SelectChangePasswordTypeController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class SelectChangePasswordTypeController: BaseViewController {

    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginLB: UILabel!
    
    @IBOutlet weak var loginIV: UIImageView!
    
    @IBOutlet weak var payBtn: UIButton!
    
    @IBOutlet weak var payLB: UILabel!
    
    @IBOutlet weak var payIV: UIImageView!
    
    var isLoginType : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Type"
        self.addNavBar(.white)
    }


    @IBAction func selectTypeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        self.isLoginType = btn == self.loginBtn ? true : false
        self.loginLB.font = btn == self.loginBtn ? UIFont(name: "PingFangSC-Semibold",size: 14) : UIFont(name: "PingFangSC-Regular",size: 14)
        self.payLB.font = btn == self.payBtn ? UIFont(name: "PingFangSC-Semibold",size: 14) : UIFont(name: "PingFangSC-Regular",size: 14)
        self.loginIV.image = btn == self.loginBtn ? UIImage(named: "paySelect") : UIImage(named: "payUnSelect")
        self.payIV.image = btn == self.payBtn ? UIImage(named: "paySelect") : UIImage(named: "payUnSelect")
    }
    
    @IBAction func nextClick(_ sender: Any) {
        let vc = ChangePasswordCheckController()
        vc.isLoginType = self.isLoginType
        self.pushVC(vc: vc)
    }
}
