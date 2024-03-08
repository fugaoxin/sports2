//
//  MatchGetOnSaleLeaguesModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/4.
//

import Foundation
import HandyJSON

struct onSaleLeaguesModel:HandyJSON {
    //区域id
    var rid: Int?
    //区域名称
    var rnm: String?
    var type: Bool?
    var hlsModels:[hlsModel]?
}
    
struct hlsModel:HandyJSON {
    //ID
    var id:Int?
    //赛事总数
    var mt: Int?
    //联赛名称
    var na: String?
    //logo的url地址
    var lurl: String?
    //运动种类ID
    var sid: Int?
    //联赛等级，可用于联赛排序，值越小，联赛等级越高
    var or: Int?
    //区域id
    var rid: Int?
    //区域名称
    var rnm: String?
    //是否热门
    var hot: Bool?
    
    //是否收藏
    var isCollect: Bool?
}
