//
//  SportsImg.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/15.
//

import Foundation

func getSportImg(key: Int) -> String{
    switch key {
    case 1:
    return "Football"
    case 2:
    return "Ice hockey"
    case 3:
    return "Basketball"
    case 4:
    return "Rugby"
    case 5:
    return "Tennis"
    case 6:
    return "American Football"
    case 7:
    return "Baseball"
    case 13:
    return "Volleyball"
    case 14:
    return "Cricket"
    case 15:
    return "Table Tennis"
    case 16:
    return "Snooker"
    case 19:
    return "Boxing"
    case 47:
    return "Badminton"
    default:
        return "Esports"
    }
}
