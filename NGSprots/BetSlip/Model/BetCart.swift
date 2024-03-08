//
//  BetCart.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/16.
//

import Foundation
import HandyJSON

struct CarList:HandyJSON {
    var list: [carListModel]?
}

struct carListModel:HandyJSON {
    var id: Int?
    //游戏id
    var gameId: Int?
    //比赛id
    var matchId: Int?
    //玩法id
    var marketId: Int?
    //主队名称
    var hTName: String?
    //客队名称
    var aTName: String?
    //开赛时间
    var beginTime: String?
    //玩法分类
    var marketTag: String?
    //玩法名称
    var marketName: String?
}

struct relatedIdModel:HandyJSON {
    var bonusAmount: String?
    var couponAmount: String?
    var couponId: String?
    var stakeAmount: String?
    var ts: String?
    var userId: String?
    var sign: String?
}


