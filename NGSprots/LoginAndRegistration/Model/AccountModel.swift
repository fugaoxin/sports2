//
//  AccountModel.swift
//  NGSprots
//
//  Created by Jean on 30/11/2023.
//

import UIKit
import HandyJSON

class LoginModel:HandyJSON {
    //MARK: - token 登陆或注册返回的业务接口需要的token
    var token:String?
    //MARK: - access_token 为修改密码时需要的入参，在申请修改密码时返回
    var access_token:String?
    
    var `self`:AccountModel?
    var fb:fbModel?
    required init(){
       
    }
    class func getToken()->String{
        return UserDefaults.standard.value(forKey: "token") as! String? ?? ""
    }
    class func getAccess_token()->String{
        return UserDefaults.standard.value(forKey: "access_token") as! String? ?? ""
    }
}

class AccountModel: NSObject,HandyJSON,NSSecureCoding {
    required override init() {
        
    }
    
    var id:Int?
    var account: String?
    var nickname: String?
    var address: String?
    var yearOfBirth: String?
    var monthOfBirth: String?
    var dayOfBirth: String?
    var state: String?
    var region: String?
    var gender: String?
    var createTime: Int?
    var avatar: String?
    var areaCode: String?
    var phoneNum: String?
    var countryId: Int?
    var currency: String?
    var language: String?
    var oddsType: String?
    var oddsChange: Int?
    var handicapDisplayType: Int?
    var vipLevel: Int?
    var email: String?
    var hasPayPassword: Bool?
    var wallets: [WalletModel]?
    static var supportsSecureCoding: Bool{return true}


    required init?(coder aCoder: NSCoder) {
        id = aCoder.decodeObject(forKey: "id") as? Int
        account = aCoder.decodeObject(forKey: "account") as? String
        nickname = aCoder.decodeObject(forKey: "nickname") as? String
        address = aCoder.decodeObject(forKey: "address") as? String
        yearOfBirth = aCoder.decodeObject(forKey: "yearOfBirth") as? String
        monthOfBirth = aCoder.decodeObject(forKey: "monthOfBirth") as? String
        dayOfBirth = aCoder.decodeObject(forKey: "dayOfBirth") as? String
        state = aCoder.decodeObject(forKey: "state") as? String
        region = aCoder.decodeObject(forKey: "region") as? String
        gender = aCoder.decodeObject(forKey: "gender") as? String
        createTime = aCoder.decodeObject(forKey: "createTime") as? Int
        avatar = aCoder.decodeObject(forKey: "avatar") as? String
        areaCode = aCoder.decodeObject(forKey: "areaCode") as? String
        phoneNum = aCoder.decodeObject(forKey: "phoneNum") as? String
        countryId = aCoder.decodeObject(forKey: "countryId") as? Int
        currency = aCoder.decodeObject(forKey: "currency") as? String
        language = aCoder.decodeObject(forKey: "language") as? String
        oddsType = aCoder.decodeObject(forKey: "oddsType") as? String
        oddsChange = aCoder.decodeObject(forKey: "oddsChange") as? Int
        handicapDisplayType = aCoder.decodeObject(forKey: "handicapDisplayType") as? Int
        vipLevel = aCoder.decodeObject(forKey: "vipLevel") as? Int
        email = aCoder.decodeObject(forKey: "email") as? String
        hasPayPassword = aCoder.decodeObject(forKey: "hasPayPassword") as? Bool
        wallets = aCoder.decodeObject(forKey: "wallets") as? [WalletModel]
    }
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(account, forKey: "account")
        coder.encode(address, forKey: "address")
        coder.encode(yearOfBirth, forKey: "yearOfBirth")
        coder.encode(monthOfBirth, forKey: "monthOfBirth")
        coder.encode(dayOfBirth, forKey: "dayOfBirth")
        coder.encode(state, forKey: "state")
        coder.encode(region, forKey: "region")
        coder.encode(gender, forKey: "gender")
        coder.encode(createTime, forKey: "createTime")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(areaCode, forKey: "areaCode")
        coder.encode(phoneNum, forKey: "phoneNum")
        coder.encode(countryId, forKey: "countryId")
        coder.encode(currency, forKey: "currency")
        coder.encode(language, forKey: "language")
        coder.encode(oddsType, forKey: "oddsType")
        coder.encode(oddsChange, forKey: "oddsChange")
        coder.encode(handicapDisplayType, forKey: "handicapDisplayType")
        coder.encode(vipLevel, forKey: "vipLevel")
        coder.encode(email, forKey: "email")
        coder.encode(hasPayPassword, forKey: "hasPayPassword")
        coder.encode(wallets, forKey: "wallets")
    }
    
}

class fbModel: NSObject,HandyJSON,NSSecureCoding {
    required override init() {
        
    }
    var baseUrl: String?
    var token: String?
    var virtualUrl: String?
    static var supportsSecureCoding: Bool{return true}
    
    required init?(coder aCoder: NSCoder) {
        baseUrl = aCoder.decodeObject(forKey: "baseUrl") as? String
        token = aCoder.decodeObject(forKey: "token") as? String
        virtualUrl = aCoder.decodeObject(forKey: "virtualUrl") as? String
    }
    func encode(with coder: NSCoder) {
        coder.encode(baseUrl, forKey: "baseUrl")
        coder.encode(token, forKey: "token")
        coder.encode(virtualUrl, forKey: "virtualUrl")
    }
    
}

class WalletModel: NSObject,HandyJSON,NSSecureCoding {
    required override init() {
        
    }
    var id: Int?
    //用户id
    var userId: Int?
    //币种编码
    var currency: String?
    //余额
    var balance: String?
    //奖金余额
    var bonus: String?
    //0:本平台，其他数字为上游平台id
    var platformId: Int?
    //状态：1正常，2冻结
    var status: Int?
    //创建时间
    var createTime: Int?
    //更新时间
    var updateTime: Int?
    
    //冻结金额
    var block: String?
    
    static var supportsSecureCoding: Bool{return true}
    
    required init?(coder aCoder: NSCoder) {
        id = aCoder.decodeObject(forKey: "id") as? Int
        userId = aCoder.decodeObject(forKey: "userId") as? Int
        currency = aCoder.decodeObject(forKey: "currency") as? String
        balance = aCoder.decodeObject(forKey: "balance") as? String
        platformId = aCoder.decodeObject(forKey: "platformId") as? Int
        status = aCoder.decodeObject(forKey: "status") as? Int
        createTime = aCoder.decodeObject(forKey: "createTime") as? Int
        updateTime = aCoder.decodeObject(forKey: "updateTime") as? Int
        bonus = aCoder.decodeObject(forKey: "bonus") as? String
    }
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(userId, forKey: "userId")
        coder.encode(currency, forKey: "currency")
        coder.encode(balance, forKey: "balance")
        coder.encode(platformId, forKey: "platformId")
        coder.encode(status, forKey: "status")
        coder.encode(createTime, forKey: "createTime")
        coder.encode(updateTime, forKey: "updateTime")
        coder.encode(bonus, forKey: "bonus")
    }
    
}
