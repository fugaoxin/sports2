//
//  OrderBetListModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/11.
//

import Foundation
import HandyJSON
struct orderBetParam:HandyJSON {
    //true 为查询已结算列表，false 为查询未结算列表
    var isSettled: Bool?
    //开始时间，13位数字时间戳，查询已结算列表，该字段必填
    var startTime: String?
    //结束时间
    var endTime: String?
    //国际化语言类型，CMN、ENG等
    var languageType: String?
    //当前分页页数，从1开始
    var current: String?
    //每页订单条数
    var size: String?
    //时间范围类型
    var timeType: String?
    //币种ID
    var currencyId: String? = "20"
}


struct orderBetListModel:HandyJSON {
    //
    var current: Int?
    //
    var size: Int?
    //
    var total: Int?
    //总条数的类型: 0: 精准, 1: 比实际的少, 2: 只是个约数, 可能通过预判或计算得知
    var totalType: Int?
    //数据集合
    var records: [obRecordModel]?
    //统计当前条件下所有订单总投注金额
    var tamt: String?
    //统计当前条件下所有订单总结算派奖金额
    var tsamt: String?
}

struct obRecordModel:HandyJSON {
    //订单选项详情
    var ops: [obOpsModel]?
    //订单号
    var id: String?
    //用户输赢 
    var uwl: String?
    //注单类型(0:单注 1:串关 ) , see enum: series_type
    var sert: Int?
    //总注单数，单关为1，串关为子单个数，如4串4*11，则该字段为11
    var bn: Int?
    //选项个数
    var al: Int?
    //总投注额(本金)
    var sat: String?
    //订单状态，0创建成功，1确认中，2拒单，3取消订单，4接单成功，5已结算
    var st: Int?
    //是否接受赔率变更设置：0不接受，1 接受更好赔率，2接受任意赔率
    var oc: Int?
    //订单结算时间，13位数字时间戳
    var stm: String?
    //订单下单时间，13位数字时间戳
    var cte: Int?
    //订单取消时间，13位数字时间戳
    var ct: String?
    //订单变更时间，13位数字时间戳
    var mt: String?
    //单笔投注金额，单关时和总投注额相等，串关为子单投注额
    var us: Int?
    //串关类型，(例:3x1*3)
    var bt: String?
    //是否为预约投注单，true是，false否
    var ab: Bool?
    //选项个数，单关为1，串关为选项个数
    var ic: Int?
    //串关子单选项个数，如：投注4场比赛的3串1，此字段为3，如果是全串关（4串11*11），则为0；
    var sv: Int?
    //剩余可赢额，如有部分提前结算，该字段为剩余本金*赔率
    var lwa: String?
    //可返还金额，包含本金
    var mla: String?
    //最大可赢额，不包含本金
    var mwa: String?
    //币种ID , see enum: currency
    var cid: Int?
    //汇率快照
    var exr: Int?
    //是否支持提前结算, 1:支持,0:不支持
    var co: Int?
    //
    var ss: Bool?
    //提前结算总本金
    var cots: String?
    //提前结算派彩金额
    var cops: String?
    
    //据单原因码
    var rj: Int?
    //据单原因
    var rjs: String?
}

struct obOpsModel:HandyJSON {
    var sid: Int?
    var mid: String?
    var mn: String?
    var ln: String?
    var bt: Int?
    var pe: String?
    var mty: String?
    var on: String?
    var onm: String?
    var ip: Bool?
    var te: [obteModel]?
    var bo: String?
    var of: Int?
    var re: String?
    var mrid: String?
    var ty: Int?
    var od: String?
    var mgn: String?
    var mtp: Int?
    var ms: Int?
    var mc: obmcModel?
    var sr: Int?
    //订单结算时比分，部分玩法没有对应比分 (暂时没有看到返回)
    var rs: String?
    //当前比分
    var scs:[String]?
}

struct obteModel:HandyJSON {
    var na: String?
    var id: Int?
}

struct obmcModel:HandyJSON {
    var pe: String?
}

struct StakeOrderStatusParam:HandyJSON {
    var languageType: String?
    var orderIds: [String]?
}

struct orderGetStakeOrderStatusModel:HandyJSON {
    //订单ID，返回为字符串
    var oid:String?
    //下单后订单状态code，由于系统为异步处理订单，下单后订单处于未确认状态
    var st: Int?
    //据单原因码
    var rj:Int?
    //据单原因
    var rjs:String?
}

struct OrderListParam:HandyJSON {
    //当前页码
    var current: Int?
    //每页数量，默认15，最大200
    var pageSize: Int?
    //排序方式：如 "order_by desc,id desc"，具体以实际业务为主
    var orderBy: String?
    //游戏分类id，滚球1、体育2、真人游戏3、老虎机4
    var categoryId: Int?
    //起始时间戳（13位）
    var startTime: Int?
    //终止时间戳（13位）
    var endTime: Int?
}

struct orderListModel:HandyJSON {
    //当前页码
    var current: Int?
    //总条数
    var total: Int?
    //
    var totalAmount: Int?
    //
    var totalProfit: Int?
    //数据集合
    var orderList: [odlistModel]?
}

struct odlistModel:HandyJSON {
    var id: Int?
    //订单号（在本平台）
    var orderId: String?
    //用户id
    var userId: Int?
    //游戏id
    var gameId: Int?
    //细分类别或子游戏（空代表未知）
    var subGame: String?
    //（上游系统中）订单id
    var oId: String?
    //币种
    var currency: String?
    //
    var amount: String?
    //
    var maxWinAmount: String?
    //
    var detail: String?
    //订单状态（0:Created未确认【创建】,1:Confirming确认中，2:Rejected:已拒单，3:Canceled：已取消，4:Confirmed：已接单，5:Settled已结算）
    var status: Int?
    //
    var settleAmount: String?
    //订单结果（0:NoResult无结果，2:Return和，3:Lost输，4:Won赢，5:WinReturn赢半，6:LooseReturn输半，7:Cancel取消）
    var result: Int?
    //订单结算时间
    var oSettleTime: Int?
    //订单创建时间
    var oCreateTime: Int?
    //订单取消时间
    var oCancelTime: Int?
    //版本号
    var version: Int?
    //记录创建时间
    var createTime: Int?
    //记录更新时间
    var updateTime: Int?
    var cashoutAmount: Int?
    var cashoutSettleAmount: Int?
    var wagered: Int?
    //1单关、2 串关
    var seriesType: Int?
    //游戏供应商的编码
    var providerCode: String?
    
    //
    var gameName: String?

}


