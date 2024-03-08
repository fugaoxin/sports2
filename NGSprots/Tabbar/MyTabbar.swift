//
//  MyTabbar.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/14.
//

import UIKit

class MyTabbar: UITabBarController {
    
    let manager = KeyboardManager_UIWindow.init()
    lazy var checkInAlertView : CheckInAlertView = {
        let bgH = 275*630/550
        let view = CheckInAlertView(frame: CGRect(x: (Int(kScreenW)-275)/2, y: (Int(kScreenH)-bgH-70)/2, width: 275, height: bgH+70))
        return view
    }()

    lazy var registerAlertView : RegisterActivityAlertView = {
        let bgH = (kScreenW-50)*506/660
        let y = (kScreenH-(bgH+185))/2
        let view = RegisterActivityAlertView(frame: CGRect(x: 0, y: y, width: kScreenW, height: bgH+185))
        return view
    }()
    lazy var depositAlertView : DepositActivityAlertView = {
        let bgH = (kScreenW-50)*550/660
        let y = (kScreenH-(bgH+80))/2
        let view = DepositActivityAlertView(frame: CGRect(x: 0, y: y, width: kScreenW, height: bgH+80))
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        ///启动app时刷新钱包数据
        if Tool.getuserInfoModel() != nil{
            Tool.requestGetUserInfo {
            }
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(showCheckInView), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
        LaunchImageHelper.changeAllLaunchImage(toPortrait: UIImage(named: "FFSportsBg")!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let coder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(coder)
        
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {
            if self.checkInAlertView.superview != nil{
                Tool.keyWindow().hiddenInWindow()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    Tool.keyWindow().showInWindow(functionView: self.depositAlertView)
                }
            }else{
                Tool.keyWindow().hiddenInWindow()
            }
        }
        self.showCheckInView()
        if Tool.getuserInfoModel() == nil{
            self.showRegisterActivityAlertView()
        }
    }
    @objc func showCheckInView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentDate = dateFormatter.string(from: Date())
        let value = UserDefaults.standard.object(forKey: currentDate)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Tool.requestGetCheckInDetail(rangeType: "week", date: currentDate) { model in
                for item in model?.checkinStatus ?? []{
                    if item.status != 1 && item.date == currentDate && Tool.getuserInfoModel() != nil && value == nil{
                        self.checkInAlertView.setBtnUI()
                        self.checkInAlertView.model = model
                        Tool.keyWindow().showInWindow(functionView: self.checkInAlertView)
                        self.checkInAlertView.checkInAlertCloseBlock = {[weak self] in
                            ActivityRequest.getDepositActivity { model in
                                self?.depositAlertView.rateLB.text = Tool.StringIsEmpty(value: model?.taskTotalAwardText) ? "":model?.taskTotalAwardText
                                Tool.keyWindow().showInWindow(functionView: self!.depositAlertView)
                                self?.depositAlertView.goToDepositActivity = {
                                    self?.requestDepositActivityDetail()
                                }
                            }
                        }
                        UserDefaults.standard.set(1, forKey: currentDate)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    func showRegisterActivityAlertView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        let value = UserDefaults.standard.object(forKey: currentDate)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            Tool.requestGetCheckInDetail(rangeType: "week", date: currentDate) { model in
//                for item in model?.checkinStatus ?? []{
                    if value == nil{
                        Tool.keyWindow().showInWindow(functionView: self.registerAlertView)
                        UserDefaults.standard.set(1, forKey: currentDate)
                        UserDefaults.standard.synchronize()
                    }
//                }
//            }
        }
    }
    func requestDepositActivityDetail(){
        ActivityRequest.getActivityDetail(type: 3) { model in
            let web = PublicWebController()
            web.titleStr = "Deposit Bonus"
            web.url = model?.linkH5
            let vc = Tool.getCurrentVc()
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(web, animated: true)
            if vc.navigationController?.children.count == 2{
                vc.hidesBottomBarWhenPushed = false
            }
        }
    }
    private func setupUI() {
        let HotsVC = BrowseViewController()
        let HotsNav = UINavigationController.init(rootViewController: HotsVC)
        let FollowVC = PopularViewController()
        let FollowNav = UINavigationController.init(rootViewController: FollowVC)
        let BettingSlipVC = BetSlipController()
        let BettingSlipNav = UINavigationController.init(rootViewController: BettingSlipVC)
        let RechargeVC = PurseController()
        let RechargeNav = UINavigationController.init(rootViewController: RechargeVC)
        let MineVC = MineController()
        let MineNav = UINavigationController.init(rootViewController: MineVC)
        
        let item1 = tabItem(title: "Menu", image: UIImage.init(named: "Menu2") ?? UIImage(), selectImage: UIImage.init(named: "Menu") ?? UIImage())
        HotsNav.tabBarItem = item1
        let item2 = tabItem(title: "Home", image: UIImage.init(named: "Home2") ?? UIImage(), selectImage: UIImage.init(named: "Home") ?? UIImage())
        FollowNav.tabBarItem = item2
        
        let item3 = tabItem(title: "Betslip", image: UIImage.init(named: "Betslip2") ?? UIImage(), selectImage: UIImage.init(named: "Betslip") ?? UIImage())
        BettingSlipNav.tabBarItem = item3
        
        let item4 = tabItem(title: "Deposit", image: UIImage.init(named: "Deposit2") ?? UIImage(), selectImage: UIImage.init(named: "Deposit") ?? UIImage())
        RechargeNav.tabBarItem = item4
        let item5 = tabItem(title: "Me", image: UIImage.init(named: "Me2") ?? UIImage(), selectImage: UIImage.init(named: "Me") ?? UIImage())
        MineNav.tabBarItem = item5

        self.viewControllers = [HotsNav,FollowNav,BettingSlipNav,RechargeNav,MineNav]
        self.tabBar.tintColor = UIColor.hexColor(hex: "000000")
        self.tabBar.backgroundColor = .white
        self.selectedIndex = 1
        
        if #available(iOS 13, *) {
           let appearance = self.tabBar.standardAppearance.copy()
           appearance.backgroundImage = UIImage()
           appearance.backgroundColor = .white
           appearance.backgroundEffect = nil////这句话非常重要，在不动.translucent属性前提下，设置纯背景颜色，特别是设置tabbar透明，非常重要
           self.tabBar.standardAppearance = appearance
           if #available(iOS 15.0, *) {
             ///用这个方法的，这个一定要加，否则15.0系统下会出问题，一滑动tabbar就变透明!!!
              self.tabBar.scrollEdgeAppearance = appearance
             } else {
                 
             }
        }else{
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.shadowImage = UIImage()
            self.tabBar.barTintColor = .white
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(endBetHistory), name: NSNotification.Name(rawValue: "history"), object: nil)
    }
    
    @objc func endBetHistory(){
        self.selectedIndex = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "history2"), object: nil)
        }
    }
    
    func tabItem(title:String ,image:UIImage,selectImage:UIImage) -> UITabBarItem{
        let item = UITabBarItem.init()
        let imageNor = image.withRenderingMode(.alwaysOriginal)
        let imageSel = selectImage.withRenderingMode(.alwaysOriginal)
        item.selectedImage = imageSel
        item.image = imageNor
        item.title = title
        return item
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if Tool.getuserInfoModel() == nil{
            if item.title == "Deposit" || item.title == "Betslip"{
                Tool.goToLogin()
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
