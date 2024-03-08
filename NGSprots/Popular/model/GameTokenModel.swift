//
//  GameTokenModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/30.
//

import Foundation
import HandyJSON

struct GameTokenParam:HandyJSON {
    //游戏ID
    var gameId: String?
    var property1: String?
    var property2: String?
    
    //游戏3
    var categoryId: String?
    var config: configModel?
}

struct configModel:HandyJSON {
    var gameCode: String?
    var appType: Int?
}
