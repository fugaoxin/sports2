//
//  SBTips.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/3.
//

import Foundation
let isShowHudToken = "isShowHudToken"
extension UIViewController{
    func showTextSB(_ text: String?, dismissAfterDelay: TimeInterval) {
        if Tool.getuserInfoModel() == nil{
            let value = UserDefaults.standard.object(forKey: isShowHudToken)
            if text?.contains("token") == true && value != nil{
                return
            }
        }
        let tipsview = UIView(frame: CGRect(x: CGFloat(30), y: 100, width: kScreenW - 60, height: 66))
        tipsview.backgroundColor = .hexColor(hex: "333333")
        tipsview.layer.cornerRadius = 15
        tipsview.layer.masksToBounds = true
        let img = UIImageView(frame: CGRect(x: 16, y: 20.5, width: 25, height: 25))
        img.image = UIImage(named: "tipsx")
        tipsview.addSubview(img)
        let lab = UILabel(frame: CGRect(x: Int(img.frame.origin.x + img.frame.width) + 16, y: 20, width: Int(kScreenW) - 60 - 57, height: 26))
        tipsview.addSubview(lab)
        lab.text = text
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 2
        self.view.addSubview(tipsview)
        hideSB(dismissAfterDelay, v: tipsview)
        if Tool.getuserInfoModel() == nil{
            if text?.contains("token") == true{
                UserDefaults.standard.set(1, forKey: isShowHudToken)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func showTextSBimg(_ text: String?, dismissAfterDelay: TimeInterval, imgstr: String?) {
        let tipsview = UIView(frame: CGRect(x: CGFloat(30), y: 100, width: kScreenW - 60, height: 66))
        tipsview.backgroundColor = .hexColor(hex: "333333")
        tipsview.layer.cornerRadius = 15
        tipsview.layer.masksToBounds = true
        let img = UIImageView(frame: CGRect(x: 16, y: 20.5, width: 25, height: 25))
        if imgstr == nil{
            img.image = UIImage(named: "paySelect")
        }else{
            img.image = UIImage(named: imgstr ?? "")
        }
        tipsview.addSubview(img)
        let lab = UILabel(frame: CGRect(x: Int(img.frame.origin.x + img.frame.width) + 16, y: 20, width: Int(kScreenW) - 60 - 57, height: 26))
        tipsview.addSubview(lab)
        lab.text = text
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 2
        self.view.addSubview(tipsview)
        hideSB(dismissAfterDelay, v: tipsview)
    }
    
    func hideSB(_ afterDelay: TimeInterval, v: UIView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterDelay) {
            v.removeFromSuperview()
        }
    }
    
}

extension UIWindow{
    func showTextSB(_ text: String?, dismissAfterDelay: TimeInterval) {
        if Tool.getuserInfoModel() == nil{
            let value = UserDefaults.standard.object(forKey: isShowHudToken)
            if text?.contains("token") == true && value != nil{
                return
            }
        }
        let tipsview = UIView(frame: CGRect(x: CGFloat(30), y: 100, width: kScreenW - 60, height: 66))
        tipsview.backgroundColor = .hexColor(hex: "333333")
        tipsview.layer.cornerRadius = 15
        tipsview.layer.masksToBounds = true
        let img = UIImageView(frame: CGRect(x: 16, y: 20.5, width: 25, height: 25))
        img.image = UIImage(named: "tipsx")
        tipsview.addSubview(img)
        let lab = UILabel(frame: CGRect(x: Int(img.frame.origin.x + img.frame.width) + 16, y: 20, width: Int(kScreenW) - 60 - 57, height: 26))
        tipsview.addSubview(lab)
        lab.text = text
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 14)
        Tool.keyWindow().addSubview(tipsview)
        hideSB(dismissAfterDelay, v: tipsview)
        
        if Tool.getuserInfoModel() == nil{
            if text?.contains("token") == true{
                UserDefaults.standard.set(1, forKey: isShowHudToken)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func showTextSBimg(_ text: String?, dismissAfterDelay: TimeInterval, imgstr: String?) {
        let tipsview = UIView(frame: CGRect(x: CGFloat(30), y: 100, width: kScreenW - 60, height: 66))
        tipsview.backgroundColor = .hexColor(hex: "333333")
        tipsview.layer.cornerRadius = 15
        tipsview.layer.masksToBounds = true
        let img = UIImageView(frame: CGRect(x: 16, y: 20.5, width: 25, height: 25))
        if imgstr == nil{
            img.image = UIImage(named: "paySelect")
        }else{
            img.image = UIImage(named: imgstr ?? "")
        }
        tipsview.addSubview(img)
        let lab = UILabel(frame: CGRect(x: Int(img.frame.origin.x + img.frame.width) + 16, y: 20, width: Int(kScreenW) - 60 - 57, height: 26))
        tipsview.addSubview(lab)
        lab.text = text
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 2
        Tool.keyWindow().addSubview(tipsview)
        hideSB(dismissAfterDelay, v: tipsview)
    }
    
    func hideSB(_ afterDelay: TimeInterval, v: UIView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterDelay) {
            v.removeFromSuperview()
        }
    }
}
