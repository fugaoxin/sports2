//
//  SearchModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/19.
//

import Foundation
import HandyJSON

struct searchModel:HandyJSON {
    var list: [String]?
    var key: String?
}

struct queryMatchByRecommendParam:HandyJSON {
    //推荐词
    var recommend: String?
    //国际化语言类型
    var languageType: String? = "ENG"
    //赔率类型
    var oddsType: Int? = 1
}
