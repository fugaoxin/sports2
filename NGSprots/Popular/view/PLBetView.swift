//
//  PLBetView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/2.
//

import Foundation
import UIKit

extension UIView: BetViewDelegate{
    func stakeAndPromoview(index: Int) {
        UIView.stakeAndproType = index
        if index == 2{
            UIView.betview.frame = CGRect(x: 0, y: kScreenH - 350, width: kScreenW, height: 350)
        }else{
            UIView.betview.frame = CGRect(x: 0, y: kScreenH - 470, width: kScreenW, height: 470)
        }
    }
    
    private static var touzhuBg = UILabel()
    private static var betview:BetView!
    static var stakeAndproType = 1
    func setBet(){
        UIView.touzhuBg.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.windows.last?.addSubview(UIView.touzhuBg)
        UIView.touzhuBg.backgroundColor = .black
        UIView.touzhuBg.alpha = 0.5
        UIView.touzhuBg.isUserInteractionEnabled = true
        let touzhuBgtap = UITapGestureRecognizer(target: self, action: #selector(hiddenBetView))
        UIView.touzhuBg.addGestureRecognizer(touzhuBgtap)
        UIView.betview = BetView.init(frame: CGRect(x: 0, y: kScreenH - 470, width: kScreenW, height: 470))
        UIApplication.shared.windows.last?.addSubview(UIView.betview)
        UIView.betview.delegate = self
        UIView.touzhuBg.isHidden = true
        UIView.betview.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditingNotification(_:)), name: UITextField.textDidEndEditingNotification, object: nil)
    }
    
    func showBetView(model: opModel){
        UIView.touzhuBg.isHidden = false
        UIView.betview.isHidden = false
        
        var str = ""
        let ty = model.ty ?? 0
        if ty == 1 || ty == 2{
            str = "\(model.ty ?? 0)"
        }else if ty == 3{
            str = "X"
        }else{
            str = model.nm ?? ""
        }
        UIView.betview.ngnmLabel.text = (model.ngnm ?? "") + " : " + str
        UIView.betview.opodLabel.text = "@" + (model.od ?? "")
        UIView.betview.matchnmLabel.text = model.recordsnm
    }
    
    @objc func keyboardWillShow(_ showNoti:Notification){
        let frame = (showNoti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(frame.origin.y)
        print(frame.height)
        UIView.animate(withDuration: 0.25) {
            if UIView.stakeAndproType == 1{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - (frame.height + 450), width: kScreenW, height: 470)
            }else{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - (frame.height + 330), width: kScreenW, height: 350)
            }
        }
    }
    
    @objc func textDidEndEditingNotification(_ endEdit:Notification){
        UIView.animate(withDuration: 0.25) {
            if UIView.stakeAndproType == 1{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - 470, width: kScreenW, height: 470)
            }else{
                UIView.betview.frame = CGRect(x: 0, y: kScreenH - 350, width: kScreenW, height: 350)
            }
        }
    }
    
    @objc func hiddenBetView(){
        UIView.touzhuBg.isHidden = true
        UIView.betview.isHidden = true
        UIView.betview.res()
    }
}
