//
//  MatchStatisticalModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/5.
//

import Foundation
import HandyJSON

//MARK: 赛事统计
struct matchStatisticalModel:HandyJSON {
    //赛事个数
    var tc:Int?
    //所有赛事对应的不同类型的场次集合
    var sl: [slModel]?
    //热门总数，包括竞彩赛事和热门联赛赛事
    var ht: Int?
    //热门联赛下的赛事个数统计
    var hls: [hlsModel]?
}

struct slModel:HandyJSON {
    //分类类型，如 滚球、今日、早盘等，返回对应枚举code , see enum: match_play_type
    var ty:Int?
    //分类描述
    var des: String?
    //赛事总数
    var tc: Int?
    //每个类型下每个运动里的赛事统计信息
    var ssl: [sslModel]?
}

struct sslModel:HandyJSON {
    //运动ID , see enum: sports
    var sid:Int?
    //统计赛事个数
    var c: Int?
    //联赛集合
    var ls: [lsModel]?
}

//MARK: 筛选
struct shaixuanModel:HandyJSON {
    //英文
    var later:String?
    //联赛
    var leagueMatch: [leagueMatchModel]?
}

struct leagueMatchModel:HandyJSON {
    //联赛名字、联赛ID、联赛logo、运动ID、标识(展开)、标识(选中)
    var na:String?
    var id: Int?
    var lurl: String?
    var zan: String?
    var bs: String?
}

struct virtualMatchStatisticalModel:HandyJSON {
    //运动集合
    var ssl: [sslModel]?
}

struct lsModel:HandyJSON {
    //联赛名称id
    var id:Int?
    //联赛名称
    var na: String?
    //logo的url地址
    var lurl: String?
}
