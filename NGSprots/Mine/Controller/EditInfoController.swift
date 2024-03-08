//
//  EditInfoController.swift
//  NGSprots
//
//  Created by Jean on 8/1/2024.
//

import UIKit

class EditInfoController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,SelectDateDelegate,SelectSexDelegate{

    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var headerIV: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let titleArr : [[String]] = [["Nickname","Birthday","Gender","Region","Address"],["ID","Date registration"]]
    
    var dataArr  : [[String]] = []

    lazy var selectHeaderView : SelectHeaderView = {
        let view = SelectHeaderView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height:495))
        return view
    }()
    ///选择生日
    lazy var selectDateView : SelectDateView = {
        let view = SelectDateView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 350))
        view.dateDelegate = self
        return view
    }()
    ///选择性别
    lazy var selectSexView : SelectSexView = {
        let view = SelectSexView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 350))
        view.selectSexDelegate = self
        return view
    }()
//    ///选择地区
//    lazy var selectRegionView : SelectRegionView = {
//        let view = SelectRegionView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 460))
//       
//        return view
//    }()
    
    ///选择地区
    lazy var selectRegionViewNew : SelectRegionViewNew = {
        let view = SelectRegionViewNew(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 357))
       
        return view
    }()
    
    var selectState = ""
    var selectCity = ""
    var statesAreaModel : StatesModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"
        self.addNavBar(.white)
        self.setUpUI()
    }
    func setUpUI(){
        self.headerBgView.layer.cornerRadius = 15
        self.headerBgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()

        let nickName = ((Tool.StringIsEmpty(value: account.nickname) == true) ? "Not filled" : account.nickname)!
        let  str = (account.yearOfBirth ?? "") + "/" + (account.monthOfBirth ?? "") + "/" + (account.dayOfBirth ?? "")
        let birthDay = (Tool.StringIsEmpty(value: account.yearOfBirth) == true) ? "Not filled" : str
        let gender = (Tool.StringIsEmpty(value: account.gender) == true) ? "Not filled" : (account.gender == "2" ? "Women" : "Men")
        let region = ((Tool.StringIsEmpty(value: account.region) == true) ? "Not filled" : account.region)!
        let address = ((Tool.StringIsEmpty(value: account.address) == true) ? "Not filled" : account.address)!
        
        let arr : [String] = [nickName,birthDay,gender,region,address]
        dataArr.append(arr)
        let registTime = Tool.getTimeWithTimestamp(timestampStr: String(account.createTime ?? 0), dateFormatStr: "yyyy-MM-dd HH:mm:ss")
        dataArr.append([String(account.id ?? 0),registTime])
        
        self.headerIV.sd_setImage(with: URL(string: account.avatar ?? ""), placeholderImage: UIImage(named: "headerPlaceholder"), context: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EditInfoCell", bundle: nil), forCellReuseIdentifier: "EditInfoCell")
        
        self.selectRegionViewNew.confirmSelectCityBlock = { [weak self] state , city in
            self?.selectState = state
            self?.selectCity = city
            self?.requestEditRegion()
            self?.tableView.reloadData()
        }
    }
    func requestEditHeader(avatarUrl: String){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.avatarUrl = avatarUrl
        let api = wxApi.editUserHeader(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){

                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestEditBirthday(day: String, month: String, year: String){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd-MMMM-yyyy"
        let str =  "\(day)-\(month)-\(year)"
        let date = dformatter.date(from: str) ?? Date()
        
        dformatter.dateFormat = "dd-MM-yyyy"
        let datestr = dformatter.string(from: date)
        let result = datestr.components(separatedBy: "-")
        param.yearOfBirth = Int(year)
        param.monthOfBirth = Int(result[1])
        param.dayOfBirth = Int(day)
        let api = wxApi.editUserBirthday(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                let birthday = year + "/" + "\(param.monthOfBirth ?? 1)" + "/" + day
                self.dataArr[0][1] = birthday
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestEditSex(sexCode: String){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.gender = sexCode == "0" ? 1 : 2
        let api = wxApi.editUserSex(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.dataArr[0][2] = sexCode == "0" ? "Men" : "Women"
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestEditRegion(){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.state = self.selectState
        param.region = self.selectCity
        let api = wxApi.editUserRegion(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.dataArr[0][3] = self.selectCity
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestCountryArea(){
        self.showHUD(text: "Loading...")
        let api = wxApi.getUserRegion
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<StatesModel>.deserialize(from: data)
            if(result?.code == 0){
//                if self.selectState != ""{
//                    self.statesAreaModel = result?.data ?? StatesModel()
//                    self.requestGetCity()
//                }else{
//                    Tool.keyWindow().showInWindow(functionView: self.selectRegionView)
//                    self.selectRegionView.model = result?.data ?? StatesModel()
//                    UIView.animate(withDuration: 0.5) {
//                        self.selectRegionView.transform = CGAffineTransformMakeTranslation(0, -460)
//                    }
//                }
                Tool.keyWindow().showInWindow(functionView: self.selectRegionViewNew)
                self.selectRegionViewNew.model = result?.data ?? StatesModel()
                UIView.animate(withDuration: 0.5) {
                    self.selectRegionViewNew.transform = CGAffineTransformMakeTranslation(0, -357)
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestGetCity(){
        self.showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.state = self.selectState
        let api = wxApi.getUserRegionCity(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<StatesModel>.deserialize(from: data)
            if(result?.code == 0){
//                Tool.keyWindow().showInWindow(functionView: self.selectRegionView)
//                self.statesAreaModel?.regions = result?.data?.regions ?? []
//                UIView.animate(withDuration: 0.5) {
//                    self.selectRegionView.transform = CGAffineTransformMakeTranslation(0, -460)
//                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    @IBAction func changeHeaderClick(_ sender: Any) {
        Tool.keyWindow().showInWindow(functionView: self.selectHeaderView)
        self.selectHeaderView.confirmBlock = {[weak self]image in
            self?.headerIV.image = image
        }
        UIView.animate(withDuration: 0.5) {
            self.selectHeaderView.transform = CGAffineTransformMakeTranslation(0, -495)
        }
    }
    func dateSureClick(day: String, month: String, year: String) {
        self.requestEditBirthday(day: day, month: month, year: year)
    }
    func sexSureClick(code: String) {
        self.requestEditSex(sexCode: code)
    }
 
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.titleArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 || indexPath.row == self.titleArr[indexPath.section].count-1) && indexPath.section == 0{
            return 68
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EditInfoCell = tableView.dequeueReusableCell(withIdentifier: "EditInfoCell") as! EditInfoCell
        cell.titleLB.text = self.titleArr[indexPath.section][indexPath.row]
        cell.subTitleLB.text = self.dataArr[indexPath.section][indexPath.row]
        
        if indexPath.row == 0 && self.titleArr[indexPath.section].count == 1{
            cell.type = -1
        }else if indexPath.row == self.titleArr[indexPath.section].count-1 &&  self.titleArr[indexPath.section].count != 1{
            cell.type = 2
        }else if indexPath.row == 0 && self.titleArr[indexPath.section].count != 1 {
            cell.type = 0
        }else{
            cell.type = 1
        }
        if indexPath.section == 1{
            cell.subTitleLB.textColor = .hexColor(hex: "101010")
            cell.arrowIV.isHidden = true
            cell.subTitleRightLeftSpace.constant = 15
        }else{
            cell.subTitleLB.textColor = .hexColor(hex: "B8B8B8")
            cell.arrowIV.isHidden = false
            cell.subTitleRightLeftSpace.constant = 41
        }
        if indexPath.section == 0{
            if  indexPath.row == 0{
                cell.titleLBTopSpace.constant = 30
            }else{
                cell.titleLBTopSpace.constant = 17.5
            }
        }else{
            if  indexPath.row == 0{
                cell.titleLBTopSpace.constant = 22.5
            }else{
                cell.titleLBTopSpace.constant = 12.5
            }
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
        if indexPath.section == 0{
            switch indexPath.item{
            case 0:
                let vc = EditNickNameController()
                vc.saveNickNameBlock = { [weak self]nickName in
                    self!.dataArr[0][0] = nickName
                    tableView.reloadData()
                }
                vc.nickName = self.dataArr[0][0] == "Not filled" ? "" : self.dataArr[0][0]
                self.pushVC(vc: vc)
                break
            case 1:
                Tool.keyWindow().showInWindow(functionView: self.selectDateView)
                UIView.animate(withDuration: 0.5) {
                    self.selectDateView.transform = CGAffineTransformMakeTranslation(0, -350)
                }
                break
            case 2:
                Tool.keyWindow().showInWindow(functionView: self.selectSexView)
                UIView.animate(withDuration: 0.5) {
                    self.selectSexView.transform = CGAffineTransformMakeTranslation(0, -350)
                }
                break
            case 3:
                self.requestCountryArea()
                break
            case 4:
                let vc = EditAddressController()
                vc.saveAddressBlock = { [weak self]address in
                    self!.dataArr[0][4] = address
                    tableView.reloadData()
                }
                vc.address = self.dataArr[0][4] == "Not filled" ? "" : self.dataArr[0][4]
                self.pushVC(vc: vc)
                break
            default:
                break
            }
        }
    }
}
