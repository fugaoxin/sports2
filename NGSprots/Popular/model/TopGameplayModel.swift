//
//  TopGameplay.swift
//  NGSprots
//
//  Created by Jean on 16/12/2023.
//

import Foundation
import HandyJSON
struct GameplayParam:HandyJSON {
    //游戏id
    var gameId: Int? = 1
    //比赛id
    var mId: Int?
    //开赛时间
    var beginTime: Int?
    //玩法名称
    var mkName: String?
}
struct GameplayModel:HandyJSON {
    
    var list: [String]?
}

class GameplayRequest : NSObject{
    
    //置顶赛事玩法
    class func topGamePlayWithParam(param : GameplayParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.topGameplay(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                completion()
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //取消置顶赛事玩法
    class func cancelTopGamePlayWithParam(param : GameplayParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.cancelTopGameplay(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                completion()
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
}
