//
//  AccumulatorView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/12.
//

import UIKit

protocol AccumulatorViewDelegate {
    func accumulatorViewBet()
    func btshowHUD()
    func bthudHide()
    func btshowTextSB(msg: String)
    func delectList(index: Int, matchId: Int, marketId: Int)
}

class AccumulatorView: UIView {
    
    @IBOutlet weak var betNum: UILabel!
    @IBOutlet weak var peilv: UILabel!
    @IBOutlet weak var betBg: UIView!
    
    @IBOutlet weak var bottomViewHH: NSLayoutConstraint!
    @IBOutlet weak var collectionview: UICollectionView!
    var delegate:AccumulatorViewDelegate?
    private var showType = "xx"
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("AccumulatorView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionview.setCollectionViewLayout(layout2, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "AccumulatorViewCell", bundle: nil), forCellWithReuseIdentifier: "AccumulatorViewCell")
    }
    
    func viewWillLoadUI(type:Bool){
        self.setTipsDelegate(view: self)
        if chuanguanArray.count > 0{
            if type{
                betBg.isHidden = false
                self.isHidden = false
            }else{
                betBg.isHidden = true
                self.isHidden = true
            }
        }else{
            betBg.isHidden = true
            self.isHidden = true
        }
        betNum.text = "\(chuanguanArray.count)"
        collectionview.reloadData()
    }
    
    private var chuanguanArrayOld = [opModel]()
    func loadData(model:marketOfJumpLineModel){
        chuanguanArrayOld.removeAll()
        if chuanguanArray.count == model.bms?.count{
            var index = 0
            for item in model.bms ?? [bmsModel](){
                var omodel = opModel()
                omodel.mksId = item.mid
                if item.mid == chuanguanArray[index].mksId{
                    chuanguanArray[index].od = item.op?.od
                    chuanguanArray[index].ss = item.ss
                    chuanguanArray[index].opsOnm = item.op?.nm
                    
                    omodel.od = item.op?.od
                    omodel.ss = item.ss
                    omodel.opsOnm = item.op?.nm
                }
                chuanguanArrayOld.append(omodel)
                index += 1
            }
        }
        collectionview.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickBet(_ sender: UIButton) {
        showType = "xx"
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        let acnum: Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
        if 600 > acnum{
            self.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
        }else{
            delegate?.accumulatorViewBet()
        }
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MMM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }

    var deleteIndex = 0
    
}

extension AccumulatorView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AccumulatorViewCellDelegate, NYTipsViewDelegate{
    func clickLeftBtn() {
        self.hiddenTipsView()
    }
    
    func clickRightBtn() {
        if showType == "xx"{
            self.hiddenTipsView()
            Tool.getCurrentVc().tabBarController?.selectedIndex = 3
        }else{
            self.hiddenTipsView()
            delegate?.delectList(index: chuanguanArray.count, matchId: chuanguanArray[deleteIndex].recordsId ?? 0, marketId: chuanguanArray[deleteIndex].mksId ?? 0)
            chuanguanArray.remove(at: deleteIndex)
            collectionview.reloadData()
            viewWillLoadUI(type: true)
        }
    }
   
    func deleteBtn(index: Int) {
        showType = "ss"
        deleteIndex = index - 200
        self.showTipsView(title: "Deleting", subTitle: "Are you sure you want to delete the event?", leftTitle: "Cancel", rightTitle: "Delete")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chuanguanArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccumulatorViewCell", for: indexPath) as! AccumulatorViewCell
        let model = chuanguanArray[indexPath.item]
        cell.titleLabel.text = model.recordsnm
        let kk = model.tps?.components(separatedBy: ",")
        var timeStr = timeDate(time: "\((model.recordsbt ?? 0)/1000)")
        if (kk?.count ?? 0) > 0{
            timeStr = timeStr + ", " + getMarketTag(key: kk?[0] ?? "")
        }
        cell.timeLabel.text = timeStr
        //cell.wfLabel.text = (model.ngnm ?? "") + " : " + getTYType(key: model.ty ?? 0)//"\(model.ty ?? 0)"
        cell.wfLabel.text = (model.ngnm ?? "") + " : " + (model.opsOnm ?? "")
        cell.peilvLabel.text = "@" + (model.od ?? "0")
        cell.detBtn.tag = 200 + indexPath.item
        cell.delegate = self
        
        if chuanguanArray.count == chuanguanArrayOld.count{
            let modelOld = chuanguanArrayOld[indexPath.item]
            if model.mksId == modelOld.mksId{
                cell.peilvLabel.text = "@" + (modelOld.od ?? "0")
                let od1:Float = Float(modelOld.od ?? "0") ?? 0
                let od2:Float = Float(model.od ?? "0") ?? 0
                if od1 > od2{
                    cell.peilvLabel.textColor = .hexColor(hex: "FF3344")
                }else if od1 < od2{
                    cell.peilvLabel.textColor = .hexColor(hex: "0CD664")
                }else{
                    cell.peilvLabel.textColor = .hexColor(hex: "19263C")
                }
                
                if modelOld.ss == 1{
                    cell.bgimg.isHidden = false
                    cell.backgroundColor = .hexColor(hex: "F5F5F7")
                }else{
                    cell.bgimg.isHidden = true
                    cell.backgroundColor = .hexColor(hex: "969696")
                }
                chuanguanArray[indexPath.item].od = modelOld.od
                chuanguanArray[indexPath.item].ss = modelOld.ss
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: kScreenW - 20, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}
