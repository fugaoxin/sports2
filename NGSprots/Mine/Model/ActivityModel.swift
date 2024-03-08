//
//  ActivityModel.swift
//  NGSprots
//
//  Created by Jean on 1/3/2024.
//

import Foundation
import HandyJSON

struct ActivityParam:HandyJSON {
   
    var taskN: Int?
    
    var id: Int?
}
struct ActivityDetailModel:HandyJSON {
   
    var name:String?
    var linkApp:String?
    var linkH5:String?
    var linkPC:String?
    var redirectType: Int?
    var bgImg:String?
    var richText:[ActivityIntroItemModel]?
    var status:Int?
}
struct ActivityIntroItemModel:HandyJSON {
    var s:String?
    var t:String?
}
struct RegisterActivityModel:HandyJSON {
   
    var status:Int?
    var ExpireTime:Int?
    var task1:RegisterActivityTaskModel?
    var task2:RegisterActivityTaskModel?
    var task3:RegisterActivityTaskModel?
    
    var richText:[ActivityIntroItemModel]?
}

struct RegisterActivityTaskModel:HandyJSON {
   
    var id:Int?
    var status:Int?
    var claimed:Int?
    var processes:[RegisterActivityTaskStepModel]?
    
    var coupons:[itemModel]?
}

struct RegisterActivityTaskStepModel:HandyJSON {
   
    var text:String?
    var status:Int?
}
struct RegisterActivityTaskCouponModel:HandyJSON {
   
    var mainValue:String?
    var id:Int?
}

struct DepositActivityModel:HandyJSON {
    var status:Int?
    var taskTotalAwardText:String?
    var info:[DepositActivityTaskModel]?
}
struct DepositActivityTaskModel:HandyJSON {
   
    var taskN:Int?
    var awardText:String?
    var status:Int?
}
class ActivityRequest : NSObject{
    
    class func getRegisterActivity(completion : @escaping(_ isSuccess: Bool?)->Void){
        Tool.getCurrentVc().showHUD(text: "Loading...")
        let api = wxApi.getRegisterActivity
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.getCurrentVc().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                completion(true)
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion(false)
            }
        }) { error in
            Tool.getCurrentVc().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion(false)
        }
    }
    class func getActivityDetail(type:Int,completion : @escaping(_ model: ActivityDetailModel?)->Void){
        Tool.getCurrentVc().showHUD(text: "Loading...")
        var param = ActivityParam()
        param.id = type
        let api = wxApi.getActivityDetail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.getCurrentVc().hudHide()
            let result = RequestCallBackViewModel<ActivityDetailModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? ActivityDetailModel())
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
    
    class func getDepositActivity(completion : @escaping(_ model: DepositActivityModel?)->Void){
        Tool.getCurrentVc().showHUD(text: "Loading...")
        let api = wxApi.depositActivity
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.getCurrentVc().hudHide()
            let result = RequestCallBackViewModel<DepositActivityModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? DepositActivityModel())
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
