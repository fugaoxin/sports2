//
//  PopularViewController.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/27.
//

import UIKit
import IQKeyboardManager
import SDWebImage
import MJRefresh
import AVKit

let IsNeedGetCollect = "isNeedGetCollect"
let CollectGameID = "collectGameID"
class PopularViewController: MyNavigationController {

    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var scrollBgview: UIView!
    @IBOutlet weak var classBgview: UIView!
    @IBOutlet weak var highlightCollectionView: UICollectionView!
    @IBOutlet weak var Hightlight: UIButton!
    @IBOutlet weak var LIVE: UIButton!
    @IBOutlet weak var Favourites: UIButton!
    @IBOutlet weak var Virtual: UIButton!
    @IBOutlet weak var LiveCasino: UIButton!
    @IBOutlet weak var Esports: UIButton!
    @IBOutlet weak var statusScrollView: UIScrollView!
    @IBOutlet weak var stateIndicatorView: UIView!
    @IBOutlet weak var stateIndicatorLeftSpace: NSLayoutConstraint!
    @IBOutlet weak var listHH: NSLayoutConstraint!
    
    //type为 livecasino 和 Esports时 UI需要变化
    @IBOutlet weak var statusScrollviewH: NSLayoutConstraint!
    @IBOutlet weak var statusBgViewH: NSLayoutConstraint!
    
    private var classTitleArr1 = ["IceHockey","Basketball","TableTennis","E-Basketball", "Greyhounds"]
    
    private var typeArray = [("All","All","0","1",false,""), ("Football","Football_icon","1","0",false,""), ("Basketball","Basketball_icon2","3","0",false,""), ("Slot Ma…","Tennis_icon2","2","0",false,""),
                             ("e-sports","Snooker_icon","4","0",false,""), ("Volleyball","Volleyball_icon","13","0",false,""),("Rugby","Rugby_icon","15","0",false,""),("Snooker","Snooker_icon-1","16","0",false,""), ("Tennis","Tennis_icon-1","19","0",false,""),("Screen","Screen","19","0",false,"")]
    private var classArray = [("Football","Soccer_icon","1","1","",""), ("Basketball","Basketball_icon","3","0","",""), ("Tennis","Tennis_icon","5","0","",""),("Ice Hockey","Ice Hockey_icon","2","0","",""),
                              ("Football","Soccer_icon","1","0","",""), ("Basketball","Basketball_icon","3","0","",""), ("Tennis","Tennis_icon","5","0","",""),("Ice Hockey","Ice Hockey_icon","3","0","","")]
    
    private var imgNames = ["sctest","sctest","sctest","sctest","sctest","sctest"]
    private var listArray = ["","","","","","",""]
    private var stakeAndproType = 1
    private var followUsType = false
    
    private var curPage = 1
    //每页显示数量
    private var limitSize = 30
    private var isRequesting = false
    private var sportId = "1"
    private var matchPlayType = "3"
    
    private var insertTimers:Timer?
    private var orderTimers:Timer?
    private var opodTimers:Timer?
    
    //头部赛事种类model
    var sportsModel : SportsModel?
    
    let cellReuseId = "cellReuseId"
    
    var bannerArr : [PromotionsItemModel] = []
    lazy var bannerView: CWBanner = {
        let layout = CWSwiftFlowLayout.init(style: .preview_normal)
        layout.itemSpace = 15
        let banner = CWBanner.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW - 20, height: 120), flowLayout: layout, delegate: self as CWBannerDelegate)
        scrollBgview.addSubview(banner)
        banner.backgroundColor = view.backgroundColor
        banner.banner.register(UINib(nibName: "ActivityBannerCell", bundle: nil), forCellWithReuseIdentifier: cellReuseId)
        banner.autoPlay = true
        banner.endless = true
        banner.timeInterval = 2
        banner.pageControl.isHidden = true
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        requestTopSport()
        requestBannerActivity()
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutRefresh), name: NSNotification.Name(rawValue: LogoutNotice), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(jumpToController), name: NSNotification.Name(rawValue: CheckInGetCouponNotice), object: nil)
    }
    
    private func setUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        classCollectionView.setCollectionViewLayout(layout, animated: true)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.alwaysBounceHorizontal = true
        classCollectionView.showsHorizontalScrollIndicator = false
        classCollectionView.register(UINib(nibName: "ClassCVCell", bundle: nil), forCellWithReuseIdentifier: "ClassCVCell")
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = UICollectionView.ScrollDirection.horizontal
        highlightCollectionView.setCollectionViewLayout(layout1, animated: true)
        highlightCollectionView.delegate = self
        highlightCollectionView.dataSource = self
        highlightCollectionView.alwaysBounceHorizontal = true
        highlightCollectionView.showsHorizontalScrollIndicator = false
        highlightCollectionView.register(UINib(nibName: "HLClassCell", bundle: nil), forCellWithReuseIdentifier: "HLClassCell")
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        listCollectionView.setCollectionViewLayout(layout2, animated: true)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.alwaysBounceVertical = true
        listCollectionView.showsVerticalScrollIndicator = false
//        listCollectionView.register(UINib(nibName: "LeagueMatchListCell", bundle: nil), forCellWithReuseIdentifier: "LeagueMatchListCell")
//        listCollectionView.register(UINib(nibName: "LeagueMatchReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LeagueMatchReusableView")
        listCollectionView.register(UINib(nibName: "FooterLineReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterLineReusableView")
        listCollectionView.register(UINib(nibName: "SportsStatusHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SportsStatusHeaderView")
        
        listCollectionView.register(UINib(nibName: "FootballListCell", bundle: nil), forCellWithReuseIdentifier: "FootballListCell")
        listCollectionView.register(UINib(nibName: "BasketballListCell", bundle: nil), forCellWithReuseIdentifier: "BasketballListCell")
        listCollectionView.register(UINib(nibName: "VolleyballListCell", bundle: nil), forCellWithReuseIdentifier: "VolleyballListCell")
        listCollectionView.register(UINib(nibName: "FavouritesNoDataCell", bundle: nil), forCellWithReuseIdentifier: "FavouritesNoDataCell")
        listCollectionView.register(UINib(nibName: "OtherSportViewCell", bundle: nil), forCellWithReuseIdentifier: "OtherSportViewCell")
        listCollectionView.register(UINib(nibName: "BrowseGameCell", bundle: nil), forCellWithReuseIdentifier: "BrowseGameCell")
        listCollectionView.register(UINib(nibName: "PortraitViewCell", bundle: nil), forCellWithReuseIdentifier: "PortraitViewCell")
        listCollectionView.register(UINib(nibName: "OtherSportViewCell", bundle: nil), forCellWithReuseIdentifier: "OtherSportViewCell")
        listCollectionView.register(UINib(nibName: "LiveCasinoCell", bundle: nil), forCellWithReuseIdentifier: "LiveCasinoCell")
        listCollectionView.register(UINib(nibName: "LiveCasinoGameCell", bundle: nil), forCellWithReuseIdentifier: "LiveCasinoGameCell")
        listCollectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(lmlviewHeaderRefresh))
        listCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(lmlviewFooterRefresh))
        let mjcf = MJRefreshConfig.default
        mjcf.languageCode = "en"
        
        //self.view.setBet()
        self.view.setNewBet()

        NotificationCenter.default.addObserver(self, selector: #selector(loadCart), name: NSNotification.Name(rawValue: "loadCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTime), name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
        
        self.view.setTipsView()
        
        if Tool.getuserInfoModel() != nil{
            lodaCartBetSlipList()
        }
    }
    @objc private func jumpToController(_ notify: NSNotification){
        let userInfo = notify.userInfo
        let type: Int = userInfo!["type"] as! Int
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if type == 1{
                if (Tool.getCurrentVc() is PopularViewController) && !(Tool.getCurrentVc() is CouponController){
                    self.pushVC(vc: CouponController())
                }
            }else if type == 0{
                self.tabBarController?.selectedIndex = 3
            }else{
                self.tabBarController?.selectedIndex = 1
            }
        }
    }
    @objc func invalidateTime(){
        orderTimers?.invalidate()
        opodTimers?.invalidate()
    }
    
    //每次进来只拿一次（后台的排序不经常变动）
    private var allSportType = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setTipsDelegate(vc: self)
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        if self.Hightlight.isSelected == true{
            stateIndicatorLeftSpace.constant = Hightlight.center.x - 8
        }
        let data  = UserDefaults.standard.value(forKey: CollectGameID)
        var arr : Array<CollectGameItemModel> = []
        if data != nil{
            arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
        }

        if self.Favourites.isSelected == true && classArray[0].3 == "1"{
            if arr.count == 0{
                curPage = 1
                self.matchPlayType = "1"
                
            }else{
                curPage = 1
                self.matchPlayType = "0"
            }
        }else if self.Favourites.isSelected == true && classArray[1].3 == "1"{
            self.collectLeagueMatchUI()
        }else if self.Favourites.isSelected == true && classArray[2].3 == "1"{
            self.getBrowseGameUI()
        }
        
        if matchPlayType == "10" && self.Virtual.isSelected == true{
            virtualMatchStatisticalRequest()
        }else if self.LiveCasino.isSelected == true || self.Esports.isSelected == true{
            self.listCollectionView.reloadData()
        }else{
            //matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
            matchStatisticalRequest()
        }
            
        if self.matchPlayType != "0"{
            loadUITimers()
        }
        
        Tool.requestGetUserInfo{}
        
        if allSportType{
            allSportType = false
            requestAllSport(type: 2)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.Virtual.isSelected == true{
            if self.virtualListModels.count > 0{
                self.listCollectionView.hiddenEmptyView()
                listCollectionView.reloadData()
            }else{
                self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
            }
        }else if self.LiveCasino.isSelected == true || self.Esports.isSelected == true{
            if self.liveCasinoModels.count > 0{
                self.listCollectionView.hiddenEmptyView()
                listCollectionView.reloadData()
            }else{
                self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
            }
        }else{
            if self.Favourites.isSelected == false{
                if listModels.count > 0{
                    self.listCollectionView.hiddenEmptyView()
                    listCollectionView.reloadData()
                }else{
                    self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
                }
            }else{
                if favouriteModels.count == 0 && leagueMatchModels.count == 0 && listModels.count == 0 && browseGameModels.count == 0{
                    self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "Your list of favorite games is empty", subtitle: "No data of interest is currently accessible", btnStr: "")
                }else{
                    self.listCollectionView.hiddenEmptyView()
                }
                listCollectionView.reloadData()
            }
        }
        popGestureClose()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popGestureOpen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
    }
    
    private var listModels = Array<recordModel>()
    private var favouriteModels = Array<Array<recordModel>>()
    private var leagueMatchModels = Array<CollectLeagueMatchItemModel>()
    private var browseGameModels = Array<BrowseGameItemModel>()
    private var liveCasinoModels = Array<GameListModel>()
    private var listModelsOld = Array<recordModel>()
    private func loadUI(models: [recordModel]){
        let data  = UserDefaults.standard.value(forKey: CollectGameID)
        var arr : Array<CollectGameItemModel> = []
        if data != nil{
            arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
        }
        if self.Favourites.isSelected == true && arr.count != 0 && self.matchPlayType == "0" && classArray[0].3 == "1"{
            var live : Array<recordModel> = []
            var results : Array<recordModel> = []
            for i in 0..<models.count{
                let item = models[i]
                if item.ms == 5{ //正在进行
                    live.append(item)
                }else{
                    results.append(item)
                }
                favouriteModels = [live,results]
            }
        }else{
            for md in models{
                listModels.append(md)
            }
        }
        if self.Favourites.isSelected == false{
            if listModels.count > 0{
                self.listCollectionView.hiddenEmptyView()
                listCollectionView.reloadData()
            }else{
                self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
            }
        }else{
            if favouriteModels.count == 0 && listModels.count == 0  && classArray[0].3 == "1"{
                
                if self.matchPlayType != "1"{
                    curPage = 1
                    self.matchPlayType = "1"
                    matchGetList(current: "\(curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
                }else{
//                    self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "Your list of favorite games is empty", subtitle: "No data of interest is currently accessible", btnStr: "")
                    self.listCollectionView.hiddenEmptyView()
                    listCollectionView.reloadData()
                }
            }else{
                self.listCollectionView.hiddenEmptyView()
                listCollectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func clickHightlight(_ sender: UIButton) {
        Hightlight.isSelected = true
        LIVE.isSelected = false
        Favourites.isSelected = false
        Virtual.isSelected = false
        LiveCasino.isSelected = false
        Esports.isSelected = false
        self.buttonClicked(sender: Hightlight)
        self.changeStutasUI(type: 0)
        stateIndicatorLeftSpace.constant = Hightlight.center.x - 8
        loadClassUI()
        curPage = 1
        self.matchPlayType = "3"
        requestAllSport(type: 2)
        matchStatisticalRequest()
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
    }
    
    @IBAction func clickLIVE(_ sender: UIButton) {
        Hightlight.isSelected = false
        LIVE.isSelected = true
        Favourites.isSelected = false
        Virtual.isSelected = false
        LiveCasino.isSelected = false
        Esports.isSelected = false
        self.buttonClicked(sender: LIVE)
        self.changeStutasUI(type: 0)
        stateIndicatorLeftSpace.constant = LIVE.center.x - 8
        loadClassUI()
        curPage = 1
        self.matchPlayType = "1"
        requestAllSport(type: 3)
        matchStatisticalRequest()
    }
    
    @IBAction func clickFavourites(_ sender: UIButton) {
        Hightlight.isSelected = false
        LIVE.isSelected = false
        Favourites.isSelected = true
        Virtual.isSelected = false
        LiveCasino.isSelected = false
        Esports.isSelected = false
        self.buttonClicked(sender: Favourites)
        self.changeStutasUI(type: 0)
        stateIndicatorLeftSpace.constant = Favourites.center.x - 8
        classArray.removeAll()
        classArray = [("Events","Events","1","1","",""), ("Other","Other","1","0","",""), ("Viewed","Viewed","1","0","","")]
        loadClassUI()
        
        let data  = UserDefaults.standard.value(forKey: CollectGameID)
        var arr : Array<CollectGameItemModel> = []
        if data != nil{
            arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
        }
        if arr.count == 0{
            curPage = 1
            self.matchPlayType = "1"
            matchGetList(current: "\(curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
        }else{
            curPage = 1
            self.matchPlayType = "0"
            matchGetList(current: "\(curPage)", size:"\(50)", type: self.matchPlayType, sportId: self.sportId)
        }
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
    }
    
    @IBAction func clickVirtual(_ sender: UIButton) {
        Hightlight.isSelected = false
        LIVE.isSelected = false
        Favourites.isSelected = false
        Virtual.isSelected = true
        LiveCasino.isSelected = false
        Esports.isSelected = false
        self.buttonClicked(sender: Virtual)
        self.changeStutasUI(type: 0)
        stateIndicatorLeftSpace.constant = Virtual.center.x - 8
//        classArray.removeAll()
        loadClassUI()
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
        
        //虚拟体育（xjb写）
        self.matchPlayType = "10"
        requestAllSport(type: 4)
        virtualMatchStatisticalRequest()
    }
    
    private var gameType = "3"
    @IBAction func clickLiveCasino(_ sender: Any) {
        Hightlight.isSelected = false
        LIVE.isSelected = false
        Favourites.isSelected = false
        Virtual.isSelected = false
        LiveCasino.isSelected = true
        Esports.isSelected = false
        //self.buttonClicked(sender: LiveCasino)
        self.liveCasinoModels.removeAll()
        self.changeStutasUI(type: 1)
        stateIndicatorLeftSpace.constant = LiveCasino.center.x - 8
        
        self.matchPlayType = "11"
        gameType = "3"
        gameList()
    }
    
    @IBAction func clickEsports(_ sender: Any) {
        Hightlight.isSelected = false
        LIVE.isSelected = false
        Favourites.isSelected = false
        Virtual.isSelected = false
        LiveCasino.isSelected = false
        Esports.isSelected = true
        //self.buttonClicked(sender: Esports)
        self.liveCasinoModels.removeAll()
        self.changeStutasUI(type: 1)
        stateIndicatorLeftSpace.constant = Esports.center.x - 8
        
        self.matchPlayType = "11"
        gameType = "4"
        gameList()
    }
    func buttonClicked(sender: UIButton) {
        let scrollWidth = self.statusScrollView.frame.width
        let scrollHeight = self.statusScrollView.frame.height
        let desiredXCoor = sender.frame.origin.x - ((scrollWidth / 2) - (sender.frame.width / 2) )
        let rect = CGRect(x: desiredXCoor, y: 0, width: scrollWidth, height: scrollHeight)
        self.statusScrollView.scrollRectToVisible(rect, animated: true)
        
//        if sender == self.Esports{
//            self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
//            self.listCollectionView.reloadData()
//        }else{
//            self.listCollectionView.hiddenEmptyView()
//            self.listCollectionView.reloadData()
//        }
        
    }
    func changeStutasUI(type:Int){
        self.statusBgViewH.constant = type == 0 ? 75 : 50
        self.statusScrollviewH.constant = type == 0 ? 30 : 40
        self.highlightCollectionView.isHidden = type == 0 ? false : true
        self.listHH.constant = type == 0 ? 225 : 200
    }
    @objc func lmlviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        if matchPlayType == "10"{
            virtualMatchStatisticalRequest()
        }else if matchPlayType == "11"{
            gameList()
        }else{
            curPage = 1
            if self.Favourites.isSelected == true{
                if self.classArray[0].3 == "1"{
                    self.matchPlayType = "0"
                    matchGetList(current: "\(curPage)", size:"\(50)", type: self.matchPlayType, sportId: self.sportId)
                }else{
                    matchGetList(current: "\(curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
                }
            }else{
                matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
            }
        }
    }
    
    @objc func lmlviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        if matchPlayType == "10"{
            virtualMatchStatisticalRequest()
        }else if matchPlayType == "11"{
            gameList()
        }else{
            self.curPage += 1
            matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
        }
    }
    
    private func loadClassUI(){
//        self.sportId = ""
//        var index = 0
//        for _ in classArray {
//            classArray[index].3 = "0"
//            index += 1
//        }
        highlightCollectionView.reloadData()
    }
    
    private func roadClassData(sl: [slModel]){
        classArray.removeAll()
        for model in sl{
            if "\(model.ty ?? 0)" == self.matchPlayType{
                var index = 0
                for ssl in model.ssl ?? [sslModel](){
                    let sid:Int = ssl.sid ?? 0
                    let c:Int = ssl.c ?? 0
                    if c > 0{
                        if "\(sid)" == self.sportId{
                            classArray.append((getSportsName(Id: sid),"Soccer_icon", "\(sid)", "1","",""))
                            index = 0
                        }else{
                            classArray.append((getSportsName(Id: sid),"Soccer_icon", "\(sid)", "0","",""))
                            index += 1
                        }
                    }
                }
                if classArray.count > 0{
                    if index == classArray.count{
                        classArray[0].3 = "1"
                        self.sportId = classArray[0].2
                    }
                }
            }
            
            if model.ty ?? 0 == 1{
                liveNumber = 0
                for ssl in model.ssl ?? [sslModel](){
                    let c:Int = ssl.c ?? 0
                    if c > 0{
                        liveNumber = liveNumber + c
                    }
                }
            }
        }
        if classArray.count > 1{
            if self.sportsModel != nil{
                if (self.sportsModel?.all?.count ?? 0) > 0{
                    var index = 0
                    for item in self.sportsModel?.all ?? [SportsItemModel](){
                        var index2 = 0
                        if index < classArray.count{
                            for item2 in classArray{
                                if item.games?.count ?? 0 > 0{
                                    if "\(item.games?[0].sportId ?? 0)" == item2.2{
                                        classArray[index2].4 = item.image ?? ""
                                        classArray[index2].5 = item.imageHighlight ?? ""
                                        classArray.insert(classArray[index2], at: index)
                                        classArray.remove(at: index2 + 1)
                                        index += 1
                                        break
                                    }
                                }
                                index2 += 1
                            }
                        }
                    }
                }
            }else{
                if classArray[0].2 == "1"{
                    var index = 0
                    for md in classArray{
                        if md.2 == "3"{
                            classArray.insert(md, at: 1)
                            classArray.remove(at: index + 1)
                            break
                        }
                        index += 1
                    }
                }
            }
        }
        highlightCollectionView.reloadData()
        matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
        if self.matchPlayType == "1"{
            self.loadUITimers()
        }else{
            self.insertTimers?.invalidate()
        }
    }
    
    private var virtualIndex = 0
    private var virtualListModels = Array<sslModel>()
    private func roadVirtualClassData(ssl: [sslModel]){
        virtualListModels = ssl
        classArray.removeAll()
        for model in ssl{
            classArray.append((getVirtualSportsName(Id: model.sid ?? 0),"Soccer_icon", "\(model.sid ?? 0)", "0", "", ""))
        }
        if classArray.count >= virtualIndex{
            classArray[virtualIndex].3 = "1"
        }
        
        if virtualListModels.count > 0{
            self.listCollectionView.hiddenEmptyView()
        }else{
            self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
        
        highlightCollectionView.reloadData()
        listCollectionView.reloadData()
    }
    
    private func sortClassTag(){
        
    }
    
    private func loadUITimers(){
        self.insertTimers?.invalidate()
        if self.matchPlayType == "1"{
            self.insertTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(3), repeats: true, block: { (timer) in
                self.uploadUI()
            })
        }
    }
    
    private func uploadUI(){
        matchGetList2(current: "\(curPage)", size:"\(limitSize * (curPage))", type: self.matchPlayType, sportId: self.sportId)
    }
    
    private var labraa:UILabel!
    private func setbgLabel(text: String){
        
        labraa = UILabel(frame: CGRect(x: (kScreenW - 200)/2, y: (kScreenH - 100)/2, width: 200, height: 100))
        labraa.text = text
        UIApplication.shared.windows.last?.addSubview(lab)
        labraa.isHidden = false
    }
    
    private func delectlabel(){
        labraa.isHidden = true
    }
    
    private func setChuangArray(lists: [carListModel]){
        chuanguanArray.removeAll()
        for item in lists{
            var model = opModel()
            model.recordsId = item.matchId
            model.mksId = item.marketId
            model.recordsnm = (item.hTName ?? ".") + " - " + (item.aTName ?? ".")
            model.recordsbt = Int(item.beginTime ?? "0")
            let kk = item.marketName?.components(separatedBy: " : ")
            if (kk?.count ?? 0) > 2{
                model.ngnm = kk?[0]
                model.ty = Int(kk?[1] ?? "0")
                model.opsOnm = kk?[2]
            }else{
                model.ngnm = ""
                model.ty = 1
                model.opsOnm = ""
            }
            model.tps = item.marketTag
            chuanguanArray.append(model)
        }
    }
    
    @objc func loadCart(){
        lodaCartBetSlipList()
    }
    
    private func loadOrderStatus(Id: String, model: opModel, money: String){
        self.orderTimers?.invalidate()
        self.orderTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            self.loadOrderGetStakeOrderStatus(orderIds: [Id], model: model, money: money)
        })
    }
    
    private func loadOPOD(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        self.opodTimers?.invalidate()
        self.opodTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            //print("刷新赔率")
            self.loadOrderBatchBetMatchMarketOfJumpLine2(param: param, model: model)
        })
    }
    
    private func setTypeArray(model: SportsModel){
        var selectID = "0"
        for i in 0..<self.typeArray.count{
            if self.typeArray[i].3 == "1"{
                selectID = self.typeArray[i].2
            }
        }
        if model.list?.count ?? 0 > 0{
            self.typeArray.removeAll()
            self.typeArray.append(("All","All","0","1",false,""))
            for item in model.list ?? [SportsItemModel](){
                //self.typeArray.append((item.name ?? "",item.name ?? "",getSportsID(type: item.name ?? ""),"0"))
                if item.games?.count ?? 0 > 0{
                    self.typeArray.append((item.name ?? "",item.name ?? "","\(item.games?[0].sportId ?? 0)","0",item.games?[0].isVirtual ?? false,item.image ?? ""))
                }
            }
            if Tool.getuserInfoModel() != nil{
                self.typeArray.append(("Screen","Screen","-1","0",false,""))
            }
            for i in 0..<self.typeArray.count{
                if self.typeArray[i].2 == selectID{
                    self.typeArray[i].3 = "1"
                }else{
                    self.typeArray[i].3 = "0"
                }
            }
            self.classCollectionView.reloadData()
        }
    }
    
    private func getgundongIndex(id: Int) -> Int{
        if gundongIndexArray.count > 0{
            var index = 0
            for item in gundongIndexArray{
                if item.0 == id{
                    return gundongIndexArray[index].1
                 }
                index += 1
            }
            if index == gundongIndexArray.count{
                return 0
            }
        }
        return 0
    }
    
    private func roadGameList(models: [GameListModel]){
        self.liveCasinoModels = models
        self.listCollectionView.reloadData()
        if self.liveCasinoModels.count > 0{
            self.listCollectionView.hiddenEmptyView()
        }else{
            self.listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }
    }

    @IBOutlet weak var tipsB: UIButton!
    @IBOutlet weak var contactH: NSLayoutConstraint!
    @IBOutlet weak var lineLabel: UILabel!
    @IBAction func contact(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tipsB.isSelected = !tipsB.isSelected
        lineLabel.isHidden = !sender.isSelected
        contactH.constant = sender.isSelected == true ? 103 : 45
    }
    
    @IBAction func contactList(_ sender: UIButton) {
        var str = ""
        switch(sender.tag) {
        case 10:
            print("telephone")
            str = "tel://10086"
            break
        case 11:
            print("email")
            str = "mailto://wenxi@a.com"
            break
        case 12:
            print("FACEBOOK")
            str = "fb://profile/135057709986569"
            break
        case 13:
            print("IG")
            str = "instagram://media?id=1346423547953773636_401375631"
            break
        case 14:
            print("x")
            str = "twitter://user?screen_name=MyTwitterID"
            break
        default:
            print("TELEGRAM")
            str = "telegram://"
            break
        }
        let url = URL(string: str)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
}

extension PopularViewController {
    
    //获取赛事列表信息
    private func matchGetList(current: String, size: String, type: String, sportId: String){
        self.getCollectGame (completion: { colletSportArr in
            self.showHUD(text: "Loading...")
            var param = MatchGetListParam()
            param.current = current
            param.size = size
            param.languageType = "ENG"
            param.type = type
            param.sportId = sportId
            param.orderBy = "0"
            //param.matchIds = ["906379"]
            if type == "0"{
                param.matchIds = []
                let data  = UserDefaults.standard.value(forKey: CollectGameID)
                var arr : Array<CollectGameItemModel> = []
                if data != nil{
                    arr  = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                }
                for i in 0..<arr.count{
                    let model = arr[i]
                    param.matchIds?.append("\(model.mId ?? 0)")
                }
            }
            let api = wxApi.matchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                self.hudHide()
                if self.listCollectionView.mj_header != nil{
                    self.listCollectionView.mj_header?.endRefreshing()
                }
                if self.listCollectionView.mj_footer != nil{
                    if self.Favourites.isSelected == true{
                        self.listCollectionView.mj_footer?.endRefreshingWithNoMoreData()
                    }else{
                        self.listCollectionView.mj_footer?.endRefreshing()
                    }
                }
                self.isRequesting = false
                if self.curPage == 1 {
                    self.listModels.removeAll()
                    self.favouriteModels.removeAll()
                }
                var result = RequestCallBackViewModel<matchGetListModel>.deserialize(from: data)
                if(result?.code == 0){
                    //print("matchGetList===\(result?.data)")
                    for i in 0..<(result?.data?.records!.count ?? 0){
                        let model : recordModel = result?.data?.records![i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?.records![i].sctype = isCollect
                    }
                    self.loadUI(models: result?.data?.records ?? [recordModel]())

                    if self.Favourites.isSelected == false{
                        let num: Int = result?.data?.total ?? 0
                        if self.listModels.count < num{
                            self.listCollectionView.mj_footer?.endRefreshing()
                        }else{
                            self.listCollectionView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                }else{
                    //令牌失效
                    if result?.code == 14010 {
                        Tool.gameAccessTokenRequest {
                            self.matchGetList(current: current, size: size, type: type, sportId: sportId)
                        }
                    }else{
                        self.loadUI(models: [])
                        self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                    }
                }
                
            }) { (error) in
                self.hudHide()
                self.isRequesting = false
                if self.listCollectionView.mj_header != nil{
                    self.listCollectionView.mj_header?.endRefreshing()
                }
                if self.listCollectionView.mj_footer != nil{
                    self.listCollectionView.mj_footer?.endRefreshing()
                }
                self.loadUI(models: [])
                self.showTextSB(error, dismissAfterDelay: 1.5)
            }
        })
    }
    
    //赛事统计matchStatistical
    private func matchStatisticalRequest(){
        if self.Favourites.isSelected == true{
            return
        }
        var param = MatchDetailParam()
        param.languageType = "ENG"
        let api = wxApi.matchStatistical(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            //print("matchStatisticalRequest===\(data)")
            let result = RequestCallBackViewModel<matchStatisticalModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadClassData(sl: result?.data?.sl ?? [slModel]())
            }else{
                //令牌失效
                if result?.code == 14010 {
                    Tool.gameAccessTokenRequest{
                        self.matchStatisticalRequest()
                    }
                }else{
                    self.loadUI(models: [])
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
            }
        }) { (error) in
            self.loadUI(models: [])
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //virtual赛事统计matchStatistical
    private func virtualMatchStatisticalRequest(){
        if self.Favourites.isSelected == true{
            return
        }
        var param = MatchDetailParam()
        param.languageType = "ENG"
        let api = wxApi.virtualMatchStatistical(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            if self.listCollectionView.mj_header != nil{
                self.listCollectionView.mj_header?.endRefreshing()
            }
            if self.listCollectionView.mj_footer != nil{
                self.listCollectionView.mj_footer?.endRefreshing()
            }
            self.isRequesting = false
            let result = RequestCallBackViewModel<virtualMatchStatisticalModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadVirtualClassData(ssl: result?.data?.ssl ?? [sslModel]())
            }else{
                if result?.code == 14010 {
                    Tool.gameAccessTokenRequest{
                        self.virtualMatchStatisticalRequest()
                    }
                }else{
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                }
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func loadOrderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        self.showHUDNO()
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("result?.data===\(result?.data)")
                if result?.data?.bms?.count ?? 0 > 0{
                    if result?.data?.bms?[0].ss == 1{
                        self.view.showNewBetView(model: model)
                        self.view.setDelegate(view: self)
                        self.view.loadBms(bsmodel: result?.data?.bms?[0] ?? bmsModel())
                        self.loadOPOD(param: param, model: model)
                    }else if result?.data?.bms?[0].ss == -1{
                        self.showTextSB("Not available for sale", dismissAfterDelay: 1.5)
                    }else{
                        self.showTextSB("pause", dismissAfterDelay: 1.5)
                    }
                }else{
                    self.showTextSB("Do not bet", dismissAfterDelay: 1.5)
                }
                
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func loadOrderBatchBetMatchMarketOfJumpLine2(param: BatchBetMatchMarketOfJumpLineParam, model: opModel){
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("result?.data===\(result?.data)")
                if result?.data?.bms?.count ?? 0 > 0{
                    if result?.data?.bms?[0].ss == 1{
                        self.view.loadBms(bsmodel: result?.data?.bms?[0] ?? bmsModel())
                    }else if result?.data?.bms?[0].ss == -1{
                        self.opodTimers?.invalidate()
                    }else{
                        self.opodTimers?.invalidate()
                    }
                }else{
                    self.opodTimers?.invalidate()
                }
            }else{
                self.opodTimers?.invalidate()
            }
        }) { (error) in
            self.opodTimers?.invalidate()
        }
    }
    
    func loadOrderGetStakeOrderStatus(orderIds: [String], model: opModel, money: String){
        var param = StakeOrderStatusParam()
        param.languageType = "ENG"
        param.orderIds = orderIds
        let api = wxApi.orderGetStakeOrderStatus(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderGetStakeOrderStatusModel]>.deserialize(from: data)
            if(result?.code == 0){
                //print("result==OrderStatus==\(result?.data)")
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 4{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: money)
                    }else if st == 0 || st == 1{
                        if self.orderTimers == nil{
                            self.loadOrderStatus(Id: result?.data?[0].oid ?? "", model: model, money: money)
                        }
                    }else{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: result?.data?[0].rjs ?? "Lose a bet", money: money)
                    }
                }
            }else{
                self.orderTimers?.invalidate()
                self.opodTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: result?.message ?? "Lose a bet", money: money)
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.opodTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: money)
        }
    }
    
    func loadOrderBetSinglePass(param: singlePassParam, model: opModel){
        let api = wxApi.orderBetSinglePass(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[orderBetSinglePassResponseModel]>.deserialize(from: data)
            //print("loadOrderBetSinglePass===\(result?.data)")
            if(result?.code == 0){
                Tool.requestGetUserInfo{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "balance"), object: nil)
                }
                if result?.data?.count ?? 0 > 0{
                    let st = result?.data?[0].st ?? 0
                    if st == 0 || st == 1{
                        self.loadOrderStatus(Id: result?.data?[0].id ?? "", model: model, money: param.singleBetList?[0].unitStake ?? "0")
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }else if st == 4{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: param.singleBetList?[0].unitStake ?? "0")
                    }else{
                        self.orderTimers?.invalidate()
                        self.opodTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }
                }else{
                    self.orderTimers?.invalidate()
                    self.opodTimers?.invalidate()
                    self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
                }
            }else{
                self.orderTimers?.invalidate()
                self.opodTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.opodTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
        }
    }
    
    private func matchGetList2(current: String, size: String, type: String, sportId: String){
        self.getCollectGame (completion: { colletSportArr in
            var param = MatchGetListParam()
            param.current = current
            param.size = size
            param.languageType = "ENG"
            param.type = type
            param.sportId = sportId
            param.orderBy = "0"
            if type == "0"{
                param.matchIds = []
                let data  = UserDefaults.standard.value(forKey: CollectGameID)
                let arr : Array<CollectGameItemModel> = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                for i in 0..<arr.count{
                    let model = arr[i]
                    param.matchIds?.append("\(model.mId ?? 0)")
                }
            }
            let api = wxApi.matchGetList(param: param)
            AdHttpRequest(url: api, successCallBack: { (data) in
                var result = RequestCallBackViewModel<matchGetListModel>.deserialize(from: data)
                if(result?.code == 0){
                    self.listModelsOld = self.listModels
                    self.listModels.removeAll()
                    self.favouriteModels.removeAll()
                    
                    for i in 0..<(result?.data?.records!.count ?? 0){
                        let model : recordModel = result?.data?.records![i] ?? recordModel()
                        var isCollect = false
                        if colletSportArr.count != 0{
                            for j in 0...colletSportArr.count-1{
                                let sportModel = colletSportArr[j]
                                if model.id == sportModel.mId{
                                    isCollect = true
                                }
                            }
                        }
                        result?.data?.records![i].sctype = isCollect
                    }
                    
                    self.loadUI(models: result?.data?.records ?? [recordModel]())
                }
            }) { (error) in}
        })
    }
    
    func getCollectGame(completion : @escaping(Array<CollectGameItemModel>)->Void){
        if Tool.getuserInfoModel() == nil{
            completion([])
            return
        }
        let isRequest : Bool? = UserDefaults.standard.value(forKey: IsNeedGetCollect) as? Bool
        if isRequest == true || isRequest == nil{
            let api = wxApi.getCollectGame
            AdHttpRequest(url: api, successCallBack: { data in
                print("------\(data)")
                self.hudHide()
                let result = RequestCallBackViewModel<CollectGameModel>.deserialize(from: data)
                if(result?.code == 0){
                    let model : CollectGameModel = result?.data ?? CollectGameModel()
                    let modelData = NSKeyedArchiver.archivedData(withRootObject: model.list)
                    UserDefaults.standard.set(false, forKey: IsNeedGetCollect)
                    UserDefaults.standard.set(modelData, forKey: CollectGameID)
                    UserDefaults.standard.synchronize()
                    completion(model.list ?? [])
                }else{
                    if Tool.getuserInfoModel() == nil{
                        UserDefaults.standard.set(false, forKey: IsNeedGetCollect)
                        UserDefaults.standard.synchronize()
                    }
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                    completion([])
                }
            }) { error in
                self.hudHide()
                self.showTextSB(error, dismissAfterDelay: 1.5)
                completion([])
            }
        }else{
            let data  = UserDefaults.standard.value(forKey: CollectGameID)
            var arr : Array<CollectGameItemModel> = []
            if data != nil{
                arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
            }
            completion(arr)
        }
    }
    func requestBatchCancelCollect(index:Int){
        var param = CancelCollectParam()
        param.ids = []
        let data  = UserDefaults.standard.value(forKey: CollectGameID)
        let arr : Array<CollectGameItemModel> = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
        var deleteArr : Array<CollectGameItemModel> = []
        for i in 0..<favouriteModels[index].count{
            let model : recordModel = favouriteModels[index][i]
            for j in 0..<arr.count{
                let sportModel = arr[j]
                if model.id == sportModel.mId{
                    param.ids?.append(sportModel.id ?? 0)
                    deleteArr.append(sportModel)
                }
            }
        }
        self.showHUD(text: "Loading...")
        let api = wxApi.batchCancelCollectGame(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<CollectGameModel>.deserialize(from: data)
            if(result?.code == 0){
                
                let totalArr : NSMutableArray = NSMutableArray(array:arr)
                totalArr.removeObjects(in: deleteArr)
                let currentMids : Array<CollectGameItemModel> = totalArr as! Array<CollectGameItemModel>
                let modelData = NSKeyedArchiver.archivedData(withRootObject: currentMids)
                UserDefaults.standard.set(modelData, forKey: CollectGameID)
                UserDefaults.standard.synchronize()
                self.showTextSB("Uncollect successfully", dismissAfterDelay: 1)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.clickFavourites(UIButton())
                }
                
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }

    //购物车列表
    func lodaCartBetSlipList(){
        self.showHUD(text: "Loading...")
        let api = wxApi.cartBetSlipList
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<CarList>.deserialize(from: data)
            if(result?.code == 0){
                if result?.data?.list != nil{
                    self.setChuangArray(lists: result?.data?.list ?? [carListModel]())
                }
            }else{
            }
        }) { (error) in
            self.hudHide()
        }
    }
    
    private func gameList(){
        self.showHUD(text: "Loading...")
        var param = GameTokenParam()
        param.categoryId = gameType
        let api = wxApi.gameList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            if self.listCollectionView.mj_header != nil{
                self.listCollectionView.mj_header?.endRefreshing()
            }
            if self.listCollectionView.mj_footer != nil{
                self.listCollectionView.mj_footer?.endRefreshing()
            }
            self.isRequesting = false
            let result = RequestCallBackViewModel<GameModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadGameList(models: result?.data?.list ?? [GameListModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
}

extension PopularViewController: CWBannerDelegate{
    func didStartScroll(banner: CWBanner, index: Int, indexPath: IndexPath) {
    }
    
    func didEndScroll(banner: CWBanner, index: Int, indexPath: IndexPath) {
        
    }
    
    func bannerNumbers() -> Int {
        return self.bannerArr.count
    }
    
    func bannerView(banner: CWBanner, index: Int, indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ActivityBannerCell = banner.banner.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! ActivityBannerCell
        let item = self.bannerArr[index]
        cell.model = item
        return cell
    }
    
    func didSelected(banner: CWBanner, index: Int, indexPath: IndexPath) {
        print("点击 \(index) click...")
        let model = self.bannerArr[index]
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
            }else{
                web.titleStr = "Promotions"
            }
            web.url = model.linkH5
            self.pushVC(vc: web)
        }
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MMM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }
    
    private func miaozhuanLanqiu(time: Int) -> String{
        if time == 0{
            return "00:00"
        }
        let mm = "\(time/60)"
        let ss = "\(time%60)"
        return "\(mm.count > 1 ? mm : ("0" + mm))" + ":" + "\(ss.count > 1 ? ss : ("0" + ss))"
    }
    
}

extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FootballListCellDelegate, BasketballListCellDelegate, VolleyballListCellDelegate, FooterLineReusableViewDelegate, NewStakeViewDelegate,NYTipsViewDelegate,PortraitViewCellDelegate{
    func topUpAccount() {
        self.view.hiddenNewBetView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func clickLeftBtn() {
        self.view.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.view.hiddenTipsView()
        self.tabBarController?.selectedIndex = 3
    }
    
    func popularVideoBtn(index: Int) {
        var item : recordModel?
        if self.Favourites.isSelected == true{
            if classArray[0].3 == "1"{
                if self.favouriteModels.count != 0{
                    if index < 3000{
                        let arr = self.favouriteModels[0]
                        item = arr[index - 2000]
                    }else{
                        let arr = self.favouriteModels[1]
                        item = arr[index - 3000]
                    }
                }else{
                    //此为收藏数据空 点击了默认live数据
                    item = self.listModels[index - 3000]
                }
            }else{
                    //此为收藏数据空 点击了默认live数据
                    item = self.listModels[index - 3000]
            }
        }else{
            item = listModels[index - 2000]
        }
        if item?.vs?.m3u8SD != nil{
//            guard let playUrl = URL(string: item?.vs?.m3u8SD ?? "") else {
//                return
//            }
//            let vc = AVPlayerViewController()
//            vc.player = AVPlayer(url: playUrl)
//            present(vc, animated: true) {
//                vc.player?.play()
//            }
        }
    }
    
    //吓猪
    func settleAccounts(money: String, model: opModel) {
        //print(model)
        var blmodel = betOptionListModel()
        blmodel.marketId = "\(model.mksId ?? 0)"
        blmodel.odds = model.od
        blmodel.oddsFormat = "1"
        blmodel.optionType = "\(model.ty ?? 0)"
        
        var sbmodel = singleBetListModel()
        sbmodel.unitStake = money
        sbmodel.oddsChange = "1"
        sbmodel.betOptionList = [blmodel]
        
        var param = singlePassParam()
        param.languageType = "ENG"
        param.currencyId = "20"
        param.singleBetList = [sbmodel]
        loadOrderBetSinglePass(param: param, model: model)
    }
    
    func LMVGodetail(index: Int) {
        //进入详情页先获取一次收藏的game ID
        self.getCollectGame (completion: { [weak self] colletSportArr in
            let vc = MatchDetailsViewController()
            var item : recordModel?
            if self!.Favourites.isSelected == true{
                if self!.favouriteModels.count != 0{
                    if index < 200{
                        let arr = self!.favouriteModels[0]
                        item = arr[index - 100]
                    }else{
                        let arr = self!.favouriteModels[1]
                        item = arr[index - 200]
                    }
                }else{
                    //此为收藏数据空 点击了默认live数据
                    item = self!.listModels[index - 200]
                }
            }else{
                item = self!.listModels[index - 100]
            }
            vc.titleStr = item?.lg?.na ?? ""
            vc.matchId = "\(item?.id ?? 0)"
            vc.isCollect = item?.sctype ?? false
            vc.beginTime = item?.bt
            vc.isVirtual = false
            self?.hidesBottomBarWhenPushed = true
            self!.navigationController?.pushViewController(vc, animated: true)
            self?.hidesBottomBarWhenPushed = false
        })
    }
    
    func followUsListType(index: Int) {
//        let activityItems = ["Welcome to FFSport","logo_icon.png","http://www.baidu.com"]
//        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//        activityController.excludedActivityTypes = [.copyToPasteboard, .assignToContact]
//        present(activityController, animated: true, completion: nil)
        
        var str = ""
        switch(index) {
        case 10:
            print("telephone")
            //str = String(format:"tel:%@", "10086")
            str = "tel://10086"
            break
        case 11:
            print("email")
            str = "mailto://wenxi@a.com"
            break
        case 12:
            print("FACEBOOK")
            str = "fb://profile/135057709986569"
            break
        case 13:
            print("IG")
            str = "instagram://media?id=1346423547953773636_401375631"
            break
        case 14:
            print("x")
            str = "twitter://user?screen_name=MyTwitterID"
            break
        default:
            print("TELEGRAM")
            str = "telegram://"
            break
        }
        
        let url = URL(string: str)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    func showFollowUsList(type: Bool) {
        followUsType = type
        listCollectionView.reloadData()
    }
    
    func footballListOd(model: opModel) {
//        if Tool.getFBModel()?.token?.count ?? 0 == 0{
//            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
//            return
//        }
        
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
            if account.id != nil && balance < 600{
                self.view.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
            }else{
                if model.ss == 1{
                    var bmmodel = betMatchMarketListModel()
                    bmmodel.marketId = "\(model.mksId ?? 0)"
                    bmmodel.matchId = "\(model.recordsId ?? 0)"
                    bmmodel.oddsType = "1"
                    bmmodel.type = "\(model.ty ?? 0)"
                    
                    var param = BatchBetMatchMarketOfJumpLineParam()
                    param.languageType = "ENG"
                    param.currencyId = "20"
                    param.isSelectSeries = "false"
                    param.betMatchMarketList = [bmmodel]
                    self.loadOrderBatchBetMatchMarketOfJumpLine(param: param, model: model)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if listCollectionView == scrollView as? UICollectionView{
            let currentPoint = scrollView.panGestureRecognizer.location(in: listCollectionView)
            UIView.animate(withDuration: 0.5, animations: {
                if currentPoint.y > 500{
                    self.listHH.constant = 10
                    self.scrollBgview.alpha = 0
                    self.classBgview.alpha = 0
                }else{
                    if self.LiveCasino.isSelected == true || self.Esports.isSelected == true{
                        self.listHH.constant = 200
                    }else{
                        self.listHH.constant = 225
                    }
                    self.scrollBgview.alpha = 1
                    self.classBgview.alpha = 1
                }
            }, completion: { (finish) in
            })
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.Favourites.isSelected == true && collectionView == self.listCollectionView{
            if classArray[0].3 == "1" {
                if favouriteModels.count == 0{
                    return 2
                }else{
                    return self.favouriteModels.count
                }
            }else if classArray[1].3 == "1" {
                if leagueMatchModels.count == 0{
                   return 2
                }else{
                   return 1
                }
            }else if classArray[2].3 == "1" {
                if browseGameModels.count == 0{
                   return 2
                }else{
                   return 1
                }
            }
            return 1
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView{
            //return self.sportsModel?.list?.count ?? 0
            return typeArray.count
        }
        if collectionView == highlightCollectionView{
            return classArray.count
        }
        
        if matchPlayType == "10" && self.Virtual.isSelected == true{
            if virtualListModels.count == 0{
                return 0
            }
            return virtualListModels[virtualIndex].ls?.count ?? 0
        }
        
        if self.Favourites.isSelected == true{
            if classArray[0].3 == "1" {
                if favouriteModels.count == 0{
                    if section == 0{
                        return 1
                    }else{
                        return listModels.count
                    }
                }else{
                    let itemArr = self.favouriteModels[section]
                    return itemArr.count
                }
            }else if classArray[1].3 == "1" {
                if leagueMatchModels.count == 0{
                    if section == 0{
                        return 1
                    }else{
                        return listModels.count
                    }
                }else{
                    return leagueMatchModels.count
                }
            }else if classArray[2].3 == "1" {
                if browseGameModels.count == 0{
                    if section == 0{
                        return 1
                    }else{
                        return listModels.count
                    }
                }else{
                    return browseGameModels.count
                }
            }
            return listModels.count
        }
        if self.LiveCasino.isSelected == true || self.Esports.isSelected == true{
            return liveCasinoModels.count
        }
        return listModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCVCell", for: indexPath) as! ClassCVCell
            let dic = typeArray[indexPath.item]
            cell.titleLabel.text = dic.0
            cell.logoImage.sd_setImage(with: URL(string: dic.5 ), placeholderImage: UIImage.init(named: getTopSportsImg(Id: Int(dic.2) ?? 0)))
            if dic.3 == "0" {
                cell.titleLabel.textColor = UIColor.hexColor(hex: "929AA5")
            }else{
                cell.titleLabel.textColor = UIColor.hexColor(hex: "19263C")
            }
            return cell
        }
        
        if collectionView == highlightCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HLClassCell", for: indexPath) as! HLClassCell
            let dic = classArray[indexPath.item]
            cell.titleLabel.text = dic.0
            if dic.3 == "0" {
                cell.bgLabel.backgroundColor = UIColor.hexColor(hex: "F5F6F9")
                cell.titleLabel.textColor = .hexColor(hex: "19263C")
            }else{
                cell.bgLabel.backgroundColor = UIColor.hexColor(hex: "0CD664")
                cell.titleLabel.textColor = .white
            }
            if self.Favourites.isSelected == true{
                if dic.3 == "0"{
                    cell.logoimg.image = UIImage(named: dic.1)
                }else{
                    if UIImage(named: "\(dic.1)_select") != nil{
                        cell.logoimg.image =  UIImage(named: "\(dic.1)_select")
                    }else{
                        cell.logoimg.image = UIImage(named: dic.1)
                    }
                }
            }else{
                if self.matchPlayType == "10" && self.Virtual.isSelected == true{
                    if dic.3 == "0"{
                        cell.logoimg.image = UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0))?.withTintColor(.hexColor(hex: "19263C"))
                    }else{
                        cell.logoimg.image = UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0))?.withTintColor(.hexColor(hex: "FFFFFF"))
                    }
                }else{
                    if dic.3 == "0"{
                        cell.logoimg.sd_setImage(with: URL(string: dic.4), placeholderImage: UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0)))
                    }else{
                        cell.logoimg.sd_setImage(with: URL(string: dic.5), placeholderImage: UIImage(named: getClassSportsImg(Id: Int(dic.2) ?? 0)))
                    }
                }
            }
            return cell
        }
        
        //virtual
        if self.matchPlayType == "10" && self.Virtual.isSelected == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherSportViewCell", for: indexPath) as! OtherSportViewCell
            cell.mtLabel.isHidden = true
            cell.collectBtn.isHidden = true
            cell.rightBtn.isHidden = false
            let model = virtualListModels[virtualIndex].ls
            cell.titleLabel.text = model?[indexPath.item].na
            cell.logoimg.sd_setImage(with: URL(string: model?[indexPath.item].lurl ?? ""), placeholderImage: UIImage(named: "WorldCup"))
            return cell
        }
        
        if self.Favourites.isSelected == true && indexPath.section == 0{
            if (classArray[0].3 == "1" && favouriteModels.count == 0) || (classArray[1].3 == "1" && leagueMatchModels.count == 0 || (classArray[2].3 == "1" && browseGameModels.count == 0)) {
                let cell : FavouritesNoDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesNoDataCell", for: indexPath) as! FavouritesNoDataCell
                if classArray[2].3 == "1"{
                    cell.bgView.showEmptyView(image: "browseGameNodata", title: "You have’t viewed any games yet", subtitle: "but you’re Sure to find something you like in the app", btnStr: "")
                }else{
                    cell.bgView.showEmptyView(image: "yishoucang_icon", title: "Your list of favorite games is empty", subtitle: "No data of interest is currently accessible", btnStr: "")
                }
                return cell
            }
        }
        
        if self.Favourites.isSelected == true && leagueMatchModels.count != 0 && classArray[1].3 == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherSportViewCell", for: indexPath) as! OtherSportViewCell
            let model : CollectLeagueMatchItemModel = leagueMatchModels[indexPath.item]
            cell.rightBtn.isHidden = true
            cell.collectBtn.isHidden = false
            cell.leagueMatchItemModel = leagueMatchModels[indexPath.item]
            cell.titleLabel.text = model.name
            cell.logoimg.sd_setImage(with: URL(string: model.logoUrl ?? ""), placeholderImage: UIImage(named: "WorldCup"))
            cell.mtLabel.isHidden = true
            cell.cancelCollectLeagueMatchSuccessBlock = { model in
                self.cancelCollectLeagueMatchUI(model: model! as! CollectLeagueMatchItemModel)
            }
            return cell
        }
        
        if self.Favourites.isSelected == true && browseGameModels.count != 0 && classArray[2].3 == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseGameCell", for: indexPath) as! BrowseGameCell
            cell.model = browseGameModels[indexPath.item]
            return cell
        }
        
        if self.Esports.isSelected == true && liveCasinoModels.count != 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCasinoCell", for: indexPath) as! LiveCasinoCell
            cell.model = liveCasinoModels[indexPath.item]
            return cell
        }
        
        if self.LiveCasino.isSelected == true  && liveCasinoModels.count != 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCasinoGameCell", for: indexPath) as! LiveCasinoGameCell
            cell.modelNew = liveCasinoModels[indexPath.item]
            return cell
        }
        
        var model = recordModel()
        var modelOld = recordModel()
        if self.Favourites.isSelected == true && favouriteModels.count != 0 && classArray[0].3 == "1" {
            let itemArr = self.favouriteModels[indexPath.section]
            model = itemArr[indexPath.item]
            modelOld = itemArr[indexPath.item]
        }else{
            model = listModels[indexPath.item]
            if listModels.count == listModelsOld.count{
                modelOld = listModelsOld[indexPath.item]
            }
        }
        
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitViewCell", for: indexPath) as! PortraitViewCell
            if sportId == "3" && matchPlayType == "1"{
                cell.saidateil.isHidden = false
                if model.ms == 5{
                    var scoreStr = ""
                    var index = 0
                    if model.nsg?.count ?? 0 > 0{
                        for nsg in model.nsg ?? [nsgModel](){
                            if (nsg.pe == 3005 || nsg.pe == 3006 || nsg.pe == 3007 || nsg.pe == 3008) && nsg.tyg == 5{
                                if scoreStr.count > 0{
                                    scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }else{
                                    scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }
                                index += 1
                            }
                        }
                    }
                    if index == 0{
                        for nsg in model.nsg ?? [nsgModel](){
                            if (nsg.pe == 3003 || nsg.pe == 3004 || nsg.pe == 3009) && nsg.tyg == 5{
                                if scoreStr.count > 0{
                                    scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }else{
                                    scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                                }
                                index += 1
                            }
                        }
                    }
                    
                    if scoreStr.count > 0{
                        scoreStr = " (" + scoreStr + ")"
                    }
                    cell.saidateil.text = "including Overtime " + "\(index) Quarter, " + scoreStr
                }else{
                    cell.saidateil.text = "----"
                }
            }else{
                cell.saidateil.isHidden = true
            }
            
            cell.model = model
            cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            cell.titleLabel.text = model.lg?.na
            cell.numberLabel.text = "\(model.tms ?? 0)"
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            }
            
            if model.nsg?.count ?? 0 > 0{
                cell.leftScore.text = "\(model.nsg?[0].sc?[0] ?? 0)"
                cell.rightScore.text = "\(model.nsg?[0].sc?[1] ?? 0)"
            }else{
                cell.leftScore.text = "-"
                cell.rightScore.text = "-"
            }
            
            if model.ms == 5{
                cell.tipsImg.isHidden = false
                cell.timeLabel.isHidden = false
                cell.timeLabel.text = miaozhuanLanqiu(time: model.mc?.s ?? 0) + "  " + MatchPeriod(key: model.mc?.pe ?? 0)
                cell.dateLabel.isHidden = true
            }else{
                cell.tipsImg.isHidden = true
                cell.timeLabel.isHidden = true
                cell.dateLabel.isHidden = false
                cell.dateLabel.text = timeDate(time: "\((model.bt ?? 0)/1000)")
            }
            
            if model.vs?.m3u8SD != nil{
                cell.videoBtn.setImage(UIImage(named: "warn_icon-2"), for: .normal)
                cell.videoBtn.isHidden = false
            }else{
                if model.as?.count ?? 0 > 0{
                    cell.videoBtn.setImage(UIImage(named: "donghua_icon3"), for: .normal)
                    cell.videoBtn.isHidden = false
                }else{
                    cell.videoBtn.isHidden = true
                }
            }
            if indexPath.section == 0{
                cell.videoBtn.tag = 2000 + indexPath.row
            }else{
                cell.videoBtn.tag = 3000 + indexPath.row
            }
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            if listModels.count == listModelsOld.count{
                cell.loadUIold(mgModels: modelOld.mg ?? [mgModel]())
            }
            
            if indexPath.section == 0{
                cell.detailBtn.tag = 100 + indexPath.row
            }else{
                cell.detailBtn.tag = 200 + indexPath.row
            }
            cell.delegate = self
            
            cell.collectBlock = {[weak self] isCollect in
                if self!.Favourites.isSelected == true && self!.favouriteModels.count != 0 && self!.classArray[0].3 == "1" {
                    self!.favouriteModels[indexPath.section][indexPath.item].sctype = isCollect
                }else{
                    self!.listModels[indexPath.item].sctype = isCollect
                }
                self!.listCollectionView.reloadData()
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketballListCell", for: indexPath) as! BasketballListCell
            cell.model = model
            cell.logoImage.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
        
            cell.titleLabel.text = model.lg?.na
            if model.ts?.count ?? 0 > 0{
                cell.leftLabel.text = model.ts?[0].na ?? ""
                cell.rightLabel.text = model.ts?[1].na ?? ""
                cell.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
                cell.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            }
            
            if model.nsg?.count ?? 0 > 0{
                cell.VSLabel.text = "-"
                cell.leftScore.text = "\(model.nsg?[0].sc?[0] ?? 0)"
                cell.rightScore.text = "\(model.nsg?[0].sc?[1] ?? 0)"
                cell.VSLabel2.isHidden = true
            }else{
                cell.leftScore.text = ""
                cell.rightScore.text = ""
                cell.VSLabel.text = ""
                cell.VSLabel2.isHidden = false
            }
            
            if model.ms == 5{
                var scoreStr = ""
                var index = 0
                if model.nsg?.count ?? 0 > 0{
                    for nsg in model.nsg ?? [nsgModel](){
                        if (nsg.pe == 3005 || nsg.pe == 3006 || nsg.pe == 3007 || nsg.pe == 3008) && nsg.tyg == 5{
                            if scoreStr.count > 0{
                                scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }else{
                                scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }
                            index += 1
                        }
                    }
                }
                if index == 0{
                    for nsg in model.nsg ?? [nsgModel](){
                        if (nsg.pe == 3003 || nsg.pe == 3004 || nsg.pe == 3009) && nsg.tyg == 5{
                            if scoreStr.count > 0{
                                scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }else{
                                scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }
                            index += 1
                        }
                    }
                }
                if scoreStr.count > 0{
                    scoreStr = " (" + scoreStr + ")"
                }
                cell.overtime.isHidden = false
                cell.saitime.text = MatchPeriod(key: model.mc?.pe ?? 0) + "  " + miaozhuanLanqiu(time: model.mc?.s ?? 0) + scoreStr
                cell.saitimeTop.constant = 23
            }else{
                cell.overtime.isHidden = true
                cell.saitime.text = timeDate(time: "\((model.bt ?? 0)/1000)")
                cell.saitimeTop.constant = 17
            }
            
            if model.vs?.m3u8SD != nil{
                cell.videoBtn.setImage(UIImage(named: "warn_icon-2"), for: .normal)
                cell.videoBtn.isHidden = false
            }else{
                if model.as?.count ?? 0 > 0{
                    cell.videoBtn.setImage(UIImage(named: "donghua_icon3"), for: .normal)
                    cell.videoBtn.isHidden = false
                }else{
                    cell.videoBtn.isHidden = true
                }
            }
            
            if indexPath.section == 0{
                cell.videoBtn.tag = 2000 + indexPath.row
            }else{
                cell.videoBtn.tag = 3000 + indexPath.row
            }
            
            cell.gundongIndex = getgundongIndex(id: model.id ?? 0)
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            if listModels.count == listModelsOld.count{
                cell.loadUIold(mgModels: modelOld.mg ?? [mgModel]())
            }
            
            if indexPath.section == 0{
                cell.detailBtn.tag = 100 + indexPath.row
            }else{
                cell.detailBtn.tag = 200 + indexPath.row
            }
            
            cell.delegate = self
            cell.collectBlock = {[weak self] isCollect in
                if self!.Favourites.isSelected == true && self!.favouriteModels.count != 0 && self!.classArray[0].3 == "1" {
                    self!.favouriteModels[indexPath.section][indexPath.item].sctype = isCollect
                }else{
                    self!.listModels[indexPath.item].sctype = isCollect
                }
                self!.listCollectionView.reloadData()
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == classCollectionView{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == classCollectionView{
            return CGSize(width: 65, height: 60)
        }
        if collectionView == highlightCollectionView{
            let dic = classArray[indexPath.item]
            let labelW = Tool.getLabelWith(text: dic.0, font: UIFont.systemFont(ofSize: 10), labelH: 12)
            return CGSize(width: 35 + labelW, height: 20)
        }
        if self.Favourites.isSelected == true && self.leagueMatchModels.count != 0 && classArray[1].3 == "1" {
            return CGSize(width: kScreenW - 20, height: 65)
        }
        if self.Favourites.isSelected == true && self.browseGameModels.count != 0 && classArray[2].3 == "1" {
            return CGSize(width: kScreenW - 20, height: 100)
        }
        
        if matchPlayType == "10" && self.Virtual.isSelected == true{
            return CGSize(width: kScreenW - 20, height: 70)
        }
        if self.Esports.isSelected == true{//self.LiveCasino.isSelected == true || self.Esports.isSelected == true
            return CGSize(width: kScreenW - 20, height: 93)
        }
        if self.LiveCasino.isSelected == true{
            let W = (kScreenW - 30)/2
            return CGSize(width: W, height: W*450/345)
        }
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            if sportId == "3" && matchPlayType == "1"{
                return CGSize(width: kScreenW - 20, height: 162)//纵向
            }
            return CGSize(width: kScreenW - 20, height: 150)
        }else{
            return CGSize(width: kScreenW - 20, height: 190)//横向
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if collectionView == listCollectionView{
                if kind == UICollectionView.elementKindSectionFooter{
                    if self.Favourites.isSelected == true {
                        if classArray[0].3 == "1"{
                            if indexPath.section == 0{
                                let reusableview = UICollectionReusableView()
                                return reusableview
                            }
                        }else if classArray[1].3 == "1"{
                            if self.leagueMatchModels.count == 0{
                                if indexPath.section == 0{
                                    let reusableview = UICollectionReusableView()
                                    return reusableview
                                }
                            }
                        }else if classArray[2].3 == "1"{
                            if self.browseGameModels.count == 0{
                                if indexPath.section == 0{
                                    let reusableview = UICollectionReusableView()
                                    return reusableview
                                }
                            }
                        }
                    }
                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterLineReusableView", for: indexPath) as! FooterLineReusableView
                    reusableview.delegate = self
                    reusableview.line.isHidden = !followUsType
                    return reusableview
                    
                }else{
                    if self.Favourites.isSelected == true{
                        if classArray[0].3 == "1"{
                            if favouriteModels.count == 0{
                                if indexPath.section == 1{
                                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                    reusableview.clearBtn.isHidden = true
                                    reusableview.titleLB.text = "LIVE"
                                    return reusableview
                                }
                            }else{
                                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                reusableview.clearBtn.isHidden = false
                                reusableview.batchCancelCollectBlock = { [weak self] in
                                    if self?.favouriteModels[indexPath.section].count != 0{
                                        self?.requestBatchCancelCollect(index: indexPath.section)
                                    }
                                }
                                reusableview.titleLB.text = indexPath.section == 0 ? "Live events":"Results"
                                return reusableview
                            }
                        }else if classArray[1].3 == "1"{
                            if leagueMatchModels.count == 0{
                                if indexPath.section == 1{
                                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                    reusableview.clearBtn.isHidden = true
                                    reusableview.titleLB.text = "LIVE"
                                    return reusableview
                                }
                            }else{
                                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                reusableview.clearBtn.isHidden = false
                                reusableview.batchCancelCollectBlock = { [weak self] in
                                    self!.batchCancelCollectLeagueMatch()
                                }
                                reusableview.titleLB.text = "Championships"
                                return reusableview
                            }
                        }else if classArray[2].3 == "1"{
                            if browseGameModels.count == 0{
                                if indexPath.section == 1{
                                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                    reusableview.clearBtn.isHidden = true
                                    reusableview.titleLB.text = "LIVE"
                                    return reusableview
                                }
                            }else{
                                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SportsStatusHeaderView", for: indexPath) as! SportsStatusHeaderView
                                reusableview.clearBtn.isHidden = false
                                reusableview.batchCancelCollectBlock = { [weak self] in
                                    self?.batchClearBrowseGame()
                                }
                                reusableview.titleLB.text = "Already viewed"
                                return reusableview
                            }
                        }
                        
                        let reusableview = UICollectionReusableView()
                        return reusableview
                    }
                    
                }
            
        }
        let reusableview = UICollectionReusableView()
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == listCollectionView{
            if self.Favourites.isSelected == true{
                if classArray[0].3 == "1"{
                    
                    if (section == 1 && favouriteModels.count == 0) || favouriteModels.count != 0{
                        return CGSize(width: kScreenW, height: 40)
                    }
                    
                }else if classArray[1].3 == "1"{
                    if (section == 1 && leagueMatchModels.count == 0) || leagueMatchModels.count != 0{
                        return CGSize(width: kScreenW, height: 40)
                    }
                }else if classArray[2].3 == "1"{
                    if (section == 1 && browseGameModels.count == 0) || browseGameModels.count != 0{
                        return CGSize(width: kScreenW, height: 40)
                    }
                }
            }
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if collectionView == listCollectionView{
//            if self.Favourites.isSelected == true{
//                if classArray[0].3 == "1"{
//                    if section == 0{
//                        return CGSize(width: 0, height: 0)
//                    }else{
//                        if followUsType{
//                            return CGSize(width: kScreenW, height: 103)
//                        }
//                        return CGSize(width: kScreenW, height: 50)
//                    }
//                    
//                }else if classArray[1].3 == "1"{
//                    if self.leagueMatchModels.count == 0{
//                        if section == 0{
//                            return CGSize(width: 0, height: 0)
//                        }else{
//                            if followUsType{
//                                return CGSize(width: kScreenW, height: 103)
//                            }
//                            return CGSize(width: kScreenW, height: 50)
//                        }
//                    }else{
//                        if followUsType{
//                            return CGSize(width: kScreenW, height: 103)
//                        }
//                        return CGSize(width: kScreenW, height: 50)
//                    }
//                }else if classArray[2].3 == "1"{
//                    if self.browseGameModels.count == 0{
//                        if section == 0{
//                            return CGSize(width: 0, height: 0)
//                        }else{
//                            if followUsType{
//                                return CGSize(width: kScreenW, height: 103)
//                            }
//                            return CGSize(width: kScreenW, height: 50)
//                        }
//                    }else{
//                        if followUsType{
//                            return CGSize(width: kScreenW, height: 103)
//                        }
//                        return CGSize(width: kScreenW, height: 50)
//                    }
//                }
//                return CGSize(width: 0, height: 0)
//            }
//            if followUsType{
//                return CGSize(width: kScreenW, height: 103)
//            }
//            return CGSize(width: kScreenW, height: 50)
//        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView{
            for i in 0..<self.typeArray.count{
                self.typeArray[i].3 = "0"
            }
            self.typeArray[indexPath.item].3 = "1"
            self.classCollectionView.reloadData()
            if indexPath.row != 0 && indexPath.row != typeArray.count-1{
                let vc = ChampionshipsViewController()
                let dict = typeArray[indexPath.row]
                vc.sportDict = dict
                if dict.4{
                    vc.gameType = "virtual"
                }
                self.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else if indexPath.row == typeArray.count-1{
                let vc = SportTypeScreeningController()
                vc.saveSuccessBlock = { [weak self] in
                    self?.requestTopSport()
                }
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else{
//                curPage = 1
//                loadClassUI()
//                matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
                self.pushVC(vc: ALLViewController())
            }
        }
        if collectionView == highlightCollectionView{
            var index = 0
            for _ in classArray {
                classArray[index].3 = "0"
                index += 1
            }
            classArray[indexPath.row].3 = "1"
            highlightCollectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            
            if matchPlayType == "10" && self.Virtual.isSelected == true{
                virtualIndex = indexPath.row
                listCollectionView.reloadData()
            }else{
                if self.Favourites.isSelected == true{
                    if indexPath.row == 0{
                        let data  = UserDefaults.standard.value(forKey: CollectGameID)
                        var arr : Array<CollectGameItemModel> = []
                        if data != nil{
                            arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                        }
                        if arr.count == 0{
                            curPage = 1
                            self.matchPlayType = "1"
                            matchGetList(current: "\(curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
                        }else{
                            curPage = 1
                            self.matchPlayType = "0"
                            matchGetList(current: "\(curPage)", size:"\(50)", type: self.matchPlayType, sportId: self.sportId)
                        }
                    }else if indexPath.row == 1{
                        self.collectLeagueMatchUI()
                    }else if indexPath.row == 2{
                        self.getBrowseGameUI()
                    }
                }else{
                    
                    curPage = 1
                    self.sportId = classArray[indexPath.row].2
                    matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
                }
            }
        }
        
        if matchPlayType == "10" && collectionView == self.listCollectionView && self.Virtual.isSelected == true{
            let model = virtualListModels[virtualIndex].ls?[indexPath.item]
            let vc = ChampionshipsListController()
            vc.leagueTitle = "Virtual - " + (getVirtualSportsName(Id: virtualListModels[virtualIndex].sid ?? 0))//(model?.na ?? "")
            vc.leagueId = "\(model?.id ?? 0)"
            vc.gameType = "virtual"
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        
        if self.Favourites.isSelected == true && leagueMatchModels.count != 0 && classArray[1].3 == "1" && collectionView == self.listCollectionView{
            let model : CollectLeagueMatchItemModel = leagueMatchModels[indexPath.item]
            let vc = ChampionshipsListController()
            vc.leagueTitle = model.name ?? ""
            vc.leagueType = "0"
            vc.sportId = "看什么看,打爆眼睛"
            vc.leagueId = "\(model.lId ?? 0)"
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        
        if self.Favourites.isSelected == true && classArray[2].3 == "1" && browseGameModels.count != 0 && collectionView == self.listCollectionView{
            let vc = MatchDetailsViewController()
            let item = browseGameModels[indexPath.item]
            vc.titleStr = item.lName ?? ""
            vc.matchId = "\(item.mId ?? 0)"
            vc.beginTime = item.beginTime
            vc.isVirtual = false
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        if (self.LiveCasino.isSelected == true || self.Esports.isSelected == true) && collectionView == self.listCollectionView{
            let model = liveCasinoModels[indexPath.item]
            if model.subType == 2{
                let vc = LiveCasinoController()
                vc.model = model
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else{
                let vc = GameViewController()
                vc.gameId = "\(model.id ?? 0)"
                vc.gameCode = "01"
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
    
}

extension PopularViewController{
    @objc func loginRefresh(){
        self.requestTopSport()
        self.requestBannerActivity()
        if self.Favourites.isSelected == true{
            if classArray[0].3 == "1"{
                self.getCollectGame (completion: { colletSportArr in
                    if colletSportArr.count == 0{
                        self.curPage = 1
                        self.matchPlayType = "1"
                        self.matchGetList(current: "\(self.curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
                    }else{
                        self.curPage = 1
                        self.matchPlayType = "0"
                        self.matchGetList(current: "\(self.curPage)", size:"\(50)", type: self.matchPlayType, sportId: self.sportId)
                    }
                })
            }else if classArray[1].3 == "1"{
                self.collectLeagueMatchUI()
            }else {
                self.getBrowseGameUI()
            }
        }else if self.LiveCasino.isSelected == true || self.Esports.isSelected == true{
            self.listCollectionView.reloadData()
        }else{
            matchStatisticalRequest()
            curPage = 1
            matchGetList(current: "\(curPage)", size:"\(limitSize)", type: self.matchPlayType, sportId: self.sportId)
        }
    }
    @objc func logOutRefresh(){
        self.favouriteModels.removeAll()
        self.leagueMatchModels.removeAll()
        self.browseGameModels.removeAll()
        self.listCollectionView.reloadData()
        UserDefaults.standard.set(true, forKey: IsNeedGetCollect)
        UserDefaults.standard.set(nil, forKey: CollectGameID)
        UserDefaults.standard.synchronize()
        if self.Favourites.isSelected == true{
            curPage = 1
            self.matchPlayType = "1"
            matchGetList(current: "\(curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
        }
        self.requestTopSport()
        self.bannerArr.removeAll()
        self.bannerView.banner.reloadData()
        self.bannerView.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
    }
    @objc func requestTopSport(){
        UserDefaults.standard.set(true, forKey: IsNeedGetCollect)
        UserDefaults.standard.synchronize()
        self.showHUD(text: "Loading...")
        let api = Tool.getuserInfoModel() != nil ? wxApi.getLoginSports : wxApi.getUnLoginSports
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
//                var model : SportsModel = (result?.data)!
//                for i in 0...model.list!.count-1{
//                    let item : SportsItemModel = model.list![i]
//                    item.select = false
//                }
//                
//                let allModel = SportsItemModel()
//                allModel.id = 0
//                allModel.name = "All"
//                allModel.select = true
//                model.list?.insert(allModel, at: 0)
//                
//                if Tool.getuserInfoModel() != nil{
//                    let chooseModel = SportsItemModel()
//                    chooseModel.id = -1
//                    chooseModel.name = "Screen"
//                    chooseModel.select = false
//                    model.list?.append(chooseModel)
//                }
//                self.sportsModel = model
//                self.classCollectionView.reloadData()
                self.setTypeArray(model: result?.data ?? SportsModel())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    
    /// 点击Favourites 下的other  收藏联赛判断
    func collectLeagueMatchUI(){
        CollectRequest.getCollectLeagueMatch (completion: { colletLeagueMatchArr in
            self.leagueMatchModels = colletLeagueMatchArr
            if colletLeagueMatchArr.count == 0{
                self.curPage = 1
                self.matchPlayType = "1"
                self.matchGetList(current: "\(self.curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
            }else{
                self.matchPlayType = "0"
                self.loadUI(models: [])
                self.listCollectionView.reloadData()
            }
        })
    }
    ///单个联赛取消收藏
    func cancelCollectLeagueMatchUI(model : CollectLeagueMatchItemModel){
        var index = 0
        for i in 0..<leagueMatchModels.count{
            let item = leagueMatchModels[i]
            if item.id == model.id && item.lId == model.lId{
                index = i
            }
        }
        leagueMatchModels.remove(at: index)
        self.collectLeagueMatchUI()
    }
    
    ///批量联赛取消收藏
    func batchCancelCollectLeagueMatch(){
        self.showHUD(text: "Loading...")
        var param = CancelCollectParam()
        param.ids = []
        for i in 0..<leagueMatchModels.count{
            let item = leagueMatchModels[i]
            param.ids?.append(item.id ?? 0)
        }
        let api = wxApi.batchCancelCollectLeagueMatch(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.leagueMatchModels.removeAll()
                self.curPage = 1
                self.matchPlayType = "1"
                self.matchGetList(current: "\(self.curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    /// 点击Favourites 下的viewd  获取浏览的比赛判断
    func getBrowseGameUI(){
        BrowseRequest.getBrowseGameWithParam (completion: { browseGameArr in
            self.browseGameModels = browseGameArr
            if browseGameArr.count == 0{
                self.curPage = 1
                self.matchPlayType = "1"
                self.matchGetList(current: "\(self.curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
            }else{
                self.matchPlayType = "0"
                self.loadUI(models: [])
                self.listCollectionView.reloadData() 
            }
        })
    }
    
    ///批量清除浏览过的比赛
    func batchClearBrowseGame(){
        self.showHUD(text: "Loading...")
        var param = RecordBrowseParam()
        param.ids = []
        for i in 0..<browseGameModels.count{
            let item = browseGameModels[i]
            param.ids?.append(item.id ?? 0)
        }
        let api = wxApi.batchCancelBrowseGame(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                self.browseGameModels.removeAll()
                self.curPage = 1
                self.matchPlayType = "1"
                self.matchGetList(current: "\(self.curPage)", size:"\(20)", type: self.matchPlayType, sportId: self.sportId)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    //MARK: -获取所有sport
    func requestAllSport(type:Int){
        var param = BaseSystemParam()
        param.navType = type
        let api = wxApi.getAllSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                self.sportsModel = result?.data
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func requestBannerActivity(){
        var param = BaseSystemParam()
        param.current = 1
        param.pageSize = 15
        let api = wxApi.getUserPromotions(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            let result = RequestCallBackViewModel<PromotionsModel>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.list?.count ?? 0){
                    let model = result?.data?.list?[i]
                    self.bannerArr.append(model!)
                }
                self.bannerView.banner.reloadData()
                if self.bannerArr.count>0{
                    self.bannerView.freshBanner()
                    self.bannerView.hiddenEmptyView()
                }else{
                    self.bannerView.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
                }
            }else{
                self.bannerView.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
            self.bannerView.showEmptyView(image: "baseNodata", title: "NONE", subtitle: "No data available", btnStr: nil)
        }
    }
}

