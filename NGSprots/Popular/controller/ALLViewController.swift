//
//  ALLViewController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/29.
//

import UIKit
import SDWebImage

class ALLViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = "All"
        addNavBar(.white)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AllViewCell", bundle: nil), forCellReuseIdentifier: "AllViewCell")
        
        requestAllSport()
    }
    
    private var listModel = Array<SportsItemModel>()
    private func loadData(models: [SportsItemModel]){
        listModel = models
        tableView.reloadData()
        matchGetOnSaleLeagues(type: "1")
    }
    
    private func loadLeagueMatchs(models:[hlsModel], type: String){
        var index = 0
        for item in listModel{
            if item.games?.count ?? 0 > 0{
                let sid = item.games?[0].sportId ?? 0
                for md in models{
                    if sid == md.sid{
                        listModel[index].num! += md.mt ?? 0
                    }
                }
            }
            index += 1
        }
        
        if type == "1"{
            matchGetOnSaleLeagues(type: "3")
        }else{
            tableView.reloadData()
            virtualMatchStatisticalRequest()
        }
    }
    
    private func roadVirtualClassData(ssl: [sslModel]){
        var index = 0
        for item in listModel{
            if item.games?.count ?? 0 > 0{
                let sid = item.games?[0].sportId ?? 0
                for md in ssl{
                    if sid == md.sid{
                        listModel[index].num! = md.ls?.count ?? 0
                    }
                }
            }
            index += 1
        }
        tableView.reloadData()
    }

}

extension ALLViewController{
    //MARK: -获取所有sport
    func requestAllSport(){
        self.showHUD(text: "Loading...")
        var param = BaseSystemParam()
        param.navType = 1
        let api = wxApi.getAllSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadData(models: result?.data?.all ?? [SportsItemModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //获取联赛列表
    private func matchGetOnSaleLeagues(type: String){
        var param = MatchGetOnSaleLeaguesParam()
        param.type = type
        param.languageType = "ENG"
        let api = wxApi.matchGetOnSaleLeagues(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<[hlsModel]>.deserialize(from: data)
            if(result?.code == 0){
                self.loadLeagueMatchs(models: result?.data ?? [hlsModel](), type: type)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //virtual赛事统计matchStatistical
    private func virtualMatchStatisticalRequest(){
        var param = MatchDetailParam()
        param.languageType = "ENG"
        let api = wxApi.virtualMatchStatistical(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<virtualMatchStatisticalModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadVirtualClassData(ssl: result?.data?.ssl ?? [sslModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
}

extension ALLViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AllViewCell = tableView.dequeueReusableCell(withIdentifier: "AllViewCell") as! AllViewCell
        cell.selectionStyle = .none
        let model = listModel[indexPath.row]
        cell.nameLabel.text = model.name
        if model.games?.count ?? 0 > 0{
            cell.logoimg.sd_setImage(with: URL(string: model.image ?? ""), placeholderImage: UIImage(named: getTopSportsImg(Id: model.games?[0].sportId ?? 0)))
        }
        cell.numLabel.text = "\(model.num ?? 0)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listModel[indexPath.row]
        let vc = ChampionshipsViewController()
        if model.games?.count ?? 0 > 0{
            vc.sportDict = (model.name ?? "" ,model.name ?? "" ,"\(model.games?[0].sportId ?? 0)" ,"0" ,model.games?[0].isVirtual ?? false,"")
            if model.games?[0].isVirtual ?? false{
                vc.gameType = "virtual"
            }
        }
        self.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
