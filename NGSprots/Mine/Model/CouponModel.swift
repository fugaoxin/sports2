//
//  CouponModel.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/9.
//

import Foundation
import HandyJSON

struct CouponListParam:HandyJSON {
    //当前页码
    var current: Int? = 1
    //每页数量，默认15，最大200
    var pageSize: Int? = 15
    //排序方式：如 "order_by desc,id desc"，具体以实际业务为主
    var orderBy: String?
    //状态
    var status: Int?
    
    //投注金额or充值金额
    var amount: String?
    //赔率列表,仅投注时用的，把这次投注里选择的每一项赔率都列进来
    var odds: [oddsModel]?
    //这个券的使用场景。 recharge:充值时， bet:投注时
    var scenario: String?
}
struct GetCouponParam:HandyJSON {
    //优惠券id
    var ids: [Int]?
}

struct BounsParam:HandyJSON {
    var amount: String?
    var currency: String? = "NGN"
    var odds: [oddsModel]?
}

struct BounsModel:HandyJSON {
    var amount: String?
}

struct CouponDataModel:HandyJSON {
    //当前页码
    var current: Int?
    //总条数
    var total: Int?
    //
    var Items: [CouponModel]?
}

struct CouponModel:HandyJSON {
    //优惠券id
    var id: Int?
    //优惠券描述
    var desc: String?
    //状态
    var status: Int?
    var type: Int?
    //过期时间，时间戳秒
    var expiredTime: Int?
    var createTime: Int?
    var updateTime: Int?
    
    //金额
    var money: String?
    //使用金额
    var useMoney: String?
    
    var amount: String?
    var conditionText: String?
    var expireTime: Int?
}

struct oddsModel:HandyJSON {
    //赔率
    var betOdds: String?
    //赔率类型,。1.Euro,2.HK,3.Malay,4Indo
    var oddsFormat: Int? = 1
}
struct availableAndBonusModel:HandyJSON {
    //当前页码
    var current: Int?
    //总条数
    var total: Int?
    //优惠券列表
    var items: [itemModel]?
    //
    var afterAmount: Int?

    var bonus: Int?

    var addBonus: Int?
}

struct itemModel:HandyJSON {
    //优惠券id
    var id: Int?
    //状态1 active 可用, 2 used 已用, 3 expired（过期）， 4 inactive 不可用(被运营人员下线)
    var status: Int?
    //优惠券类型：1 cash, 2 discount, 3 desposit
    var type: Int?
    //过期时间，时间戳毫秒, 券的可用时间在这结束
    var expireTime: Int?
    //券的创建时间，时间戳毫秒
    var createTime: Int?
    //优惠券配置id
    var configId: Int?
    //优惠券左侧的主面额
    var mainValue: String?
    //优惠券描述,即上面的一小行
    var desc: String?
    //优惠券的限制额，即右边中间的面额
    var limitationShow: String?
    //领取时间,时间戳毫秒，券的可用时间从这里开始
    var claimTime: Int?
    //表示过期时间/使用期限的文本，放在右下方的
    var validityText: String?
    
    var selectBool: Bool? = false
}

struct CheckInCouponModel:HandyJSON {
    //领取状态, 1已领取，2完成任务但未领取, 3未完成任务
    var claimStatus: Int?
    //对应优惠券列表(可能是已领取也可能是未领取)
    var coupons: [itemModel]?
    //需要领券的优惠券id列表
    var toClaimIds: [Int]?
    //这天是周几，1-7表示周一到周日
    var day: Int?
    //文本
    var text: String?
}
class CouponRequest : NSObject{
    //当前条件下可用优惠券列表+最佳券+可用bonus
    class func couponAvailableAndBonus(param : CouponListParam ,completion : @escaping(_ model: availableAndBonusModel)->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.couponAvailableAndBonus(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<availableAndBonusModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? availableAndBonusModel())
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    class func getCouponAvailable(param : CouponListParam ,completion : @escaping(_ model: availableAndBonusModel?)->Void){
        Tool.getCurrentVc().showHUD(text: "Loading...")
        let api = wxApi.couponAvailable(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.getCurrentVc().hudHide()
            let result = RequestCallBackViewModel<availableAndBonusModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? availableAndBonusModel())
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion(nil)
            }
        }) { error in
            Tool.getCurrentVc().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion(nil)
        }
    }
}

class AccabonusRequest : NSObject{
    //计算当前投注条件下可获得的累积奖金
    class func lodaAccabonusCalc(param: BounsParam ,completion : @escaping(_ amount: String?)->Void){
        let api = wxApi.accabonusCalc(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<BounsModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data?.amount)
            }else{}
        }) { (error) in }
    }
}
