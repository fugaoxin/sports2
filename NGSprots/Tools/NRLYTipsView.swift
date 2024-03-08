//
//  NRLYTipsView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/14.
//

import Foundation
import UIKit

extension UIView{
    private static var tipsBg = UILabel()
    private static var nytips:NYTipsView!
    
    func setTipsView(){
        UIView.tipsBg.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.windows.last?.addSubview(UIView.tipsBg)
        UIView.tipsBg.isHidden = true
        UIView.tipsBg.backgroundColor = .black
        UIView.tipsBg.alpha = 0.3
        UIView.tipsBg.isUserInteractionEnabled = true
        let touzhuBgtap = UITapGestureRecognizer(target: self, action: #selector(hiddenTipsView))
        UIView.tipsBg.addGestureRecognizer(touzhuBgtap)
        
        UIView.nytips = NYTipsView.init(frame: CGRect(x: (kScreenW - 280)/2, y: (kScreenH - 180)/2, width: 280, height: 180))
        UIApplication.shared.windows.last?.addSubview(UIView.nytips)
        UIView.nytips.isHidden = true
    }
    
    func showTipsView(title: String, subTitle: String, leftTitle: String, rightTitle: String){
        UIView.tipsBg.isHidden = false
        UIView.nytips.isHidden = false
        UIView.nytips.titleLabel.text = title
        UIView.nytips.subTitle.text = subTitle
        UIView.nytips.leftBtn.setTitle(leftTitle, for: .normal)
        UIView.nytips.rightBtn.setTitle(rightTitle, for: .normal)
    }
    
    @objc func hiddenTipsView(){
        UIView.tipsBg.isHidden = true
        UIView.nytips.isHidden = true
    }
    
    func setTipsDelegate(view: UIView){
        UIView.nytips.delegate = (view as? any NYTipsViewDelegate)
    }
    
    func setTipsDelegate(vc: UIViewController){
        UIView.nytips.delegate = vc as? any NYTipsViewDelegate
    }
    
}
