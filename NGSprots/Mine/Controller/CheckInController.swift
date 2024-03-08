//
//  CheckInController.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit
let CheckInGetCouponNotice = "CheckInGetCouponNotice"
class CheckInController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var checkInHeaderView : CheckInHeaderView = {
        let view = CheckInHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 290))
        return view
    }()
    lazy var checkInCouponObtainedView : CheckInCouponObtainedView = {
        let view = CheckInCouponObtainedView(frame: CGRect(x: 38, y: (kScreenH-185-220)/2, width: kScreenW-76, height: 185 + 110 * 2))
        return view
    }()
    var dataArr : [CheckInCouponModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check in"
        self.addNavBar(.white)
        
        setUpUI()
        
        self.requestCheckInData()
        self.requestCheckInCouponDetail()
    }
    
    func setUpUI(){
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CheckInCouponCell", bundle: nil), forCellReuseIdentifier: "CheckInCouponCell")
        tableView.tableHeaderView = self.checkInHeaderView
        
        self.checkInHeaderView.checkInBlock = {[weak self] in
            self?.requestCheckInData()
            self?.requestCheckInCouponDetail()
        }
        self.checkInCouponObtainedView.jumpBlock = {[weak self]type in
            self?.popToController(type: type)
        }
        self.setBackColor()
    }
    func setBackColor(){
        let layer = view.layer.sublayers?[0]
        if layer is CAGradientLayer{
            view.layer.sublayers?.remove(at: 0)
        }
        var colors : Array<CGColor> = []
        colors = [UIColor.kRgbColor(red: 33, green: 205, blue: 87, alpha: 1).cgColor,UIColor.kRgbColor(red: 2, green: 177, blue: 165, alpha: 1).cgColor]
        let gradient:CAGradientLayer = CAGradientLayer.init()
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x:0, y: 1)
        gradient.colors = colors
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-(kNavigationBarH+kStatusBarH))
        view.layer.insertSublayer(gradient, at: 0)
    }
    func requestCheckInData(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentDate = dateFormatter.string(from: Date())
        Tool.requestGetCheckInDetail(rangeType: "week", date: currentDate) { model in
            self.checkInHeaderView.model = model
        }
    }
    func requestCheckInCouponDetail(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentDate = dateFormatter.string(from: Date())
        self.showHUD(text: "Loading...")
        var param = CheckInParam()
        param.date = currentDate
        let api = wxApi.getCheckInCouponList(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[CheckInCouponModel]>.deserialize(from: data)
            if(result?.code == 0){
                self.dataArr = result?.data ?? []
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
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
    func requestGetCoupon(model:CheckInCouponModel?){
        if model == nil{
            return
        }
        self.showHUD(text: "Loading...")
        var param = GetCouponParam()
        param.ids = model?.toClaimIds ?? []
        let api = wxApi.getCoupon(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.requestCheckInCouponDetail()
                if (model?.coupons?.count ?? 0)<=2{
                    self.checkInCouponObtainedView.frame = CGRect(x: 38, y: (kScreenH-185-220)/2, width: kScreenW-76, height: CGFloat(185 + (model?.coupons?.count ?? 0) * 110))
                }else{
                    self.checkInCouponObtainedView.frame = CGRect(x: 38, y: (kScreenH-185-220)/2, width: kScreenW-76, height: 185 + 110 * 2)
                }
                self.checkInCouponObtainedView.updateFrame()
                self.checkInCouponObtainedView.isRegisterActivity = false
                self.checkInCouponObtainedView.model = model
                Tool.keyWindow().showInWindow(functionView: self.checkInCouponObtainedView)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let couponArr = self.dataArr[section].coupons
        return couponArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let couponArr = self.dataArr[indexPath.section].coupons
        if indexPath.section == self.dataArr.count - 1 && indexPath.row == (couponArr?.count ?? 0)-1{
            return 120
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckInCouponCell = tableView.dequeueReusableCell(withIdentifier: "CheckInCouponCell") as! CheckInCouponCell
        let couponArr = self.dataArr[indexPath.section].coupons
        if indexPath.section == self.dataArr.count - 1 && indexPath.row == (couponArr?.count ?? 0)-1{
            cell.bgView.layer.cornerRadius = 15
            cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }else{
            cell.bgView.layer.cornerRadius = 0
        }
        let itemModel = couponArr?[indexPath.row]
        cell.model = itemModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : CheckInSectionHeaderView = CheckInSectionHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 70))
        if section == 0{
            view.promptIV.isHidden = false
            view.bgView.layer.cornerRadius = 15
            view.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            view.promptIV.isHidden = true
            view.bgView.layer.cornerRadius = 0
        }
        view.model = self.dataArr[section]
        view.obtainedBlock = {[weak self] in
            self?.requestGetCoupon(model: self?.dataArr[section])
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
