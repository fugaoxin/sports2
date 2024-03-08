//
//  RunningWaterModel.swift
//  NGSprots
//
//  Created by Jean on 28/2/2024.
//

import Foundation
import HandyJSON

struct RunningWaterParam:HandyJSON {
    var current: Int?
   
    var pageSize: Int?
    
    var bizType: String?
    
    var startTime: Int?
    
    var endTime: Int?
}
struct RunningWaterModel:HandyJSON {
   
    var current:Int?
    var total:Int?
    
    var list:[RunningWaterItemModel]?
}
struct RunningWaterTypeModel:HandyJSON {
   
    var label:String?
}
struct RunningWaterItemModel:HandyJSON {
   
    var id:Int?
    //额度类型[1主额度, 2 奖金额度]
    var type:Int?
    
    var amount:String?
    
    //变动类型（账变类型）：1加款(amount>=0)；2扣款(amount<=0)
    var tType:Int?
    //交易类型（业务类型）
    var bizType:String?
    //创建时间
    var createTime:Int?
    //币种编码
    var currency:String?
}
