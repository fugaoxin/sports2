//
//  BrowseModel.swift
//  NGSprots
//
//  Created by Jean on 14/12/2023.
//

import Foundation
import HandyJSON

struct RecordBrowseParam:HandyJSON {
    //MARK: 记录浏览
    //游戏id
    var gameId: Int? = 1
    //比赛id
    var mId: Int?
    //开赛时间
    var beginTime: Int?
    //联赛名称
    var lName: String?
    //联赛图标地址
    var lLogoUrl: String?
    //主队名称
    var hTName: String?
    //客队名称
    var aTName: String?
    
    var IsVirtual: Bool?
    
    //MARK: 批量删除
    var ids: [Int]?
}

struct BrowseGameModel:HandyJSON {
    
    var List: [BrowseGameItemModel]?
}

struct BrowseGameItemModel:HandyJSON {
    var id: Int?
    //比赛id
    var mId: Int?
    //游戏id
    var gameId: Int?
    //联赛图标地址
    var lLogoUrl: String?
    //联赛名称
    var lName: String?
    //主队名称
    var hTName: String?
    //客队名称
    var aTName: String?
    //开赛时间
    var beginTime: Int?
}

class BrowseRequest : NSObject{
    //记录浏览赛事
    class func recordBrowseWithParam(param : RecordBrowseParam ,completion : @escaping()->Void){
        let api = wxApi.recordBrowseGame(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                completion()
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion()
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion()
        }
    }
    
    //获取浏览赛事
    class func getBrowseGameWithParam(completion : @escaping(Array<BrowseGameItemModel>)->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.getBrowseGame
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<BrowseGameModel>.deserialize(from: data)
            if(result?.code == 0){
                let model : BrowseGameModel = result?.data ?? BrowseGameModel()
                completion(model.List ?? [])
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion([])
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion([])
        }
    }
}
