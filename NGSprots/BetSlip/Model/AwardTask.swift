//
//  AwardTask.swift
//  NGSprots
//
//  Created by Jack Lin on 2024/2/29.
//

import Foundation
import HandyJSON

struct accaBonusStatusParam:HandyJSON {
    var id: Int?//任务id. 1:签到；2:注册；3:充值；4:累积
    var odds: [String]?
}

struct accaBonusStatusModel:HandyJSON {
    var status: Int?
    var result: Int?
}

struct accaBonusListModel:HandyJSON {
    var items: [accaBonusListItemModel]?
}

struct accaBonusListItemModel:HandyJSON {
    var numOfSelections: Int?
    var bonusText: String?
}

struct awardTaskReqModel:HandyJSON {
    var name: String?
    var linkApp: String?
    var linkH5: String?
    var linkPC: String?
    var redirectType: Int?
    var bgImg: String?
    var status: Int?
    var richText: [richTextModel]?
}

//富文本，数组里每一个元素表示一个标题或一段正文；形如[{"s":"title", "t":"ttttt"}, {"s":"body", "t":"bbbb"}]。其中t表示格式，枚举是 title/body, 表示标题或正文； s表示对应的文本
struct richTextModel:HandyJSON {
    var t: String?
    var s: String?
}

