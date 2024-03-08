//
//  MatchDetailsViewController.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/1.
//

import UIKit
import WebKit
import AVKit
class MatchDetailsViewController: BaseViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leftLogo: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLogo: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var saitime: UILabel!
    @IBOutlet weak var saiDate: UILabel!
    @IBOutlet weak var saiGroup: UILabel!
    
    @IBOutlet weak var animalBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var shoucang: UIButton!
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    @IBOutlet weak var heardHH: NSLayoutConstraint!
    @IBOutlet weak var listviewHH: NSLayoutConstraint!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var amBgImageView: UIImageView!
    
    @IBOutlet weak var animationBgview: UIView!
    @IBOutlet weak var amwebview: WKWebView!
    @IBOutlet weak var videobgview: UIView!
    
    @IBOutlet weak var startin: UILabel!
    private var classHH0:CGFloat = 310
    private var heardHH0:CGFloat = 260
    
    @IBOutlet weak var virturaBgview: UIView!
    @IBOutlet weak var fenLabel: UILabel!
    @IBOutlet weak var miaoLabel: UILabel!
    @IBOutlet weak var livelabel: UILabel!
    @IBOutlet weak var liveimg: UIImageView!
    
    private var classArray = [("Regular time","all","1"), ("Popular","p","0"), ("1Half","h","0"), ("2Half","h","0"),("Corner","c","0"),("Special","i","0")]
    var matchId = "0"
    var titleStr = "AFC Champions league"
    //是否收藏
    var isCollect : Bool?
    //是否为虚拟体育详情
    var isVirtual : Bool?
    //比赛开始时间
    var beginTime : Int?
    
    private var RModel = recordModel()
    private var oldRModel = recordModel()
    private var lastRModel = recordModel()
    private var loadType = 0
    private var classIndex = 0
    private var shuaixuanBg = UILabel()
    private var shuaixuanView:DetailShuaixuanView!
    
    private var orderTimers:Timer?
    private var opodTimers:Timer?
    private var insertTimers:Timer?
    
    private var fristAnimal = true
    
    //是否已经记录浏览过
    private var isAlreadyRecord = false
    
    //是否已经获取置顶
    private var isAlreadyGetTop = false
    private var topGamePlayArr : [String]?
    
    //展开收起
    private var zanArr = Array<String>()
    
    var gameType = "FF"
    
    private var virtualVideoUrl = ""
    
    private var huadong = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    private func setUI(){
        self.shoucang.isHidden = self.isVirtual ?? true
    
        videoBtn.layer.borderWidth = 0.5
        animalBtn.layer.borderColor = UIColor.white.cgColor
        animalBtn.layer.borderWidth = 0.5
        titleLabel.text = titleStr
        setCollectionView()
        
        amwebview.backgroundColor = .clear
        amwebview.scrollView.contentInsetAdjustmentBehavior = .never
        amwebview.isOpaque = false
        amwebview.scrollView.bounces = false
        //amwebview.customUserAgent = "iphone"
        self.checkCollectStatus()
        
        saiGroup.isHidden = true
        
        setLeftBgview()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditingNotification(_:)), name: UITextField.textDidEndEditingNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ showNoti:Notification){
        let frame = (showNoti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(frame.origin.y)
        print(frame.height)
        UIView.animate(withDuration: 0.25) {
            self.shuaixuanView.frame = CGRect(x: 0, y: kScreenH - (frame.height + 290), width: kScreenW, height: 300)
        }
    }
    
    @objc func textDidEndEditingNotification(_ endEdit:Notification){
        UIView.animate(withDuration: 0.25) {
            self.shuaixuanView.frame = CGRect(x: 0, y: kScreenH - 500, width: kScreenW, height: 500)
        }
    }
    
    private func setCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        classCollectionView.setCollectionViewLayout(layout, animated: true)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.alwaysBounceHorizontal = true
        classCollectionView.showsHorizontalScrollIndicator = false
        classCollectionView.register(UINib(nibName: "ClassCell", bundle: nil), forCellWithReuseIdentifier: "ClassCell")
        classCollectionView.register(UINib(nibName: "DetailClassReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailClassReusableView")
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        listCollectionView.setCollectionViewLayout(layout2, animated: true)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.alwaysBounceVertical = true
        listCollectionView.showsVerticalScrollIndicator = false
        listCollectionView.register(UINib(nibName: "DetailsListCVACell", bundle: nil), forCellWithReuseIdentifier: "DetailsListCVACell")
        listCollectionView.register(UINib(nibName: "DetailsListCVBCell", bundle: nil), forCellWithReuseIdentifier: "DetailsListCVBCell")
        listCollectionView.register(UINib(nibName: "DetailsListReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailsListReusableView")
        
        shuaixuanBg.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        view.addSubview(shuaixuanBg)
        shuaixuanBg.backgroundColor = .black
        shuaixuanBg.alpha = 0.5
        shuaixuanBg.isUserInteractionEnabled = true
        let sxBgtap = UITapGestureRecognizer(target: self, action: #selector(hiddenShuaixuanBgView))
        shuaixuanBg.addGestureRecognizer(sxBgtap)
        shuaixuanView = DetailShuaixuanView.init(frame: CGRect(x: 0, y: kScreenH - 500, width: kScreenW, height: 500))
        UIApplication.shared.windows.last?.addSubview(shuaixuanView)
        shuaixuanView.delegate = self
        shuaixuanBg.isHidden = true
        shuaixuanView.isHidden = true
        
        view.setBet()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTime), name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
    }
    
    @objc func invalidateTime(){
        orderTimers?.invalidate()
        opodTimers?.invalidate()
    }
    
    func checkCollectStatus(){
        if Tool.getuserInfoModel() != nil{
            let data  = UserDefaults.standard.value(forKey: CollectGameID)
            var arr : Array<CollectGameItemModel> = []
            if data != nil{
                arr = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
            }
            self.isCollect = false
            for i in 0..<arr.count{
                let item = arr[i]
                if "\(item.mId ?? 0)" == self.matchId{
                    self.isCollect = true
                }
            }
            self.shoucang.isSelected = self.isCollect!
        }else{
            self.shoucang.isSelected = false
        }
    }
    
    private func loadpeilv(){
        self.insertTimers?.invalidate()
        var miao = 3
        if gameType == "virtual"{
            miao = 1
        }
        self.insertTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(miao), repeats: true, block: { (timer) in
            //print("刷新...")
            self.loadData()
        })
    }
    
    @objc func hiddenShuaixuanBgView(){
        shuaixuanView.sousuo.text = ""
        shuaixuanView.searchType = false
        shuaixuanBg.isHidden = true
        shuaixuanView.isHidden = true
        shuaixuanView.sousuo.resignFirstResponder()
    }

    private func loadData(){
        matchGetMatchDetail(matchId: matchId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.insertTimers?.invalidate()
        self.orderTimers?.invalidate()
        self.opodTimers?.invalidate()
        removeShouqiArray()
        self.navigationController?.isNavigationBarHidden = false
        
        slbgview.isHidden = true
        xuanzhuanbtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setTipsDelegate(vc: self)
        loadpeilv()
        self.navigationController?.isNavigationBarHidden = true
        
        if animType || videoType{
            slbgview.isHidden = false
            xuanzhuanbtn.isHidden = false
        }else{
            if kStatusBarH < 50{
                heardHH0 = 245
                classHH0 = 295
                heardHH.constant = heardHH0
                listviewHH.constant = classHH0
            }else{
                heardHH0 = 260
                classHH0 = 310
                heardHH.constant = heardHH0
                listviewHH.constant = classHH0
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        if animType || videoType{
            playerViewController.player?.pause()
            playerViewController.removeFromParent()
            animType = false
            videoType = false
            slbgview.isHidden = true
            xuanzhuanbtn.isHidden = true
            backBtn.setImage(UIImage(named: "back_white"), for: .normal)
            animationBgview.isHidden = true
            videobgview.isHidden = true
            heardHH.constant = heardHH0
            listviewHH.constant = classHH0
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private var playerViewController = AVPlayerViewController()
    private func setVideo(url: String){
        guard let playUrl = URL(string: url) else {
            return
        }
        let player = AVPlayer(url: playUrl)
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: videobgview.frame.height)
        self.addChild(playerViewController)
        videobgview.insertSubview(playerViewController.view, at: 888)
        playerViewController.player?.play()
    }
    
    private var slbgview:UIView!
    private var animatiombtn:UIButton!
    private var videobtn2:UIButton!
    private var xuanzhuanbtn:UIButton!
    private func setLeftBgview(){
        slbgview = UIView(frame: CGRect(x: 10, y: heardHH.constant - 40, width: 72, height: 30))
        slbgview.backgroundColor = .black
        slbgview.alpha = 0.6
        slbgview.layer.cornerRadius = 15
        slbgview.layer.masksToBounds = true
        UIApplication.shared.windows.last?.addSubview(slbgview)
        slbgview.isHidden = true
        
        animatiombtn = UIButton(frame: CGRect(x: 10, y: 4, width: 22, height: 22))
        animatiombtn.setImage(UIImage(named: "donghua_icon"), for: .normal)
        slbgview.addSubview(animatiombtn)
        animatiombtn.addTarget(self, action: #selector(animatiombtnTag(sender:)), for: .touchUpInside)
        
        videobtn2 = UIButton(frame: CGRect(x: 40, y: 4, width: 22, height: 22))
        videobtn2.setImage(UIImage(named: "zhibo_icon2"), for: .normal)
        slbgview.addSubview(videobtn2)
        videobtn2.addTarget(self, action: #selector(videobtnTag(sender:)), for: .touchUpInside)
        
        xuanzhuanbtn = UIButton(frame: CGRect(x: kScreenW - 45, y: heardHH.constant - 40, width: 30, height: 30))
        xuanzhuanbtn.layer.cornerRadius = 7
        xuanzhuanbtn.layer.masksToBounds = true
        xuanzhuanbtn.setImage(UIImage(named: "xuanzhuan"), for: .normal)
        UIApplication.shared.windows.last?.addSubview(xuanzhuanbtn)
        xuanzhuanbtn.addTarget(self, action: #selector(clickvideoquan), for: .touchUpInside)
        xuanzhuanbtn.isHidden = true
    }
    
    @objc func videobtnTag(sender:UIButton){
        playerViewController.player?.pause()
        playerViewController.removeFromParent()
        animationBgview.isHidden = true
        videobgview.isHidden = false
        heardHH.constant = kScreenW*3/4 + 10
        listviewHH.constant = classHH0 + (kScreenW*3/4 - 250) + (260 - heardHH0)
        videoType = true
        backBtn.setImage(UIImage(named: "guanbi_icon"), for: .normal)
        setVideo(url: videoUrl + "&language=en")
        
        slbgview.isHidden = false
        xuanzhuanbtn.isHidden = false
        slbgview.frame = CGRect(x: 10, y: heardHH.constant - 40, width: 72, height: 30)
        xuanzhuanbtn.frame = CGRect(x: kScreenW - 45, y: heardHH.constant - 40, width: 30, height: 30)
        
        videobtn2.isEnabled = false
        if RModel.as?.count ?? 0 > 0{
            animatiombtn.isEnabled = true
        }else{
            animatiombtn.isEnabled = false
        }
    }
    
    @objc func animatiombtnTag(sender:UIButton){
        playerViewController.player?.pause()
        playerViewController.removeFromParent()
        videoType = false
        heardHH.constant = heardHH0 + (kScreenW*3/4 - 228)
        listviewHH.constant = classHH0 + (kScreenW*3/4 - 228)
        videobgview.isHidden = true
        animationBgview.isHidden = false
        animType = true
        backBtn.setImage(UIImage(named: "guanbi_icon"), for: .normal)
        
        slbgview.isHidden = false
        xuanzhuanbtn.isHidden = true
        slbgview.frame = CGRect(x: 10, y: heardHH.constant - 40, width: 72, height: 30)
        
        animatiombtn.isEnabled = false
        if RModel.vs?.m3u8SD != nil {
            videobtn2.isEnabled = true
        }else{
            videobtn2.isEnabled = false
        }
    }
    
    @objc func clickvideoquan(){
        playerViewController.view.frame = CGRect(x: -videobgview.frame.height - 12, y: videobgview.frame.height + 11.5, width: kScreenH + 30, height: kScreenW + 30)
        playerViewController.view.transform = CGAffineTransformMakeRotation(CGFloat.pi / 2)
        UIApplication.shared.windows.last?.addSubview(playerViewController.view)
        
        playerViewController.view.isUserInteractionEnabled = true
        let playerViewtap = UITapGestureRecognizer(target: self, action: #selector(clickPlayerView))
        playerViewController.view.addGestureRecognizer(playerViewtap)
        
        huibgView = UIView(frame: CGRect(x: kScreenW - 60, y: 0, width: 60, height: kScreenH))
        UIApplication.shared.windows.last?.addSubview(huibgView)
        huibgView.backgroundColor = .black
        huibgView.alpha = 0.5
        
        let img = UIImageView(frame: CGRect(x: 19, y: kScreenH/2 - 50 , width: 22, height: 22))
        huibgView.addSubview(img)
        img.sd_setImage(with: URL(string: RModel.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: RModel.sid ?? 0)))
        
        huiBtn = UIButton(frame: CGRect(x: kScreenW - 38, y: 80, width: 22, height: 22))
        UIApplication.shared.windows.last?.addSubview(huiBtn)
        huiBtn.setImage(UIImage(named: "guanbi_icon"), for: .normal)
        huiBtn.addTarget(self, action: #selector(clickvideoguanbi), for: .touchUpInside)
        
        shoucangBtn = UIButton(frame: CGRect(x: kScreenW - 38, y: kScreenH - 90, width: 22, height: 22))
        UIApplication.shared.windows.last?.addSubview(shoucangBtn)
        shoucangBtn.setImage(UIImage(named: "shoucan_icon6"), for: .normal)
        shoucangBtn.setImage(UIImage(named: "alreadyCollect"), for: .selected)
        shoucangBtn.addTarget(self, action: #selector(shoucang2(sender:)), for: .touchUpInside)
        shoucangBtn.isSelected = shoucang.isSelected
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            self.huibgView.isHidden = true
            self.huiBtn.isHidden = true
            self.shoucangBtn.isHidden = true
        }
        
        let titleLabel = UILabel(frame: CGRect(x: -100, y: kScreenH/2 + 100, width: 260, height: 20))
        titleLabel.text = titleStr
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        huibgView.addSubview(titleLabel)
        titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }

    @objc func clickPlayerView(){
        self.huibgView.isHidden = false
        self.huiBtn.isHidden = false
        self.shoucangBtn.isHidden = false
        if self.huibgView != nil{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
                self.huibgView.isHidden = true
                self.huiBtn.isHidden = true
                self.shoucangBtn.isHidden = true
            }
        }
    }
    
    @objc func shoucang2(sender: UIButton) {
        shoucang(sender)
    }
    private var huibgView:UIView!
    private var huiBtn:UIButton!
    private var shoucangBtn:UIButton!
    @objc func clickvideoguanbi(){
        huibgView.removeFromSuperview()
        huiBtn.removeFromSuperview()
        shoucangBtn.removeFromSuperview()
        playerViewController.view.transform = CGAffineTransformIdentity
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: videobgview.frame.height)
        //videobgview.addSubview(playerViewController.view)
        videobgview.insertSubview(playerViewController.view, at: 0)
    }
    
    private var videoType = false
    @IBAction func clickVideoBtn(_ sender: UIButton) {
        videobgview.isHidden = false
        heardHH.constant = kScreenW*3/4 + 10
        listviewHH.constant = classHH0 + (kScreenW*3/4 - 250) + (260 - heardHH0)
        videoType = true
        backBtn.setImage(UIImage(named: "guanbi_icon"), for: .normal)
        setVideo(url: videoUrl + "&language=en")
        
        slbgview.isHidden = false
        xuanzhuanbtn.isHidden = false
        slbgview.frame = CGRect(x: 10, y: heardHH.constant - 40, width: 72, height: 30)
        xuanzhuanbtn.frame = CGRect(x: kScreenW - 45, y: heardHH.constant - 40, width: 30, height: 30)
        
        videobtn2.isEnabled = false
        if RModel.as?.count ?? 0 > 0{
            animatiombtn.isEnabled = true
        }else{
            animatiombtn.isEnabled = false
        }
    }
    
    private var animType = false
    @IBAction func clickanimlBtn(_ sender: UIButton) {
        heardHH.constant = heardHH0 + (kScreenW*3/4 - 228)
        listviewHH.constant = classHH0 + (kScreenW*3/4 - 228)
        animationBgview.isHidden = false
        animType = true
        backBtn.setImage(UIImage(named: "guanbi_icon"), for: .normal)
        
        slbgview.isHidden = false
        xuanzhuanbtn.isHidden = true
        slbgview.frame = CGRect(x: 10, y: heardHH.constant - 40, width: 72, height: 30)
        
        animatiombtn.isEnabled = false
        if RModel.vs?.m3u8SD != nil {
            videobtn2.isEnabled = true
        }else{
            videobtn2.isEnabled = false
        }
    }
    
    @IBAction func shoucang(_ sender: UIButton) {
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        UserDefaults.standard.set(true, forKey: IsNeedGetCollect)
        UserDefaults.standard.synchronize()
        if self.isCollect == true{
            var param = CancelCollectParam()
            param.mId = Int(self.matchId)
            CollectRequest.cancelCollectWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                self.shoucang.isSelected = sender.isSelected
            }
        }else{
            var param = CollectParam()
            param.mId = Int(self.matchId)
            param.beginTime = self.beginTime
            param.IsVirtual = self.isVirtual ?? false
            CollectRequest.collectWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                self.shoucang.isSelected = sender.isSelected
            }
        }
        
    }
    
    @IBAction func videoHWBtn(_ sender: UIButton) {
    }
    
    
    //展开
    func getShouqiArray() -> [String]{
        let arr = UserDefaults.standard.value(forKey: "Shouqi") as? [String] ?? []
        return arr
    }
    
    func setShouqiArray(arrs:[String]){
        UserDefaults.standard.set(arrs, forKey: "Shouqi")
        UserDefaults.standard.synchronize()
    }
    
    func removeShouqiArray(){
        UserDefaults.standard.removeObject(forKey: "Shouqi")
    }

    private var classArr1 = ["Correct Score","Penalty Shootout","Promotion Team","Champion Team","Third Place Team"]
    private var videoUrl = ""
    private var marketTagArray = Array<String>()
    private func loadUI(model: recordModel){
        
        if fristAnimal{
            fristAnimal = false
            if model.as?.count ?? 0 > 0{
                animalBtn.isEnabled = true
                amwebview.load(NSURLRequest(url: NSURL(string: (model.as?[0] ?? "") + "&language=en&tabs=disable")! as URL) as URLRequest)
                animalBtn.setTitleColor(UIColor.white, for: .normal)
                animalBtn.layer.borderColor = UIColor.white.cgColor
            }else{
                animalBtn.setTitleColor(UIColor.hexColor(hex: "989898"), for: .normal)
                animalBtn.layer.borderColor = UIColor.hexColor(hex: "989898").cgColor
                animalBtn.isEnabled = false
            }
        }
        
        if videoUrl.count == 0{
            videoUrl = model.vs?.m3u8SD ?? ""
            if model.vs?.m3u8SD != nil {
                videoBtn.isEnabled = true
                videoBtn.setTitleColor(UIColor.white, for: .normal)
                videoBtn.layer.borderColor = UIColor.white.cgColor
            }else{
                videoBtn.isEnabled = false
                videoBtn.setTitleColor(UIColor.hexColor(hex: "989898"), for: .normal)
                videoBtn.layer.borderColor = UIColor.hexColor(hex: "989898").cgColor
            }
        }
        
        self.oldRModel = model
        lastRModel = RModel
        
        //class
        var index = 0
        for mgmd in oldRModel.mg ?? [mgModel](){
            self.marketTagArray.append(contentsOf: mgmd.tps ?? [""])
            oldRModel.mg?[index].zantype = true
            oldRModel.mg?[index].bjtype = false
            index += 1
        }
        
        //RModel = oldRModel
        if classIndex != 0{
            var mgModels = Array<mgModel>()
            //print(classArray[classIndex])
            for mgmd in oldRModel.mg ?? [mgModel](){
                let type:Bool = mgmd.tps?.contains(classArray[classIndex].1) ?? false
                if type{
                    mgModels.append(mgmd)
                }
            }
            RModel.mg = mgModels
        }else{
            RModel = oldRModel
        }
        
        self.marketTagArray = Array(Set(self.marketTagArray))
        if self.marketTagArray.count > 1{
            self.marketTagArray = self.marketTagArray.sorted { (str1:String , str2: String) in
                return str1 < str2
            }
        }

        self.classArray.removeAll()
        for str in self.marketTagArray{
            self.classArray.append((getMarketTag(key: str),str,"0"))
        }
        
        if self.classArray.count > 0{
            if self.classArray.count > classIndex{
                self.classArray[classIndex].2 = "1"
            }else{
                self.classArray[0].2 = "1"
            }
            //print("self.marketTagArray====\(self.marketTagArray)")
            var mgModels = Array<mgModel>()
            for mgmd in oldRModel.mg ?? [mgModel](){
                let type:Bool = mgmd.tps?.contains(classArray[classIndex].1) ?? false
                if type{
                    //print("mgmd.tps===\(mgmd.tps)")
                    mgModels.append(mgmd)
                }
            }
            RModel.mg = mgModels
        }
        
        //置顶排序
        self.setDataTop()
        
        self.classCollectionView.reloadData()
        self.shuaixuanView.uploadUI(arr: self.classArray)
        
        self.titleLabel.text = model.lg?.na
        self.logoImg.sd_setImage(with: URL(string: model.lg?.lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
        
        if model.ts?.count ?? 0 > 0{
            self.leftLabel.text = model.ts?[0].na ?? ""
            self.rightLabel.text = model.ts?[1].na ?? ""
            self.leftLogo.sd_setImage(with: URL(string: model.ts?[0].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
            self.rightLogo.sd_setImage(with: URL(string: model.ts?[1].lurl ?? ""), placeholderImage: UIImage(named: getSportImg(key: model.sid ?? 0)))
        }
        
        if model.nsg?.count ?? 0 > 0{
            self.scoreLabel.text = "\(model.nsg?[0].sc?[0] ?? 0)" + " : " + "\(model.nsg?[0].sc?[1] ?? 0)"
        }else{
            self.scoreLabel.text = "VS"
        }
        if model.ms == 5{
            self.saitime.isHidden = false
            self.saitime.text = miaozhuanLanqiu(time: model.mc?.s ?? 0)
            //self.saiDate.text = MatchPeriod(key: model.mc?.pe ?? 0)
            self.startin.text = "Time elapsed"
            
            var scoreStr = ""
            var index = 0
            if model.nsg?.count ?? 0 > 0{
                for nsg in model.nsg ?? [nsgModel](){
                    if getPeriodScore(pe: nsg.pe ?? 0) && (nsg.tyg == 5 || nsg.tyg == 5556 || nsg.tyg == 5559 || nsg.tyg == 12 || nsg.tyg == 19 || nsg.tyg == 23){
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
            self.saiDate.text = MatchPeriod(key: model.mc?.pe ?? 0) + "  " + scoreStr
        }else{
            self.saitime.isHidden = true
            self.saiDate.text = timeDate(time: "\((model.bt ?? 0)/1000)")
            self.startin.text = "Starts in"
        }
        
        if RModel.mg?.count == 0 || RModel.id == nil{
            listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
        }else{
            listCollectionView.hiddenEmptyView()
        }
        listCollectionView.reloadData()
        
        if !animType && !videoType{
            if huadong {
                if classArray.count > 0{
                    classHH0 = heardHH0 + 50
                }else{
                    classHH0 = heardHH0 + 10
                }
                listviewHH.constant = classHH0
            }else{
                if classArray.count == 0{
                    classHH0 = heardHH0 + 10
                    listviewHH.constant = classHH0
                }
            }
        }
        
        if gameType == "virtual"{
            if model.nsg?.count ?? 0 > 0{
                self.scoreLabel.text = "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[0] ?? 0)" + " : " + "\(model.nsg?[(model.nsg?.count ?? 0) - 1].sc?[1] ?? 0)"
            }else{
                self.scoreLabel.text = "VS"
            }
            
            videoUrl = virtualVideoUrl
            if virtualVideoUrl.count > 0{
                videoBtn.isEnabled = true
                videoBtn.setTitleColor(UIColor.white, for: .normal)
                videoBtn.layer.borderColor = UIColor.white.cgColor
            }else{
                videoBtn.isEnabled = false
                videoBtn.setTitleColor(UIColor.hexColor(hex: "989898"), for: .normal)
                videoBtn.layer.borderColor = UIColor.hexColor(hex: "989898").cgColor
            }
            
            saiGroup.isHidden = false
            saiGroup.text = model.lg?.bnm
            saitime.isHidden = true
            saiDate.isHidden = true
            startin.isHidden = true
            virturaBgview.isHidden = false
            if model.ms == 5{
                liveimg.isHidden = false
                livelabel.isHidden = false
                fenLabel.isHidden = true
                miaoLabel.isHidden = true
            }else{
                liveimg.isHidden = true
                livelabel.isHidden = true
                fenLabel.isHidden = false
                miaoLabel.isHidden = false
                let (fen,miao) = virtualMiaozhuanLanqiu(time: (model.cd ?? 0)/1000)
                fenLabel.text = fen
                miaoLabel.text = miao
                if (Int(fen) ?? 0) == 0 && (Int(miao) ?? 0) <= 9 {
                    fenLabel.backgroundColor = .hexColor(hex: "F01717")
                    miaoLabel.backgroundColor = .hexColor(hex: "F01717")
                }else{
                    fenLabel.backgroundColor = .hexColor(hex: "0CD664")
                    miaoLabel.backgroundColor = .hexColor(hex: "0CD664")
                }
            }
            
            if model.ms == 0{
                virturaBgview.isHidden = true
                saitime.isHidden = false
                saitime.text = "END"
                self.insertTimers?.invalidate()
            }
        }
        
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd.MM.yyyy (HH:mm)"
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
    
    private func virtualMiaozhuanLanqiu(time: Int) -> (String,String){
        if time == 0{
            return ("00","00")
        }
        let mm = "\(time/60)"
        let ss = "\(time%60)"
        return ("\(mm.count > 1 ? mm : ("0" + mm))","\(ss.count > 1 ? ss : ("0" + ss))")
    }
    
    private func loadOrderStatus(Id: String, model: opModel, money: String){
        self.orderTimers?.invalidate()
        self.orderTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            self.loadOrderGetStakeOrderStatus(orderIds: [Id], model: model, money: money)
        })
    }
    
    private func loadOPOD(param: BatchBetMatchMarketOfJumpLineParam){
        self.opodTimers?.invalidate()
        self.opodTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (timer) in
            //print("刷新赔率")
            self.loadOrderBatchBetMatchMarketOfJumpLine2(param: param)
        })
    }
}

extension MatchDetailsViewController{
    private func matchGetMatchDetail(matchId: String){
        if self.loadType == 0{
            self.loadType = 1
            self.showHUD(text: "Loading...")
        }
        var param = MatchDetailParam()
        param.matchId = matchId
        param.oddsType = "1"
        param.languageType = "ENG"
        let api = gameType == "virtual" ? wxApi.virtualMatchGetMatchDetail(param: param) : wxApi.matchGetMatchDetail(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            if self.gameType == "virtual"{
                if let dict = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as? NSDictionary {
                    if dict["data"] != nil{
                        let vtData = dict["data"] as! NSDictionary
                        if vtData["vs"] != nil{
                            let arr = vtData["vs"] as? NSArray
                            if arr?.count ?? 0 > 0{
                                let vurldict = arr?[0] as! NSDictionary
                                self.virtualVideoUrl = vurldict["url"] as! String
                            }else{
                                self.virtualVideoUrl = ""
                            }
                        }
                    }
                }
            }
            let result = RequestCallBackViewModel<recordModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("recordModel===\(result?.data)")
                let model : recordModel = result?.data ?? recordModel()
                
                //记录浏览比赛 记录一次就行
                if self.isAlreadyRecord == false{
                    var param = RecordBrowseParam()
                    param.mId = model.id
                    param.lName = model.lg?.na
                    param.lLogoUrl = model.lg?.lurl
                    if model.ts?.count ?? 0 > 0{
                        param.hTName = model.ts?[0].na ?? ""
                        param.aTName = model.ts?[1].na ?? ""
                    }
                    param.beginTime = model.bt
                    param.IsVirtual = false
                    BrowseRequest.recordBrowseWithParam(param: param) {
                        self.isAlreadyRecord = true
                    }
                }
                self.getTopGamePlay(completion: { gamePlayArr in
                    self.loadUI(model: result?.data ?? recordModel())
                })
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func loadOrderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam){
        self.showHUDNO()
        let api = wxApi.orderBatchBetMatchMarketOfJumpLine(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<marketOfJumpLineModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("result?.data===\(result?.data)")
                if result?.data?.bms?.count ?? 0 > 0{
                    if result?.data?.bms?[0].ss == 1{
                        self.view.loadBms(bsmodel: result?.data?.bms?[0] ?? bmsModel())
                        self.loadOPOD(param: param)
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
    
    func loadOrderBatchBetMatchMarketOfJumpLine2(param: BatchBetMatchMarketOfJumpLineParam){
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
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: money)
                    }else if st == 0 || st == 1{
                        if self.orderTimers == nil{
                            self.loadOrderStatus(Id: result?.data?[0].oid ?? "", model: model, money: money)
                        }
                    }else{
                        self.orderTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: result?.data?[0].rjs ?? "Lose a bet", money: money)
                    }
                }
            }else{
                self.orderTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: result?.message ?? "Lose a bet", money: money)
            }
        }) { (error) in
            self.orderTimers?.invalidate()
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
                        self.view.showCalculatorEndView(model: model, msg: "Bet Placed successfully", money: param.singleBetList?[0].unitStake ?? "0")
                    }else{
                        self.orderTimers?.invalidate()
                        self.view.showCalculatorEndView(model: model, msg: getOrderStatus(key: st), money: param.singleBetList?[0].unitStake ?? "0")
                    }
                }else{
                    self.orderTimers?.invalidate()
                    self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
                }
            }else{
                self.orderTimers?.invalidate()
                self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
            }
        }) { (error) in
            self.orderTimers?.invalidate()
            self.view.showCalculatorEndView(model: model, msg: "Lose a bet", money: param.singleBetList?[0].unitStake ?? "0")
        }
    }
    
    func getTopGamePlay(completion : @escaping(Array<String>)->Void){
        if isAlreadyGetTop == false{
            var param = GameplayParam()
            param.mId = Int(self.matchId)
            let api = wxApi.getTopGameplay(param: param)
            AdHttpRequest(url: api, successCallBack: { data in
                print("------\(data)")
                self.hudHide()
                self.isAlreadyGetTop = true
                let result = RequestCallBackViewModel<GameplayModel>.deserialize(from: data)
                if(result?.code == 0){
                    let model : GameplayModel = result?.data ?? GameplayModel()
                    self.topGamePlayArr = model.list ?? []
                    completion(model.list ?? [])
                }else{
                    self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                    self.topGamePlayArr = []
                    completion([])
                }
            }) { error in
                self.isAlreadyGetTop = true
                self.hudHide()
                self.showTextSB(error, dismissAfterDelay: 1.5)
                self.topGamePlayArr = []
                completion([])
            }
        }else{
            completion(self.topGamePlayArr ?? [])
        }
    }
    func setDataTop(){
        //置顶排序
        if self.topGamePlayArr != nil{
            let totalArr : [mgModel] = RModel.mg ?? []
            var isNeedTopModel : [mgModel] = []
            for i in 0..<self.topGamePlayArr!.count{
                let str = self.topGamePlayArr![i]
                for item in totalArr{
                    if str == item.nm{
                        isNeedTopModel.append(item)
                    }
                }
            }
            let data : [mgModel] = totalArr.filter{!(self.topGamePlayArr?.contains($0.nm ?? "") ?? false)}
            RModel.mg = isNeedTopModel  + data
        }
    }

}

extension MatchDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DetailsListCVACellDelegate, DetailsListCVBCellDelegate,DetailClassReusableViewDelegate,DetailShuaixuanViewDelegate, DetailsListReusableViewDelegate, NewStakeViewDelegate,NYTipsViewDelegate {
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
    
    func detailsZhan(btn: UIButton) {
//        RModel.mg?[btn.tag - 1000].zantype = btn.isSelected
//        listCollectionView.reloadData()
//        
//        var index = 0
//        for item in oldRModel.mg ?? [mgModel](){
//            if item.nm == RModel.mg?[btn.tag - 1000].nm{
//                oldRModel.mg?[index].zantype = btn.isSelected
//                break
//            }
//            index += 1
//        }
        
        if btn.isSelected{
            zanArr.append(RModel.mg?[btn.tag - 1000].nm ?? "")
        }else{
            zanArr = zanArr.filter { str in
                str != RModel.mg?[btn.tag - 1000].nm ?? ""
            }
        }
        listCollectionView.reloadData()
    }
    
    func detailsBiaoji(btn: UIButton) {
        if Tool.getuserInfoModel() == nil{
            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        self.isAlreadyGetTop = false
        if btn.isSelected == true{
            var param = GameplayParam()
            param.mId = Int(self.matchId)
            param.mkName =  RModel.mg?[btn.tag - 3000].nm
            GameplayRequest.cancelTopGamePlayWithParam(param: param, completion: {
                btn.isSelected = !btn.isSelected
                self.topGamePlayArr = self.topGamePlayArr?.filter { $0 != param.mkName}
                self.setDataTop()
                self.listCollectionView.reloadData()
            })
        }else{
            var param = GameplayParam()
            param.mId = Int(self.matchId)
            param.mkName =  RModel.mg?[btn.tag - 3000].nm
            param.beginTime = RModel.bt
            GameplayRequest.topGamePlayWithParam(param: param, completion: {
                btn.isSelected = !btn.isSelected
                self.topGamePlayArr?.insert(param.mkName ?? "", at: 0)
                self.setDataTop()
                self.listCollectionView.reloadData()
            })
        }
    }
    
    func shuaixuanRegsult(dic: (String, String, String)) {
        var index = 0
        for item in classArray{
            classArray[index].2 = "0"
            if dic.1 == item.1{
                classArray[index].2 = "1"
                classIndex = index
            }
            index += 1
        }
        
        var mgModels = Array<mgModel>()
        for mgmd in oldRModel.mg ?? [mgModel](){
            let type:Bool = mgmd.tps?.contains(classArray[classIndex].1) ?? false
            if type{
                //print("mgmd.tps===\(mgmd.tps)")
                mgModels.append(mgmd)
            }
        }
        RModel.mg = mgModels
        
        shuaixuanBg.isHidden = true
        shuaixuanView.isHidden = true
        shuaixuanView.sousuo.resignFirstResponder()
        classCollectionView.scrollToItem(at: IndexPath(row: classIndex, section: 0), at: .centeredHorizontally, animated: true)
        classCollectionView.reloadData()
        listCollectionView.reloadData()
    }
    
    func shuanxuan() {
        shuaixuanBg.isHidden = false
        shuaixuanView.isHidden = false
        
    }
    
    func CVAPeilvBg(index: Int) {
        if Tool.getFBModel()?.token?.count ?? 0 == 0{
            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        
        let section = index/10000
        var item = index%10000/1000
        var i = index%10000%1000
        if ((RModel.mg?[section].mks?.count ?? 0) == 1) && ((RModel.mg?[section].mks?[0].op?.count ?? 0) > 3) {
            item = 0
            i = index%10000
        }
        //print("op===\(RModel.mg?[section].mks?[item].op?[i] ?? opModel())")
        var opmd = RModel.mg?[section].mks?[item].op?[i]
        if (opmd?.od ?? "") == "-"{
            self.showTextSB("No odds yet", dismissAfterDelay: 1.5)
            return
        }
        
        if (opmd?.od ?? "") == "-999"{
            return
        }
        
        opmd?.au = RModel.mg?[section].mks?[item].au
        opmd?.ss = RModel.mg?[section].mks?[item].ss
        opmd?.mksId = RModel.mg?[section].mks?[item].id
        opmd?.ngnm = RModel.mg?[section].nm
        opmd?.tps = RModel.mg?[section].tps?.joined(separator: ",")
        opmd?.recordsId = RModel.id
        opmd?.recordsnm = RModel.nm
        opmd?.recordsbt = RModel.bt
        opmd?.lgna = RModel.lg?.na
        
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
            if balance < 600{
                self.view.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
            }else{
                if opmd?.ss == 1{
                    self.view.showNewBetView(model: opmd ?? opModel())
                    self.view.setDelegate(view: self)
                    
                    var bmmodel = betMatchMarketListModel()
                    bmmodel.marketId = "\(opmd?.mksId ?? 0)"
                    bmmodel.matchId = "\(opmd?.recordsId ?? 0)"
                    bmmodel.oddsType = "1"
                    bmmodel.type = "\(opmd?.ty ?? 0)"
                    
                    var param = BatchBetMatchMarketOfJumpLineParam()
                    param.languageType = "ENG"
                    param.currencyId = "20"
                    param.isSelectSeries = "false"
                    param.betMatchMarketList = [bmmodel]
                    self.loadOrderBatchBetMatchMarketOfJumpLine(param: param)
                }
            }
        }
    }
    
    func CVBPeilvBg(index: Int) {
        if Tool.getFBModel()?.token?.count ?? 0 == 0{
            self.showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        
        let section = index/10000
        var item = index%10000/1000
        var i = index%10000%1000
        if ((RModel.mg?[section].mks?.count ?? 0) == 1) && ((RModel.mg?[section].mks?[0].op?.count ?? 0) > 3) {
            item = 0
            i = index%10000
        }
        //print("op===\(RModel.mg?[section].mks?[item].op?[i] ?? opModel())")
        var opmd = RModel.mg?[section].mks?[item].op?[i]
        if (opmd?.od ?? "") == "-"{
            self.showTextSB("No odds yet", dismissAfterDelay: 1.5)
            return
        }
        
        if (opmd?.od ?? "") == "-999"{
            return
        }
        
        opmd?.au = RModel.mg?[section].mks?[item].au
        opmd?.ss = RModel.mg?[section].mks?[item].ss
        opmd?.mksId = RModel.mg?[section].mks?[item].id
        opmd?.ngnm = RModel.mg?[section].nm
        opmd?.tps = RModel.mg?[section].tps?.joined(separator: ",")
        opmd?.recordsId = RModel.id
        opmd?.recordsnm = RModel.nm
        opmd?.recordsbt = RModel.bt
        opmd?.lgna = RModel.lg?.na
        //view.showBetView(model: opmd ?? opModel())
        
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
            if balance < 600{
                self.view.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
            }else{
                if opmd?.ss == 1{
                    self.view.showNewBetView(model: opmd ?? opModel())
                    self.view.setDelegate(view: self)
                    
                    var bmmodel = betMatchMarketListModel()
                    bmmodel.marketId = "\(opmd?.mksId ?? 0)"
                    bmmodel.matchId = "\(opmd?.recordsId ?? 0)"
                    bmmodel.oddsType = "1"
                    bmmodel.type = "\(opmd?.ty ?? 0)"
                    
                    var param = BatchBetMatchMarketOfJumpLineParam()
                    param.languageType = "ENG"
                    param.currencyId = "20"
                    param.isSelectSeries = "false"
                    param.betMatchMarketList = [bmmodel]
                    self.loadOrderBatchBetMatchMarketOfJumpLine(param: param)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if listCollectionView == scrollView as? UICollectionView{
            let currentPoint = scrollView.panGestureRecognizer.location(in: listCollectionView)
            if animType || videoType{
                if currentPoint.y > 400{
                    huadong = false
                    listviewHH.constant = 90
                    slbgview.isHidden = true
                    if videoType{
                        xuanzhuanbtn.isHidden = true
                    }
                }else{
                    huadong = true
                    slbgview.isHidden = false
                    if animType{
                        listviewHH.constant = classHH0 + (kScreenW*3/4 - 228)
                    }
                    if videoType{
                        xuanzhuanbtn.isHidden = false
                        listviewHH.constant = classHH0 + (kScreenW*3/4 - 250) + (260 - heardHH0)
                    }
                }
            }else{
                if currentPoint.y > 400{
                    huadong = false
                    listviewHH.constant = 90
                }else{
                    huadong = true
                    listviewHH.constant = classHH0
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == classCollectionView{
            return 1
        }
        return RModel.mg?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView{
            return classArray.count
        }
        
//        if RModel.mg?[section].zantype ?? false{
//            if ((RModel.mg?[section].mks?.count ?? 0) == 1) && ((RModel.mg?[section].mks?[0].op?.count ?? 0) > 3) {
//                return (RModel.mg?[section].mks?[0].op?.count ?? 0)/2 + (RModel.mg?[section].mks?[0].op?.count ?? 0)%2
//            }
//            return RModel.mg?[section].mks?.count ?? 0
//        }else{
//            return 0
//        }
        
        if !zanArr.contains(RModel.mg?[section].nm ?? ""){
            if ((RModel.mg?[section].mks?.count ?? 0) == 1) && ((RModel.mg?[section].mks?[0].op?.count ?? 0) > 3) {
                return (RModel.mg?[section].mks?[0].op?.count ?? 0)/2 + (RModel.mg?[section].mks?[0].op?.count ?? 0)%2
            }
            return RModel.mg?[section].mks?.count ?? 0
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ClassCell
            let dic = classArray[indexPath.item]
            cell.titleLabel.text = dic.0
            cell.titleLabel.font = .boldSystemFont(ofSize: 15)
            cell.titleLabel.layer.cornerRadius = 15
            cell.TLH.constant = 30
            if classArr1.contains(dic.0){
                cell.TLW.constant = 140
            }else if "Handicap & Over/Under" == dic.0{
                cell.TLW.constant = 200
            }else{
                cell.TLW.constant = 105
            }
            if dic.2 == "0" {
                cell.titleLabel.textColor = UIColor.hexColor(hex: "19263C")
                cell.titleLabel.backgroundColor = UIColor.hexColor(hex: "FFFFFF")
            }else{
                cell.titleLabel.textColor = UIColor.hexColor(hex: "FFFFFF")
                cell.titleLabel.backgroundColor = UIColor.hexColor(hex: "0CD664")
            }
            return cell
        }
        
        //op里面多个
        if ((RModel.mg?[indexPath.section].mks?.count ?? 0) == 1) && ((RModel.mg?[indexPath.section].mks?[0].op?.count ?? 0) > 3) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsListCVACell", for: indexPath) as! DetailsListCVACell
            cell.delegate = self
            let opmodels = RModel.mg?[indexPath.section].mks?[0].op
 
            let num = (RModel.mg?[indexPath.section].mks?[0].op?.count ?? 0)/2 + (RModel.mg?[indexPath.section].mks?[0].op?.count ?? 0)%2
            if (num - 1) == indexPath.item{
                cell.bglabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.bglabel.layer.cornerRadius = 10
            }else{
                cell.bglabel.layer.cornerRadius = 0
            }
            
            if RModel.mg?[indexPath.section].mks?[0].ss == 1{
                
                let index0 = indexPath.item*2
                let index1 = indexPath.item*2 + 1
                
                if Int(opmodels?[index0/2  +  index0%2 +  indexPath.item].od ?? "0") ?? 0 < 0{
                    cell.suo1.isHidden = false
                    cell.wf1.isHidden = true
                    cell.peilv1.isHidden = true
                }else{
                    cell.wf1.text = opmodels?[index0/2  +  index0%2 +  indexPath.item].nm
                    cell.peilv1.text = opmodels?[index0/2  +  index0%2 +  indexPath.item].od
                    cell.suo1.isHidden = true
                    cell.wf1.isHidden = false
                    cell.peilv1.isHidden = false
                }
                cell.peilvBg1.tag = indexPath.section*10000 + index0

                if index1 < (opmodels?.count ?? 0){
                    cell.peilvBg2.isHidden = false
                    if Int(opmodels?[index1/2  +  index1%2 +  indexPath.item].od ?? "0") ?? 0 < 0{
                        cell.suo2.isHidden = false
                        cell.wf2.isHidden = true
                        cell.peilv2.isHidden = true
                    }else{
                        cell.wf2.text = opmodels?[index1/2  +  index1%2 +  indexPath.item].nm
                        cell.peilv2.text = opmodels?[index1/2  +  index1%2 +  indexPath.item].od
                        cell.suo2.isHidden = true
                        cell.wf2.isHidden = false
                        cell.peilv2.isHidden = false
                    }
                    cell.peilvBg2.tag = indexPath.section*10000 + index1
                }else{
                    cell.wf2.isHidden = true
                    cell.peilv2.isHidden = true
                    cell.peilvBg2.isHidden = true
                }
                
                if lastRModel.mg?.count == RModel.mg?.count{
                    if ((lastRModel.mg?[indexPath.section].mks?.count ?? 0) == 1) && ((lastRModel.mg?[indexPath.section].mks?[0].op?.count ?? 0) > 3) {
                        if RModel.mg?[indexPath.section].mks?.count == lastRModel.mg?[indexPath.section].mks?.count{
                            if RModel.mg?[indexPath.section].mks?[0].id == lastRModel.mg?[indexPath.section].mks?[0].id{
                                let last_opmodels = lastRModel.mg?[indexPath.section].mks?[0].op
                                let od1_new = opmodels?[index0/2  +  index0%2 +  indexPath.item].od ?? "0"
                                let od1_last = last_opmodels?[index0/2  +  index0%2 +  indexPath.item].od ?? "0"
                                if (Double(od1_new) ?? 0) > (Double(od1_last) ?? 0){
                                    cell.peilv1.textColor = .hexColor(hex: "F01717")
                                }else if (Double(od1_new) ?? 0) < (Double(od1_last) ?? 0){
                                    cell.peilv1.textColor = .hexColor(hex: "2ABF83")
                                }else{
                                    cell.peilv1.textColor = .hexColor(hex: "101010")
                                }
                                
                                if index1 < (opmodels?.count ?? 0){
                                    let od2_new = opmodels?[index1/2  +  index1%2 +  indexPath.item].od ?? "0"
                                    let od2_last = last_opmodels?[index1/2  +  index1%2 +  indexPath.item].od ?? "0"
                                    if (Double(od2_new) ?? 0) > (Double(od2_last) ?? 0){
                                        cell.peilv2.textColor = .hexColor(hex: "F01717")
                                    }else if (Double(od2_new) ?? 0) < (Double(od2_last) ?? 0){
                                        cell.peilv2.textColor = .hexColor(hex: "2ABF83")
                                    }else{
                                        cell.peilv2.textColor = .hexColor(hex: "101010")
                                    }
                                }
                            }
                        }
                    }
                }
                
            }else{
                cell.suo1.isHidden = false
                cell.suo2.isHidden = false
                cell.wf1.isHidden = true
                cell.wf2.isHidden = true
                cell.peilv1.isHidden = true
                cell.peilv2.isHidden = true
            }
            return cell
        }
        
        //主和客
        let opmodels = RModel.mg?[indexPath.section].mks?[indexPath.item].op
        if (opmodels?.count ?? 0) == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsListCVBCell", for: indexPath) as! DetailsListCVBCell
            cell.delegate = self
            let num = RModel.mg?[indexPath.section].mks?.count ?? 0
            if (num - 1) == indexPath.item{
                cell.bglabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.bglabel.layer.cornerRadius = 10
            }else{
                cell.bglabel.layer.cornerRadius = 0
            }
            
            cell.peilvBg1.tag = indexPath.section*10000 + indexPath.item*1000
            cell.peilvBg2.tag = indexPath.section*10000 + indexPath.item*1000 + 1
            cell.peilvBg3.tag = indexPath.section*10000 + indexPath.item*1000 + 2
            if RModel.mg?[indexPath.section].mks?[indexPath.item].ss == 1{
                if Int(opmodels?[0].od ?? "0") ?? 0 < 0{
                    cell.suo1.isHidden = false
                    cell.wf1.isHidden = true
                    cell.peilv1.isHidden = true
                }else{
                    cell.wf1.text = "\(opmodels?[0].ty ?? 0)"
                    cell.peilv1.text = opmodels?[0].od
                    cell.suo1.isHidden = true
                    cell.wf1.isHidden = false
                    cell.peilv1.isHidden = false
                }
                
                if Int(opmodels?[1].od ?? "0") ?? 0 < 0{
                    cell.suo2.isHidden = false
                    cell.wf2.isHidden = true
                    cell.peilv2.isHidden = true
                }else{
                    cell.wf2.text = "X"
                    cell.peilv2.text = opmodels?[1].od
                    cell.suo2.isHidden = true
                    cell.wf2.isHidden = false
                    cell.peilv2.isHidden = false
                }
                
                if Int(opmodels?[2].od ?? "0") ?? 0 < 0{
                    cell.suo3.isHidden = false
                    cell.wf3.isHidden = true
                    cell.peilv3.isHidden = true
                }else{
                    cell.wf3.text = "\(opmodels?[2].ty ?? 0)"
                    cell.peilv3.text = opmodels?[2].od
                    cell.suo3.isHidden = true
                    cell.wf3.isHidden = false
                    cell.peilv3.isHidden = false
                }
                
                if lastRModel.mg?.count == RModel.mg?.count{
                    if RModel.mg?[indexPath.section].mks?.count == lastRModel.mg?[indexPath.section].mks?.count{
                        if RModel.mg?[indexPath.section].mks?[indexPath.item].id == lastRModel.mg?[indexPath.section].mks?[indexPath.item].id{
                            let last_opmodels = lastRModel.mg?[indexPath.section].mks?[indexPath.item].op
                            let od1_new = opmodels?[0].od ?? "0"
                            let od1_last = last_opmodels?[0].od ?? "0"
                            let od2_new = opmodels?[1].od ?? "0"
                            let od2_last = last_opmodels?[1].od ?? "0"
                            let od3_new = opmodels?[2].od ?? "0"
                            let od3_last = last_opmodels?[2].od ?? "0"
                            
                            if (Double(od1_new) ?? 0) > (Double(od1_last) ?? 0){
                                cell.peilv1.textColor = .hexColor(hex: "F01717")
                            }else if (Double(od1_new) ?? 0) < (Double(od1_last) ?? 0){
                                cell.peilv1.textColor = .hexColor(hex: "2ABF83")
                            }else{
                                cell.peilv1.textColor = .hexColor(hex: "101010")
                            }
                            
                            if (Double(od2_new) ?? 0) > (Double(od2_last) ?? 0){
                                cell.peilv2.textColor = .hexColor(hex: "F01717")
                            }else if (Double(od2_new) ?? 0) < (Double(od2_last) ?? 0){
                                cell.peilv2.textColor = .hexColor(hex: "2ABF83")
                            }else{
                                cell.peilv2.textColor = .hexColor(hex: "101010")
                            }
                            
                            if (Double(od3_new) ?? 0) > (Double(od3_last) ?? 0){
                                cell.peilv3.textColor = .hexColor(hex: "F01717")
                            }else if (Double(od3_new) ?? 0) < (Double(od3_last) ?? 0){
                                cell.peilv3.textColor = .hexColor(hex: "2ABF83")
                            }else{
                                cell.peilv3.textColor = .hexColor(hex: "101010")
                            }
                        }
                    }
                }
                
            }else{
                cell.suo1.isHidden = false
                cell.suo2.isHidden = false
                cell.suo3.isHidden = false
                cell.wf1.isHidden = true
                cell.wf2.isHidden = true
                cell.wf3.isHidden = true
                cell.peilv1.isHidden = true
                cell.peilv2.isHidden = true
                cell.peilv3.isHidden = true
            }
            
            return cell
        }
        
        //主客
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsListCVACell", for: indexPath) as! DetailsListCVACell
        cell.delegate = self
        let num = RModel.mg?[indexPath.section].mks?.count ?? 0
        if (num - 1) == indexPath.item{
            cell.bglabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.bglabel.layer.cornerRadius = 10
        }else{
            cell.bglabel.layer.cornerRadius = 0
        }
        cell.peilvBg1.tag = indexPath.section*10000 + indexPath.item*1000
        cell.peilvBg2.tag = indexPath.section*10000 + indexPath.item*1000 + 1
        cell.peilvBg1.isHidden = false
        cell.peilvBg2.isHidden = false
        if RModel.mg?[indexPath.section].mks?[indexPath.item].ss == 1{
            if (opmodels?.count ?? 0) > 1{

                if Int(opmodels?[0].od ?? "0") ?? 0 < 0{
                    cell.suo1.isHidden = false
                    cell.wf1.isHidden = true
                    cell.peilv1.isHidden = true
                }else{
                    cell.wf1.text = opmodels?[0].nm
                    cell.peilv1.text = opmodels?[0].od
                    cell.suo1.isHidden = true
                    cell.wf1.isHidden = false
                    cell.peilv1.isHidden = false
                }
                
                if Int(opmodels?[1].od ?? "0") ?? 0 < 0{
                    cell.suo2.isHidden = false
                    cell.wf2.isHidden = true
                    cell.peilv2.isHidden = true
                }else{
                    cell.wf2.text = opmodels?[1].nm
                    cell.peilv2.text = opmodels?[1].od
                    cell.suo2.isHidden = true
                    cell.wf2.isHidden = false
                    cell.peilv2.isHidden = false
                }

                if lastRModel.mg?.count == RModel.mg?.count{
                    if RModel.mg?[indexPath.section].mks?.count == lastRModel.mg?[indexPath.section].mks?.count{
                        if RModel.mg?[indexPath.section].mks?[indexPath.item].id == lastRModel.mg?[indexPath.section].mks?[indexPath.item].id{
                            let last_opmodels = lastRModel.mg?[indexPath.section].mks?[indexPath.item].op
                            let od1_new = opmodels?[0].od ?? "0"
                            let od1_last = last_opmodels?[0].od ?? "0"
                            let od2_new = opmodels?[1].od ?? "0"
                            let od2_last = last_opmodels?[1].od ?? "0"
                            if (Double(od1_new) ?? 0) > (Double(od1_last) ?? 0){
                                cell.peilv1.textColor = .hexColor(hex: "F01717")
                            }else if (Double(od1_new) ?? 0) < (Double(od1_last) ?? 0){
                                cell.peilv1.textColor = .hexColor(hex: "2ABF83")
                            }else{
                                cell.peilv1.textColor = .hexColor(hex: "101010")
                            }
                            
                            if (Double(od2_new) ?? 0) > (Double(od2_last) ?? 0){
                                cell.peilv2.textColor = .hexColor(hex: "F01717")
                            }else if (Double(od2_new) ?? 0) < (Double(od2_last) ?? 0){
                                cell.peilv2.textColor = .hexColor(hex: "2ABF83")
                            }else{
                                cell.peilv2.textColor = .hexColor(hex: "101010")
                            }
                        }
                    }
                }
            }
        }else{
            cell.suo1.isHidden = false
            cell.suo2.isHidden = false
            cell.wf1.isHidden = true
            cell.wf2.isHidden = true
            cell.peilv1.isHidden = true
            cell.peilv2.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == classCollectionView{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == classCollectionView{
            let dic = classArray[indexPath.item]
            if classArr1.contains(dic.0){
                return CGSize(width: 150, height: 30)
            }else if "Handicap & Over/Under" == dic.0{
                return CGSize(width: 210, height: 30)
            }else{
                return CGSize(width: 115, height: 30)
            }
            //return CGSize(width: 115, height: 30)
        }
        return CGSize(width: kScreenW - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if collectionView == listCollectionView{
            if kind == UICollectionView.elementKindSectionHeader{
                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailsListReusableView", for: indexPath) as! DetailsListReusableView
                reusableview.titleLabel.text = RModel.mg?[indexPath.section].nm
                if zanArr.contains(RModel.mg?[indexPath.section].nm ?? ""){
                    reusableview.zanbtn.isSelected = true
                    reusableview.bglabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                }else{
                    reusableview.zanbtn.isSelected = false
                    reusableview.bglabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                reusableview.bglabel.layer.cornerRadius = 10
                reusableview.zanbtn.tag = 1000 + indexPath.section
                var isSelect = false
                for str in self.topGamePlayArr ?? []{
                    if str == RModel.mg?[indexPath.section].nm{
                        isSelect = true
                    }
                }
                reusableview.biaojibtn.isSelected = isSelect
                reusableview.biaojibtn.tag = 3000 + indexPath.section
                reusableview.delegate = self
                return reusableview
            }
            return UICollectionReusableView()
        }
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailClassReusableView", for: indexPath) as! DetailClassReusableView
        reusableview.delegate = self
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == listCollectionView{
            return CGSize(width: kScreenW - 20, height: 40)
        }
        if classArray.count < 4{
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 30, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView{
            var index = 0
            for _ in classArray {
                classArray[index].2 = "0"
                index += 1
            }
            classArray[indexPath.row].2 = "1"
            classCollectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            
            classIndex = indexPath.row
            //oldClassIndex = indexPath.row
            if classIndex != 0{
                var mgModels = Array<mgModel>()
                print(classArray[classIndex])
                for mgmd in oldRModel.mg ?? [mgModel](){
                    let type:Bool = mgmd.tps?.contains(classArray[classIndex].1) ?? false
                    if type{
                        //print("mgmd.tps===\(mgmd.tps)")
                        mgModels.append(mgmd)
                    }
                }
                RModel.mg = mgModels
            }else{
                RModel = oldRModel
            }
            var mgModels = Array<mgModel>()
            print(classArray[classIndex])
            for mgmd in oldRModel.mg ?? [mgModel](){
                let type:Bool = mgmd.tps?.contains(classArray[classIndex].1) ?? false
                if type{
                    //print("mgmd.tps===\(mgmd.tps)")
                    mgModels.append(mgmd)
                }
            }
            RModel.mg = mgModels
            
            //置顶排序
            self.setDataTop()
            
            if RModel.mg?.count == 0 || RModel.id == nil{
                listCollectionView.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
            }else{
                listCollectionView.hiddenEmptyView()
            }
            listCollectionView.reloadData()
        }
    }
    
}
