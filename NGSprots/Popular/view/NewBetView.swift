//
//  NewBetView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import UIKit

protocol NewBetViewDelegate{
    func newStakeAndPromoview(index: Int)
}

class NewBetView: UIView {
    
    @IBOutlet weak var stake: UIButton!
    @IBOutlet weak var promo: UIButton!
    @IBOutlet weak var stakeview: UIView!
    @IBOutlet weak var promoview: UIView!
    @IBOutlet weak var bgviewHH: NSLayoutConstraint!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var skv:NewStakeView!
    var prov:CouponView!
    var delegate: NewBetViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("NewBetView", owner: self, options: nil)?.first as! UIView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        prov = CouponView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 425))
        promoview.addSubview(prov)
        
        skv = NewStakeView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 550))
        stakeview.addSubview(skv)
        skv.couponList = { models in
            self.prov.loadUI(models: models)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    @IBAction func clickStake(_ sender: UIButton) {
        stake.backgroundColor = .hexColor(hex: "0CD664")
        promo.backgroundColor = .hexColor(hex: "F5F6F9")
        stake.setTitleColor(.white, for: .normal)
        promo.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        stakeview.isHidden = false
        promoview.isHidden = true
//        bgviewHH.constant = 480
        delegate?.newStakeAndPromoview(index: 1)
    }
    
    @IBAction func clickPromo(_ sender: UIButton) {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.id == nil{
            Tool.goToLogin()
            return
        }
        stake.backgroundColor = .hexColor(hex: "F5F6F9")
        promo.backgroundColor = .hexColor(hex: "0CD664")
        stake.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        promo.setTitleColor(.white, for: .normal)
        stakeview.isHidden = true
        promoview.isHidden = false
//        bgviewHH.constant = 300
        delegate?.newStakeAndPromoview(index: 2)
    }
    
    @IBAction func addtoBetslip(_ sender: UIButton) {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.id == nil{
            Tool.goToLogin()
            return
        }
        
        let model = self.skv.opmodel ?? opModel()
        if model.au == 1{
            if chuanguanArray.count >= 10{
                tipsLabel.text = "Add a maximum of ten matches"
                tipsLabel.textColor = .hexColor(hex: "FF3344")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.tipsLabel.text = "Add to bet slip"
                    self.tipsLabel.textColor = .white
                }
                return
            }
            for item in chuanguanArray{
                if model.recordsId == item.recordsId{
                    tipsLabel.text = "The same event cannot be joined"
                    tipsLabel.textColor = .hexColor(hex: "FF3344")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        self.tipsLabel.text = "Add to bet slip"
                        self.tipsLabel.textColor = .white
                    }
                    return
                }
            }
            //chuanguanArray.append(model)
            let kk = model.recordsnm?.components(separatedBy: " vs. ")
            var param = carListModel()
            param.gameId = 1
            param.matchId = model.recordsId
            param.marketId = model.mksId
            param.marketTag = (model.tps?.count ?? 0) > 0 ? model.tps : "p"
            //param.marketName = (model.ngnm ?? "") + " : " + "\(model.ty ?? 0)"
            
            var str = ""
            let strnm = model.nm ?? ""
            if strnm == "Home" || strnm == "Away"{
                str = "\(model.ty ?? 0)"
            }else if strnm == "Draw"{
                str = "X"
            }else{
                if (model.na ?? "") == (model.nm ?? ""){
                    str = model.nm ?? ""
                }else{
                    str = (model.na ?? "") + " " + (model.nm ?? "")
                }
            }
            param.marketName = (model.ngnm ?? "") + " : " + "\(model.ty ?? 0)" + " : " + str
            
            if (kk?.count ?? 0) > 1{
                param.hTName = kk?[0]
                param.aTName = kk?[1]
            }else{
                param.hTName = ".."
            }
            param.beginTime = "\(model.recordsbt ?? 0)"
            cartBetSlipAdd(param: param)
            self.hiddenNewBetView()
        }else{
            tipsLabel.text = "Cannot add to bet slip"
            tipsLabel.textColor = .hexColor(hex: "FF3344")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.tipsLabel.text = "Add to bet slip"
                self.tipsLabel.textColor = .white
            }
        }
    }
    
    //加入购物车
    func cartBetSlipAdd(param: carListModel){
        let api = wxApi.cartBetSlipAdd(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<String>.deserialize(from: data)
            if(result?.code == 0){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadCart"), object: nil)
            }else{
            }
        }) { (error) in
        }
    }
    
}
