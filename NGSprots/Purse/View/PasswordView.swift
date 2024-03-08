//
//  PasswordView.swift
//  NGSprots
//
//  Created by Jean on 25/12/2023.
//

import UIKit

protocol PasswordViewDelegate {
    //文本发生改变(插入或删除)时调用
    func passwordView(view:PasswordView,textChanged: String, length: Int)
    
    //输入完成(输入的长度与指定的密码最大长度相同)时调用
    func passwordView(view:PasswordView,textFinished: String)
}

class PasswordView: UIView, UIKeyInput {
    //输入的文本
    var text: NSMutableString?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var delegate: PasswordViewDelegate?
    
    //密码最大长度
    var maxLength: Int = 6
    
    var hasText: Bool {
        return text!.length > 0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardShow(_ showNoti:Notification){
       
        let keyBoardframe  = (showNoti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let view = self.getViewOnWindow(view: self)
        if (view != nil) {
            let framey = CGRectGetMinY(self.superview?.superview?.frame ?? CGRect()) + CGRectGetMaxY(self.frame) //frame转换 输入框相对于window的frame
            let frame2 = view?.superview?.convert(view!.frame, from: Tool.keyWindow())
            let y2 = keyBoardframe.origin.y
            let y3 = y2 - framey - 8  //实际遮挡距离
            if y3<0{
                UIView.animate(withDuration: 0.25) {
                    if frame2 != nil{
                        view?.transform = CGAffineTransformMakeTranslation((frame2?.origin.x)!, y3)
                    }
                }
            }
        }
    }
    
    @objc func keyboardHide(_ endEdit:Notification){
        let view = self.getViewOnWindow(view: self)
        if (view != nil) {
            UIView.animate(withDuration: 0.25) {
                view?.transform = CGAffineTransform.identity
            }
        }
    }
    func getViewOnWindow(view : UIView) ->UIView?{
        var nextV = view
        var nextResponder : UIResponder = view
        while !(nextResponder is UIWindow) {
            nextResponder = nextResponder.next ?? UIWindow.init()
            if nextResponder is UIViewController{
                return nil
            }
            if !(nextResponder is UIWindow) && (nextResponder is UIView){
                nextV = nextResponder as! UIView
            }
        }
        return nextV
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }
    func insertText(_ text: String) {
        if self.text!.length < maxLength {
            self.text!.append(text)
            delegate?.passwordView(view: self,textChanged: self.text as! String, length: self.text!.length)
            setNeedsDisplay()
            if self.text!.length == maxLength {
                self.resignFirstResponder()
                delegate?.passwordView(view: self,textFinished: self.text as! String)
            }
        }
    }
    
    func deleteBackward() {
        if self.text!.length > 0 {
            self.text!.deleteCharacters(in: NSRange(location: text!.length - 1, length: 1))
            delegate?.passwordView(view: self,textChanged: self.text as! String, length: self.text!.length)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = rect.width / CGFloat(maxLength) //每一个小格子的宽度
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(5)
        //外边框
        context.stroke(rect)
        let path = UIBezierPath()
        //画中间分隔的竖线
        (1..<maxLength).forEach { (index) in
            path.move(to: CGPoint(x: rect.origin.x + CGFloat(index) * width, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x + CGFloat(index) * width, y: rect.origin.y + rect.height))
        }
        context.addPath(path.cgPath)
        context.strokePath()
        
        var cornerRadius : CGFloat = 0
        if rect.height<60{
            cornerRadius = 8
        }else{
            cornerRadius = 12
        }
        (0..<maxLength).forEach { (index) in
            var otherPath = UIBezierPath()
            otherPath = UIBezierPath(roundedRect: CGRect(x: (width)*CGFloat(index), y: 0, width: width, height: rect.height), cornerRadius: cornerRadius)
            otherPath.lineWidth = 1
            context.addPath(otherPath.cgPath)
            context.strokePath()
        }
        //画圓点
        let pointSize = CGSize(width: 7, height: 7)
        (0..<self.text!.length).forEach { (index) in
            let origin = CGPoint(x: rect.origin.x + CGFloat(index) * width + (width - pointSize.width) / 2, y: rect.origin.y + (rect.height - pointSize.height) / 2)
            let pointRect = CGRect(origin: origin, size: pointSize)
            context.fillEllipse(in: pointRect)
        }
    }
    
    //键盘的样式 (UITextInputTraits中的属性)
    var keyboardType: UIKeyboardType {
        get{
            return .numberPad
        } set{
            
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isFirstResponder {
            becomeFirstResponder()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
