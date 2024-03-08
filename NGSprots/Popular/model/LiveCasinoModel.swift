//
//  LiveCasinoModel.swift
//  NGSprots
//
//  Created by Jean on 25/1/2024.
//

import Foundation
import HandyJSON

struct LiveCasinoModel:HandyJSON {
    var url: String?
    
    var name: String?

    var gameNum: String?
   
    var isPlay: Bool?
    
    var isNew: Bool?
    
    var isHot: Bool?
    
    var isOpen: Bool?
}

struct GameModel:HandyJSON {
    var list: [GameListModel]?
}

struct GameListModel:HandyJSON {
    //游戏ID
    var id: Int?
    //游戏编号
    var name: String?
    //游戏名称
    var cnName: String?
    //相关配置
    var config: String?
    //游戏封面图片url
    var coverImgUrl: String?
    //游戏小分类id，0代表没有小分类
    var tagId: String?
    //游戏小分类名称
    var tagCnName: String?
    //新开：0否，1是
    var isNew: Int?
    //推荐：0否，1是
    var isRecommend: Int?
    //维护中：0否，1是
    var isMaintaining: Int?
    //维护说明
    var maintainingDesc: String?
    //下属游戏类型，0：没有，1：平台，2：游戏列表
    var subType: Int?
}

struct GameDataModel:HandyJSON {
    var list: [GameDataListModel]?
}

struct GameDataListModel:HandyJSON {
    var gameId: Int?
    //游戏编号
    var gameCode: String?
    //游戏类型
    var gameType: String?
    //游戏中文名字
    var cnName: String?
    //游戏英文名字
    var enName: String?
    //游戏封面图片url
    var imgDefault: String?
    //推荐：1是，2是
    var recommend: Int?
    //热门，1是，2否
    var hot: Int?
    //状态：1正常，2停用，维护中
    var status: Int?
}

struct gameAccessUrlModel:HandyJSON {
    var url: String?
}
