//
//  PurseRecordController.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit
import MJRefresh
class PurseRecordController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex = 1
    
    //var dataArr : [PurseRecordModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Record"
        self.addNavBar(.white)
        
        setUpUI()
    }
    func setUpUI(){
//        self.dataArr = [PurseRecordModel(type: 0,date: "2024-11-12",number: "3000",state: 1),
//                        PurseRecordModel(type: 1,date: "1992-11-12",number: "3000",state: 0)]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        tableView.register(UINib(nibName: "PurseRecordCell", bundle: nil), forCellReuseIdentifier: "PurseRecordCell")
        
        tableView.showEmptyView(image: "payRecordNoData", title: "NONE", subtitle: "No data available", btnStr: nil)
        getData()
    }
    @objc func getData(){
        requestDataWithMore(isMore: false)
    }
    @objc func getMoreData(){
        requestDataWithMore(isMore: true)
    }
    
    private var listModels = Array<payRwList>()
    private func loadData(models: [payRwList]){
        listModels = models
        tableView.reloadData()
        if listModels.count > 0{
            tableView.hiddenEmptyView()
        }else{
            tableView.showEmptyView(image: "payRecordNoData", title: "NONE", subtitle: "No data available", btnStr: nil)
        }
    }
    
    func requestDataWithMore(isMore:Bool){
        if isMore == true{
            pageIndex = pageIndex + 1
        }else{
            pageIndex = 1
            listModels.removeAll()
        }
        var param = payRwListParam()
        param.current = pageIndex
        param.pageSize = 15
        let api = wxApi.payRwList(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            self.tableView.mj_header?.endRefreshing()
            let result = RequestCallBackViewModel<payRwListModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadData(models: result?.data?.list ?? [payRwList]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            if self.listModels.count >= result?.data?.total ?? 0{
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
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.listModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PurseRecordCell = tableView.dequeueReusableCell(withIdentifier: "PurseRecordCell") as! PurseRecordCell
        cell.model = self.listModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecordDetailController()
        vc.model = self.listModels[indexPath.row]
        self.pushVC(vc: vc)
    }
}
