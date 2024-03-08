//
//  BaseViewController.swift
//  SportsDemo
//
//  Created by Jean on 6/11/2023.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate{
    
    var navBgColor : UIColor = .hexColor(hex: "F7F7F7")
    var navTitleColor : UIColor? {
        didSet{
            navigationItem.backBarButtonItem?.tintColor = navTitleColor == nil ? .black : navTitleColor
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: navTitleColor == nil ? .black : navTitleColor]
            let presentingViewController = self.presentingViewController
            if self.navigationController?.children.count != 1 || presentingViewController != nil {
                let btn:UIButton = UIButton(type:.custom)
                btn.addTarget(self, action: #selector(back), for: .touchUpInside)
                btn.frame = CGRectMake(0, 0, 40, 44)
                var imageV : UIImageView
                if (navTitleColor == nil ? .black : navTitleColor) == UIColor.white{
                    imageV = UIImageView(image: UIImage (named: "back_white" ))
                    imageV.frame = CGRect(x: 5, y: 10, width: 20, height: 20)
                }else{
                    imageV = UIImageView(image: UIImage (named: "fanhui_icon" ))
                    imageV.frame = CGRect(x: 5, y: 12, width: 12, height: 20)
                }
                btn.addSubview(imageV)
                let  leftBarBtn =  UIBarButtonItem.init(customView: btn)
                self .navigationItem.leftBarButtonItem = leftBarBtn
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let presentingViewController = self.presentingViewController
        if self.navigationController?.children.count != 1 || presentingViewController != nil {
            let btn:UIButton = UIButton(type:.custom)
            btn.addTarget(self, action: #selector(back), for: .touchUpInside)
            btn.frame = CGRectMake(0, 0, 40, 44)
            var imageV : UIImageView
            if (navTitleColor == nil ? .black : navTitleColor) == UIColor.white{
                imageV = UIImageView(image: UIImage (named: "back_white" ))
                imageV.frame = CGRect(x: 5, y: 10, width: 20, height: 20)
            }else{
                imageV = UIImageView(image: UIImage (named: "fanhui_icon" ))
                imageV.frame = CGRect(x: 5, y: 12, width: 12, height: 20)
            }
            btn.addSubview(imageV)
            let  leftBarBtn =  UIBarButtonItem.init(customView: btn)
            self .navigationItem.leftBarButtonItem = leftBarBtn
        }
        navigationItem.backBarButtonItem?.tintColor = navTitleColor == nil ? .black : navTitleColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: navTitleColor == nil ? .black : navTitleColor]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        let presentingViewController = self.presentingViewController
//        if self.navigationController?.children.count != 1 || presentingViewController != nil {
//            let btn:UIButton = UIButton(type:.custom)
//            btn.addTarget(self, action: #selector(back), for: .touchUpInside)
//            btn.frame = CGRectMake(0, 0, 40, 44)
//            var imageV : UIImageView
//            if navTitleColor == UIColor.white{
//                imageV = UIImageView(image: UIImage (named: "back_white" ))
//                imageV.frame = CGRect(x: 5, y: 10, width: 20, height: 20)
//            }else{
//                imageV = UIImageView(image: UIImage (named: "fanhui_icon" ))
//                imageV.frame = CGRect(x: 5, y: 12, width: 12, height: 20)
//            }
//            btn.addSubview(imageV)
//            let  leftBarBtn =  UIBarButtonItem.init(customView: btn)
//            self .navigationItem.leftBarButtonItem = leftBarBtn
//        }
//        navigationItem.backBarButtonItem?.tintColor = navTitleColor
//
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: navTitleColor]
        
    }
    @objc func back(){
        if self.isKind(of: PublicWebController.self){
            let vc : PublicWebController = self as! PublicWebController
            if vc.webView.canGoBack{
                vc.webView.goBack()
                return
            }
        }
        if self.isKind(of: GameViewController.self){
            let vc : GameViewController = self as! GameViewController
            if vc.webView.canGoBack{
                vc.webView.goBack()
                return
            }
        }
        if let presentingViewController = self.presentingViewController {
            // 通过 present 过来的页面
            if self.navigationController?.children.count != 1 { // present中继续push
                self.navigationController?.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        } else if let navigationController = self.navigationController {
            // 通过 push 过来的页面
            self.navigationController?.popViewController(animated: true)
        }
    }
    func addNavBar(_ color:UIColor){
         
         //设置导航栏高度（此处可根据导航栏高度的不同来获取导航栏高度）
         let size = CGSize(width: kScreenW, height: kStatusBarH + kNavigationBarH)
         //纯色创建UIImage
         UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
         color.setFill()
         UIRectFill(CGRect(origin: .zero, size: size))
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         //将UIImage添加到UIImageView
         let navImageView = UIImageView(image: image)
         view .addSubview(navImageView)
     }
    func pushVC (vc : UIViewController){
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        if self.navigationController?.children.count == 2{
            self.hidesBottomBarWhenPushed = false
        }
    }
    @discardableResult
    func addRightItemText(normal:String , select:String? ,textColor:UIColor?,selectTextColor:UIColor?) -> UIButton {
        let btn:UIButton = UIButton(type:.custom)
        btn.setTitle(normal, for: .normal)
        if select != nil && select?.isEmpty != true{
            btn.setTitle(select ?? "", for: .selected)
        }
        if selectTextColor != nil {
            btn.setTitleColor(selectTextColor, for: .selected)
        }
        btn.setTitleColor(textColor, for: .normal)
        btn.frame = CGRectMake(0, 0, 60, 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        let rightBarItem = UIBarButtonItem(customView:btn)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        return btn
    }
    @discardableResult
    func addRightItemImage(imageName:String) -> UIButton {
        let btn:UIButton = UIButton(type:.custom)
        btn.frame = CGRectMake(0, 0, 60, 44)
        if imageName == "customerService"{
            btn.addTarget(self, action: #selector(customerService), for: .touchUpInside)
        }
        let imageV : UIImageView = UIImageView(frame: CGRect(x: 25, y: 11, width: 25, height: 25))
        imageV.image = UIImage(named: imageName)
        btn.addSubview(imageV)
        let rightBarItem = UIBarButtonItem(customView:btn)
        self.navigationItem.rightBarButtonItem = rightBarItem
        return btn
    }
    @discardableResult
    func addRightTwoItemsImage(oneImageName:String,twoImageName:String) -> UIButton {
        let btn:UIButton = UIButton(type:.custom)
        btn.frame = CGRectMake(0, 0, 40, 44)
        if oneImageName == "customerService"{
            btn.addTarget(self, action: #selector(customerService), for: .touchUpInside)
        }
        let imageV : UIImageView = UIImageView(frame: CGRect(x: 15, y: 11, width: 25, height: 25))
        imageV.image = UIImage(named: oneImageName)
        btn.addSubview(imageV)
        let oneBarItem = UIBarButtonItem(customView:btn)
        
        let otherBtn:UIButton = UIButton(type:.custom)
        otherBtn.frame = CGRectMake(0, 0, 40, 44)
        if twoImageName == "customerService"{
            otherBtn.addTarget(self, action: #selector(customerService), for: .touchUpInside)
        }
        let otherImageV : UIImageView = UIImageView(frame: CGRect(x: 5, y: 11, width: 25, height: 25))
        otherImageV.image = UIImage(named: twoImageName)
        otherBtn.addSubview(otherImageV)
        let twoBarItem = UIBarButtonItem(customView:otherBtn)
        
        self.navigationItem.rightBarButtonItems = [twoBarItem,oneBarItem]
        return otherBtn
    }
    @objc func customerService(){
//        self.pushVC(vc: CustomerServiceController())
//        if self.navigationController?.viewControllers.count == 1{
//            self.hidesBottomBarWhenPushed = false
//        }
//        self.hidesBottomBarWhenPushed = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: -某一控制器可自由开启或关闭右滑pop
    func popGestureClose() {
        if let ges = self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            for item in ges {
                item.isEnabled = false
            }
        }
    }
        
    func popGestureOpen() {
        if let ges = self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            for item in ges {
                item.isEnabled = true
            }
        }
    }

  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController?.children.count == 1{
            popGestureClose()
        }else{
            popGestureOpen()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
