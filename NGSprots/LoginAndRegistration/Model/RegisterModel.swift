//
//  RegisterModel.swift
//  NGSprots
//
//  Created by Jean on 30/11/2023.
//

import UIKit
import HandyJSON
struct RegisterParam:HandyJSON {
    //国家码
    var areaCode: String?
    //手机号
    var phoneNum: String?
    //邮箱
    var email: String?
    //验证码只能验证一次（不管成功或失败），登录失败后，前端请刷新验证码
    var optCode: String?
    //密码
    var password: String?
    //出生年
    var yearOfBirth: Int?
    //出生月
    var monthOfBirth: Int?
    //出生日
    var dayOfBirth: Int?
    //邀请码
    var inviteCode: String?
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
}

struct LoginParam:HandyJSON {
    //国家码
    var areaCode: String?
    //手机号
    var phoneNum: String?
    //邮箱
    var email: String?
    //密码
    var password: String?
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
}

struct ResetPassWordParam:HandyJSON {
    //国家码
    var areaCode: String?
    //手机号
    var phoneNum: String?
    //邮箱
    var email: String?
    //验证码只能验证一次（不管成功或失败），登录失败后，前端请刷新验证码
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
    
    //MARK: -确认重置密码
    //需要提供token
    var access_token: String?
    //密码
    var password: String?
}
