//
//  OrderStatus.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/14.
//

import Foundation

func getDayStatus(key: Int) -> String{
    switch key {
    case 100:
    return "Today"
    case 101:
    return "Yesterday"
    case 102:
    return "1 week"
    case 103:
    return "Optional"
    default:
        return "Today"
    }
}

func getOutcome(key: Int) -> String{
    switch key {
    case 0:
    return "NoResulted"
    case 2:
    return "Return"
    case 3:
    return "Lost"
    case 4:
    return "Won"
    case 5:
    return "WinReturn"
    case 6:
    return "LooseReturn"
    case 7:
    return "Cancel"
    default:
        return "NoResulted"
    }
}

func getOutcomeColor(key: Int) -> String{
    switch key {
    case 4,5:
    return "0CD664"
    default:
        return "FF3344"
    }
}

func getOrderStatus(key: Int) -> String{
    switch key {
    case 0:
    return "Created..."
    case 1:
    return "Confirming..."
    case 2:
    return "Rejected"//
    case 3:
    return "Canceled"
    case 4:
    return "Accepted"//Confirmed
    case 5:
    return "Settled"
    default:
        return ""
    }
}

func getUWL(key: String) -> String{
    if key.contains("-"){
        return "Lost"
    }else{
        return "Won"
    }
}

func getUWLColor(key: String) -> String{
    if key.contains("-") || key == "0"{
        return "FF3344"
    }else{
        return "0CD664"
    }
}

func getUWLLogo(key: String) -> String{
    if key.contains("-") || key == "0"{
        return "组 124424Q"
    }else{
        return "组 124424"
    }
}
