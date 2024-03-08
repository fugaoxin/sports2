//
//  SearchEndView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit
import AVKit

class SearchEndView: UIView {

    @IBOutlet weak var collectionview: UICollectionView!
    private var listModels = Array<recordModel>()
    var currentvc:BrowseViewController?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("SearchEndView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "BasketballListCell", bundle: nil), forCellWithReuseIdentifier: "BasketballListCell")
        collectionview.register(UINib(nibName: "VolleyballListCell", bundle: nil), forCellWithReuseIdentifier: "VolleyballListCell")
        collectionview.register(UINib(nibName: "FootballListCell", bundle: nil), forCellWithReuseIdentifier: "FootballListCell")
        collectionview.register(UINib(nibName: "PortraitViewCell", bundle: nil), forCellWithReuseIdentifier: "PortraitViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func loadUIData(models: [recordModel]){
        self.setTipsDelegate(view: self)
        listModels = models
        collectionview.reloadData()
        if listModels.count > 0{
            collectionview.hiddenEmptyView()
        }else{
            collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible",btnStr: "")
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

extension SearchEndView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FootballListCellDelegate, BasketballListCellDelegate, VolleyballListCellDelegate,NYTipsViewDelegate,PortraitViewCellDelegate{
    func clickLeftBtn() {
        self.view.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.view.hiddenTipsView()
        self.currentvc?.tabBarController?.selectedIndex = 3
    }
    
    func footballListOd(model: opModel) {
        if Tool.getFBModel()?.token?.count ?? 0 == 0{
            currentvc?.showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
            if balance < 600{
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
                    self.currentvc?.loadOrderBatchBetMatchMarketOfJumpLine(param: param, model: model)
                }
            }
        }
    }
    
    func LMVGodetail(index: Int) {
        currentvc?.getCollectGame (completion: {_ in
            let item = self.listModels[index - 200]
            let vc = MatchDetailsViewController()
            vc.titleStr = item.lg?.na ?? ""
            vc.matchId = "\(item.id ?? 0)"
            vc.isCollect = item.sctype ?? false
            vc.beginTime = item.bt
            vc.isVirtual = false
            self.currentvc?.hidesBottomBarWhenPushed = true
            self.currentvc?.navigationController?.pushViewController(vc, animated: true)
            self.currentvc?.hidesBottomBarWhenPushed = false
        })
    }
    
    func popularVideoBtn(index: Int) {
        let item = listModels[index - 2000]
        if item.vs?.m3u8SD != nil{
            guard let playUrl = URL(string: item.vs?.m3u8SD ?? "") else {
                return
            }
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: playUrl)
            currentvc?.present(vc, animated: true) {
                vc.player?.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = listModels[indexPath.item]
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitViewCell", for: indexPath) as! PortraitViewCell
            cell.saidateil.isHidden = true
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
            cell.videoBtn.tag = 2000 + indexPath.row
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            
            cell.detailBtn.tag = 200 + indexPath.row
            cell.delegate = self
            
            cell.collectBlock = {[weak self] isCollect in
                self?.listModels[indexPath.item].sctype = isCollect
                self?.collectionview.reloadData()
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
                if model.nsg?.count ?? 0 > 0{
                    for nsg in model.nsg ?? [nsgModel](){
                        if (nsg.pe == 3005 || nsg.pe == 3006) && nsg.tyg == 5{
                            if scoreStr.count > 0{
                                scoreStr = scoreStr + ", " + "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }else{
                                scoreStr = "\(nsg.sc?[0] ?? 0)" + "-" + "\(nsg.sc?[1] ?? 0)"
                            }
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
            cell.videoBtn.tag = 2000 + indexPath.row
            
            cell.recordsnm = model.nm ?? ""
            cell.recordsId = model.id ?? 0
            cell.recordsbt = model.bt ?? 0
            cell.lgna = model.lg?.na ?? ""
            cell.loadUI(mgModels: model.mg ?? [mgModel]())
            
            cell.detailBtn.tag = 200 + indexPath.row
            cell.delegate = self
            
            cell.collectBlock = {[weak self] isCollect in
                self?.listModels[indexPath.item].sctype = isCollect
                self?.collectionview.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.handicapDisplayType == 1{
            //return CGSize(width: kScreenW - 20, height: 162)
            return CGSize(width: kScreenW - 20, height: 150)
        }else{
            return CGSize(width: kScreenW - 20, height: 190)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
