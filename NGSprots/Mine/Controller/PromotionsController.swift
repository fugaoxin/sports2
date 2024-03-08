//
//  PromotionsController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit
import MJRefresh

class PromotionsController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex = 1
    
    var dataArr : [PromotionsItemModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Promotions"
        self.addNavBar(.white)
        
        setUpUI()
        
        self.getData()
    }

    func setUpUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        tableView.register(UINib(nibName: "PromotionsCell", bundle: nil), forCellReuseIdentifier: "PromotionsCell")
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
        var param = BaseSystemParam()
        param.current = pageIndex
        param.pageSize = 15
        let api = wxApi.getUserPromotions(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.tableView.mj_header?.endRefreshing()
            let result = RequestCallBackViewModel<PromotionsModel>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.list?.count ?? 0){
                    let model = result?.data?.list?[i]
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
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataArr.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromotionsCell = tableView.dequeueReusableCell(withIdentifier: "PromotionsCell") as! PromotionsCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 165
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        if model.redirectType == 1{
            if model.linkApp?.contains("checkin") == true {
                self.pushVC(vc: CheckInController())
            }else if model.linkApp?.contains("welcome") == true {
                self.pushVC(vc: RegisterActivityController())
            }
        }else{
            let web = PublicWebController()
            if model.linkApp?.contains("deposit") == true {
                web.titleStr = "Deposit Bonus"
            }else if model.linkApp?.contains("acca") == true {
                web.titleStr = "Accumulator Bonus"
            }
            web.url = model.linkH5
            self.pushVC(vc: web)
        }
    }
}
