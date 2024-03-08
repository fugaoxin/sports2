//
//  Language.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/17.
//

import Foundation

enum LanguageKey:Int {
    case CN = 1
    case EN = 2
}

enum gameKey: String{
    case ENG
    case CMN
}

func setLanguage(lang: Int){
    UserDefaults.standard.set(lang, forKey: "Applang")
    UserDefaults.standard.synchronize()
}

func getLanguage() -> LanguageKey{
    let lang = UserDefaults.standard.integer(forKey: "Applang")
    if lang == 0 || lang == 1{
        return .CN
    }
    return .EN
}

func getGameLanguage() -> String{
    let lang = getLanguage()
    switch lang {
        case .CN:
        return "CMN"
        case .EN:
        return "ENG"
    }
}

func getLanguageByKey(key: String) -> String {
    let lang = getLanguage()
    var path = ""
    switch lang {
        case .CN:
        path = Bundle.main.path(forResource: "zh-Hans.lproj/Localizable", ofType: "strings") ?? ""
            break
        case .EN:
        path = Bundle.main.path(forResource: "en.lproj/Localizable", ofType: "strings") ?? ""
            break
    }
    let localDict:NSDictionary = NSDictionary(contentsOfFile: path) ?? ["test":""]
    if ((localDict.object(forKey: key)) != nil){
        return localDict.object(forKey: key) as! String
    }
    return ""
}
