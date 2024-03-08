//
//  BetSlipBetView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/13.
//

import UIKit
import CryptoKit

protocol BetSlipBetViewDelegate {
    func settleAccounts(money: String, model: opModel, PotentialBonus: String, relatedId: String)
}

class BetSlipBetView: UIView, NYTipsViewDelegate {
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var peilv: UILabel!
    
    @IBOutlet weak var stake: UIButton!
    @IBOutlet weak var promo: UIButton!
    
    @IBOutlet weak var sminLabel: UILabel!
    @IBOutlet weak var returnsMoney: UILabel!
    
    @IBOutlet weak var moneyBgview: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var betBtn: UIButton!
    
    var delegate:BetSlipBetViewDelegate?
    private var opmodel:opModel?
    var prov:CouponView!
    @IBOutlet weak var accountMoney: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var endMoney: UILabel!
    @IBOutlet weak var benMoney: UILabel!
    @IBOutlet weak var benLine: UILabel!
    @IBOutlet weak var bounsMoney: UILabel!
    @IBOutlet weak var userbounsMoney: UILabel!
    
    //记录第一次
    var frist = true
    //最大金额
    var MAX = 3000
    //最小金额
    var MIN = 600
    var peilvStr = "1.5"
    var peilvStrOld = "0"
    
    @IBOutlet weak var jpHH: NSLayoutConstraint!
    var clickDone: (()->Void)?
    var clickMoneyBgview: (()->Void)?
    var clickTopUp: (()->Void)?
    var bounsTips: (()->Void)?
    
    let Secret = "vQi=66$re\">Wq$y"
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BetSlipBetView", owner: self, options: nil)?.first as! UIView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        moneyBgview.layer.borderColor = UIColor.hexColor(hex: "E0E0E0").cgColor
        moneyBgview.layer.borderWidth = 0.5
        moneyBgview.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickMoneyBg))
        moneyBgview.addGestureRecognizer(tap)
        
        prov = CouponView(frame: CGRect(x: 0, y: 60, width: kScreenW, height: 425))
        self.addSubview(prov)
        prov.isHidden = true
        
        prov.clickSelectItems = { itemModels in
            self.listItem = itemModels
            var num: Int = Int(self.moneyLabel.text ?? "") ?? 0
            for item in self.listItem{
                if item.selectBool ?? false{
                    //model.type == 1 ? false : true
                    let mainValue = (Int(item.mainValue ?? "0") ?? 0)
                    if item.type == 1{
                        num = num - mainValue
                        self.tipsLabel.text = "\(item.mainValue ?? "0")" + " coupons have been used"
                    }else{
                        num = num - (num*mainValue/100)
                        self.tipsLabel.text = "%\(item.mainValue ?? "0")" + " coupons have been used"
                    }
                    break
                }
            }
            self.endMoney.text = "Place Bet ₦\(num)"
        }
    }
    
    @objc func clickMoneyBg(){
        clickMoneyBgview!()
        if jpHH.constant == 0{
            prov.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 285)
        }else{
            prov.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 425)
        }
    }
    
    func loadBms(bmsmodel: bmsModel){
        bmsmodelArr.removeAll()
        MAX = bmsmodel.smax ?? 0
        MIN = bmsmodel.smin ?? 0
        sminLabel.text = "₦ \(MIN)" + " - " + "₦ \(MAX)"
        
        peilvStr = "\(bmsmodel.op?.od ?? "0")"
        peilv.text = "@" + "\(bmsmodel.op?.od ?? "0")"
        
//        let db1 = Float(peilvStrOld)
//        let db2 = Float(peilvStr)
//        if db1 != db2{
//            var odds = oddsModel()
//            odds.oddsFormat = 1
//            odds.betOdds = peilvStr
//            var param = CouponListParam()
//            param.amount = moneyLabel.text ?? ""
//            param.scenario = "bet"
//            param.odds = [odds]
//            CouponRequest.couponAvailableAndBonus(param: param) { model in
//                //print("model==loadBms==\(model)")
//                if model.items?.count ?? 0 > 0{
//                    self.listItem = model.items ?? [itemModel]()
//                    self.listItem[0].selectBool = true
//                    self.prov.loadUI(models: self.listItem)
//                    
//                    if model.items?[0].type == 1{
//                        self.tipsLabel.text = "\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }else{
//                        self.tipsLabel.text = "%\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }
//                    self.endMoney.text = "Place Bet ₦\(model.afterAmount ?? 0)"
//                    self.userbounsMoney.text = "-₦\(model.bonus ?? 0)"
//                }else{
//                    self.prov.loadUI(models: [])
//                }
//            }
//        }
        peilvStrOld = peilvStr
    }
    
    private var bmsmodelArr = Array<bmsModel>()
    func loadsos(sosmodel: sosModel, bmsmodels: [bmsModel]){
        bmsmodelArr = bmsmodels
        MAX = sosmodel.mx ?? 0
        MIN = sosmodel.mi ?? 0
        sminLabel.text = "₦ \(MIN)" + " - " + "₦ \(MAX)"
        
        peilvStr = "\(sosmodel.sodd ?? 0)"
        peilv.text = "@" + "\(sosmodel.sodd ?? 0)"
        
        let db1 = Float(peilvStrOld)
        let db2 = Float(peilvStr)
        if db1 != db2{
            var bonusParam = BounsParam()
            bonusParam.amount = moneyLabel.text ?? ""
            var oddsArr = Array<oddsModel>()
            for bmsmodel in bmsmodels{
                var odds = oddsModel()
                odds.oddsFormat = 1
                odds.betOdds = bmsmodel.op?.od
                oddsArr.append(odds)
            }
            var param = CouponListParam()
            param.amount = moneyLabel.text ?? ""
            param.scenario = "bet"
            param.odds = oddsArr
            
            bonusParam.odds = oddsArr
            AccabonusRequest.lodaAccabonusCalc(param: bonusParam) { amount in
                let amountStr = (amount == "0" ? "0" : String(format: "%.2f", Float(amount ?? "0") ?? 0))
                self.bounsMoney.text = "₦" + amountStr
            }
            
//            CouponRequest.couponAvailableAndBonus(param: param) { model in
//                //print("model==loadsos==\(model)")
//                if model.items?.count ?? 0 > 0{
//                    self.listItem = model.items ?? [itemModel]()
//                    self.listItem[0].selectBool = true
//                    self.prov.loadUI(models: self.listItem)
//                    
//                    if model.items?[0].type == 1{
//                        self.tipsLabel.text = "\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }else{
//                        self.tipsLabel.text = "%\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }
//                    self.endMoney.text = "Place Bet ₦\(model.afterAmount ?? 0)"
//                    self.userbounsMoney.text = "-₦\(model.bonus ?? 0)"
//                }else{
//                    self.prov.loadUI(models: [])
//                }
//            }
        }
        peilvStrOld = peilvStr
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickBetBtn(_ sender: UIButton) {
        let num: Int = Int(moneyLabel.text ?? "") ?? 0
        if num < MIN{
            sminLabel.textColor = .red
            return
        }
        
//        /*计算扣除优惠券或奖金后的金额*/
//        for item in listItem{
//            if item.selectBool ?? false{
//                num = num - (Int(item.mainValue ?? "0") ?? 0)
//                break
//            }
//        }
        
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        let balance:Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
        if Float(num) > balance{
            self.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
        }else{
            var couponAmount = "0"
            var couponId = "0"
            for item in listItem{
                if item.selectBool ?? false{
                    couponAmount = item.mainValue ?? "0"
                    couponId = "\(item.id ?? 0)"
                    break
                }
            }
            
            var ridmodl = relatedIdModel()
            let str = "bonusAmount" + "\(0)" + "couponAmount" + "\(couponAmount)" + "couponId" + "\(couponId)" + "stakeAmount" + "\(num)" + "ts" + "\(Int(Date().timeIntervalSince1970))" + "userId" + "\(account.id ?? 0)" + Secret
            let md5 = md5(str)
            ridmodl.bonusAmount = "0"
            ridmodl.couponAmount = "\(couponAmount)"
            ridmodl.couponId = "\(couponId)"
            ridmodl.stakeAmount = "\(num)"
            ridmodl.ts = "\(Int(Date().timeIntervalSince1970))"
            ridmodl.userId = "\(account.id ?? 0)"
            ridmodl.sign = md5
            delegate?.settleAccounts(money: "\(num)", model: self.opmodel ?? opModel(), PotentialBonus: self.bounsMoney.text ?? "₦0", relatedId: ridmodl.toJSONString() ?? "")
        }
    }
    
    func md5(_ string: String) -> String {
        let data = Data(string.utf8)
        let digest = Insecure.MD5.hash(data: data)
        let hash = digest.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
    
    private var listItem = Array<itemModel>()
    @IBAction func numbers(_ sender: UIButton) {
        if frist {
            frist = false
            moneyLabel.text = ""
        }
        
        var num = 0
        if Int(moneyLabel.text ?? "") ?? 0 < 1{
            num = sender.tag - 10
        }else{
            if sender.tag == 60 || sender.tag == 110 || sender.tag == 510 || sender.tag == 1010{
                num = (Int(moneyLabel.text ?? "") ?? 0) + (sender.tag - 10)
            }else{
                num = Int((moneyLabel.text ?? "0") + String(sender.tag - 10)) ?? 0
            }
        }
        
//        let input = "bonusAmount" + "\(300)" + "couponAmount" + "\(50)" + "couponId" + "\(1)" + "stakeAmount" + "\(200)" + "ts" + "\(1710579361)" + "userId" + "\(1)" + Secret
//        let md5 = md5(input)
//
//        print("Secret=====\(Secret)")
//        print("哈哈哈哈哈哈=====\(md5)")
        
        if num > MAX{
            sminLabel.textColor = .red
        }else {
            sminLabel.textColor = .hexColor(hex: "989898")
            moneyLabel.text = "\(num)"
        }
        
        if num >= 300{
            var bonusParam = BounsParam()
            bonusParam.amount = moneyLabel.text ?? ""
            var param = CouponListParam()
            param.amount = moneyLabel.text ?? ""
            param.scenario = "bet"
            if bmsmodelArr.count > 0{
                var oddsArr = Array<oddsModel>()
                for bmsmodel in bmsmodelArr{
                    var odds = oddsModel()
                    odds.oddsFormat = 1
                    odds.betOdds = bmsmodel.op?.od
                    oddsArr.append(odds)
                }
                param.odds = oddsArr
                bonusParam.odds = oddsArr
            }else{
                var odds = oddsModel()
                odds.oddsFormat = 1
                odds.betOdds = peilvStr
                param.odds = [odds]
                bonusParam.odds = [odds]
            }
            
            AccabonusRequest.lodaAccabonusCalc(param: bonusParam) { amount in
                let amountStr = (amount == "0" ? "0" : String(format: "%.2f", Float(amount ?? "0") ?? 0))
                self.bounsMoney.text = "₦" + amountStr
            }
            
//            CouponRequest.couponAvailableAndBonus(param: param) { model in
//                //print("model==loadsos==\(model)")
//                if model.items?.count ?? 0 > 0{
//                    self.listItem = model.items ?? [itemModel]()
//                    self.listItem[0].selectBool = true
//                    self.prov.loadUI(models: self.listItem)
//                    self.tipsLabel.isHidden = false
//                    if model.items?[0].type == 1{
//                        self.tipsLabel.text = "\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }else{
//                        self.tipsLabel.text = "%\(model.items?[0].mainValue ?? "0")" + " coupons have been used"
//                    }
//                    
//                    self.benMoney.isHidden = false
//                    self.benLine.isHidden = false
//                    self.benMoney.text = "₦" + (self.moneyLabel.text ?? "0")
//                    self.endMoney.text = "Place Bet ₦\(model.afterAmount ?? 0)"
//                    self.userbounsMoney.text = "-₦\(model.bonus ?? 0)"
//                }else{
//                    self.prov.loadUI(models: [])
//                }
//            }
        }
        
        self.endMoney.text = "Place Bet ₦\(moneyLabel.text ?? "0")"
        result()
    }
    
    private func result(){
        let db1 = Float(moneyLabel.text ?? "0")
        let db2 = Float(peilvStr)
//        returnsMoney.text = "₦" + String(format: "%.2f", (db1 ?? 0) * (db2 ?? 0) - (db1 ?? 0))
        returnsMoney.text = "₦" + String(format: "%.2f", (db1 ?? 0) * (db2 ?? 0))
    }
    
    @IBAction func otherBtns(_ sender: UIButton) {
        switch sender.tag {
        case 1001: //x
            setXdata()
            break
        case 1002: //00
            if moneyLabel.text != "0"{
                let srt = (moneyLabel.text ?? "0") + "00"
                if Int(srt) ?? 0 > MAX{
                    sminLabel.textColor = .red
                }else {
                    sminLabel.textColor = .hexColor(hex: "989898")
                    moneyLabel.text = "\(srt)"
                    result()
                }
            }
            break
        case 1003: //clear
            cleardata()
            break
        case 1004: //done
            clickDone!()
            prov.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 285)
            break
        default:
            break
        }
    }
    
    private func setXdata(){
        if moneyLabel.text?.count ?? 0 > 0 && moneyLabel.text != "0"{
            let str = moneyLabel.text ?? ""
            let result = String(str.dropLast())
            moneyLabel.text = result
            if moneyLabel.text?.count == 0{
                moneyLabel.text = "0"
            }
        }else{
            moneyLabel.text = "0"
        }
        sminLabel.textColor = .hexColor(hex: "989898")
        result()
    }
    
    func cleardata(){
        moneyLabel.text = "0"
        frist = true
        returnsMoney.text = "₦0"
        //betBtn.setTitle("Place Bet ₦0", for: .normal)
        sminLabel.textColor = .hexColor(hex: "989898")
        self.setTipsDelegate(view: self)
        
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        accountMoney.text = account.wallets?.first?.balance
        
        /* */
        self.tipsLabel.isHidden = true
        self.benMoney.isHidden = true
        self.benLine.isHidden = true
        self.endMoney.text = "Place Bet ₦0"
        self.bounsMoney.text = "₦0"
        self.userbounsMoney.text = "-₦0"
        self.prov.loadUI(models: [])
    }
    
    @IBAction func clickStakeAndCoupon(_ sender: UIButton) {
        if sender.tag == 444{
            stake.backgroundColor = .hexColor(hex: "0CD664")
            promo.backgroundColor = .hexColor(hex: "F5F6F9")
            stake.setTitleColor(.white, for: .normal)
            promo.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
            prov.isHidden = true
        }else{
            stake.backgroundColor = .hexColor(hex: "F5F6F9")
            promo.backgroundColor = .hexColor(hex: "0CD664")
            stake.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
            promo.setTitleColor(.white, for: .normal)
            prov.isHidden = false
        }
    }

    func clickLeftBtn() {
        self.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.hiddenTipsView()
        Tool.getCurrentVc().tabBarController?.selectedIndex = 3
    }
    
    @IBAction func clickTopUpAccount(_ sender: UIButton) {
        clickTopUp!()
    }
    
    @IBAction func clickBounsTips(_ sender: UIButton) {
        bounsTips!()
    }
    
}
