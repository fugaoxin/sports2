//
//  BaseSystemParam.swift
//  NGSprots
//
//  Created by Jean on 12/12/2023.
//

import Foundation
import HandyJSON

struct BaseSystemParam:HandyJSON {
    //MARK: -系统基础配置接口入参
    //国家id
    var countryId: Int?
    //币种
    var currency: String? = Tool.getuserInfoModel()?.currency
    
    //获取popular控制器 运动种类  1顶部导航，2 highlight, 3 live ,4 virtual
    var navType: Int?
    
    var navClassIds : [Int]?
    
    var current: Int?
    
    var pageSize : Int?
}
struct CountryAreaModel:HandyJSON {
    var id: Int?
    //国家编号
    var name: String?

    var cnName: String?
    
    var localName: String?
    
    var state : [CountryStateCityModel]?
    
    var isSelect : Bool?
}
struct StatesModel:HandyJSON {
    var states: [String]?

    var regions: [String]?
}
struct CountryStateCityModel:HandyJSON {
    var city: String?
    
    var isSelect : Bool?
}
struct BindParam:HandyJSON {
    var accessToken: String?
    //国际区号
    var areaCode: String? = "234"
    //手机号
    var phoneNum: String?
    //验证码
    var optCode: String?
    //设备号
    var deviceId: String? = UIDevice.current.identifierForVendor?.uuidString
    //设备操作系统
    var deviceOs: String? = "ios"
    //设备操作系统版本号
    var deviceOsVersion: String? = UIDevice.current.systemVersion
    //设备类型（1:mobile手机,2:desktop台式,3:pad平板，4:其他）
    var deviceType: Int? = UIDevice.current.userInterfaceIdiom == .pad ? 3 : (UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2)
    //应用类型（1:app,2:h5,3:web,4:其他）
    var appType: Int? = 1
    //应用版本号
    var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    //邮箱
    var email: String?
}
struct ChangePasswordParam:HandyJSON {
    
    var password: String?
    
    var newPassword: String?
}
struct CheckUserIdentityParam:HandyJSON {
    //国际区号
    var areaCode: String? = "234"
    //手机号
    var phoneNum: String?
    //验证码
    var optCode: String?
    //邮箱
    var email: String?
}
struct CheckUserIdentityModel:HandyJSON {
    //授权token(用于绑定手机或设置支付密码)
    var accessToken: String?
}


struct HandicapDisplayParam:HandyJSON {
    //更改盘口显示方式
    var handicapDisplayType: Int?
}
