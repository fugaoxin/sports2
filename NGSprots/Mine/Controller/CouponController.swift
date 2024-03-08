//
//  CouponController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/9.
//

import UIKit
import MJRefresh

class CouponController: BaseViewController {
    var selectCouponBlock : ((_ model:itemModel)->Void)?
    
    @IBOutlet weak var functionBgView: UIView!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var validLine: UILabel!
    @IBOutlet weak var InvalidLabel: UILabel!
    @IBOutlet weak var InvalidLine: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopSpace: NSLayoutConstraint!
    private var status = 1
    private var isRequesting = false
    private var curPage = 1
    
    //以下参数 充值时有效
    var selectCoupon : Bool?
    var rechargeNum : String?
    var selectCouponModel : itemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        if self.selectCoupon == true{
            title = "Available Coupon"
            self.tableViewTopSpace.constant = 10
            self.functionBgView.isHidden = true
        }else{
            title = "Coupon"
            self.tableViewTopSpace.constant = 47
            self.functionBgView.isHidden = false
        }
        addNavBar(.white)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CheckInCouponCell", bundle: nil), forCellReuseIdentifier: "CheckInCouponCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(listviewHeaderRefresh))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(listviewFooterRefresh))
        
        InvalidLabel.text = "Invalid"
        getCouponList(status: 1)
        
    }
    
    @IBAction func clickValid(_ sender: UIButton) {
        if sender.tag == 21 {
            validLabel.textColor = .hexColor(hex: "101010")
            InvalidLabel.textColor = .hexColor(hex: "969696")
            validLine.isHidden = false
            InvalidLine.isHidden = true
            self.couponList.removeAll()
            self.tableView.reloadData()
            status = 1
            curPage = 1
            getCouponList(status: status)
        }else{
            validLabel.textColor = .hexColor(hex: "969696")
            InvalidLabel.textColor = .hexColor(hex: "101010")
            validLine.isHidden = true
            InvalidLine.isHidden = false
            self.couponList.removeAll()
            self.tableView.reloadData()
            status = 3
            curPage = 1
            getCouponList(status: status)
        }
    }
    func popToController(type:Int){
        for i in 0..<(self.navigationController?.viewControllers.count)! {
            let vc = self.navigationController?.viewControllers[i]
            if vc is MineController{
               _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! MineController, animated: true)
            break
           }
        }
        let userInfo = ["type": type]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CheckInGetCouponNotice), object: nil, userInfo: userInfo)
    }
    @objc func listviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        curPage = 1
        getCouponList(status: status)
    }
    
    @objc func listviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        getCouponList(status: status)
    }
    
    private var couponList = Array<itemModel>()
    private func loadUI(modes: [itemModel]){
        for item in modes{
            couponList.append(item)
        }
        if status == 1{
            validLabel.text = "Valid (" + "\(couponList.count)" + ")"
        }else{
            InvalidLabel.text = "Invalid (" + "\(couponList.count)" + ")"
        }
        
        if couponList.count > 0{
            tableView.hiddenEmptyView()
            tableView.reloadData()
        }else{
            tableView.showEmptyView(image: "Coupon_icon", title: "NONE", subtitle: "No data available",btnStr: "")
        }
    }
    
}

extension CouponController {
    private func getCouponList(status: Int){
        self.showHUD(text: "Loading...")
        var param = CouponListParam()
        if self.selectCoupon == true{
            param.amount = self.rechargeNum
            param.scenario = "recharge"
        }else{
            param.status = status
        }
        param.current = curPage
        
        let api = self.selectCoupon == true ? wxApi.couponAvailable(param: param) : wxApi.couponList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            if self.tableView.mj_header != nil{
                self.tableView.mj_header?.endRefreshing()
            }
            if self.tableView.mj_footer != nil{
                self.tableView.mj_footer?.endRefreshing()
            }
            self.isRequesting = false
            if self.curPage == 1 {
                self.couponList.removeAll()
            }
            self.curPage += 1
            
            let result = RequestCallBackViewModel<availableAndBonusModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadUI(modes: result?.data?.items ?? [])
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            if self.couponList.count >= result?.data?.total ?? 0{
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer?.endRefreshing()
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
            if self.couponList.count > 0{
                self.tableView.hiddenEmptyView()
            }else{
                self.validLabel.text = "Valid"
                self.InvalidLabel.text = "Invalid"
                self.tableView.showEmptyView(image: "Coupon_icon", title: "NONE", subtitle: "No data available",btnStr: "")
            }
            self.isRequesting = false
            if self.tableView.mj_header != nil{
                self.tableView.mj_header?.endRefreshing()
            }
            if self.tableView.mj_footer != nil{
                self.tableView.mj_footer?.endRefreshing()
            }
        }
    }
    
}

extension CouponController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return couponList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckInCouponCell = tableView.dequeueReusableCell(withIdentifier: "CheckInCouponCell") as! CheckInCouponCell
        cell.bgViewLeftSpace.constant = 5
        cell.bgViewRightSpace.constant = 5
        cell.bgIVH.constant = 110
        cell.useBtnH.constant = 24
        cell.useBtn.layer.cornerRadius = 12
        cell.contentView.backgroundColor = .hexColor(hex: "F5F5F7")
        cell.bgView.backgroundColor = .hexColor(hex: "F5F5F7")
        if self.selectCoupon == true{
            cell.useBtn.isHidden = true
            cell.useLB.isHidden = true
            cell.useIV.isHidden = true
        }else{
            if self.status == 3{
                cell.useBtn.isHidden = true
                cell.useLB.isHidden = true
                cell.useIV.isHidden = true
            }else{
                cell.useBtn.isHidden = false
                cell.useLB.isHidden = false
                cell.useIV.isHidden = false
            }
        }
        if self.selectCoupon == true{
            cell.selectIV.isHidden = false
        }else{
            cell.selectIV.isHidden = true
        }
        let model = couponList[indexPath.row]
        cell.model = model
        
        if self.selectCouponModel == nil{
            cell.selectIV.image = nil
            cell.selectIV.layer.borderWidth = 1.5
            cell.selectIV.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
        }else{
            if model.id == self.selectCouponModel?.id{
                cell.selectIV.image = UIImage(named: "paySelect")
                cell.selectIV.layer.borderWidth = 0
            }else{
                cell.selectIV.image = nil
                cell.selectIV.layer.borderWidth = 1.5
                cell.selectIV.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
            }
        }
        
        cell.useBlock = {[weak self]type in
            self?.popToController(type: type)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectCoupon == true{
            self.selectCouponModel = couponList[indexPath.row]
            self.tableView.reloadData()
            if self.selectCouponBlock != nil{
                self.selectCouponBlock!(couponList[indexPath.row])
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
