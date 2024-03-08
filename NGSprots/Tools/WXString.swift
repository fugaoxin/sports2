//
//  WXString.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/19.
//

import UIKit

extension String {
    // 截取字符串
    // - Parameter index: 截取从index位开始之前的字符串
    // - Returns: 返回一个新的字符串
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    // 截取字符串
    // - Parameter index: 截取从index位开始到末尾的字符串
    // - Returns: 返回一个新的字符串
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    //手机号码正则表达式
    func regexWithPhoneNumber() -> Bool{
        let regex = "^(1)\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    //用户名或者会员账号正则表达式
    func regexWithAccount() -> Bool{
        let regex = "^[a-zA-Z][a-zA-Z0-9]{5,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    //手机验证码正则表达式
    func regexWithCodeNumber() -> Bool{
        let regex = "^\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    //图形验证码正则表达式
    func regexWithCodePhoto() -> Bool{
        let regex = "^\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    //登录密码正则表达式
    func regexWithPassword() -> Bool{
        let regex = "[a-zA-Z0-9]{8,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    /**
     * 计算字符串长度
     */
    func sizeWithText(text: NSString, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
}
