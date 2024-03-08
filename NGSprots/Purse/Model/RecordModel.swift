//
//  RecordModel.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import Foundation
import HandyJSON
struct PurseRecordModel:HandyJSON {
    //1充值,2提现
    var type: Int?

    var date: String?
    
    var number: String?
    
    var state: Int?
}

struct payRwListParam:HandyJSON {
    //当前页码
    var current: Int?
    //每页数量，默认15，最大200
    var pageSize: Int?
    //排序方式：如 "order_by desc,id desc"，具体以实际业务为主
    var orderBy: String?
}

struct payRwListModel:HandyJSON {
    //当前页码
    var current: Int?
    //总条数
    var total: Int?
    //充提记录数组
    var list: [payRwList]?
}

struct payRwList:HandyJSON {
    //订单号
    var userOrderId: String?
    //订单类型[deposit, withdraw]
    var orderType: String?
    //创建时间
    var createTime: Int?
    //
    var orderAmount: String?
    //
    var BonusAmount: String?
    //币种
    var currency: String?
    //订单状态, 充值[1待充值,2凭证已上传,3到账失败,4到账成功],提现[1待处理,2处理中,3成功,4失败]
    var status: Int?
}

struct payRwDetailParam:HandyJSON {
    //订单号
    var userOrderId: String?
    //订单类型[deposit, withdraw]
    var orderType: String?
}

struct payRwDetailModel:HandyJSON {
    //订单号
    var userOrderId: String?
    //订单类型[deposit, withdraw]
    var orderType: String?
    //创建时间
    var createTime: Int?
    //
    var orderAmount: String?
    //
    var bonusAmount: String?
    //币种
    var currency: String?
    //订单状态, 充值[1待充值,2凭证已上传,3到账失败,4到账成功],提现[1待处理,2处理中,3成功,4失败]
    var status: Int?
    //支付方式名称(deposit才会有值)
    var payWayName: String?
    //银行名称(withdraw才会有值)
    var bankName: String?
    //银行卡账户卡号(withdraw才会有值)
    var accountNum: String?
}

func depositStatus(key: Int) -> String{
    switch key {
    case 1:
    return "To be recharged"
    case 2:
    return "The voucher has been uploaded"
    case 3:
    return "Failure"
    case 4:
    return "Successful"
    default:
        return ".."
    }
}

func withdrawStatus(key: Int) -> String{
    switch key {
    case 1:
    return "Pending"
    case 2:
    return "Being processed"
    case 3:
    return "Successful"
    case 4:
    return "Failure"
    default:
        return ".."
    }
}





