//
//  ChampionshipsViewController.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/28.
//

import UIKit
import SDWebImage

class ChampionshipsViewController: BaseViewController {
    
    @IBOutlet weak var LIVE: UIButton!
    @IBOutlet weak var Sports: UIButton!
    @IBOutlet weak var liveLine: UILabel!
    @IBOutlet weak var sportsLine: UILabel!
    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var topBgHH: NSLayoutConstraint!
    @IBOutlet weak var listviewTopHH: NSLayoutConstraint!
    
    var sportDict:(String,String,String,String,Bool,String)?
    var leagueType = "1"
    var gameType = "FF"
    
    private var classArray = [[("World Cup 2026 Qualification Africa","WorldCup","3"),("Premier League","PremierLeague","12"),("LaLiga","LaLiga","3"),
                               ("UEFA European Under-19 Championship Qualification","UEFA","5"),("Serie A","SerieA","3"),("Ligue 1 Uber Eats","LigueUberEats","1")],
                              [("Live Events","Greece","1"),("Starting Soon","Greece","2"),("WC Qualiflcation,AFC","Greece","1")],
                              [("India Mizoram Super League","India","1"),("Indian Premier League","India","2"),("India·Ludhiana League","India","1"),("India·Delhi Super League","India","1")],
                              [("Saudi Pro League","Saudi","3")]]
    
    private var classHeads = [("World Cup","","67",true),
                              ("Greece","Greece","4",false),("India","India","5",true),("Saudi Pro League","Saudi","3",true)]
    
    private var stateArray = ["Asia","Europe","North America","South America","Africa","Antarctica","Oceania","International"]//Belarus
    
    private var listArray = [onSaleLeaguesModel]()
    
    var liveStr = "LIVE"
    var sportsStr = "Sports"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = "Championships"
        self.addNavBar(.white)
        titleLabel.text = sportDict?.0
        logoimg.image = UIImage(named: sportDict?.1 ?? "")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "OtherSportViewCell", bundle: nil), forCellWithReuseIdentifier: "OtherSportViewCell")
        collectionview.register(UINib(nibName: "OtherReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OtherReusableView")
        
        LIVE.setTitle(liveStr, for: .normal)
        LIVE.setTitle(liveStr, for: .selected)
        Sports.setTitle(sportsStr, for: .normal)
        Sports.setTitle(sportsStr, for: .selected)
        
        //matchGetOnSaleLeagues(sportId: sportDict?.2 ?? "", type: leagueType)
        if gameType == "virtual"{
            topBgHH.constant = 0.1
            listviewTopHH.constant = 10
            LIVE.isHidden = true
            Sports.isHidden = true
            virtualMatchStatisticalRequest()
        }else{
            if leagueType == "1"{
                SetLIVE()
            }else{
                SetSports()
            }
        }
    }
    
    @IBAction func clickLIVE(_ sender: UIButton) {
        SetLIVE()
    }
    
    @IBAction func clickSports(_ sender: UIButton) {
        SetSports()
    }
    
    private func SetLIVE(){
        LIVE.isSelected = true
        Sports.isSelected = false
        liveLine.isHidden = false
        sportsLine.isHidden = true
        leagueType = "1"
        matchGetOnSaleLeagues(sportId: sportDict?.2 ?? "", type: leagueType)
    }
    
    private func SetSports(){
        LIVE.isSelected = false
        Sports.isSelected = true
        liveLine.isHidden = true
        sportsLine.isHidden = false
        leagueType = "3"
        matchGetOnSaleLeagues(sportId: sportDict?.2 ?? "", type: leagueType)
    }
    
    private func loadLeagueMatchs(models:[hlsModel]){
        self.listArray.removeAll()
        for md in models{
            if self.listArray.count > 0{
                if self.stateArray.contains(md.rnm ?? ""){
                    if self.stateArray.contains(self.listArray[0].rnm ?? ""){
                        self.listArray[0].hlsModels?.append(md)
                    }else{
                        var onSaleLeagues = onSaleLeaguesModel()
                        var records:[hlsModel] = [hlsModel]()
                        records.append(md)
                        onSaleLeagues.rid = md.rid
                        onSaleLeagues.rnm = md.rnm
                        onSaleLeagues.type = false
                        onSaleLeagues.hlsModels = records
                        self.listArray.insert(onSaleLeagues, at: 0)
                    }
                }else{
                    var index = 0
                    for records in self.listArray{
                        if md.rid == records.rid{
                            self.listArray[index].hlsModels?.append(md)
                            break
                        }
                        index += 1
                    }
                    if self.listArray.count == index{
                        var onSaleLeagues = onSaleLeaguesModel()
                        var records:[hlsModel] = [hlsModel]()
                        records.append(md)
                        onSaleLeagues.rid = md.rid
                        onSaleLeagues.rnm = md.rnm
                        onSaleLeagues.type = false
                        onSaleLeagues.hlsModels = records
                        self.listArray.append(onSaleLeagues)
                    }
                }
            }else{
                var onSaleLeagues = onSaleLeaguesModel()
                var records:[hlsModel] = [hlsModel]()
                records.append(md)
                onSaleLeagues.rid = md.rid
                onSaleLeagues.rnm = md.rnm
                onSaleLeagues.type = false
                onSaleLeagues.hlsModels = records
                self.listArray.append(onSaleLeagues)
            }
        }
        
        for recordsModel in self.listArray{
            var records:[hlsModel] = recordsModel.hlsModels ?? [hlsModel]()
            if records.count > 1{
                records = records.sorted { (md1:hlsModel , md2: hlsModel) in
                    return md1.or! < md2.or!
                }
            }
        }
        
        if self.listArray.count > 0{
            collectionview.hiddenEmptyView()
        }else{
            collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
        collectionview.reloadData()
    }
    
    private var virtualListModels = Array<lsModel>()
    private func roadVirtualClassData(ssl: [sslModel]){
        for item in ssl{
            if sportDict?.2 == "\(item.sid ?? 0)"{
                for lsm in item.ls ?? [lsModel](){
                    virtualListModels.append(lsm)
                }
            }
        }
        
        if virtualListModels.count > 0{
            collectionview.hiddenEmptyView()
        }else{
            collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
        collectionview.reloadData()
    }
    
}

extension ChampionshipsViewController{
    //获取联赛列表
    private func matchGetOnSaleLeagues(sportId: String, type: String){
        CollectRequest.getCollectLeagueMatch (completion: { colletLeagueMatchArr in
            self.showHUD(text: "Loading...")
            var param = MatchGetOnSaleLeaguesParam()
            param.sportId = sportId
            param.type = type
            param.languageType = "ENG"
            let api = wxApi.matchGetOnSaleLeagues(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                self.hudHide()
                //print("matchGetOnSaleLeagues===\(data)")
                var result = RequestCallBackViewModel<[hlsModel]>.deserialize(from: data)
                if(result?.code == 0){
                    for i in 0..<(result?.data?.count ?? 0){
                        let model : hlsModel = result?.data![i] ?? hlsModel()
                        var isCollect = false
                        for j in 0..<colletLeagueMatchArr.count{
                            let leagueMatchModel = colletLeagueMatchArr[j]
                            if model.id == leagueMatchModel.lId{
                                isCollect = true
                            }
                        }
                        result?.data?[i].isCollect = isCollect
                    }
                    
                    self.loadLeagueMatchs(models: result?.data ?? [hlsModel]())
                }else{
                    //令牌失效
//                    if result?.code == 14010 {
//                    }
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
            }) { (error) in
                self.hudHide()
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
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

extension ChampionshipsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OtherReusableViewDelegate{
    func OtherSportRightBtn(btn: UIButton) {
        if gameType == "virtual"{
            let model = virtualListModels[btn.tag - 100]
            let vc = ChampionshipsListController()
            vc.leagueTitle = "Virtual - " + (getVirtualSportsName(Id: Int(sportDict?.2 ?? "0") ?? 0))
            vc.leagueId = "\(model.id ?? 0)"
            vc.gameType = "virtual"
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            if btn.isSelected{
                listArray[btn.tag - 100].type = true
            }else{
                listArray[btn.tag - 100].type = false
            }
            collectionview.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if gameType == "virtual"{
            return virtualListModels.count
        }
        return listArray.count//classHeads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameType == "virtual"{
            return 0
        }
        if self.stateArray.contains(self.listArray[section].rnm ?? "") || (listArray[section].type ?? false) {
            return listArray[section].hlsModels?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherSportViewCell", for: indexPath) as! OtherSportViewCell
        let model = listArray[indexPath.section].hlsModels?[indexPath.item]
        if self.stateArray.contains(self.listArray[indexPath.section].rnm ?? ""){
            cell.type = -1
        }else{
            if indexPath.row == 0 && (listArray[indexPath.section].hlsModels?.count ?? 0)-1 != 0{
                cell.type = 1
            }else if indexPath.row == (listArray[indexPath.section].hlsModels?.count ?? 0)-1 {
                cell.type = 2
            }else{
                cell.type = 1
            }
        }
        cell.model = model
        cell.titleLabel.text = model?.na
        cell.logoimg.sd_setImage(with: URL(string: model?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model?.sid ?? 0)))
        cell.mtLabel.text = "\(model?.mt ?? 0)"
        cell.collectLeagueMatchSuccessBlock = {[weak self](item) in
            self!.listArray[indexPath.section].hlsModels?[indexPath.item] = item!
            self?.collectionview.reloadData()
        }
        cell.cancelCollectLeagueMatchSuccessBlock = {[weak self](item) in
            self!.listArray[indexPath.section].hlsModels?[indexPath.item] = item! as! hlsModel
            self?.collectionview.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.stateArray.contains(self.listArray[indexPath.section].rnm ?? ""){
            return CGSize(width: kScreenW - 20, height: 70)
        }
        return CGSize(width: kScreenW - 20, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OtherReusableView", for: indexPath) as! OtherReusableView
        reusableview.bgBtn.tag = 100 + indexPath.section
        reusableview.delegate = self
        if gameType == "virtual"{
            let model = virtualListModels[indexPath.section]
            reusableview.logoimg.sd_setImage(with: URL(string: model.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key:Int(sportDict?.2 ?? "0") ?? 0)))
            reusableview.titleLabel.text = model.na
            reusableview.line.isHidden = true
            reusableview.mtLabel.isHidden = true
        }else{
            let model = listArray[indexPath.section]
            reusableview.titleLabel.text = model.rnm
            reusableview.logoimg.image = UIImage(named: sportDict?.1 ?? "")
            reusableview.mtLabel.text = "\(model.hlsModels?.count ?? 0)"
            reusableview.rightBtn.isSelected = model.type ?? false
            reusableview.bgBtn.isSelected = model.type ?? false
            reusableview.bgView.layer.cornerRadius = 10
            if model.type ?? false{
                reusableview.line.isHidden = false
                reusableview.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else{
                reusableview.line.isHidden = true
                reusableview.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if gameType == "virtual"{
            return CGSize(width: kScreenW - 20, height: 60)
        }
        
        if self.stateArray.contains(self.listArray[section].rnm ?? ""){
            return CGSize(width: 0, height: 0)
        }
        
        if section == 0 {
            return CGSize(width: kScreenW - 20, height: 70)
        }
        return CGSize(width: kScreenW - 20, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let model = listArray[indexPath.section].hlsModels?[indexPath.item]
        let vc = ChampionshipsListController()
        vc.leagueTitle = model?.na ?? ""
        vc.leagueType = leagueType
        vc.sportId = sportDict?.2 ?? ""
        vc.leagueId = "\(model?.id ?? 0)"
        self.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
