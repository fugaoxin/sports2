//
//  RegisterActivityController.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class RegisterActivityController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    var cutdownTimePromptLB : UILabel?
    var cutdownTimeLB : UILabel?
    
    var model : RegisterActivityModel?
//    var detailModel : ActivityDetailModel?
    
    var dayStr : Int = 0
    var hourStr : Int = 0
    var minitStr : Int = 0
    var secondStr : Int = 0
    var timer : Timer?
    lazy var headerView : UIView = {
        let bgH = kScreenW*704/750
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: bgH))
        let imageV = UIImageView(frame: view.bounds)
        imageV.image = UIImage(named: "registerHeaderBg")
        view.addSubview(imageV)
        
        self.cutdownTimePromptLB = UILabel(frame: CGRect(x: kScreenW/2-115, y: 140, width: 100, height: 17))
        self.cutdownTimePromptLB!.text = "Remaining Time"
        self.cutdownTimePromptLB!.font = UIFont(name: "PingFangSC-Semibold",size: 12)
        self.cutdownTimePromptLB!.textAlignment = .right
        self.cutdownTimePromptLB!.textColor = .white
        self.cutdownTimePromptLB!.isHidden = true
        view.addSubview(self.cutdownTimePromptLB!)
        
        self.cutdownTimeLB = UILabel(frame: CGRect(x: kScreenW/2-10, y: 138, width: 115, height: 20))
        self.cutdownTimeLB!.font = UIFont(name: "PingFangSC-Semibold",size: 12)
        self.cutdownTimeLB!.text = "0 Day"
        self.cutdownTimeLB!.textAlignment = .center
        self.cutdownTimeLB!.textColor = .hexColor(hex: "101010")
        self.cutdownTimeLB!.backgroundColor = .hexColor(hex: "FFE283")
        self.cutdownTimeLB!.layer.cornerRadius = 10
        self.cutdownTimeLB!.layer.masksToBounds = true
        self.cutdownTimeLB!.isHidden = true
        view.addSubview(self.cutdownTimeLB!)
       
        return view
    }()
    lazy var footerView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1000))
        view.backgroundColor = .hexColor(hex: "FF3689")
        return view
    }()
    lazy var checkInCouponObtainedView : CheckInCouponObtainedView = {
        let view = CheckInCouponObtainedView(frame: CGRect(x: 38, y: (kScreenH-185-110)/2, width: kScreenW-76, height: 185 + 110))
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome Bonus"
        self.addNavBar(.white)
        
        setUpUI()
        self.requestGetDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestGetDetail), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
    }
    func setUpUI(){
        
        
        tableView.backgroundColor = .hexColor(hex: "FF3689")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RegisterActivityCell", bundle: nil), forCellReuseIdentifier: "RegisterActivityCell")
        
        tableView.tableHeaderView = self.headerView
        
        self.checkInCouponObtainedView.jumpBlock = {[weak self]type in
            self?.popToController(type: type)
        }
    }
    
    @objc func requestGetDetail(){
        self.showHUD(text: "Loading...")
        let api = wxApi.registerActivity
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<RegisterActivityModel>.deserialize(from: data)
            if(result?.code == 0){
                self.model = result?.data
                self.activityCutdownTime(timestampStr: self.model?.ExpireTime ?? 0)
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            self.changeBottomStatus()
//            ActivityRequest.getActivityDetail(type: 2) { model in
//                self.detailModel = model
//                self.setUpIntroView()
//            }
            self.setUpIntroView()
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            self.changeBottomStatus()
        }
    }
    func requestGetActivityBouns(model : RegisterActivityTaskModel,taskNum:Int){
        self.showHUD(text: "Loading...")
        var param = ActivityParam()
        param.taskN = taskNum
        let api = wxApi.getRegisterActivityBouns(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<RegisterActivityModel>.deserialize(from: data)
            if(result?.code == 0){
                self.checkInCouponObtainedView.isRegisterActivity = true
                var changeModel = CheckInCouponModel()
                changeModel.text = "Task Reward"
                changeModel.coupons = []
                for item in model.coupons ?? []{
                    changeModel.coupons?.append(item)
                }
                self.checkInCouponObtainedView.model = changeModel
                Tool.keyWindow().showInWindow(functionView: self.checkInCouponObtainedView)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func activityCutdownTime(timestampStr : Int){
        let s: String = String((Double(timestampStr)) / 1000)
        let t: TimeInterval =  TimeInterval(s)!
        let endDate: Date = Date(timeIntervalSince1970: t)
        
        //当前时间
        let currentDate = Date.init()
        
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.day,.hour,.minute,.second]
        let commponent:DateComponents = calendar.dateComponents(unit, from: currentDate, to: endDate)
        
       
        secondStr = commponent.second ?? 0
        minitStr = commponent.minute ?? 0
        hourStr = commponent.hour ?? 0
        dayStr = commponent.day ?? 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)

    }
    @objc func timerAction() {
        secondStr = secondStr - 1
        if secondStr == -1 {
            secondStr = 59
            minitStr = minitStr - 1
            if minitStr == -1 {
                minitStr = 59
                hourStr = hourStr - 1
                if hourStr == -1 {
                    hourStr = 23
                    dayStr = dayStr - 1
                }
            }
        }
        if  secondStr == 0 && minitStr == 0 && hourStr == 0 && dayStr == 0 {
            self.timer?.invalidate()
            timer = nil
            self.cutdownTimeLB?.text = "0 Day"
        }else{
            self.cutdownTimeLB?.text = "\(dayStr) Day \(hourStr):\(minitStr):\(secondStr)"
        }
    }

    func changeBottomStatus(){
        if Tool.getuserInfoModel() == nil{
            self.bottomView.isHidden = false
            self.registerBtn.setBackgroundImage(UIImage(named: "activityRegisterBtnBg"), for: .normal)
            self.registerBtn.setBackgroundImage(UIImage(named: "activityRegisterBtnBg"), for: .highlighted)
            self.tableViewBottomSpace.constant = 95
            self.cutdownTimePromptLB?.isHidden = true
            self.cutdownTimeLB?.isHidden = true
        }else{
            if model == nil || self.model?.status == 1{
                self.bottomView.isHidden = false
                self.registerBtn.setBackgroundImage(UIImage(named: "acceptActivityRegisterBtnBg"), for: .normal)
                self.registerBtn.setBackgroundImage(UIImage(named: "acceptActivityRegisterBtnBg"), for: .highlighted)
                self.tableViewBottomSpace.constant = 95
                self.cutdownTimePromptLB?.isHidden = true
                self.cutdownTimeLB?.isHidden = true
            }else{
                self.bottomView.isHidden = true
                self.tableViewBottomSpace.constant = 0
                self.cutdownTimePromptLB?.isHidden = false
                self.cutdownTimeLB?.isHidden = false
            }
        }
    }
    func popToController(type:Int){
        for i in 0..<(self.navigationController?.viewControllers.count)! {
            let vc = self.navigationController?.viewControllers[i]
            if vc is MineController{
               _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! MineController, animated: true)
            break
           }
            if vc is PopularViewController{
               _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! PopularViewController, animated: true)
            break
           }
        }
        let userInfo = ["type": type]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CheckInGetCouponNotice), object: nil, userInfo: userInfo)
    }
    func setUpIntroView(){
        if self.model == nil || self.model?.richText == nil || self.model?.richText?.count == 0{
            return
        }
        var totalH = 0
        for i in 0..<(self.model?.richText?.count ?? 0){
            let model = self.model?.richText?[i]
            if model?.t == "title"{
                totalH = totalH + 20
                let label = UILabel(frame: CGRect(x: 15, y: totalH, width: Int(kScreenW)-30, height: 25))
                label.text = model?.s
                label.textColor = .white
                label.font = UIFont(name: "PingFangSC-Semibold",size: 18)
                label.textAlignment = .left
                self.footerView.addSubview(label)
                totalH = totalH + 25
            }else{
                totalH = totalH + 10
                let detailLabel = UILabel(frame: CGRect(x: 15, y: totalH, width: Int(kScreenW)-30, height: Int(self.getLabelH(text: model?.s ?? ""))))
                detailLabel.text = model?.s
                detailLabel.textColor = .white
                detailLabel.font = UIFont(name: "PingFangSC-Regular",size: 12)
                detailLabel.numberOfLines = 0
                self.footerView.addSubview(detailLabel)
                totalH = totalH + Int(self.getLabelH(text: model?.s ?? ""))
            }
        }
        self.footerView.frame = CGRect(x: 0, y: 0, width: Int(kScreenW), height: totalH + 10)
        self.tableView.tableFooterView = self.footerView
    }
    @IBAction func bottomBtnClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
            let registVC = RegisterController()
            registVC.gotoLoginBlock = {[weak self] in
                let loginVC = LoginController()
                let nav = UINavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .custom
                self?.present(nav, animated: true)
            }
            let nav = UINavigationController(rootViewController: registVC)
            nav.modalPresentationStyle = .custom
            self.present(nav, animated: true)
        }else{
            ActivityRequest.getRegisterActivity { isSuccess in
                if isSuccess == true{
                    self.requestGetDetail()
                }
            }
        }
    }
    
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.model?.task1?.coupons?.count ?? 0
        }else if section == 1{
            return self.model?.task2?.coupons?.count ?? 0
        }
        return self.model?.task3?.coupons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bgH = (kScreenW-50)*180/650
        return bgH + 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RegisterActivityCell = tableView.dequeueReusableCell(withIdentifier: "RegisterActivityCell") as! RegisterActivityCell
        var taskModel : RegisterActivityTaskModel?
        if indexPath.section == 0{
            taskModel = self.model?.task1
        }else if indexPath.section == 1{
            taskModel = self.model?.task2
        }else{
            taskModel = self.model?.task3
        }
        if indexPath.row == (taskModel?.coupons?.count ?? 0) - 1{
            cell.bgView.layer.cornerRadius = 20
            cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }else{
            cell.bgView.layer.cornerRadius = 0
        }
         
        let couponModel = taskModel?.coupons?[indexPath.row]
        cell.model = couponModel
//        if taskModel?.status != 2 && taskModel?.status != 3{
//            cell.checkLB.isHidden = true
//            cell.promptIV.isHidden = true
//            cell.takeBtn.backgroundColor = UIColor.kRgbColor(red: 0, green: 0, blue: 0, alpha: 0.07)
//            cell.takeBtn.setTitle("Take", for: .normal)
//            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .normal)
//            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .highlighted)
//            cell.takeBtn.isEnabled = false
//        }else if taskModel?.status == 3{
//            cell.checkLB.isHidden = true
//            cell.promptIV.isHidden = true
//            cell.takeBtn.backgroundColor = UIColor.kRgbColor(red: 0, green: 0, blue: 0, alpha: 0.07)
//            cell.takeBtn.setTitle("Invalid", for: .normal)
//            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .normal)
//            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .highlighted)
//            cell.takeBtn.isEnabled = false
//        }else{
//            cell.takeBtn.isEnabled = true
//            if couponModel?.status == 5{
//                cell.checkLB.isHidden = true
//                cell.promptIV.isHidden = true
//                cell.takeBtn.backgroundColor = .hexColor(hex: "FFE283")
//                cell.takeBtn.setTitle("Take", for: .normal)
//                cell.takeBtn.setTitleColor(.hexColor(hex: "101010"), for: .normal)
//                cell.takeBtn.setTitleColor(.hexColor(hex: "101010"), for: .highlighted)
//            }else{
//                cell.takeBtn.backgroundColor = .white
//                cell.takeBtn.setTitle("", for: .normal)
//                cell.checkLB.isHidden = false
//                cell.promptIV.isHidden = false
//            }
//        }
        if taskModel?.status != 2{
            cell.checkLB.isHidden = true
            cell.promptIV.isHidden = true
            cell.takeBtn.backgroundColor = UIColor.kRgbColor(red: 0, green: 0, blue: 0, alpha: 0.07)
            cell.takeBtn.setTitle("Take", for: .normal)
            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .normal)
            cell.takeBtn.setTitleColor(.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.39), for: .highlighted)
            cell.takeBtn.isEnabled = false
        }else{
            cell.takeBtn.isEnabled = true
            if couponModel?.status == 5{
                cell.checkLB.isHidden = true
                cell.promptIV.isHidden = true
                cell.takeBtn.backgroundColor = .hexColor(hex: "FFE283")
                cell.takeBtn.setTitle("Take", for: .normal)
                cell.takeBtn.setTitleColor(.hexColor(hex: "101010"), for: .normal)
                cell.takeBtn.setTitleColor(.hexColor(hex: "101010"), for: .highlighted)
            }else{
                cell.takeBtn.backgroundColor = .white
                cell.takeBtn.setTitle("", for: .normal)
                cell.checkLB.isHidden = false
                cell.promptIV.isHidden = false
            }
        }
        cell.takeCouponBlock = {[weak self] in
            if taskModel?.status == 2{
                if couponModel?.status == 5{
                    self?.requestGetActivityBouns(model: taskModel ?? RegisterActivityTaskModel(),taskNum: indexPath.section+1)
                }else{
                    self?.popToController(type: 1)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var bgH = (kScreenW-30)*90/690
        var taskModel : RegisterActivityTaskModel?
        if section == 0{
            taskModel = self.model?.task1
        }else if section == 1{
            taskModel = self.model?.task2
        }else{
            taskModel = self.model?.task3
        }
        let h = (taskModel?.processes?.count ?? 0) * 36
        bgH = bgH + CGFloat(h)
        let view : RegisterActivityHeaderView = RegisterActivityHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 78 + bgH))
        view.imageV.image = UIImage(named:"registerTask\(section)")
        view.model = taskModel

        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var bgH = (kScreenW-30)*90/690
        
        var taskModel : RegisterActivityTaskModel?
        if section == 0{
            taskModel = self.model?.task1
        }else if section == 1{
            taskModel = self.model?.task2
        }else{
            taskModel = self.model?.task3
        }
        let h = (taskModel?.processes?.count ?? 0) * 36
        bgH = bgH + CGFloat(h)
        
        return 78 + bgH
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 25))
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func getCountentH(str:String)->CGFloat {
        let attrStr = try! NSMutableAttributedString(
            data: (str.data(using: .unicode, allowLossyConversion: true)!),
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        let contentHegiht = attrStr.boundingRect(with: CGSize(width: kScreenW-30, height: 10000), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).height
        return contentHegiht
    }
    func getLabelH(text:String) -> CGFloat{
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular",size: 12), range: NSRange(location: 0, length: text.count))
    
        var size = CGSize()
        size.width = kScreenW-30
        size.height = CGFloat.greatestFiniteMagnitude

        let boundingRect = attributedText.boundingRect(with: size, options:  [.usesFontLeading,.usesLineFragmentOrigin], context: nil).integral
        return boundingRect.height
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
