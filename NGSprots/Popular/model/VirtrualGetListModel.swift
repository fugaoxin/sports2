//
//  VirtrualGetListModel.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/19.
//

import Foundation
import HandyJSON

struct virtualMatchGetListModel:HandyJSON {
    //联赛名称
    var na: String?
    //EBlock名称
    var bnm: String?
    //联赛ID
    var id:Int?
    //联赛图标地址
    var lurl: String?
    //运动种类id , see enum: sports
    var sid: Int?
    //赛事集合
    var ms: [recordModel]?
    //开始时间
    var tm: Int?
    //开始时间倒计时
    var cd: Int?
    //期ID
    var bid:Int?
    //赛季
    var cpid: Int?
    //联赛阶段 , see enum: phase
    var ph: Int?
    //周/轮
    var md:Int?
    //是否滚球
    var lv: Bool?
}

