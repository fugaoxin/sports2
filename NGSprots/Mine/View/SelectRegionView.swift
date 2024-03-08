//
//  SelectRegionView.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit

class SelectRegionView: UIView,UITableViewDelegate,UITableViewDataSource {
    var confirmSelectCityBlock : ((_ state:String , _ city : String)->Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectState = ""
    var selectCity = ""
    var model : StatesModel?{
        didSet{
            if model?.states?.count != 0 && self.selectState == ""{
                self.selectState = model?.states?.first ?? ""
            }
            if model?.regions?.count != 0 && self.selectCity == ""{
                self.selectCity = model?.regions?.first ?? ""
            }
            self.tableView.reloadData()
        }
    }
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectRegionView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setUpUI(){
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.register(UINib(nibName: "SelectRegionStateCell", bundle: nil), forCellReuseIdentifier: "SelectRegionStateCell")
        tableView.register(UINib(nibName: "CityItemCell", bundle: nil), forCellReuseIdentifier: "CityItemCell")
    }
    func requestGetCity(){
        Tool.keyWindow().showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.state = self.selectState
        let api = wxApi.getUserRegionCity(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<StatesModel>.deserialize(from: data)
            if(result?.code == 0){
                self.model?.regions = result?.data?.regions ?? []
                self.tableView.reloadData()
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    
    @IBAction func sureClick(_ sender: Any) {
        if self.model?.states?.count == 0 || self.model == nil || self.model?.regions?.count == 0{
            return
        }
        if self.selectCity == "" || self.selectState == ""{
            return
        }
        Tool.keyWindow().hiddenInWindow()
        if self.confirmSelectCityBlock != nil{
            self.confirmSelectCityBlock!( selectState,selectCity)
        }
    }
    
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        
        return  self.model?.regions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView : UIView = UIView(frame: CGRectMake(0, 0, kScreenW, 45))
        headerView.backgroundColor = .white
        
        let sectionTitleLB : UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: kScreenW - 30, height: 45))
        sectionTitleLB.textColor = .hexColor(hex: "969696")
        sectionTitleLB.font = UIFont(name: "PingFangSC-Medium",size: 12)
        headerView.addSubview(sectionTitleLB)
        if section == 0{
           sectionTitleLB.text = "State"
        }else{
           sectionTitleLB.text = "City"
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell : SelectRegionStateCell = tableView.dequeueReusableCell(withIdentifier: "SelectRegionStateCell") as! SelectRegionStateCell
            cell.selectIndex = self.selectState
            cell.dataArr = self.model?.states
            cell.selectStateBlock = {[weak self] type in
                if self?.selectState != type{
                    self?.selectState = type
                    self?.requestGetCity()
                }
            }
            return cell
        }
        let cell : CityItemCell = tableView.dequeueReusableCell(withIdentifier: "CityItemCell") as! CityItemCell
        cell.nameLB.text = self.model?.regions?[indexPath.row]
        if self.model?.regions?[indexPath.row] == self.selectCity{
            cell.isSelect = true
        }else{
            cell.isSelect = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if self.model?.states?.count == 0{
                return 0.01
            }
            var line = (self.model?.states?.count ?? 0)/2
            if (self.model?.states?.count ?? 0) % 2 != 0{
                line = line + 1
            }
            return CGFloat(line * 35 + (line-1) * 10)
        }
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            self.selectCity = self.model?.regions?[indexPath.row] ?? ""
            self.tableView.reloadData()
        }
    }
}
