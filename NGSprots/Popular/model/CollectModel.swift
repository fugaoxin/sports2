//
//  CollectModel.swift
//  NGSprots
//
//  Created by Jean on 13/12/2023.
//

import Foundation
import HandyJSON

struct CollectParam:HandyJSON {
    //MARK: 收藏比赛
    //游戏id
    var gameId: Int? = 1
    //比赛id
    var mId: Int?
    //开赛时间
    var beginTime: Int?
    
    var IsVirtual: Bool?
    //MARK: 收藏联赛
    //联赛id
    var lId: Int?
    //联赛图标地址
    var logoUrl: String?
    //联赛名称
    var name: String?
}

struct CancelCollectParam:HandyJSON {
    //游戏id
    var gameId: Int? = 1
    //比赛id
    var mId: Int?
    //批量取消
    var ids: [Int]?
    
    //MARK: 取消收藏联赛
    //联赛id
    var lId: Int?
}

struct CollectGameModel:HandyJSON {
    //收藏的比赛列表
    var list: [CollectGameItemModel]?
   
}
class CollectGameItemModel: NSObject,HandyJSON,NSSecureCoding  {
    required override init() {
        
    }
    var id: Int?
    //比赛id
    var mId: Int?
    //游戏id
    var gameId: Int?
    
    static var supportsSecureCoding: Bool{return true}


    required init?(coder aCoder: NSCoder) {
        id = aCoder.decodeObject(forKey: "id") as? Int
        mId = aCoder.decodeObject(forKey: "mId") as? Int
        gameId = aCoder.decodeObject(forKey: "gameId") as? Int
    }
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(mId, forKey: "mId")
        coder.encode(gameId, forKey: "gameId")
    }
}

struct CollectLeagueMatchModel:HandyJSON {
    //收藏的比赛列表
    var list: [CollectLeagueMatchItemModel]?
   
}
class CollectLeagueMatchItemModel: NSObject,HandyJSON,NSSecureCoding  {
    required override init() {
        
    }
    //收藏
    var isCollect: Bool?
    
    var id: Int?
    //联赛id
    var lId: Int?
    //游戏id
    var gameId: Int?
    //联赛图标地址
    var logoUrl: String?
    //联赛名称
    var name: String?
    
    static var supportsSecureCoding: Bool{return true}


    required init?(coder aCoder: NSCoder) {
        id = aCoder.decodeObject(forKey: "id") as? Int
        lId = aCoder.decodeObject(forKey: "lId") as? Int
        gameId = aCoder.decodeObject(forKey: "gameId") as? Int
        logoUrl = aCoder.decodeObject(forKey: "logoUrl") as? String
        name = aCoder.decodeObject(forKey: "name") as? String
    }
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(lId, forKey: "lId")
        coder.encode(gameId, forKey: "gameId")
        coder.encode(logoUrl, forKey: "logoUrl")
        coder.encode(name, forKey: "name")
    }
}





class CollectRequest : NSObject{
    
    //收藏赛事
    class func collectWithParam(param : CollectParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.collectGame(param: param)
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
    //取消收藏赛事
    class func cancelCollectWithParam(param : CancelCollectParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.cancelCollectGame(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                
                
                let data  = UserDefaults.standard.value(forKey: CollectGameID)
                let arr : Array<CollectGameItemModel> = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as! Array<CollectGameItemModel>
                let totalArr : NSMutableArray = NSMutableArray(array:arr)
                var deleteArr : Array<CollectGameItemModel> = []
                for i in 0..<arr.count{
                    let sportModel = arr[i]
                    if sportModel.mId == param.mId{
                        deleteArr.append(sportModel)
                    }
                }
                totalArr.removeObjects(in: deleteArr)
                let currentMids : Array<CollectGameItemModel> = totalArr as! Array<CollectGameItemModel>
                let modelData = NSKeyedArchiver.archivedData(withRootObject: currentMids)
                UserDefaults.standard.set(modelData, forKey: CollectGameID)
                UserDefaults.standard.synchronize()
                
                completion()
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //收藏联赛
    class func collectLeagueMatchWithParam(param : CollectParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.collectLeagueMatch(param: param)
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
    //取消收藏联赛
    class func cancelCollectLeagueMatchWithParam(param : CancelCollectParam ,completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.cancelCollectLeagueMatch(param: param)
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
    //获取收藏联赛
    class func getCollectLeagueMatch(completion : @escaping(Array<CollectLeagueMatchItemModel>)->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.getCollectLeagueMatch
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<CollectLeagueMatchModel>.deserialize(from: data)
            if(result?.code == 0){
                let model : CollectLeagueMatchModel = result?.data ?? CollectLeagueMatchModel()
                for i in 0..<(model.list!.count ){
                    model.list![i].isCollect = true
                }
                completion(model.list ?? [])
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
