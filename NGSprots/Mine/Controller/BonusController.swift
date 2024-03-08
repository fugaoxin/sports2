//
//  BonusController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/9.
//

import UIKit
import MJRefresh

class BonusController: BaseViewController {

    @IBOutlet weak var ActiveLabel: UILabel!
    @IBOutlet weak var InactiveLabel: UILabel!
    @IBOutlet weak var PreviousLabel: UILabel!
    @IBOutlet weak var ActiveLine: UILabel!
    @IBOutlet weak var InactiveLine: UILabel!
    @IBOutlet weak var PreviousLine: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var status = 1
    private var isRequesting = false
    private var curPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = "Bonus"
        addNavBar(.white)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BonusCell", bundle: nil), forCellReuseIdentifier: "BonusCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(listviewHeaderRefresh))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(listviewFooterRefresh))
        
        getBonusList(status: status)
    }
    
    @IBAction func clickActive(_ sender: UIButton) {
        switch(sender.tag){
        case 21:
            ActiveLabel.textColor = .hexColor(hex: "101010")
            InactiveLabel.textColor = .hexColor(hex: "969696")
            PreviousLabel.textColor = .hexColor(hex: "969696")
            ActiveLine.isHidden = false
            InactiveLine.isHidden = true
            PreviousLine.isHidden = true
            status = 1
            curPage = 1
            getBonusList(status: status)
            break;
        case 22:
            ActiveLabel.textColor = .hexColor(hex: "969696")
            InactiveLabel.textColor = .hexColor(hex: "101010")
            PreviousLabel.textColor = .hexColor(hex: "969696")
            ActiveLine.isHidden = true
            InactiveLine.isHidden = false
            PreviousLine.isHidden = true
//            status = 0
            status = 2
            curPage = 1
            getBonusList(status: status)
            break;
        default:
            ActiveLabel.textColor = .hexColor(hex: "969696")
            InactiveLabel.textColor = .hexColor(hex: "969696")
            PreviousLabel.textColor = .hexColor(hex: "101010")
            ActiveLine.isHidden = true
            InactiveLine.isHidden = true
            PreviousLine.isHidden = false
//            status = 2
            status = 4
            curPage = 1
            getBonusList(status: status)
            break
        }
    }
    
    @objc func listviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        curPage = 1
        getBonusList(status: status)
    }
    
    @objc func listviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        getBonusList(status: status)
    }
    
    private var bonusList = Array<CouponModel>()
    private func loadUI(modes: [CouponModel]){
        for item in modes{
            bonusList.append(item)
        }
        if bonusList.count > 0{
            tableView.hiddenEmptyView()
            tableView.reloadData()
        }else{
            tableView.showEmptyView(image: "Bonus_icon", title: "NONE", subtitle: "No bonuses available",btnStr: "")
        }
    }
    
}

extension BonusController{
    private func getBonusList(status: Int){
        self.showHUD(text: "Loading...")
        var param = CouponListParam()
        param.status = status
        param.current = curPage
        let api = wxApi.bonusList(param: param)
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
                self.bonusList.removeAll()
            }
            self.curPage += 1
            let result = RequestCallBackViewModel<CouponDataModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadUI(modes: result?.data?.Items ?? [CouponModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
            if self.bonusList.count > 0{
                self.tableView.hiddenEmptyView()
            }else{
                self.tableView.showEmptyView(image: "Bonus_icon", title: "NONE", subtitle: "No bonuses available",btnStr: "")
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
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm dd/MM/yyyy"
        return dformatter.string(from: date as Date)
    }
    
}

extension BonusController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return bonusList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = bonusList[indexPath.row]
        if model.conditionText?.count ?? 0 > 2{
            return 145
        }
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BonusCell = tableView.dequeueReusableCell(withIdentifier: "BonusCell") as! BonusCell
        cell.selectionStyle = .none
        let model = bonusList[indexPath.row]
        cell.moneyLable.text = model.amount
        switch(status){
        case 1:
            cell.bgview.backgroundColor = .hexColor(hex: "04CB7E")
            cell.validityView.backgroundColor = .hexColor(hex: "101010")
            cell.dateLabel.textColor = .white
            cell.conditionLabel.textColor = .white
            let str = (model.expireTime ?? 0) > 0 ? timeDate(time: "\((model.expireTime ?? 0)/1000)") : "Expired"
            if model.conditionText?.count ?? 0 > 2{
                cell.dateLabel.text = "Validity: " + str
                cell.conditionLabel.text = model.conditionText
                cell.bottomviewH.constant = 45
            }else{
                cell.dateLabel.text = ""
                cell.conditionLabel.text = "Validity: " + str
                cell.bottomviewH.constant = 30
            }
            cell.useImg.isHidden = true
            cell.useBg.isHidden = false
            break;
        case 2:
            cell.bgview.backgroundColor = .hexColor(hex: "B8B8B8")
            cell.validityView.backgroundColor = .white
            cell.dateLabel.textColor = .hexColor(hex: "969696")
            cell.conditionLabel.textColor = .hexColor(hex: "969696")
            if model.conditionText?.count ?? 0 > 2{
                cell.dateLabel.text = "Validity: Expired"
                cell.conditionLabel.text = model.conditionText
                cell.bottomviewH.constant = 45
            }else{
                cell.dateLabel.text = ""
                cell.conditionLabel.text = "Validity: Expired"
                cell.bottomviewH.constant = 30
            }
            cell.useImg.isHidden = true
            cell.useBg.isHidden = true
            break;
        default:
            cell.bgview.backgroundColor = .hexColor(hex: "04CB7E")
            cell.validityView.backgroundColor = .hexColor(hex: "101010")
            cell.dateLabel.textColor = .white
            cell.conditionLabel.textColor = .white
            let str = (model.expireTime ?? 0) > 0 ? timeDate(time: "\((model.expireTime ?? 0)/1000)") : "Expired"
            if model.conditionText?.count ?? 0 > 0{
                cell.dateLabel.text = "Validity: " + str
                cell.conditionLabel.text = model.conditionText
                cell.bottomviewH.constant = 45
            }else{
                cell.dateLabel.text = ""
                cell.conditionLabel.text = "Validity: " + str
                cell.bottomviewH.constant = 30
            }
            cell.useImg.isHidden = false
            cell.useBg.isHidden = true
            break
        }
        
        cell.goUse = {
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
