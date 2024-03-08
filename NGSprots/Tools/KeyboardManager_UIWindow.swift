//
//  KeyboardManager_UIWindow.swift
//  SportsDemo
//
//  Created by Jean on 23/11/2023.
//

import UIKit

class KeyboardManager_UIWindow: NSObject {
    var keyboardFrame : CGRect?
    var nowTF : UITextField?
    
    static let manager =  KeyboardManager_UIWindow()
   
    override init(){
        super.init()
        setUpNotice()
    }
    func setUpNotice(){
        //键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditingNotification(_:)), name: UITextField.textDidEndEditingNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditingNotification(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        
    }
    @objc func keyboardWillShow(_ showNoti:Notification){
        if self.nowTF == nil{
            return
        }
        self.keyboardFrame = (showNoti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let tf : UITextField = self.nowTF!
        let view = self.getViewOnWindow(view: tf)
        if (view != nil) {
            let frame = tf.superview?.convert(tf.frame, to: Tool.keyWindow())//frame转换 输入框相对于window的frame
            let frame2 = view?.superview?.convert(view!.frame, from: Tool.keyWindow())
            let y = CGRectGetMaxY(frame ?? CGRect())
            let y2 = self.keyboardFrame?.origin.y
            let y3 = y2! - y - 8  //实际遮挡距离
            if y3<0{
                UIView.animate(withDuration: 0.25) {
                    if frame2 != nil{
                        view?.transform = CGAffineTransformMakeTranslation((frame2?.origin.x)!, y3)
                    }
                }
            }
        }
    }
    @objc func keyboardWillHide(_ hideNoti:Notification){
        
    }
    @objc func textDidEndEditingNotification(_ endEdit:Notification){
        let tf : UITextField = endEdit.object as! UITextField
        let view = self.getViewOnWindow(view: tf)
        if (view != nil) {
            UIView.animate(withDuration: 0.25) {
                view?.transform = CGAffineTransform.identity
            }
        }
    }
    @objc func textDidBeginEditingNotification(_ beginEdit:Notification){
        let tf : UITextField = beginEdit.object as! UITextField
        self.nowTF = tf
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
}
