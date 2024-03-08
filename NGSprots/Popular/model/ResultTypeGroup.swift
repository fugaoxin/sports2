//
//  ResultTypeGroup.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/1.
//

import Foundation

//纵向排列运动
func getSportIdType(key: Int) -> Bool {
    if key == 5 || key == 7 || key == 13 || key == 15 || key == 16 || key == 51{
        return true
    }else{
        return false
    }
}

func getMarketTag(key: String) -> String{
    switch key {
    case "p":
    return "Popular"
    case "h":
    return "Handicap & Over/Under"
    case "s":
    return "Score"
    case "f":
    return "Half"
    case "c":
    return "Corner"
    case "i":
    return "Special"
    case "cs":
    return "Correct Score"
    case "b":
    return "Booking"
    case "o":
    return "Other"
    case "q":
    return "Quarter"
    case "t":
    return "Intervals"
    case "j":
    return "Frame"
    case "set":
    return "Sets"
    case "qu":
    return "Quinella"
    case "z":
    return "Exacta"
    case "ps":
    return "Penalty Shootout"
    case "pro":
    return "Promotion Team"
    case "1st":
    return "Champion Team"
    case "3rd":
    return "Third Place Team"
    default:
        return "Regular time"
    }
}
