//
//  PayModel.swift
//  NGSprots
//
//  Created by Jean on 28/12/2023.
//

import Foundation
import HandyJSON
struct GetPayTypeParam:HandyJSON {
    //1充值,2提现
    var type: Int? = 1

    var currency: String? = Tool.getuserInfoModel()?.currency
}
struct PayTypeModel:HandyJSON {
    var list: [PayTypeItemModel]?
}
struct PayTypeItemModel:HandyJSON {
    //支付方式id
    var id:Int?
    //支付方式编号
    var number: String?
    //支付方式显示名称
    var name: String?
    //简短提示语
    var tip : String?
    
    var logoUrl : String?
    //金额提示语
    var amountTip : String?
    //快捷金额
    var amountQuick : [AmountQuickItemModel]?
    
    var isSelect : Bool?
}
struct AmountQuickItemModel:HandyJSON {
    var value : String?
    //是否热度[1否, 2是]
    var isHot : Int?
    
    var isChoose : Bool?
}
struct ApplyRechargeParam:HandyJSON {
    //充值方式id
    var wayId: Int?
    //充值币种
    var currency: String? = Tool.getuserInfoModel()?.wallets?.first?.currency
    //兑换币种
    var exchangeCurrency: String? = Tool.getuserInfoModel()?.wallets?.first?.currency
    //应用类型（1:app,2:h5,3:web,4:其他）
    var appType: Int? = 1
    
    var orderAmount : String?
    //优惠码
    var couponCode : String?
    //优惠券id
    var couponId : String?
    //支付后返回的链接,无需带域名,例 /payment/success
    var returnUrlPath : String? = "/payment/success"
}
struct ApplyRechargeModel : HandyJSON{
    //订单状态：订单显示状态[1待充值, 2上传凭证成功, 3 失败, 4 成功]
    var showStatus : Int?
    //订单创建后，多少时长内需完成支付
    var limitTime : NSString?
    //创建时间
    var createTime : NSString?
    //金额
    var orderAmount : String?
    //币种
    var currency : String?
    //币种符号
    var currencySymbol : String?
    //订单号
    var userOrderId : String?
    //充值方式显示名称
    var wayCnName : String?
    //1:链接跳转(Redirect)2:银行转账数据显示(BankTransfer)
    var method : String?
    //是否需要上传凭证：0否，1是
    var isNeedProof : Int?
    
    var redirect : ApplyRechargeChannelModel?
    var bankTransfer : ApplyRechargeBankModel?
    
}
struct ApplyRechargeChannelModel:HandyJSON {
    //支付链接
    var url : String?
}
struct ApplyRechargeBankModel:HandyJSON {
//    //银行id
//    var bankId : Int?
    //银行名称
    var bankName : String?
    //卡号
    var accountNum : String?
    
}
struct ApplyWithdrawParam:HandyJSON {
    //会员绑定的银行卡、虚拟币地址
    var receiveId : Int?
    //币种
    var currency: String? = Tool.getuserInfoModel()?.wallets?.first?.currency
    
    var orderAmount : String?
    
    var appType : Int? = 2
}
struct ApplyWithdrawModel:HandyJSON {
    //订单号
    var userOrderId : String?
   
}
