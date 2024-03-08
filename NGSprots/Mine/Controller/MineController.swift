//
//  MineController.swift
//  NGSprots
//
//  Created by Jean on 3/1/2024.
//

import UIKit

class MineController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var dataArr : [[String]] = [["Promotions","Bank Account","Online Service","Invite friends","Money record","Help","Settings"],["Log out"]]
    
    lazy var mineHeaderView : MineHeaderView = {
        let bgH = (kScreenW - 44)*157/662
        let view = MineHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 210+bgH+kNavigationBarH+kStatusBarH))
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBar(.clear)
        self.addRightItemImage(imageName: "customerService")
        
        self.setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(jumpToController), name: NSNotification.Name(rawValue: CheckInGetCouponNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginRefresh()
    }
    @objc func loginRefresh(){
        Tool.requestGetUserInfo {
            self.mineHeaderView.setUpData()
        }
        if Tool.getuserInfoModel() == nil{
            self.mineHeaderView.messageCountLB.isHidden = true
            dataArr = [["Promotions","Bank Account","Online Service","Invite friends","Money record","Help","Settings"]]
        }else{
            self.requestUnreadMessageCount()
            dataArr = [["Promotions","Bank Account","Online Service","Invite friends","Money record","Help","Settings"],["Log out"]]
        }
        self.tableView.reloadData()
       
    }
    @objc private func jumpToController(_ notify: NSNotification){
        let userInfo = notify.userInfo
        let type: Int = userInfo!["type"] as! Int
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if type == 1{
                if (Tool.getCurrentVc() is MineController) && !(Tool.getCurrentVc() is CouponController){
                    self.pushVC(vc: CouponController())
                }
            }else if type == 0{
                self.tabBarController?.selectedIndex = 3
            }else{
                self.tabBarController?.selectedIndex = 1
            }
        }
    }
    func requestUnreadMessageCount(){
        self.showHUD(text: "Loading...")
        let api = wxApi.getUnreadMessageCount
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<MessageCountModel>.deserialize(from: data)
            if(result?.code == 0){
                if result?.data?.unreadCount == 0 || result?.data?.unreadCount == nil{
                    self.mineHeaderView.messageCountLB.isHidden = true
                }else{
                    self.mineHeaderView.messageCountLB.isHidden = false
                    self.mineHeaderView.messageCountLB.text = String(result?.data?.unreadCount ?? 0)
                }
            }else{
                self.mineHeaderView.messageCountLB.isHidden = true
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.mineHeaderView.messageCountLB.isHidden = true
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestLogout(){
        self.showHUD(text: "Loading...")
        let api = wxApi.userLogout
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<MessageCountModel>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSBimg("Exit successfully", dismissAfterDelay: 1.5, imgstr: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.hideHUD()
                    Tool.clearFBModel()
                    Tool.clearUserInfoModel()
                    chuanguanArray.removeAll()
                    UserDefaults.standard.set(nil, forKey: "token")
                    UserDefaults.standard.set(nil, forKey: isShowHudToken)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogoutNotice), object: nil, userInfo: nil)
                    self.mineHeaderView.setUpData()
                    self.dataArr = [["Promotions","Bank Account","Online Service","Invite friends","Money record","Help","Settings"]]
                    self.tableView.reloadData()
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func setUpUI(){
        tableView.backgroundColor = .hexColor(hex: "F5F6F9")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MineCell", bundle: nil), forCellReuseIdentifier: "MineCell")
        tableView.tableHeaderView = self.mineHeaderView
       
        self.mineHeaderView.headerFuctionBlock = {[weak self]type in
            switch type{
            case -1: ///编辑个人信息
                self?.pushVC(vc: EditInfoController())
                break
            case -2:
                self?.tabBarController?.selectedIndex = 3
                break
            case 0:
                self?.pushVC(vc: BonusController())
                break
            case 1:
                self?.pushVC(vc: CouponController())
                break
            case 2:
                self?.tabBarController?.selectedIndex = 2
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "history2"), object: nil)
                }
                break
            case 3:
                self?.pushVC(vc: MessageController())
                break
            default:
                break
            }
        }
    }
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0 || indexPath.row == self.dataArr[indexPath.section].count-1{
                return 68
            }
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MineCell = tableView.dequeueReusableCell(withIdentifier: "MineCell") as! MineCell
        cell.imageV.image = UIImage(named: self.dataArr[indexPath.section][indexPath.row])
        cell.titleLB.text = self.dataArr[indexPath.section][indexPath.row]
        if indexPath.row == 0 && self.dataArr[indexPath.section].count == 1{
            cell.type = -1
        }else if indexPath.row == self.dataArr[indexPath.section].count-1 &&  self.dataArr[indexPath.section].count != 1{
            cell.type = 2
        }else if indexPath.row == 0 && self.dataArr[indexPath.section].count != 1 {
            cell.type = 0
        }else{
            cell.type = 1
        }
        if indexPath.section == 0 && indexPath.row == 0{
            cell.imageVTopSpace.constant = 30
        }else{
            cell.imageVTopSpace.constant = 17.5
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW-30, height: 10))
        view.backgroundColor = .hexColor(hex: "F5F6F9")
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            self.requestLogout()
        }else{
            if indexPath.row == 1  || indexPath.row == 4 || indexPath.row == 6{
                if Tool.getuserInfoModel() == nil{
//                    self.showTextSB("Please Login", dismissAfterDelay: 1.5)
                    Tool.goToLogin()
                    return
                }
            }
            switch indexPath.row{
            case 0:
                self.pushVC(vc: PromotionsController())
                break
            case 1:
                self.pushVC(vc: BankAccountController())
                break
            case 2:
                break
            case 3:
                break
            case 4:
                self.pushVC(vc: MoneyRecordController())
                break
            case 5:
                self.pushVC(vc: HelpController())
                break
            case 6:
                self.pushVC(vc: SettingsController())
                break
            default:
                break
            }
        }
    }
}
