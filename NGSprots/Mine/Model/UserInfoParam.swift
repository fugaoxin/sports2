//
//  UserInfoParam.swift
//  NGSprots
//
//  Created by Jean on 22/1/2024.
//

import Foundation
import HandyJSON

struct UserInfoParam:HandyJSON {
   
    var address: String?
   
    var avatarUrl: String?
    
    //出生年
    var yearOfBirth: Int?
    //出生月
    var monthOfBirth: Int?
    //出生日
    var dayOfBirth: Int?
    
    var gender: Int?
    
    var nickName: String?
    
    var region: String?
    
    var state: String?
}
struct CheckInParam:HandyJSON {
   
    var rangeType: String?
   
    var date: String?
    
}
struct CheckInModel:HandyJSON {
   
    var checkinStatus:[CheckInItemModel]?
    var count:Int?
}
struct CheckInItemModel:HandyJSON {
   
    var date: String?
    var status: Int?
}

struct PromotionsModel:HandyJSON {
   
    var current: Int?
   
    var total: Int?
    
    var list: [PromotionsItemModel]?
}
struct PromotionsItemModel:HandyJSON {
   
    var id: Int?

    var name: String?
    
    var desc: String?
    
    var linkApp: String?
    
    var linkH5: String?
    
    var linkPC: String?
    
    var bgImg: String?
    
    var redirectType: Int?
}

