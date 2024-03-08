//
//  MoneyRecordController.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/21.
//

import UIKit
import MJRefresh

class MoneyRecordController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dataW: NSLayoutConstraint!
    @IBOutlet weak var categoryW: NSLayoutConstraint!
    private var selectTimeView:SelectTimeView!
    private var scview: SelectionCategoryView!
    private let bgview = UIView()
    
    private var categoryArray = [("ALL",true), ("Deposit",false), ("Withdraw",false), ("Single",false), ("Bonus",false), ("Activity reward",false), ("other",false)]
    private let miao = 86400
    private let miaomiao = 1000
    private var startTime = 0
    private var endTime = 0
    private var dayTag = 100
    
    var pageIndex = 1
    
    var dataArr : [RunningWaterItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.requestRunningWaterType()
    }
    
    private func setUI(){
        title = "Money record"
        addNavBar(.white)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        tableview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        tableview.register(UINib(nibName: "PurseRecordCell", bundle: nil), forCellReuseIdentifier: "PurseRecordCell")
        
        bgview.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        bgview.backgroundColor = .black
        bgview.alpha = 0.5
        bgview.isHidden = true
        UIApplication.shared.windows.last?.addSubview(bgview)
        bgview.isUserInteractionEnabled = true
        let bgvClick = UITapGestureRecognizer(target: self, action: #selector(clickBgView))
        bgview.addGestureRecognizer(bgvClick)
        scview = SelectionCategoryView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 460))
        scview.isHidden = true
        scview.typeArray = categoryArray
        UIApplication.shared.windows.last?.addSubview(scview)
        scview.xbtn = {
            self.scview.isHidden = true
            self.bgview.isHidden = true
        }
        
        scview.okbtn = { str in
            self.categoryLabel.text = str
            self.categoryW.constant = CGFloat(77 + (str.count - 3) * 5)
            self.getData()
        }
        
        selectTimeView = SelectTimeView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 680))
        selectTimeView.isHidden = true
        UIApplication.shared.windows.last?.addSubview(selectTimeView)
        selectTimeView.delegate = self
        (startTime,endTime) = selectDay(tag: 100)

    }
    @objc func getData(){
        requestDataWithMore(isMore: false)
    }
    @objc func getMoreData(){
        requestDataWithMore(isMore: true)
    }
    func requestDataWithMore(isMore:Bool){
        if isMore == true{
            pageIndex = pageIndex + 1
        }else{
            pageIndex = 1
            dataArr.removeAll()
        }
        var param = RunningWaterParam()
        param.current = pageIndex
        param.pageSize = 15
        param.startTime = self.startTime
        param.endTime = self.endTime
        param.bizType = self.categoryLabel.text
        let api = wxApi.getRunningWaterList(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.tableview.mj_header?.endRefreshing()
            let result = RequestCallBackViewModel<RunningWaterModel>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.list?.count ?? 0){
                    let model = result?.data?.list?[i]
                    self.dataArr.append(model!)
                }
                self.tableview.reloadData()
            }else{
                self.tableview.reloadData()
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            if self.dataArr.count == 0{
                self.tableview.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
            }else{
                self.tableview.hiddenEmptyView()
            }
            if self.dataArr.count >= result?.data?.total ?? 0{
                self.tableview.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.tableview.mj_footer?.endRefreshing()
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            self.tableview.mj_header?.endRefreshing()
            self.tableview.mj_footer?.endRefreshing()
        }
    }
    func requestRunningWaterType(){
        self.showHUD(text: "Loading...")
        let api = wxApi.getRunningWaterTypeList
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[RunningWaterTypeModel]>.deserialize(from: data)
            if(result?.code == 0){
                self.categoryArray.removeAll()
                for i in 0..<(result?.data?.count ?? 0){
                    let model = result?.data?[i]
                    if i == 0{
                        self.categoryArray.append((model?.label ?? "",true))
                        let str = model?.label ?? ""
                        self.categoryLabel.text = str
                        self.categoryW.constant = CGFloat(77 + (str.count - 3) * 5)
                    }else{
                        self.categoryArray.append((model?.label ?? "",false))
                    }
                }
                self.scview.typeArray = self.categoryArray
                self.scview.collectionview.reloadData()
            }else{
                let str = ""
                self.categoryLabel.text = str
                self.categoryW.constant = CGFloat(77 + (str.count - 3) * 5)
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            self.getData()
        }) { error in
            self.hudHide()
            let str = ""
            self.categoryLabel.text = str
            self.categoryW.constant = CGFloat(77 + (str.count - 3) * 5)
            self.showTextSB(error, dismissAfterDelay: 1.5)
            
            self.getData()
        }
    }
    @objc func clickBgView(){
        bgview.isHidden = true
        scview.isHidden = true
        selectTimeView.isHidden = true
    }
    
    private func selectDay(tag: Int) -> (Int,Int){
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let aa = dformatter.date(from: dformatter.string(from: now)) ?? Date()
        let timeInterval:TimeInterval = aa.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        switch(tag){
        case 100:
            return (timeStamp*miaomiao, (timeStamp + miao)*miaomiao)
        case 101:
            return ((timeStamp - miao)*miaomiao, timeStamp*miaomiao)
        case 102:
            return ((timeStamp - miao*7)*miaomiao, timeStamp*miaomiao)
        default:
            return (0,0)
        }
    }
    
    private func zdyTime(date: String, date2: String) -> (Int,Int){
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let aa = dformatter.date(from: date) ?? Date()
        let timeInterval:TimeInterval = aa.timeIntervalSince1970
        if date == date2{
            return (Int(timeInterval)*miaomiao,(Int(timeInterval) + miao)*miaomiao)
        }
        
        let aa2 = dformatter.date(from: date2) ?? Date()
        let timeInterval2:TimeInterval = aa2.timeIntervalSince1970
        return (Int(timeInterval)*miaomiao,Int(timeInterval2)*miaomiao)
    }
    
    @IBAction func clickTypeBtn(_ sender: UIButton) {
        if sender.tag == 77{
            bgview.isHidden = false
            selectTimeView.isHidden = false
            selectTimeView.setdaybg(tag: dayTag)
        }else{
            scview.isHidden = false
            bgview.isHidden = false
        }
    }
    
}

extension MoneyRecordController: UITableViewDelegate, UITableViewDataSource, SelectTimeViewDelegate{
    func XBtn() {
        bgview.isHidden = true
        selectTimeView.isHidden = true
    }
    
    func okAndbok(index: Int, dayTag: Int, startTime: String, endTime: String) {
        bgview.isHidden = true
        selectTimeView.isHidden = true
        self.dayTag = dayTag
        dataLabel.text = getDayStatus(key: dayTag)
        dataW.constant = CGFloat(88 + (getDayStatus(key: dayTag).count - 5) * 5)
        if index == 51{
            if dayTag == 103{
                (self.startTime,self.endTime) = zdyTime(date: startTime, date2: endTime)
            }else{
                (self.startTime,self.endTime) = selectDay(tag: dayTag)
            }
            self.getData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PurseRecordCell = tableView.dequeueReusableCell(withIdentifier: "PurseRecordCell") as! PurseRecordCell
        cell.bottomH.constant = 10
        cell.bonusLB.isHidden = true
        cell.stateLB.isHidden = true
        cell.priceLB.textColor = .hexColor(hex: "101010")
        cell.unitLB.textColor = .hexColor(hex: "101010")
        cell.priceBottom.constant = -15
        
        let model = self.dataArr[indexPath.row]
        if model.bizType == "Deposit" || model.bizType == "deposit"{
            cell.imageV.image = UIImage(named:"depositRecord")
        }else{
            if let image = UIImage(named:model.bizType ?? ""){
                if model.bizType == "Other" || model.bizType == "other"{
                    cell.imageV.image = UIImage(named:"RunningWaterOther")
                }else{
                    cell.imageV.image = image
                }
            }else{
                cell.imageV.image = UIImage(named:"RunningWaterOther")
            }
        }
        cell.typeNameLB.text = Tool.StringIsEmpty(value: model.bizType) ? "Other" : model.bizType
        let time = Tool.getTimeWithTimestamp(timestampStr: String(model.createTime ?? 0), dateFormatStr: "yyyy/MM/dd HH:mm:ss")
        cell.dateLB.text = time
        if model.tType == 1{
            cell.priceLB.text = "+\(model.amount ?? "0")"
        }else{
            cell.priceLB.text = model.amount ?? "0"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
