//
//  PurseModel.swift
//  NGSprots
//
//  Created by Jean on 28/12/2023.
//

import Foundation
import HandyJSON
struct SetPayPassWordParam:HandyJSON {
    //支付密码
    var password: Int?
    
    //MARK: -设置支付密码时 在验证身份接口返回  重置支付密码 重置申请接口返回  
    var accessToken: String?
}
struct SetPayPassWordModel:HandyJSON {
    //授权token(用于操作银行卡的添加删除)
    var accessToken: String?
}
struct ApplyChangePayPassWordParam:HandyJSON {
    //验证码
    var optCode: String?
    //验证码
    var phoneNum: String?

    var areaCode: String? = "234"
//    //设备号
//    var deviceId: String? = UIDevice.current.identifierForVendor?.uuidString
//    //设备操作系统
//    var deviceOs: String? = "ios"
//    //设备操作系统版本号
//    var deviceOsVersion: String? = UIDevice.current.systemVersion
//    //设备类型（1:mobile手机,2:desktop台式,3:pad平板，4:其他）
//    var deviceType: Int? = UIDevice.current.userInterfaceIdiom == .pad ? 3 : (UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2)
//    //应用类型（1:app,2:h5,3:web,4:其他）
//    var appType: Int? = 1
//    //应用版本号
//    var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//    //邮箱
//    var email: String?
}
struct ApplyChangePayPassWordModel:HandyJSON {
    //授权token(用于重置支付密码)
    var accessToken: String?
}
