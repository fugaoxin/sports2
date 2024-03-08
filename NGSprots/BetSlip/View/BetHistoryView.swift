//
//  BetHistoryView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/12.
//

import UIKit
import MJRefresh

protocol BetHistoryViewDelegate{
    func btshowHUD()
    func bthudHide()
    func btshowTextSB(msg: String)
}

class BetHistoryView: UIView {

    @IBOutlet weak var Unsettled: UIButton!
    @IBOutlet weak var Settled: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var wonMoney: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var typecollectionview: UICollectionView!
    @IBOutlet weak var tipsTopH: NSLayoutConstraint!
    @IBOutlet weak var clvTopH: NSLayoutConstraint!
    private var selectTimeView:SelectTimeView!
    var delegate:BetHistoryViewDelegate?
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BetHistoryView", owner: self, options: nil)?.first as! UIView
    }()
    
    private let bgview = UIView()
    private let miao = 86400
    private let miaomiao = 1000
    private var startTime = 0
    private var endTime = 0
    
    private var curPage = 1
    private var limitSize = 30
    private var isRequesting = false
    private var jsType = true
    private var oldHH:CGFloat = 0
    
    private var typeArray = [("Sports",true), ("Live casino",false), ("Slot machine",false)]
    //, ("Esports",false),("Simulate",false), ("League&Races",false), ("Virtual",false)
    
    private var scview: SelectionCategoryView!
    
    private var typeName = "Sports"

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        oldHH = frame.height
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "BetHistoryViewACell", bundle: nil), forCellWithReuseIdentifier: "BetHistoryViewACell")
        collectionview.register(UINib(nibName: "BetHistoryViewBCell", bundle: nil), forCellWithReuseIdentifier: "BetHistoryViewBCell")
        collectionview.register(UINib(nibName: "BetHistoryReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BetHistoryReusableView")
        collectionview.register(UINib(nibName: "BetHistoryFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BetHistoryFooterView")
        
        collectionview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(listviewHeaderRefresh))
        collectionview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(listviewFooterRefresh))
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        typecollectionview.setCollectionViewLayout(layout1, animated: true)
        typecollectionview.delegate = self
        typecollectionview.dataSource = self
        typecollectionview.alwaysBounceHorizontal = true
        typecollectionview.showsHorizontalScrollIndicator = false
        typecollectionview.register(UINib(nibName: "BetHistoryTypeCell", bundle: nil), forCellWithReuseIdentifier: "BetHistoryTypeCell")
        
        bgview.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        bgview.backgroundColor = .black
        bgview.alpha = 0.5
        bgview.isHidden = true
        UIApplication.shared.windows.last?.addSubview(bgview)
        bgview.isUserInteractionEnabled = true
        let bgvClick = UITapGestureRecognizer(target: self, action: #selector(clickBgView))
        bgview.addGestureRecognizer(bgvClick)
        
        selectTimeView = SelectTimeView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 680))//550
        selectTimeView.isHidden = true
        UIApplication.shared.windows.last?.addSubview(selectTimeView)
        selectTimeView.delegate = self
        
        (startTime,endTime) = selectDay(tag: 100)
        
        dateLabel.isHidden = true
        dateBtn.isHidden = true
        
        scview = SelectionCategoryView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 260))
        scview.typeArray = typeArray
        scview.isHidden = true
        UIApplication.shared.windows.last?.addSubview(scview)
        scview.xbtn = {
            self.scview.isHidden = true
            self.bgview.isHidden = true
        }
        
        scview.okbtn = { str in
            var index = 0
            var index2 = 0
            for dict in self.typeArray{
                if str == dict.0{
                    index2 = index
                }
                self.typeArray[index].1 = false
                index += 1
            }
            self.typeArray[index2].1 = true
            self.typecollectionview.reloadData()
            self.typecollectionview.scrollToItem(at: IndexPath(row: index2, section: 0), at: .centeredHorizontally, animated: true)
            self.typeName = self.typeArray[index2].0
            if self.typeArray[index2].0 == "Live casino" || self.typeArray[index2].0 == "Slot machine"{
                self.Unsettled.isHidden = true
                self.Settled.isHidden = true
                self.tipsTopH.constant = -20
                self.clvTopH.constant = 20
                self.dateLabel.isHidden = false
                self.dateBtn.isHidden = false
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: self.oldHH)
                self.curPage = 1
                self.dayTag = 100
                (self.startTime,self.endTime) = self.selectDay(tag: 100)
                self.orderListRequest(categoryId: self.typeArray[index2].0 == "Live casino" ? 3 : 4, current: self.curPage, startTime: self.startTime, endTime: self.endTime)
            }else{
                self.Unsettled.isHidden = false
                self.Settled.isHidden = false
                self.tipsTopH.constant = 10
                self.clvTopH.constant = 10
                
                if self.jsType{
                    self.dateLabel.isHidden = true
                    self.dateBtn.isHidden = true
                }else{
                    self.dateLabel.isHidden = false
                    self.dateBtn.isHidden = false
                }
                self.curPage = 1
                self.dayTag = 100
                (self.startTime,self.endTime) = self.selectDay(tag: 100)
                self.orderBetListRequest(isSettled: !self.jsType, startTime: "\(self.startTime)", endTime: "\(self.endTime)", current: "\(self.curPage)")
            }
        }
        
    }
    
    @objc func listviewHeaderRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        curPage = 1
        if typeName == "Sports"{
            orderBetListRequest(isSettled: !jsType, startTime: "\(startTime)", endTime: "\(endTime)", current: "\(curPage)")
        }else{
            orderListRequest(categoryId: typeName == "Live casino" ? 3 : 4, current: curPage, startTime: startTime, endTime: endTime)
        }
        
    }
    
    @objc func listviewFooterRefresh(){
        if isRequesting{
            return
        }
        isRequesting = true
        if typeName == "Sports"{
            orderBetListRequest(isSettled: !jsType, startTime: "\(startTime)", endTime: "\(endTime)", current: "\(curPage)")
        }else{
            orderListRequest(categoryId: typeName == "Live casino" ? 3 : 4, current: curPage, startTime: startTime, endTime: endTime)
        }
        
    }
    
    private var wjslistArrays = Array<obRecordModel>()
    private var yjslistArrays = Array<obRecordModel>()
    private func uplodaUI(models: orderBetListModel){
        var moneyStr = 0
        for record in models.records ?? [obRecordModel](){
            wjslistArrays.append(record)
            moneyStr = moneyStr + (Int(record.sat ?? "0") ?? 0)
        }
        tipsLabel.text = "Bets for period：" + "\(models.total ?? 0)" + " bets（₦ " + "\(moneyStr)" + "）"
        
        if wjslistArrays.count == 0{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 120)
        }else{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: oldHH)
        }
        collectionview.reloadData()
    }
    
    private func uplodaYjsUI(models: orderBetListModel){
        if models.current == 1{
            tipsLabel.text = "Total Bet：" + "₦ \(models.tamt ?? "")" + "      profit："
            let tsamt = models.tsamt ?? ""
            wonMoney.text =  "₦ " + tsamt
            if tsamt.contains("-"){
                wonMoney.textColor = .hexColor(hex: "FF3344")
            }else{
                wonMoney.textColor = .hexColor(hex: "0CD664")
            }
            dateLabel.text = getDayStatus(key: dayTag) + "（" + "\(models.total ?? 0)" + "）"
        }
        
        for record in models.records ?? [obRecordModel](){
            yjslistArrays.append(record)
        }
        
        if yjslistArrays.count == 0{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 120)
        }else{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: oldHH)
        }
        collectionview.reloadData()
    }
    
    @objc func clickBgView(){
        bgview.isHidden = true
        selectTimeView.isHidden = true
        self.scview.isHidden = true
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
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private var dayTag = 100
    @IBAction func selectdate(_ sender: UIButton) {
        bgview.isHidden = false
        selectTimeView.isHidden = false
        selectTimeView.setdaybg(tag: dayTag)
    }
    
    @IBAction func clickUnsettled(_ sender: UIButton) {
        Unsettled.backgroundColor = .hexColor(hex: "0CD664")
        Settled.backgroundColor = .white
        Unsettled.setTitleColor(.white, for: .normal)
        Settled.setTitleColor(.hexColor(hex: "101010"), for: .normal)
        dateLabel.isHidden = true
        dateBtn.isHidden = true
        wonMoney.isHidden = true
        
        jsType = true
        curPage = 1
        orderBetListRequest(isSettled: !jsType, startTime: "\(startTime)", endTime: "\(endTime)", current: "\(curPage)")
    }
    
    @IBAction func clickSettled(_ sender: UIButton) {
        Unsettled.backgroundColor = .white
        Settled.backgroundColor = .hexColor(hex: "#0CD664")
        Unsettled.setTitleColor(.hexColor(hex: "101010"), for: .normal)
        Settled.setTitleColor(.white, for: .normal)
        dateLabel.isHidden = false
        dateBtn.isHidden = false
        wonMoney.isHidden = false
        
        jsType = false
        curPage = 1
        orderBetListRequest(isSettled: !jsType, startTime: "\(startTime)", endTime: "\(endTime)", current: "\(curPage)")
    }
    
    private func timeDate(time: String) -> String{
        if time == ""{
            return ""
        }
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd-MM-yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }
    
    @IBAction func clickBetType(_ sender: UIButton) {
        self.scview.isHidden = false
        bgview.isHidden = false
        for dict in typeArray{
            if dict.1{
                self.scview.loadUI(title: dict.0)
                break
            }
        }
    }
    
    private var liveCasinoArr = Array<odlistModel>()
    private func loadLiveCasino(models: [odlistModel]){
        liveCasinoArr = models
        if liveCasinoArr.count == 0{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 120)
        }else{
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: oldHH)
        }
        collectionview.reloadData()
    }
    
}

extension BetHistoryView{
    private func orderBetListRequest(isSettled: Bool, startTime: String, endTime: String, current: String){
        delegate?.btshowHUD()
        var timeType = "1"
        if isSettled{
            timeType = "2"
        }
        var param = orderBetParam()
        param.languageType = "ENG"
        param.isSettled = isSettled
        param.current = current
        param.size = "\(limitSize)"
        param.timeType = timeType
        param.current = current
        param.startTime = startTime
        param.endTime = endTime
        let api = wxApi.orderBetList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.delegate?.bthudHide()
            if self.collectionview.mj_header != nil{
                self.collectionview.mj_header?.endRefreshing()
            }
            if self.collectionview.mj_footer != nil{
                self.collectionview.mj_footer?.endRefreshing()
            }
            self.isRequesting = false
            if self.curPage == 1 {
                self.wjslistArrays.removeAll()
                self.yjslistArrays.removeAll()
            }
            self.curPage += 1
            //print("orderBetList===\(data)")
            let result = RequestCallBackViewModel<orderBetListModel>.deserialize(from: data)
            if(result?.code == 0){
                guard let data = result?.data else{
                    self.collectionview.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }

                if data.total == 0{
                    if self.curPage == 2{
                        if isSettled{
                            self.wonMoney.isHidden = false
                            self.uplodaYjsUI(models: data)
                        }else{
                            self.wonMoney.isHidden = true
                            self.uplodaUI(models: data)
                        }
                    }
                    self.collectionview.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }
                
                if isSettled{
                    self.wonMoney.isHidden = false
                    self.uplodaYjsUI(models: data)
                }else{
                    self.wonMoney.isHidden = true
                    self.uplodaUI(models: data)
                }
                
            }else{
                self.wonMoney.isHidden = true
                self.collectionview.reloadData()
                self.delegate?.btshowTextSB(msg: result?.message ?? "")
                if self.jsType{
                    if self.wjslistArrays.count == 0{
                        self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 140)
                    }
                }else{
                    if self.yjslistArrays.count == 0{
                        self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 140)
                    }
                }
            }
        }) { (error) in
            self.delegate?.bthudHide()
            self.isRequesting = false
            if self.collectionview.mj_header != nil{
                self.collectionview.mj_header?.endRefreshing()
            }
            if self.collectionview.mj_footer != nil{
                self.collectionview.mj_footer?.endRefreshing()
            }
            self.delegate?.btshowTextSB(msg: error)
        }
    }
    
    private func orderListRequest(categoryId: Int, current: Int, startTime: Int, endTime: Int){
        delegate?.btshowHUD()
        var param = OrderListParam()
        param.current = current
        param.pageSize = limitSize
        param.orderBy = "desc"
        param.categoryId = categoryId
        param.startTime = startTime
        param.endTime = endTime
        let api = wxApi.orderList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.delegate?.bthudHide()
            if self.collectionview.mj_header != nil{
                self.collectionview.mj_header?.endRefreshing()
            }
            if self.collectionview.mj_footer != nil{
                self.collectionview.mj_footer?.endRefreshing()
            }
            self.isRequesting = false
            let result = RequestCallBackViewModel<orderListModel>.deserialize(from: data)
            if(result?.code == 0){
                guard let data = result?.data else{
                    self.collectionview.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }
                self.tipsLabel.text = "Bets for period：" + "\(data.total ?? 0)" + " bets（₦ " + "\(data.totalAmount ?? 0)" + "）"
                self.dateLabel.text = getDayStatus(key: self.dayTag) + "（" + "\(data.total ?? 0)" + "）"
                let tsamt = "\(data.totalProfit ?? 0)"
                self.wonMoney.text =  "₦ " + tsamt
                if tsamt.contains("-"){
                    self.wonMoney.textColor = .hexColor(hex: "FF3344")
                }else{
                    self.wonMoney.textColor = .hexColor(hex: "0CD664")
                }
                self.loadLiveCasino(models: data.orderList ?? [odlistModel]())
            }else{
                self.delegate?.btshowTextSB(msg: result?.message ?? "")
                if self.liveCasinoArr.count == 0{
                    self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 120)
                }
            }
        }) { (error) in
            self.delegate?.bthudHide()
            self.isRequesting = false
            if self.collectionview.mj_header != nil{
                self.collectionview.mj_header?.endRefreshing()
            }
            if self.collectionview.mj_footer != nil{
                self.collectionview.mj_footer?.endRefreshing()
            }
            self.delegate?.btshowTextSB(msg: error)
            if self.liveCasinoArr.count == 0{
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: 120)
            }
        }
    }
    
}

extension BetHistoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectTimeViewDelegate{
    func XBtn() {
        bgview.isHidden = true
        selectTimeView.isHidden = true
    }
    
    func okAndbok(index: Int, dayTag: Int, startTime: String, endTime: String) {
        bgview.isHidden = true
        selectTimeView.isHidden = true
        self.dayTag = dayTag
        dateLabel.text = getDayStatus(key: dayTag)
//        //print("time===\(selectDay(tag: dayTag))")
        if index == 51{
            if dayTag == 103{
                (self.startTime,self.endTime) = zdyTime(date: startTime, date2: endTime)
            }else{
                (self.startTime,self.endTime) = selectDay(tag: dayTag)
            }
            curPage = 1
            if typeName == "Sports"{
                orderBetListRequest(isSettled: !jsType, startTime: "\(self.startTime)", endTime: "\(self.endTime)", current: "\(curPage)")
            }else{
                orderListRequest(categoryId: typeName == "Live casino" ? 3 : 4, current: curPage, startTime: self.startTime, endTime: self.endTime)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == typecollectionview{
            return 1
        }else{
            if typeName == "Sports"{
                if jsType{
                    return wjslistArrays.count
                }else{
                    return yjslistArrays.count
                }
            }else{
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typecollectionview{
            return typeArray.count
        }else{
            if typeName == "Sports"{
                if jsType{
                    return wjslistArrays[section].ops?.count ?? 0
                }else{
                    return yjslistArrays[section].ops?.count ?? 0
                }
            }else{
                return liveCasinoArr.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == typecollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BetHistoryTypeCell", for: indexPath) as! BetHistoryTypeCell
            let dict = typeArray[indexPath.row]
            cell.titleLabel.text = dict.0
            cell.tipsLabel.isHidden = !dict.1
            if dict.1{
                cell.titleLabel.textColor = .hexColor(hex: "0CD664")
            }else{
                cell.titleLabel.textColor = .hexColor(hex: "989898")
            }
            return cell
        }else{
            if typeName == "Sports"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BetHistoryViewACell", for: indexPath) as! BetHistoryViewACell
                if jsType{
                    let model:obOpsModel = wjslistArrays[indexPath.section].ops?[indexPath.item] ?? obOpsModel()
                    cell.titlelabel.text = model.ln
                    cell.logoImg.image = UIImage(named: getSportImg(key: model.sid ?? 0))
                    if model.te?.count ?? 0 > 1{
                        cell.leftLabel.text = model.te?[0].na
                        cell.rightLabel.text = model.te?[1].na
                    }
                    cell.betMoney.text = "₦ " + (wjslistArrays[indexPath.section].sat ?? "")
                    cell.keyinMoney.text = "₦ " + (wjslistArrays[indexPath.section].mla ?? "")
                    cell.peilv.text = "@" + (model.od ?? "0")
                    if (model.mgn ?? "") == "1x2" || (model.mgn ?? "") == "Winner"{
                        cell.wflabel.text = (model.mgn ?? "") + " / " + getTYType(key: model.ty ?? 0)
                    }else{
                        cell.wflabel.text = (model.mgn ?? "") + " / " + (model.onm ?? "")
                    }
                    
                    if model.ms == 5{
                        if model.scs?.count ?? 0 > 1{
                            cell.leftscore.isHidden = false
                            cell.rightscore.isHidden = false
                            cell.vsLabel.isHidden = false
                            cell.vs2Label.isHidden = true
                            cell.leftscore.text = model.scs?[0]
                            cell.rightscore.text = model.scs?[1]
                        }else{
                            cell.leftscore.isHidden = true
                            cell.rightscore.isHidden = true
                            cell.vsLabel.isHidden = true
                            cell.vs2Label.isHidden = false
                        }
                    }else{
                        if model.rs?.count ?? 0 > 0{
                            let rss = model.rs?.components(separatedBy: "-")
                            cell.leftscore.isHidden = false
                            cell.rightscore.isHidden = false
                            cell.vsLabel.isHidden = false
                            cell.vs2Label.isHidden = true
                            cell.leftscore.text = rss?[0]
                            cell.rightscore.text = rss?[1]
                        }else{
                            cell.leftscore.isHidden = true
                            cell.rightscore.isHidden = true
                            cell.vsLabel.isHidden = true
                            cell.vs2Label.isHidden = false
                        }
                    }
            
                    if (wjslistArrays[indexPath.section].ops?.count ?? 0) > 1{
                        cell.line.isHidden = false
                        cell.betLabel.text = "Status: "
                        cell.betMoney.text = "Accepted"
                        cell.betMoney.textColor = .hexColor(hex: "349AFF")
                    }else{
                        cell.line.isHidden = true
                        cell.betLabel.text = "Bet: "
                        cell.betMoney.text = "₦ " + (wjslistArrays[indexPath.section].sat ?? "")
                        cell.betMoney.textColor = .hexColor(hex: "19263C")
                    }
                }else{
                    let model:obOpsModel = yjslistArrays[indexPath.section].ops?[indexPath.item] ?? obOpsModel()
                    cell.titlelabel.text = model.ln
                    cell.logoImg.image = UIImage(named: getSportImg(key: model.sid ?? 0))
                    cell.keyinMoney.text = "₦ " + (yjslistArrays[indexPath.section].mla ?? "")
                    cell.peilv.text = "@" + (model.od ?? "0")
                    if (model.mgn ?? "") == "1x2" || (model.mgn ?? "") == "Winner"{
                        cell.wflabel.text = (model.mgn ?? "") + " / " + getTYType(key: model.ty ?? 0)
                    }else{
                        cell.wflabel.text = (model.mgn ?? "") + " / " + (model.onm ?? "")
                    }
                    
                    if model.te?.count ?? 0 > 1{
                        cell.leftLabel.text = model.te?[0].na
                        cell.rightLabel.text = model.te?[1].na
                    }
                    
                    if model.scs?.count ?? 0 > 1{
                        cell.leftscore.isHidden = false
                        cell.rightscore.isHidden = false
                        cell.vsLabel.isHidden = false
                        cell.vs2Label.isHidden = true
                        cell.leftscore.text = model.scs?[0]
                        cell.rightscore.text = model.scs?[1]
                    }else{
                        if model.rs?.count ?? 0 > 0{
                            let rss = model.rs?.components(separatedBy: "-")
                            cell.leftscore.isHidden = false
                            cell.rightscore.isHidden = false
                            cell.vsLabel.isHidden = false
                            cell.vs2Label.isHidden = true
                            cell.leftscore.text = rss?[0]
                            cell.rightscore.text = rss?[1]
                        }else{
                            cell.leftscore.isHidden = true
                            cell.rightscore.isHidden = true
                            cell.vsLabel.isHidden = true
                            cell.vs2Label.isHidden = false
                        }
                    }
                    
                    if (yjslistArrays[indexPath.section].ops?.count ?? 0) > 1{
                        cell.line.isHidden = false
                        cell.betLabel.text = "Status: "
                        cell.betMoney.text = getOutcome(key: model.sr ?? 0)
                        cell.betMoney.textColor = .hexColor(hex: getOutcomeColor(key: model.sr ?? 0))
                    }else{
                        cell.line.isHidden = true
                        cell.betLabel.text = "Bet: "
                        cell.betMoney.text = "₦ " + (yjslistArrays[indexPath.section].sat ?? "")
                        cell.betMoney.textColor = .hexColor(hex: "19263C")
                    }
                }
                cell.sellfor.backgroundColor = .hexColor(hex: "F5F5F7")
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BetHistoryViewBCell", for: indexPath) as! BetHistoryViewBCell
                let dict = liveCasinoArr[indexPath.item]
                cell.datalabel.text = timeDate(time: "\((dict.oCreateTime ?? 0) / 1000)") + " · " + "\(dict.orderId ?? "0")"
                cell.titlelabel.text = dict.seriesType == 2 ? "Accumulator" : "Single"
                cell.gameName.text = dict.gameName
                cell.bMoney.text = "₦ " + (dict.amount ?? "0")
                cell.winMoney.text = "₦ " + (dict.settleAmount ?? "0")
                cell.typelabel.text = getOutcome(key: dict.result ?? 0)
                if dict.result == 4 || dict.result == 5{
                    cell.typelabel.textColor = .hexColor(hex: "0CD664")
                    cell.winMoney.textColor = .hexColor(hex: "0CD664")
                    cell.typeImg.isSelected = false
                }else{
                    cell.typelabel.textColor = .hexColor(hex: "FF3344")
                    cell.winMoney.textColor = .hexColor(hex: "FF3344")
                    cell.typeImg.isSelected = true
                }
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == typecollectionview{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            if typeName == "Sports"{
                if jsType{
                    if (wjslistArrays[section].ops?.count ?? 0) > 1{
                        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    }
                }else{
                    if (yjslistArrays[section].ops?.count ?? 0) > 1{
                        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    }
                }
                return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            }else{
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0{//单关
//            return CGSize(width: kScreenW - 20, height: 168)
//        }
//        if indexPath.section == 2{//串关
//            return CGSize(width: kScreenW - 20, height: 150)
//        }
//        return CGSize(width: kScreenW - 20, height: 220)//183//可提前结算
        
        if collectionView == typecollectionview{
            if indexPath.item == 0{
                return CGSize(width: 96, height: 40)
            }
            return CGSize(width: 120, height: 40)
        }else{
            if typeName == "Sports"{
                if jsType{
                    if (wjslistArrays[indexPath.section].ops?.count ?? 0) > 1{
                        return CGSize(width: kScreenW - 20, height: 145)
                    }
                }else{
                    if (yjslistArrays[indexPath.section].ops?.count ?? 0) > 1{
                        return CGSize(width: kScreenW - 20, height: 145)
                    }
                }
                return CGSize(width: kScreenW - 20, height: 183)
            }else{
                //游戏
                return CGSize(width: kScreenW - 20, height: 170)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if collectionView == typecollectionview{
            return UICollectionReusableView()
        }else{
            if typeName == "Sports"{
                if kind == UICollectionView.elementKindSectionHeader{
                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BetHistoryReusableView", for: indexPath) as! BetHistoryReusableView
                    reusableview.layer.cornerRadius = 10
                    reusableview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    if jsType{
                        reusableview.logoImg.setImage(UIImage(named: "组 124424R"), for: .normal)
                        let model:obRecordModel = wjslistArrays[indexPath.section]
                        reusableview.datelabel.text = timeDate(time: "\((model.cte ?? 0) / 1000)") + " · " + "\(model.id ?? "0")"
                        reusableview.statuslabel.text = getOrderStatus(key: model.st ?? 0)
                        reusableview.statuslabel.textColor = .hexColor(hex: "349AFF")
                        if (model.ops?.count ?? 0) > 1{
                            reusableview.typelabel.text = "Accumulator"
                            reusableview.cimg.isHidden = false
                            reusableview.cnum.isHidden = false
                            reusableview.cnum.text = "\(model.ops?.count ?? 0)"
                        }else{
                            reusableview.typelabel.text = "Single"
                            reusableview.cimg.isHidden = true
                            reusableview.cnum.isHidden = true
                        }
                    }else{
                        let model:obRecordModel = yjslistArrays[indexPath.section]
                        reusableview.datelabel.text = timeDate(time: "\((model.cte ?? 0) / 1000)") + " · " + "\(model.id ?? "0")"
                        if model.uwl == "0"{//拒单
                            reusableview.statuslabel.text = model.rjs
                        }else{
                            reusableview.statuslabel.text = getUWL(key: model.uwl ?? "")
                        }
                        reusableview.logoImg.setImage(UIImage(named: getUWLLogo(key: model.uwl ?? "")), for: .normal)
                        reusableview.statuslabel.textColor = .hexColor(hex: getUWLColor(key: model.uwl ?? ""))
                        
                        if (model.ops?.count ?? 0) > 1{
                            reusableview.typelabel.text = "Accumulator"
                            reusableview.cimg.isHidden = false
                            reusableview.cnum.isHidden = false
                            reusableview.cnum.text = "\(model.ops?.count ?? 0)"
                        }else{
                            reusableview.typelabel.text = "Single"
                            reusableview.cimg.isHidden = true
                            reusableview.cnum.isHidden = true
                        }
                    }
                    return reusableview
                }else{
                    let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BetHistoryFooterView", for: indexPath) as! BetHistoryFooterView
                    
                    let model:obRecordModel = jsType ? wjslistArrays[indexPath.section]:yjslistArrays[indexPath.section]
                    if model.ops?.count ?? 0 > 1{
                        var betnum: Float = 1
                        var mcnum = 0
                        for item in model.ops ?? [obOpsModel](){
                            let od = Float(item.od ?? "0")
                            betnum = betnum * (od ?? 0)
                            if item.mc != nil{
                                mcnum += 1
                            }
                        }
                        reusableview.events.text = "\((model.ops?.count ?? 0) - mcnum) " + "of" + " \(model.ops?.count ?? 0) " + "completed"
                        reusableview.odds.text = "@\(betnum)"
                        reusableview.bet.text = "₦ " + (model.sat ?? "")
                        reusableview.potential.text = "₦ " + (model.mla ?? "")
                    }
                    return reusableview
                }
            }else{
                return UICollectionReusableView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == typecollectionview{
            return CGSize(width: 0, height: 0)
        }
        if typeName == "Sports"{
            return CGSize(width: kScreenW - 20, height: 60)
        }else{
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == typecollectionview{
            return CGSize(width: 0, height: 0)
        }else{
            if typeName == "Sports"{
                if jsType{
                    if (wjslistArrays[section].ops?.count ?? 0) > 1{
                        return CGSize(width: kScreenW, height: 120)
                    }
                }else{
                    if (yjslistArrays[section].ops?.count ?? 0) > 1{
                        return CGSize(width: kScreenW, height: 120)
                    }
                }
                return CGSize(width: 0, height: 0)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typecollectionview{
            var index = 0
            for _ in typeArray {
                typeArray[index].1 = false
                index += 1
            }
            typeArray[indexPath.row].1 = true
            typeName = typeArray[indexPath.row].0
            typecollectionview.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionview.reloadData()
            
            if typeArray[indexPath.row].0 == "Live casino" || typeArray[indexPath.row].0 == "Slot machine"{
                Unsettled.isHidden = true
                Settled.isHidden = true
                tipsTopH.constant = -20
                clvTopH.constant = 20
                dateLabel.isHidden = false
                dateBtn.isHidden = false
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kScreenW, height: oldHH)
                curPage = 1
                dayTag = 100
                (startTime,endTime) = selectDay(tag: 100)
                orderListRequest(categoryId: typeArray[indexPath.row].0 == "Live casino" ? 3 : 4, current: curPage, startTime: startTime, endTime: endTime)
            }else{
                Unsettled.isHidden = false
                Settled.isHidden = false
                tipsTopH.constant = 10
                clvTopH.constant = 10
                
                if jsType{
                    dateLabel.isHidden = true
                    dateBtn.isHidden = true
                }else{
                    dateLabel.isHidden = false
                    dateBtn.isHidden = false
                }
                curPage = 1
                dayTag = 100
                (startTime,endTime) = selectDay(tag: 100)
                orderBetListRequest(isSettled: !jsType, startTime: "\(startTime)", endTime: "\(endTime)", current: "\(curPage)")
            }
            
        }
        
    }
}
