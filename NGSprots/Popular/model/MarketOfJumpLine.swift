//
//  MarketOfJumpLine.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import Foundation
import HandyJSON

struct marketOfJumpLineModel:HandyJSON {
    //玩法选项实时赔率及限额
    var bms:[bmsModel]?
    //单关，批量允许最大订单个数
    var mon: String?
    //串关，订单最大选项个数（关数）
    var msl: String?
    //串关组合赔率及限额
    var sos:[sosModel]?
}


struct bmsModel:HandyJSON {
    //玩法id
    var mid: Int?
    //玩法销售状态，0暂停，1开售，-1未开售
    var ss: Int?
    //单关，最小投注额限制
    var smin: Int?
    //单关，最大投注额限制
    var smax: Int?
    //是否支持串关，0 不支持，1 支持 , see enum: all_up_enum
    var au: Int?
    //足球让球当前比分， 如1-1
    var re: String?
    //是否为滚球 1滚球 0非滚球
    var ip: Int?
    var op: opModel?
}

struct sosModel:HandyJSON {
    //串关子单选项个数，如：投注4场比赛的3串1，此字段为3，如果是全串关（4串11×11），则为0
    var sn: Int?
    //串关子单个数，如 投注4场比赛的3串1*4，此字段为4，全串关（4串11×11），则为11
    var `in`: Int?
    //串关对应的赔率
    var sodd: Double?
    //串关，最小投注额
    var mi: Int?
    //串关，最大投注额
    var mx: Int?
}
