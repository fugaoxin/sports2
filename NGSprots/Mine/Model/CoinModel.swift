//
//  CoinModel.swift
//  NGSprots
//
//  Created by Jean on 6/12/2023.
//

import Foundation
import HandyJSON

struct AddCoinAddressParam:HandyJSON {
    //协议
    var `protocol`: String?
    //地址
    var address: String?
    //币种
    var currency: String? = Tool.getuserInfoModel()?.wallets?.first?.currency
    //别名
    var title: String?
    //短信验证码
    var smsCaptcha: String?
}

struct CoinModel:HandyJSON {
    //钱包地址id
    var id: Int?
    //协议
    var `protocol`: String?
    //地址
    var address: String?
    //币种
    var currency: String? 
    //别名
    var title: String?
}
