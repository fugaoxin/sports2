//
//  UIView+EmptyData.swift
//  SportsDemo
//
//  Created by Jean on 23/11/2023.
//

import Foundation
import UIKit

extension UIView{

    private static var emptyViewKey = true
    
    var emptyView : UIView?{
        get {
            return objc_getAssociatedObject(self, &UIView.emptyViewKey) as? UIView
            }
        set {
            objc_setAssociatedObject(self, &UIView.emptyViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
    }
    @discardableResult
    func showEmptyView(image: String, title: String, subtitle: String, btnStr: String?) -> UIButton?{

        if emptyView != nil{
            emptyView!.isHidden = false
            self.bringSubviewToFront(emptyView!)

            
            let imageV : UIImageView = emptyView?.viewWithTag(1001) as! UIImageView
            imageV.image = UIImage(named: image)

            let tilteLB : UILabel = emptyView?.viewWithTag(1002) as! UILabel
            tilteLB.text = title
            tilteLB.sizeToFit()
            if self.bounds.height<=120{
                tilteLB.center = CGPoint(x: imageV.center.x, y: CGRectGetMaxY(imageV.frame)+7+tilteLB.frame.size.height/2)
            }else{
                tilteLB.center = CGPoint(x: imageV.center.x, y: CGRectGetMaxY(imageV.frame)+14+tilteLB.frame.size.height/2)
            }
            let subTitleLB : UILabel = emptyView?.viewWithTag(1003) as! UILabel
            subTitleLB.frame = CGRect(x: 20, y: CGRectGetMaxY(tilteLB.frame)+5, width: self.bounds.width - 40, height: 15)
            subTitleLB.text = subtitle
            subTitleLB.sizeToFit()
            if self.bounds.height<=120{
                subTitleLB.center = CGPoint(x: imageV.center.x, y: CGRectGetMaxY(tilteLB.frame)+subTitleLB.frame.size.height/2)
            }else{
                subTitleLB.center = CGPoint(x: imageV.center.x, y: CGRectGetMaxY(tilteLB.frame)+5+subTitleLB.frame.size.height/2)
            }
            if emptyView?.viewWithTag(1004) != nil{
                let btn : UIButton = emptyView?.viewWithTag(1004) as! UIButton
                btn.setTitle(btnStr, for: .normal)
                return btn
            }
            if btnStr != nil && btnStr != ""{
                let label = emptyView?.viewWithTag(1003)
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: (self.bounds.width-270)/2, y: CGRectGetMaxY(label!.frame)+40, width: 270, height: 50)
                btn.setTitle(btnStr, for: .normal)
                btn.backgroundColor = .hexColor(hex: "0CD664")
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold",size: 14)
                emptyView!.addSubview(btn)
                btn.layer.cornerRadius = 25
                btn.layer.masksToBounds = true
                btn.tag = 1004
                return btn
            }
            return nil
        }else{
            if btnStr?.isEmpty == false && self.bounds.height < 200 {
                assertionFailure("superView -> Lack of height (高度不足)")
                return nil
            }
            if btnStr?.isEmpty == true && self.bounds.height < 110{
                assertionFailure("superView -> Lack of height (高度不足)")
                return nil
            }
            let view = UIView(frame: self.bounds)
            view.backgroundColor = .hexColor(hex: "F7F7F7")
            self.addSubview(view)
            self.bringSubviewToFront(view)
            emptyView = view
            
            let iv : UIImage  = UIImage(named: image)!
            let emptyIV = UIImageView.init()
            if iv.size.height > 70{
                if iv.size.height/2 > 70{
                    emptyIV.frame.size = CGSize(width: iv.size.width/3, height: iv.size.height/3)
                }else{
                    emptyIV.frame.size = CGSize(width: iv.size.width/2, height: iv.size.height/2)
                }
            }else{
                emptyIV.frame.size = CGSize(width: iv.size.width, height: iv.size.height)
            }
            emptyIV.center = CGPoint(x: view.center.x, y: view.center.y)
            emptyIV.image = UIImage(named: image)
            emptyIV.tag = 1001
            view.addSubview(emptyIV)
            emptyIV.contentMode = .scaleAspectFill
            
            if CGRectGetMinY(emptyIV.frame) >= 65 && CGRectGetMinY(emptyIV.frame) < 100{
                emptyIV.center = CGPoint(x: view.center.x, y: view.center.y - 40)
            }else if CGRectGetMinY(emptyIV.frame) >= 100{
                emptyIV.center = CGPoint(x: view.center.x, y: view.center.y - 90)
            }else if  CGRectGetMinY(emptyIV.frame) >= 35 &&  CGRectGetMinY(emptyIV.frame) < 65{
                emptyIV.center = CGPoint(x: view.center.x, y: view.center.y - 15)
            }else{
                emptyIV.center = CGPoint(x: view.center.x, y: 27)
            }
            
            let emptyLB = UILabel()
            emptyLB.frame = CGRect(x: 20, y: CGRectGetMaxY(emptyIV.frame)+14, width: self.bounds.width-40, height: 0.1)
            emptyLB.text = title
            emptyLB.sizeToFit()
            if self.bounds.height<=120{
                emptyLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(emptyIV.frame)+7+emptyLB.frame.size.height/2)
            }else{
                emptyLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(emptyIV.frame)+14+emptyLB.frame.size.height/2)
            }
            emptyLB.font = UIFont(name: "PingFangSC-Semibold",size: 15)
            emptyLB.textColor = .hexColor(hex: "101010")
            emptyLB.textAlignment = .center
            emptyLB.tag = 1002
            view.addSubview(emptyLB)
            
            
            let emptySubTitleLB = UILabel()
//            emptySubTitleLB.frame = CGRect(x: 20, y: CGRectGetMaxY(emptyLB.frame)+5, width: self.bounds.width - 40, height: 15)
            emptySubTitleLB.text = subtitle
            emptySubTitleLB.numberOfLines = 0
            emptySubTitleLB.sizeToFit()
            if self.bounds.height<=120{
                emptySubTitleLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(emptyLB.frame)+emptySubTitleLB.frame.size.height/2)
            }else{
                emptySubTitleLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(emptyLB.frame)+5+emptySubTitleLB.frame.size.height/2)
            }
            emptySubTitleLB.font = UIFont(name: "PingFangSC-Regular",size: 12)
            emptySubTitleLB.textColor = .hexColor(hex: "969696")
            emptySubTitleLB.textAlignment = .center
            emptySubTitleLB.tag = 1003
            view.addSubview(emptySubTitleLB)
            
            if btnStr != nil && btnStr != ""{
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: (self.bounds.width-270)/2, y: CGRectGetMaxY(emptySubTitleLB.frame)+30, width: 270, height: 50)
                btn.setTitle(btnStr, for: .normal)
                btn.backgroundColor = .hexColor(hex: "0CD664")
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold",size: 14)
                view.addSubview(btn)
                btn.layer.cornerRadius = 25
                btn.layer.masksToBounds = true
                btn.tag = 1004
                return btn
            }
            return nil
        }
    }
    
    func hiddenEmptyView(){
        if emptyView != nil{
            emptyView!.isHidden = true
        }
    }
    func layoutEmptyView(){
        if emptyView != nil{
            emptyView?.frame = self.bounds
            
            let emptyIV : UIImageView = emptyView?.viewWithTag(1001) as! UIImageView
            emptyIV.center = CGPoint(x: emptyView!.center.x, y: emptyView!.center.y)
            if CGRectGetMinY(emptyIV.frame) >= 65 && CGRectGetMinY(emptyIV.frame) < 100{
                emptyIV.center = CGPoint(x: emptyView!.center.x, y: emptyView!.center.y - 30)
            }else if CGRectGetMinY(emptyIV.frame) >= 100{
                emptyIV.center = CGPoint(x: emptyView!.center.x, y: emptyView!.center.y - 70)
            }else if  CGRectGetMinY(emptyIV.frame) >= 35 &&  CGRectGetMinY(emptyIV.frame) < 65{
                emptyIV.center = CGPoint(x: emptyView!.center.x, y: emptyView!.center.y - 15)
            }else{
                emptyIV.center = CGPoint(x: emptyView!.center.x, y: 27)
            }
            let tilteLB : UILabel = emptyView?.viewWithTag(1002) as! UILabel
            tilteLB.sizeToFit()
            tilteLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(emptyIV.frame)+14+tilteLB.frame.size.height/2)

            let subTitleLB : UILabel = emptyView?.viewWithTag(1003) as! UILabel
            subTitleLB.sizeToFit()
            subTitleLB.center = CGPoint(x: emptyIV.center.x, y: CGRectGetMaxY(tilteLB.frame)+5+subTitleLB.frame.size.height/2)

            if emptyView?.viewWithTag(1004) != nil{
                let btn : UIButton = emptyView?.viewWithTag(1004) as! UIButton
                btn.frame = CGRect(x: (self.bounds.width-270)/2, y: CGRectGetMaxY(subTitleLB.frame)+40, width: 270, height: 50)
            }
        }
    }
}
class BlackView:UIView,UIGestureRecognizerDelegate{
    var tapBgblock : (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickBg))
        tap.delegate = self
        self.addGestureRecognizer(tap);
    }
    @objc func clickBg(){
        if self.tapBgblock != nil{
            self.tapBgblock!()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self{
            return true
        }else{
            return false
        }
    }
}

extension UIWindow{
    private static var blackBgKey = true
    
    @objc var blackBg : BlackView?{
        get {
            return objc_getAssociatedObject(self, &UIWindow.blackBgKey) as? BlackView
            }
        set {
            objc_setAssociatedObject(self, &UIWindow.blackBgKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
    }
    func initBlackView(){
        if Tool.keyWindow().blackBg == nil{
            let view = BlackView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.blackBg = view
            Tool.keyWindow().addSubview(view)
            Tool.keyWindow().bringSubviewToFront(view)
            Tool.keyWindow().blackBg = view
            Tool.keyWindow().blackBg?.isHidden = true
        }
    }
    func showInWindow(functionView : UIView){
        if Tool.keyWindow().blackBg != nil{
            let arr : Array<UIView> = Tool.keyWindow().blackBg!.subviews
            for subview in arr {
                subview.removeFromSuperview()
            }
            Tool.keyWindow().bringSubviewToFront(Tool.keyWindow().blackBg!)
            Tool.keyWindow().blackBg!.isHidden = false
        }else{
            let view = BlackView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            Tool.keyWindow().addSubview(view)
            Tool.keyWindow().bringSubviewToFront(view)
            self.blackBg = view
            if Tool.keyWindow().blackBg?.tapBgblock == nil{
                Tool.keyWindow().blackBg?.tapBgblock = {
                    Tool.keyWindow().hiddenInWindow()
                }
            }
        }
        self.blackBg!.addSubview(functionView)
        self.blackBg!.bringSubviewToFront(functionView)
        functionView.isHidden = false
    }
    func hiddenInWindow(){
        if Tool.keyWindow().blackBg != nil{
            let arr : Array<UIView> = Tool.keyWindow().blackBg!.subviews
            if arr.count == 0{
                Tool.keyWindow().blackBg!.isHidden = true
            }
            for subview in arr {
                UIView.animate(withDuration: 0.25, animations: {
                    subview.transform = CGAffineTransform.identity
                },completion:  { _ in
                    subview.removeFromSuperview()
                    Tool.keyWindow().blackBg!.isHidden = true
                })
            }
        }      
    }
}
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

