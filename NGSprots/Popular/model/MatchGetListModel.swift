//
//  MatchGetListModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/30.
//

import Foundation
import HandyJSON

struct MatchGetListParam:HandyJSON {
    //当前页码，从1开始计数
    var current: String?
    //每页大小, 默认50
    var size: String?
    //国际化语言类型: ENG，CMN等
    var languageType: String?
    //赛事列表排序方式：0 按开赛时间排序，1 按联赛排序
    var orderBy: String?
    //赛事分组类型，例如：1、滚球，3、今日
    var type: String?
    //运动ID , see enum: sports
    var sportId: String?
    //联赛ID，matchIds、leagueId、type三者必传其一
    var leagueId: String?
    //盘口类型集合
    var marketTypes: NSArray?
    //赛事Id集合
    var matchIds: [String]?
    //联赛id集合
    var leagueIds: [String]?
}

struct MatchDetailParam:HandyJSON {
    //赛事ID
    var matchId: String?
    //国际化语言类型
    var languageType: String?
    //赔率类型
    var oddsType: String?
}

struct MatchGetOnSaleLeaguesParam:HandyJSON {
    //运动ID
    var sportId: String?
    //国际化语言类型
    var languageType: String?
    //类表分类类型，如滚球、今日
    var type: String?
}

struct BatchBetMatchMarketOfJumpLineParam:HandyJSON {
    //国际化语言类型
    var languageType: String?
    //赛事盘口数据对象
    var betMatchMarketList: [betMatchMarketListModel]?
    //是否查询串关
    var isSelectSeries: String?
    //币种id
    var currencyId: String?
}

struct betMatchMarketListModel:HandyJSON {
    //玩法ID
    var marketId: String?
    //赛事ID
    var matchId: String?
    //投注项类型
    var type: String?
    //赔率类型
    var oddsType: String?
}

struct VirtualMatchGetListParam:HandyJSON {
    //联赛id
    var leagueId: Int?
    //国际化语言类型: ENG，CMN等
    var languageType: String?
    //是否为PC页面请求，App接入不传该参数，PC页面传true
    var isPC: Bool?
    //期ID
    var blockId: Int?
}

