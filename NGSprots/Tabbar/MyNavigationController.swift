//
//  MyNavigationController.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/27.
//

import UIKit
let BalanceNotice = "balanceNotice"
let LoginNotice = "LoginNotice"
let LogoutNotice = "LogoutNotice"
class MyNavigationController: BaseViewController {
    
    var registerBtn: UIButton!
    var signInBtn: UIButton!
    var img: UIImageView!
    var lab: UILabel!
    var arrowIV: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        NotificationCenter.default.addObserver(self, selector: #selector(checkBalance), name: NSNotification.Name(rawValue: BalanceNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setRightBtn), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setRightBtn), name: NSNotification.Name(rawValue: LogoutNotice), object: nil)
    }
    
    
    func setNav(){
        self.addNavBar(.white)
        
        registerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 93, height: 35))
        registerBtn.backgroundColor = .hexColor(hex: RegisterBtnCorlor)
        registerBtn.addTarget(self, action: #selector(onRegisterBtn), for: .touchUpInside)
        registerBtn.layer.cornerRadius = 17.5
        registerBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        registerBtn.setTitle("Register", for: .normal)
        registerBtn.setTitleColor(.white, for: .selected)
        registerBtn.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        registerBtn.isSelected = true
        
        img = UIImageView(frame: CGRect(x: 5, y: 6.5, width: 22, height: 22))
        registerBtn.addSubview(img)
        img.image = UIImage(named: "navNumberUnit")
        lab = UILabel(frame: CGRect(x: 26, y: 7.5, width: 52, height: 20))
        lab.font = UIFont(name: "DIN Alternate Bold",size: 15)
        registerBtn.addSubview(lab)
        lab.textAlignment = .center
        lab.text = "2008"
        lab.textColor = .hexColor(hex: "101010")
        //registerBtn.backgroundColor = .hexColor(hex: "F4F4F4")
        arrowIV = UIImageView(frame: CGRect(x: 80, y: 13.5, width: 4.5, height: 8))
        registerBtn.addSubview(arrowIV)
        arrowIV.image = UIImage(named: "navArrow")
        
        img.isHidden = true
        lab.isHidden = true
        arrowIV.isHidden = true
        
        signInBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 93, height: 35))
        signInBtn.backgroundColor = .clear
        signInBtn.addTarget(self, action: #selector(onSignInBtn), for: .touchUpInside)
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.contentHorizontalAlignment = .right
        signInBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
        signInBtn.layer.cornerRadius = 17.5
        signInBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        signInBtn.setTitleColor(.white, for: .selected)
        signInBtn.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: registerBtn),UIBarButtonItem(customView: signInBtn)]
        
        let logoimg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 105, height: 30))
        let bgview = UIView.init(frame: CGRect(x: 0, y: 0, width: 105, height: 30))
        bgview.addSubview(logoimg)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: bgview)
        logoimg.image = UIImage.init(named: "logo_icon")
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRightBtn()
    }
    @objc func checkBalance(){
        let balance : String = Tool.getuserInfoModel()?.wallets?.first?.balance ?? ""
        lab.text = "\(balance)"
    }
    @objc func onRegisterBtn(){
        if Tool.getFBModel()?.token?.count ?? 0 > 0{
            self.tabBarController?.selectedIndex = 3
            return
        }
//        registerBtn.isSelected = true
//        signInBtn.isSelected = false
//        signInBtn.backgroundColor = .clear
//        registerBtn.backgroundColor = .hexColor(hex: RegisterBtnCorlor)
        
        let registVC = RegisterController()
        registVC.gotoLoginBlock = {[weak self] in
            self!.onSignInBtn()
        }
        let nav = UINavigationController(rootViewController: registVC)
        nav.modalPresentationStyle = .custom
        self.present(nav, animated: true)
    }
    
    @objc func onSignInBtn(){
//        registerBtn.isSelected = false
//        signInBtn.isSelected = true
//        signInBtn.backgroundColor = .hexColor(hex: RegisterBtnCorlor)
//        registerBtn.backgroundColor = .clear
        
        let loginVC = LoginController()
        loginVC.loginSuccessBlock = {[weak self] in
            self?.setRightBtn()
        }
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .custom
        self.present(nav, animated: true)
        
    }
    
    @objc func setRightBtn(){
        if Tool.getFBModel()?.token?.count ?? 0 > 0{
            img.isHidden = false
            lab.isHidden = false
            arrowIV.isHidden = false
            let balance : String = Tool.getuserInfoModel()?.wallets?.first?.balance ?? ""
            lab.text = "\(balance)"
            registerBtn.setTitle("", for: .normal)
            registerBtn.backgroundColor = .hexColor(hex: "F4F4F4")
            signInBtn.isHidden = true
            let textW = Tool.getLabelWith(text: balance,font: UIFont(name: "DIN Alternate Bold",size: 15)! ,labelH: 20)
            registerBtn.frame = CGRect(x: 0, y: 0, width: textW + 49, height: 35)
            lab.frame = CGRect(x: 30, y: 7.5, width: textW, height: 20)
            arrowIV.frame = CGRect(x: textW + 49 - 13, y: 13.5, width: 4.5, height: 8)
        }else{
            img.isHidden = true
            lab.isHidden = true
            arrowIV.isHidden = true
            if signInBtn.isSelected == false{
                registerBtn.backgroundColor = .hexColor(hex: RegisterBtnCorlor)
            }else{
                registerBtn.backgroundColor = .white
            }
            registerBtn.setTitle("Register", for: .normal)
            signInBtn.isHidden = false
            registerBtn.frame = CGRect(x: 0, y: 0, width: 93, height: 35)
            lab.frame = CGRect(x: 26, y: 7.5, width: 52, height: 20)
            arrowIV.frame = CGRect(x: 80, y: 13.5, width: 4.5, height: 8)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
