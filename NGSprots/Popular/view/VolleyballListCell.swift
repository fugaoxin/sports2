//
//  VolleyballListCell.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/30.
//

import UIKit

protocol VolleyballListCellDelegate{
    func footballListOd(model: opModel)
    func LMVGodetail(index: Int)
    func popularVideoBtn(index: Int)
}

class VolleyballListCell: UICollectionViewCell {
    var collectBlock : ((_ isCollect : Bool)->Void)?
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var ldBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    
    @IBOutlet weak var leftLogo: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLogo: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftScore: UILabel!
    @IBOutlet weak var leftScore2: UILabel!
    @IBOutlet weak var rightScore: UILabel!
    @IBOutlet weak var rightScore2: UILabel!
    @IBOutlet weak var ssl1: UIButton!
    @IBOutlet weak var ssl2: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var detailBtn: UIButton!
    
    @IBOutlet weak var setLabel: UILabel!
    var delegate: VolleyballListCellDelegate?
    
    private var models = [opModel]()
    var recordsId = 0
    var recordsnm = ""
    var recordsbt = 0
    var lgna = ""
    
    var gundongIndex = 0
    
    var model : recordModel? {
        didSet{
            collectBtn.isSelected = model?.sctype ?? false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.register(UINib(nibName: "BettingCell", bundle: nil), forCellWithReuseIdentifier: "BettingCell")
    }

    @IBAction func clickCollect(_ sender: UIButton) {
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        UserDefaults.standard.set(true, forKey: IsNeedGetCollect)
        UserDefaults.standard.synchronize()
        if model?.sctype == true{
            var param = CancelCollectParam()
            param.mId = model?.id
            CollectRequest.cancelCollectWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                if self.collectBlock != nil{
                    self.collectBlock!(sender.isSelected)
                }
            }
        }else{
            var param = CollectParam()
            param.mId = model?.id
            param.beginTime = model?.bt
            param.IsVirtual = false
            CollectRequest.collectWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                if self.collectBlock != nil{
                    self.collectBlock!(sender.isSelected)
                }
            }
        }
    }
    
    @IBAction func clickLDBtn(_ sender: UIButton) {
    }
    @IBAction func clickVideoBtn(_ sender: UIButton) {
        delegate?.popularVideoBtn(index: sender.tag)
    }
    
    private var modelsOld = [opModel]()
    func loadUIold(mgModels:[mgModel]){
        modelsOld.removeAll()
        for md in mgModels{
            if (md.mks?.count ?? 0) > 0{
                if (md.mks?[0].op?.count ?? 0) > 0{
                    var index = 0
                    for opmd in md.mks?[0].op ?? [opModel](){
                        var oml = opModel()
                        oml.na = opmd.na
                        oml.nm = opmd.nm
                        oml.ty = opmd.ty
                        oml.od = opmd.od
                        oml.bod = opmd.bod
                        oml.odt = opmd.odt
                        oml.ss = md.mks?[0].ss
                        oml.au = md.mks?[0].au
                        oml.mksId = md.mks?[0].id ?? 0
                        oml.ngnm = md.nm ?? ""
                        oml.tps = md.tps?.joined(separator: ",")
                        if index == 0{
                            oml.ngnmType = true
                        }else{
                            oml.ngnmType = false
                        }
                        modelsOld.append(oml)
                        index += 1
                    }
                }
            }
        }
    }
    
    func loadUI(mgModels:[mgModel]){
        models.removeAll()
        for md in mgModels{
            if (md.mks?.count ?? 0) > 0{
                if (md.mks?[0].op?.count ?? 0) > 0{
                    var index = 0
                    for opmd in md.mks?[0].op ?? [opModel](){
                        var oml = opModel()
                        oml.na = opmd.na
                        oml.nm = opmd.nm
                        oml.ty = opmd.ty
                        oml.od = opmd.od
                        oml.bod = opmd.bod
                        oml.odt = opmd.odt
                        oml.ss = md.mks?[0].ss
                        oml.au = md.mks?[0].au
                        oml.mksId = md.mks?[0].id ?? 0
                        oml.ngnm = md.nm ?? ""
                        oml.tps = md.tps?.joined(separator: ",")
                        if index == 0{
                            oml.ngnmType = true
                        }else{
                            oml.ngnmType = false
                        }
                        models.append(oml)
                        index += 1
                    }
                }
            }
        }
        self.collectionview.reloadData()
        if mgModels.count > 0{
            if gundongIndex >= mgModels.count{
                gundongIndex = 0
            }
            self.collectionview.scrollToItem(at: IndexPath(row: gundongIndex, section: 0), at: .left, animated: false)
        }
    }

    @IBAction func godetail(_ sender: UIButton) {
        delegate?.LMVGodetail(index: sender.tag)
    }
    
}

extension VolleyballListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BettingCellDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionview == scrollView as? UICollectionView{
            let currentIndexPath:IndexPath = self.collectionview.indexPathForItem(at: scrollView.contentOffset) ?? IndexPath()
            if gundongIndexArray.count > 0{
                var index = 0
                for item in gundongIndexArray{
                    if item.0 == recordsId{
                        gundongIndexArray[index].1 = (currentIndexPath != []) ? currentIndexPath.item: 0
                        break
                     }
                    index += 1
                }
                if index == gundongIndexArray.count{
                    gundongIndexArray.append((recordsId, (currentIndexPath != []) ? currentIndexPath.item: 0))
                }
            }else{
                gundongIndexArray.append((recordsId, (currentIndexPath != []) ? currentIndexPath.item: 0))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BettingCell", for: indexPath) as! BettingCell
        if models[indexPath.row].ngnmType ?? false{
            cell.titleLabel.isHidden = false
            cell.titleLabel.text = models[indexPath.row].ngnm
        }else{
            cell.titleLabel.isHidden = true
        }
        if models[indexPath.row].ss == 1{
            cell.leftLabel.isHidden = false
            cell.rightLabel.isHidden = false
            cell.suoimg.isHidden = true
//            let ty = models[indexPath.row].ty ?? 0
//            if ty == 1 || ty == 2{
//                cell.leftLabel.text = "\(models[indexPath.row].ty ?? 0)"
//            }else if ty == 3{
//                cell.leftLabel.text = "X"
//            }else{
//                cell.leftLabel.text = models[indexPath.row].nm
//            }
            if models[indexPath.row].nm == "Home" || models[indexPath.row].nm == "Away"{
                cell.leftLabel.text = "\(models[indexPath.row].ty ?? 0)"
            }else if models[indexPath.row].nm == "D"{
                cell.leftLabel.text = "X"
            }else{
                cell.leftLabel.text = models[indexPath.row].nm
            }
            cell.leftLabel.textColor = .hexColor(hex: "969696")
            cell.rightLabel.text = models[indexPath.row].od
            cell.rightLabel.textColor = .hexColor(hex: "19263C")
        }else{
            cell.leftLabel.isHidden = true
            cell.rightLabel.isHidden = true
            cell.suoimg.isHidden = false
        }

        cell.odLabel.tag = 10000 + indexPath.row
        cell.delegate = self
        
        if models.count == modelsOld.count{
            let model = models[indexPath.row]
            let modelOld = modelsOld[indexPath.row]
            if model.mksId == modelOld.mksId{
                let od1:Float = Float(modelOld.od ?? "0") ?? 0
                let od2:Float = Float(model.od ?? "0") ?? 0
                if od1 < od2{
                    cell.rightLabel.textColor = .hexColor(hex: "FF3344")
                }else if od1 > od2{
                    cell.rightLabel.textColor = .hexColor(hex: "0CD664")
                }else{
                    cell.rightLabel.textColor = .hexColor(hex: "19263C")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenW - 50)/4, height: 70)
    }
    
    func clickOdLabel(index: Int) {
        print("\(index - 10000)")
        var model = models[index - 10000]
        model.recordsId = recordsId
        model.recordsnm = recordsnm
        model.recordsbt = recordsbt
        model.lgna = lgna
        delegate?.footballListOd(model: model)
    }
}
