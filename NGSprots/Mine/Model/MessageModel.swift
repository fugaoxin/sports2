//
//  MessageModel.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import Foundation
import HandyJSON

struct MessageParam:HandyJSON {
   
    var current: Int?
    var pageSize: Int?
    
    var id: [Int]?
    
    var status: Int?
  
    var platform: String? = "ios"
}
struct MessageModel:HandyJSON {
   
    var current: Int?
   
    var total: Int?
    
    var items: [MessageDateModel]?
  
}
struct MessageDateModel:HandyJSON {
   
    var date: String?
    
    var msgs: [MessageItemModel]?
  
}
struct MessageCountModel:HandyJSON {
   
    var unreadCount: Int?
}
struct MessageItemModel:HandyJSON {
    var id: Int?

    var status: Int?
    
    var body: String?
    
    var title: String?
    
    var link: String?
    
    var isH5: Bool?
    
    var createTime: Int?
    
    var isSelect: Bool?
    
    //公告特有字段
    var type: Int?//1平台，2体育，3其他
    
}
