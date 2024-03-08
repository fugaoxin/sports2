//
//  BankModel.swift
//  NGSprots
//
//  Created by Jean on 6/12/2023.
//

import Foundation
import HandyJSON

struct AddBankParam:HandyJSON {
    //银行id
    var bankId: Int?
    //验证支付密码的token
    var accessToken: String?
    //银行卡卡号
    var accountNum: String?
    
    //删除银行卡 卡id
    var id: Int?
}

struct DeleteBankOrAddressParam:HandyJSON {
    //银行卡 或 虚拟币地址id
    var id: Int?
}


class BankCardModel:NSObject,HandyJSON {
    //银行卡id
    var id: Int?
    //银行id
    var bankId: Int?
    //银行名称
    var bankName: String?
    //银行卡卡号
    var accountNum: String?
    //银行图标
    var bankIcon: String?
  
    
    var isSelect : Bool?
    required override init() {
        
    }
}
class BankModel:NSObject,HandyJSON {
    //银行id
    var id: Int?
    //银行名称
    @objc var name: String?
    //银行编码
    var code: String?
    //图标
    var icon: String?
    
    var isSelect : Bool?
    
    required override init() {
        
    }
}
