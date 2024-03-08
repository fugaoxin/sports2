//
//  NewStakeView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import UIKit

protocol NewStakeViewDelegate {
    func settleAccounts(money: String, model: opModel)
    func topUpAccount()
}

class NewStakeView: UIView, NYTipsViewDelegate{

    @IBOutlet weak var moneyBgview: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var accountMoney: UILabel!
    
    @IBOutlet weak var ngnmLabel: UILabel!
    @IBOutlet weak var matchnmLabel: UILabel!
    @IBOutlet weak var opodLabel: UILabel!
    
    @IBOutlet weak var sminLabel: UILabel!
    @IBOutlet weak var returnsMoney: UILabel!
    
    @IBOutlet weak var betBtn: UIButton!
    @IBOutlet weak var couponsTips: UILabel!
    @IBOutlet weak var calculatorHH: NSLayoutConstraint!
    
    var delegate:NewStakeViewDelegate?
    
    var opmodel:opModel?
    
    //记录第一次
    var frist = true
    //最大金额
    var MAX = 3000
    //最小金额
    var MIN = 600
    var peilvStr = "1.5"
    
    var couponList:((_ models: [itemModel])->Void)?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("NewStakeView", owner: self, options: nil)?.first as! UIView
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
        
        calculatorHH.constant = 0
        NotificationCenter.default.addObserver(self, selector: #selector(onLoadBalance), name: NSNotification.Name(rawValue: "balance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(roloadAccount), name: NSNotification.Name(rawValue: LoginNotice), object: nil)
    }
    
    @objc func roloadAccount(){
        accountMoney.text = Tool.getuserInfoModel()?.wallets?.first?.balance ?? "0"
    }
    
    @objc func onLoadBalance(){
        accountMoney.text = Tool.getuserInfoModel()?.wallets?.first?.balance ?? "0"
    }
    
    @objc func clickMoneyBg(){
        if calculatorHH.constant == 0{
            calculatorHH.constant = 120
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calculator"), object: nil, userInfo: ["number":2])
        }else{
            calculatorHH.constant = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calculator"), object: nil, userInfo: ["number":1])
        }
    }
    
    private func loadCoupon(od: String, amount: String){
//        var odds = oddsModel()
//        odds.oddsFormat = 1
//        odds.betOdds = od
//        var param = CouponListParam()
//        param.amount = amount
//        param.scenario = "bet"
//        param.odds = [odds]
//        CouponRequest.couponAvailableAndBonus(param: param) { model in
//            self.couponList!(model.items ?? [itemModel]())
//        }
    }
    
    func loadUI(model: opModel){
        cleardata()
        self.opmodel = model
        peilvStr = model.od ?? ""
        accountMoney.text = Tool.getuserInfoModel()?.wallets?.first?.balance ?? "0"
        
//        var str = ""
//        let ty = model.ty ?? 0
//        if ty == 1 || ty == 2{
//            str = "\(model.ty ?? 0)"
//        }else if ty == 3{
//            str = "X"
//        }else{
//            str = model.nm ?? ""
//        }
        
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
        
        ngnmLabel.text = (model.ngnm ?? "") + " : " + str
        opodLabel.text = "@" + (model.od ?? "")
        matchnmLabel.text = model.recordsnm
        
        loadCoupon(od: model.od ?? "", amount: "0")
    }
    
    func loadBms(bmsmodel: bmsModel){
        MAX = bmsmodel.smax ?? 0
        MIN = bmsmodel.smin ?? 0
        sminLabel.text = "₦ \(MIN)" + " - " + "₦ \(MAX)"
        
        let od1:Float = Float(peilvStr) ?? 0
        let od2:Float = Float(bmsmodel.op?.od ?? "0") ?? 0
        if od1 < od2{
            opodLabel.textColor = .hexColor(hex: "FF3344")
            loadCoupon(od: bmsmodel.op?.od ?? "0", amount: moneyLabel.text ?? "0")
        }else if od1 > od2{
            opodLabel.textColor = .hexColor(hex: "0CD664")
            loadCoupon(od: bmsmodel.op?.od ?? "0", amount: moneyLabel.text ?? "0")
        }else{
            opodLabel.textColor = .hexColor(hex: "19263C")
        }
        
        peilvStr = bmsmodel.op?.od ?? "0"
        opodLabel.text = "@" + "\(bmsmodel.op?.od ?? "0")"
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickBetBtn(_ sender: UIButton) {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.id == nil{
            Tool.goToLogin()
            return
        }
        let acnum: Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
        let num: Float = Float(moneyLabel.text ?? "") ?? 0
        if num > acnum{
            self.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
        }else{
            if num < Float(MIN){
                sminLabel.textColor = .red
                return
            }
            delegate?.settleAccounts(money: "\(num)", model: self.opmodel ?? opModel())
        }
    }
    
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
        
        if num > MAX{
            sminLabel.textColor = .red
        }else {
            sminLabel.textColor = .hexColor(hex: "989898")
            moneyLabel.text = "\(num)"
        }
        
        if num >= MIN && num <= MAX{
            loadCoupon(od: peilvStr, amount: "\(num)")
        }
        
        result()
    }
    
    private func result(){
        let db1 = Float(moneyLabel.text ?? "0")
        let db2 = Float(peilvStr)
//        returnsMoney.text = "₦" + String(format: "%.2f", (db1 ?? 0) * (db2 ?? 0) - (db1 ?? 0))
        returnsMoney.text = "₦" + String(format: "%.2f", (db1 ?? 0) * (db2 ?? 0))
        betBtn.setTitle("Place Bet ₦" + (moneyLabel.text ?? "0"), for: .normal)
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
            calculatorHH.constant = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calculator"), object: nil, userInfo: ["number":1])
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
        betBtn.setTitle("Place Bet ₦0", for: .normal)
        sminLabel.textColor = .hexColor(hex: "989898")
        self.setTipsDelegate(view: self)
    }
    
    @IBAction func clickToUp(_ sender: UIButton) {
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if account.id == nil{
            Tool.goToLogin()
            return
        }
        delegate?.topUpAccount()
    }
    
    func clickLeftBtn() {
        self.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.hiddenTipsView()
        self.hiddenNewBetView()
        Tool.getCurrentVc().tabBarController?.selectedIndex = 3
    }

}
