//
//  MessageController.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit
import MJRefresh
class MessageController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var messagesBtn: UIButton!
    
    @IBOutlet weak var noticeBtn: UIButton!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
   
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var readBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var editBtn: UIButton?
    var isEdit : Bool = false
    var pageIndex = 1
    var dataArr : [MessageDateModel] = []
    
    var dic = [String:Array<MessageModel>]()
    var sectionTitleArr : Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message"
        self.addNavBar(.white)
        
        setUpUI()
       
    }
    func setUpUI(){
        
        let btn = self.addRightItemText(normal: "Editing", select: "Done", textColor: .hexColor(hex: "101010"),selectTextColor: .hexColor(hex: "0CD664"))
        btn.addTarget(self, action: #selector(clickEditItem(_:)), for: .touchUpInside)
        editBtn = btn
        
        self.messagesBtn.isSelected = true
        self.changeBottomUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
        self.getData()
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
        var param = MessageParam()
        param.current = pageIndex
        param.pageSize = 15
        if self.messagesBtn.isSelected == true{
            param.status = 0
        }
        let api = self.messagesBtn.isSelected == true ? wxApi.getMessageList(param: param) : wxApi.getNoticeList(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.tableView.mj_header?.endRefreshing()
            let result = RequestCallBackViewModel<MessageModel>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.items?.count ?? 0){
                    var model = result?.data?.items?[i]
                    for j in 0..<(model?.msgs?.count ?? 0){
                        model?.msgs?[j].isSelect = false
                    }
                    self.dataArr.append(model!)
                }
                self.tableView.reloadData()
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            if self.dataArr.count == 0{
                self.tableView.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
            }else{
                self.tableView.hiddenEmptyView()
            }
            if self.dataArr.count >= result?.data?.total ?? 0{
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer?.endRefreshing()
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    func requestReadMessage(id : Int?){
        self.showHUD(text: "Loading...")
        var param = MessageParam()
        var idArr : Array<Int> = []
        if id == nil{
            for i in 0..<self.dataArr.count{
                let model = self.dataArr[i]
                for j in 0..<(model.msgs?.count ?? 0){
                    if  model.msgs?[j].isSelect == true{
                        idArr.append(model.msgs?[j].id ?? 0)
                    }
                }
            }
            param.id = idArr
        }else{
            param.id = [id ?? 0]
        }
        let api = wxApi.readMessage(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.showTextSB("successfully", dismissAfterDelay: 1.5)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    @IBAction func readClick(_ sender: Any) {
        self.requestReadMessage(id: nil)
    }
    @objc func clickEditItem(_ btn:UIButton){
        if self.dataArr.count == 0{
            return
        }
        btn.isSelected = !btn.isSelected
        self.isEdit = btn.isSelected
        changeBottomUI()
        tableView.reloadData()
    }
    func changeBottomUI(){
        if self.isEdit == true{
            self.bottomView.isHidden = false
            self.tableViewBottomSpace.constant = 50 + kbottomSafeH
            self.view.backgroundColor = .white
        }else{
            self.bottomView.isHidden = true
            self.tableViewBottomSpace.constant = kbottomSafeH
            self.view.backgroundColor = .hexColor(hex: "F7F7F7")
        }
        self.tableView.reloadData()
    }
    @IBAction func typeClick(_ sender: Any) {
        self.editBtn?.isSelected = false
        self.isEdit = false
        changeBottomUI()
        let btn : UIButton = sender as! UIButton
        btn.isSelected = true
        if btn == self.messagesBtn{
            self.noticeBtn.isSelected = false
        }else{
            self.messagesBtn.isSelected = false
        }
    
        UIView.animate(withDuration: 0.25) {
            self.tipView.center.x = btn.center.x
        }
        self.tableView.reloadData()
        self.requestDataWithMore(isMore: false)
    }
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateModel : MessageDateModel = self.dataArr[section]
        return dateModel.msgs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView : UIView = UIView(frame: CGRectMake(0, 0, kScreenW, 40))
        headerView.backgroundColor = .hexColor(hex: "F7F7F7")
        
        let sectionTitleLB : UILabel = UILabel()
        if self.isEdit == true{
            sectionTitleLB.frame = CGRect(x: 55, y: 0, width: kScreenW - 55, height: 40)
        }else{
            sectionTitleLB.frame = CGRect(x: 25, y: 0, width: kScreenW - 25, height: 40)
        }
        sectionTitleLB.textColor = .hexColor(hex: "929AA5")
        sectionTitleLB.backgroundColor = .clear
        sectionTitleLB.font = UIFont(name: "PingFangSC-Regular",size: 12)
        headerView.addSubview(sectionTitleLB)
    
        let dateModel : MessageDateModel = self.dataArr[section]
        sectionTitleLB.text = dateModel.date
       
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MessageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.edit = self.isEdit
       
        let dateModel : MessageDateModel = self.dataArr[indexPath.section]
        let model = dateModel.msgs?[indexPath.row]
        cell.titleLB.text = model?.title
        let time = Tool.getTimeWithTimestamp(timestampStr: String(model?.createTime ?? 0), dateFormatStr: "yyyy-MM-dd HH:mm:ss")
        cell.timeLB.text = time
        cell.detailLB.text = model?.body
        if self.messagesBtn.isSelected == true{
            cell.redView.isHidden = model?.status == 1 ? false : true
        }else{
            cell.redView.isHidden = true
        }
        cell.selectIV.image = (model?.isSelect ?? false) ? UIImage(named:"paySelect") : UIImage(named: "payUnSelect")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEdit == true{
            var dateModel : MessageDateModel = self.dataArr[indexPath.section]
            dateModel.msgs![indexPath.row].isSelect = !(dateModel.msgs![indexPath.row].isSelect ?? false)
            self.tableView.reloadData()
        }else{
            if self.messagesBtn.isSelected == true{
                let dateModel : MessageDateModel = self.dataArr[indexPath.section]
                let model = dateModel.msgs?[indexPath.row]
                self.requestReadMessage(id: model?.id)
                if model?.isH5 == true && Tool.StringIsEmpty(value: model?.link) == false{
                    let vc = PublicWebController()
                    vc.titleStr = "Information Details"
                    vc.url = model?.link
                    self.pushVC(vc: vc)
                }else{
                    let vc = MessageDetailController()
                    vc.model = model
                    self.pushVC(vc: vc)
                }
            }
        }
    }
}
