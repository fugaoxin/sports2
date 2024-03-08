//
//  SportsType.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/5.
//

import Foundation
import HandyJSON

func getSportsName(Id: Int) -> String {
    switch Id {
    case 1:
    return "Football"
    case 2:
    return "IceHockey"
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
    case 8:
    return "Handball"

    case 10:
    return "Floorball"
    case 12:
    return "Golf"
    case 13:
    return "Volleyball"
    case 14:
    return "Cricket"
    case 15:
    return "TableTennis"
    case 16:
    return "Snooker"
    case 17:
    return "Futsal"
    case 18:
    return "MixedMartialArts"
    case 19:
    return "Boxing"
    case 20:
    return "Darts"
    case 21:
    return "Bowls"
    case 24:
    return "WaterPolo"
    case 25:
    return "Cycling"
        
    case 47:
    return "Badminton"
    case 51:
    return "BeachVolleyball"
    case 92:
    return "Formula 1"
    case 93:
    return "Specials"
    case 94:
    return "Stock Car Racing"
    case 95:
    return "Motorcycle Racing"
    case 100:
    return "Olympic"
    case 101:
    return "Asian Game"
    case 164:
    return "Dota2"
    case 165:
    return "LOL"
    case 177:
    return "E-Football"
    case 178:
    return "E-Basketball"
    case 179:
    return "CS:GO"
    case 180:
    return "KOG"
    case 1001:
    return "Virtual Soccer"
    case 1020:
    return "Virtual Horse"
    case 1021:
    return "Virtual Greyhounds"
    case 1022:
    return "Virtual Speedway"
    case 1023:
    return "Virtual Motorbike"
    default:
        return "母鸡"
    }
}


struct SportsModel:HandyJSON {
  
    var list: [SportsItemModel]?
    
    var all: [SportsItemModel]?
}

class SportsItemModel:HandyJSON {
    
    var id: Int?
    
    var name: String?
    
    var image: String?
    var imageHighlight: String?
    
    var games: [SportsItemIDModel]?
    
    var select : Bool!
    
    var num: Int? = 0
    
    required init(){
       
    }
}
struct SportsItemIDModel:HandyJSON {
    var id: Int?
    var sportId: Int?
    var isVirtual: Bool?
}


func getSportsID(type: String) -> String {
    switch type {
    case "Football":
    return "1"
    case "Ice hockey":
    return "2"
    case "Ice Hockey":
    return "2"
    case "Basketball":
    return "3"
    case "Rugby":
    return "4"
    case "Tennis":
    return "5"
    case "American Football":
    return "6"
    case "Baseball":
    return "7"
    case "Handball":
    return "8"

    case "Floorball":
    return "10"
    case "Golf":
    return "12"
    case "Volleyball":
    return "13"
    case "Cricket":
    return "14"
    case "Table Tennis":
    return "15"
    case "Snooker":
    return "16"
    case "Futsal":
    return "17"
    case "MixedMartialArts":
    return "18"
    case "Boxing":
    return "19"
    case "Darts":
    return "20"
    case "Bowls":
    return "21"
    case "WaterPolo":
    return "24"
    case "Cycling":
    return "25"
        
    case "Badminton":
    return "47"
    case "BeachVolleyball":
    return "51"
    case "Formula 1":
    return "92"
    case "Specials":
    return "93"
    case "Stock Car Racing":
    return "94"
    case "Motorcycle Racing":
    return "95"
    case "Olympic":
    return "100"
    case "Asian Game":
    return "101"
    case "Dota2":
    return "164"
    case "LOL":
    return "165"
    case "E-Football":
    return "177"
    case "E-Basketball":
    return "178"
    case "CS:GO":
    return "179"
    case "KOG":
    return "180"
    case "Virtual Soccer":
    return "1001"
    case "Horse Racing":
    return "1020"
    case "Virtual Greyhounds":
    return "1021"
    case "Virtual Speedway":
    return "1022"
    case "Virtual Motorbike":
    return "1023"
    default:
        return "177"//不认识的当电子足球先
    }
}

func getVirtualSportsName(Id: Int) -> String {
    switch Id {
    case 1001:
    return "Football"
    case 1020:
    return "Horse"
    case 1021:
    return "Greyhounds"
    case 1022:
    return "Speedway"
    case 1023:
    return "Motorbike"
    default:
        return ".."
    }
}


func getPeriodScore(pe:Int) -> Bool {
    let arr = [1002,1003,3005,3006,3007,3008,13002,13003,13004,13005,13006,13007,13008,5002,5003,5004,5005,5006,
               15002,15003,15004,15005,15006,15007,15008,7004,7005,7006,7007,7008,7009,7010,7011,7012,
               47002,47003,47004,47005,47006,2003,2004,2005,6005,6006,6007,6008,16002,16003,16004,16005,16006,16007,16008,16009,16010,
               51002,51003,51004,51005,51006,8003,8004,4003,4004,177002,177003,178005,178006,178007,178008]
    if arr.contains(pe){
        return true
    }
    return false
}


func getTopSportsImg(Id: Int) -> String {
    switch Id {
    case 1:
    return "Soccer_icon_svg"
    case 2:
    return "Ice hockey_icon"
    case 3:
    return "Basketball_icon_svg"
    case 4:
    return "Rugby_icon"
    case 5:
    return "Tennis_icon_svg"
    case 6:
    return "American Football_icon"
    case 7:
    return "Baseball_icon"
    case 8:
    return "Handball_icon"
    case 10:
    return "FLoorball_icon"
    case 12:
    return "Golf_icon"
    case 13:
    return "Volleyball_icon"
    case 14:
    return "Cricket_icon_svg"
    case 15:
    return "Table  Tennis_icon"
    case 16:
    return "Snooker_icon"
    case 17:
    return "Futsal_icon"
    case 18:
    return "mma_icon"
    case 19:
    return "boxing_icon"
    case 20:
    return "Darts_icon"
    case 21:
    return "Bowls_icon"
    case 24:
    return "WaterPolo_icon"
    case 25:
    return "Cycling_icon"
    case 47:
    return "Badminton_icon"
    case 51:
    return "BeachVolleyball_icon"
    case 92:
    return "Formula 1_icon"
    case 93:
    return "Specials_icon"
    case 94:
    return "Stock Car Racing_icon"
    case 95:
    return "Motorcycle Racing_icon"
    case 100:
    return "Olympic_icon"
    case 101:
    return "Asian Game_icon"
    case 164:
    return "Darts_icon"
    case 165:
    return "LOL_icon"
    case 177:
    return "E-Football_icon"
    case 178:
    return "E-Basketball_icon"
    case 179:
    return "CSGO_icon"
    case 180:
    return "KOG_icon"
    case 1001:
    return "Virtual Football_icon"
    case 1020:
    return "Virtual Horse_icon"
    case 1021:
    return "Virtual Greyhounds_icon"
    case 1022:
    return "Virtual Speedway_icon"
    case 1023:
    return "Virtual Motorbike_icon"
    case 0:
    return "All"
    case -1:
    return "Screen"
    default:
        return "Soccer_icon_svg"
    }
}

func getClassSportsImg(Id: Int) -> String {
    switch Id {
    case 1:
    return "icon-Soccer-44x44"
    case 2:
    return "icon-Ice hockey-44x44"
    case 3:
    return "icon-Basketball-44x44"
    case 4:
    return "icon-Rugby-44x44"
    case 5:
    return "icon-Tennis-44x44"
    case 6:
    return "icon-AmericanFootball-44x44"
    case 7:
    return "icon-Baseball-44x44"
    case 8:
    return "icon-Handball-44x44"
    case 10:
    return "icon-FLoorball-44x44"
    case 12:
    return "icon-Golf-44x44"
    case 13:
    return "icon-Volleyball-44x44"
    case 14:
    return "icon-Cricket-44x44"
    case 15:
    return "icon-TableTennis-44x44"
    case 16:
    return "icon-Snooker-44x44"
    case 17:
    return "icon-Futsal-44x44"
    case 18:
    return "icon-MMA-44x44"
    case 19:
    return "icon-Boxing-44x44"
    case 20:
    return "icon-Darts-44x44"
    case 21:
    return "icon-Bowls-44x44"
    case 24:
    return "icon-waterpolo-44x44"
    case 25:
    return "icon-Cycling-44x44"
    case 47:
    return "icon-Badminton-44x44"
    case 51:
    return "icon-BeachVolleyball-44x44"
    case 92:
    return "icon-Formula-1-44x44"
    case 93:
    return "icon-Specials-44x44"
    case 94:
    return "icon-Stock-Car-Racing-44x44"
    case 95:
    return "icon-Motorcycle-Racing-44x44"
    case 100:
    return "icon-Olympic-44x44"
    case 101:
    return "icon-Asian-Game-44x44"
    case 164:
    return "icon-Darts-44x44"
    case 165:
    return "icon-LOL-44x44"
    case 177:
    return "icon-E-Football-44x44"
    case 178:
    return "icon-E-Basketball-44x44"
    case 179:
    return "icon-CSGO-44x44"
    case 180:
    return "icon-KOG-44x44"
    case 1001:
    return "icon-Virtual-Football-44x44"
    case 1020:
    return "icon-Virtual-Horse-44x44"
    case 1021:
    return "icon-Virtual-Greyhounds-44x44"
    case 1022:
    return "icon-Virtual-Speedway-44x44"
    case 1023:
    return "icon-Virtual-Motorbike-44x44"
    default:
        return "Soccer_icon"
    }
}
