//
//  SinglePass.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import Foundation
import HandyJSON

struct singlePassParam:HandyJSON {
    //单关投注数组
    var singleBetList:[singleBetListModel]?
    //国际化语言类型
    var languageType: String?
    //币种id
    var currencyId: String?
}

struct singleBetListModel:HandyJSON {
    //每单的投注金额
    var unitStake:String?
    //是否接受赔率变更类型code
    var oddsChange: String?
    //投注玩法选项，数组大小为1
    var betOptionList: [betOptionListModel]?
    //第三方数据关联ID，可为空
    var relatedId: String?
    //第三方备注
    var thirdRemark: String?
}

struct betOptionListModel:HandyJSON {
    //玩法ID
    var marketId:String?
    //投注选项类型code
    var optionType: String?
    //下注赔率
    var odds: String?
    //下注时展示的赔率类型code，如港盘、欧盘
    var oddsFormat: String?
}

struct orderBetSinglePassResponseModel:HandyJSON {
    //订单ID，返回为字符串
    var id:String?
    //下单后订单状态code，由于系统为异步处理订单，下单后订单处于未确认状态
    var st: Int?
    //订单选项集合
    var ops:[opsModel]?
}

struct opsModel:HandyJSON {
    //盘口id
    var mid:String?
    //欧式赔率
    var od: String?
    //赔率类型 , see enum: odds_format_type_enum
    var of:String?
    //下注赔率
    var bod: String?
}

struct orderBetMultipleParam:HandyJSON {
    //串关投注关次数据，几串几的关次等
    var betMultipleData:[betMultipleDataModel]?
    //投注的盘口玩法项数据集合
    var betOptionList:[betOptionListModel]?
    //国际化语言类型
    var languageType: String?
    //币种id
    var currencyId: String?
}

struct betMultipleDataModel:HandyJSON {
    //是否接受赔率变更设置code ：0不接受，1 接受更好赔率，2接受任意赔率
    var oddsChange:String?
    //串关子单选项个数，如：投注4场比赛的3串1，此字段为3
    var seriesValue: Int?
    //每个子单投注金额， 如 4选个的3串1*4，四个子单，每子单投注"10"元，总共投注40元，此字段为10
    var unitStake:String?
    //第三方备注
    var thirdRemark: String?
    //三方数据关联ID，可为空
    var relatedId: String?
}


//virtual
struct VirtualSinglePassParam:HandyJSON {
    //单关投注数组
    var options:[optionsModel]?
    //国际化语言类型
    var languageType: String?
    //币种id
    var currencyId: String?
    //是否接受赔率变更类型code
    var oddsChange: String?
}

struct optionsModel:HandyJSON {
    //玩法ID
    var marketId:String?
    //投注选项类型code
    var optionType: String?
    //下注赔率
    var odds: String?
    //下注时展示的赔率类型code，如港盘、欧盘
    var oddsFormat: String?
    //每单的投注金额
    var unitStake:String?
    //第三方数据关联ID，可为空
    var relatedId: String?
    //第三方备注
    var thirdRemark: String?
}
