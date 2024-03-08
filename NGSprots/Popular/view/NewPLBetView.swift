//
//  NewPLBetView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import Foundation
import UIKit

extension UIView: NewBetViewDelegate,BetEndViewDelegate{
    func CalculatorEndViewLeftTarget() {
        UIView.touzhuBg.isHidden = true
        UIView.betendview.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "history"), object: nil)
    }
    
    func CalculatorEndViewRightTarget() {
        UIView.touzhuBg.isHidden = true
        UIView.betendview.isHidden = true
    }

    func newStakeAndPromoview(index: Int) {
        UIView.stakeAndproTypeNew = index
        if index == 2{
            UIView.betview.frame = CGRect(x: 0, y: kScreenH - 530, width: kScreenW, height: 530)
        }else{
            if UIView.calculatorType == 1{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - 430, width: kScreenW, height: 430)
            }else{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - 550, width: kScreenW, height: 550)
            }
        }
    }
    
    private static var touzhuBg = UILabel()
    private static var betview:NewBetView!
    private static var betendview:BetEndView!
    static var stakeAndproTypeNew = 1
    static var calculatorType = 1
    func setNewBet(){
        UIView.touzhuBg.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.windows.last?.addSubview(UIView.touzhuBg)
        UIView.touzhuBg.backgroundColor = .black
        UIView.touzhuBg.alpha = 0.5
        UIView.touzhuBg.isUserInteractionEnabled = true
        let touzhuBgtap = UITapGestureRecognizer(target: self, action: #selector(hiddenNewBetView))
        UIView.touzhuBg.addGestureRecognizer(touzhuBgtap)
        UIView.betview = NewBetView.init(frame: CGRect(x: 0, y: kScreenH - 430, width: kScreenW, height: 430))
        UIApplication.shared.windows.last?.addSubview(UIView.betview)
        UIView.betview.delegate = self
        UIView.touzhuBg.isHidden = true
        UIView.betview.isHidden = true

        UIView.betendview = BetEndView.init(frame: CGRect(x: 0, y: kScreenH - 320, width: kScreenW, height: 320))
        UIApplication.shared.windows.last?.addSubview(UIView.betendview)
        UIView.betendview.delegate = self
        UIView.betendview.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeHH), name: NSNotification.Name(rawValue: "calculator"), object: nil)
    }
    
    @objc private func onChangeHH(_ notify: NSNotification) {
        let dict = notify.userInfo
        UIView.calculatorType = dict?["number"] as! Int
        if UIView.calculatorType == 1{
            UIView.betview.frame = CGRect(x: 0, y: kScreenH - 430, width: kScreenW, height: 430)
        }else{
            UIView.betview.frame = CGRect(x: 0, y: kScreenH - 550, width: kScreenW, height: 550)
        }
    }
    
    func showNewBetView(model: opModel){
        UIView.touzhuBg.isHidden = false
        UIView.betview.isHidden = false
        UIView.betview.skv.loadUI(model: model)
    }
    
    func showCalculatorEndView(model: opModel, msg: String, money: String){
        if msg == "Bet Placed successfully" || msg == "Created..." || msg == "Confirming..."{
            UIView.betendview.endBtn.setImage(UIImage(named: "组 124424"), for: .normal)
        }else{
            UIView.betendview.endBtn.setImage(UIImage(named: "组 780"), for: .normal)
        }
        UIView.betview.isHidden = true
        UIView.betendview.isHidden = false
        UIView.betendview.endLabel.text = msg
        UIView.betendview.bg1.isHidden = false
        UIView.betendview.bg2.isHidden = true
        //UIView.betendview.label1.text = (model.ngnm ?? "") + " : " + getTYType(key: model.ty ?? 0)
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
        UIView.betendview.label1.text = (model.ngnm ?? "") + " : " + str
        
        UIView.betendview.label2.text = model.recordsnm
        UIView.betendview.peilv.text = "@" + (model.od ?? "0")
        UIView.betendview.benjin.text = "₦ " + money
        let db1 = Float(money)
        let db2 = Float(model.od ?? "0")
        UIView.betendview.keying.text = "₦ " + String(format: "%.2f", ((db1 ?? 0) * (db2 ?? 0)))
    }
    
    func loadBms(bsmodel: bmsModel){
        UIView.betview.skv.loadBms(bmsmodel: bsmodel)
    }
    
    func setDelegate(view: UIViewController){
        UIView.betview.skv.delegate = (view as! any NewStakeViewDelegate)
    }
    
    @objc func hiddenNewBetView(){
        UIView.touzhuBg.isHidden = true
        UIView.betview.isHidden = true
        UIView.betendview.isHidden = true
        UIView.betview.skv.cleardata()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenNewBetView"), object: nil)
    }
}
