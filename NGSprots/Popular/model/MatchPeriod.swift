//
//  MatchPeriod.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/24.
//

import Foundation

func MatchPeriod(key: Int) -> String {
    switch key {
    case 1001:
    return "soccer Not started"
    case 1002:
    return "soccer First Half"
    case 1003:
    return "soccer Half Time"
    case 1004:
    return "soccer Second Half"
    case 1005:
    return "soccer FT-Finish"
    case 1006:
    return "soccer ET-First Half"
    case 1007:
    return "soccer ET-Half Time"
    case 1008:
    return "soccer ET-Second Half"
    case 1009:
    return "soccer ET-Finish"
    case 1010:
    return "soccer Penalty"
    case 1011:
    return "soccer Finish"
    case 1012:
    return "soccer Awaiting ET"
    case 1013:
    return "soccer Awaiting Penalty"
    case 1014:
    return "soccer Penalty-Finish"
    case 1015:
    return "soccer Interrupted"
    case 1016:
    return "soccer Abandoned"
     
    //🏀
    case 3001:
    return "basketball Not started"
    case 3002:
    return "basketball First Half"
    case 3003:
    return "basketball Half Time"
    case 3004:
    return "basketball Second Half"
    case 3005:
    return "basketball FirstQuarter"
    case 3006:
    return "basketball Break 1"
    case 3007:
    return "basketball SecondQuarter"
    case 3008:
    return "basketball Half Time"
    case 3009:
    return "basketball ThirdQuarter"
    case 3010:
    return "basketball Break 3"
    case 3011:
    return "basketball FourthQuarter"
    case 3012:
    return "basketball OverTime"
    case 3013:
    return "basketball RT-Finish"
    case 3014:
    return "basketball Finish"
    case 3015:
    return "basketball Awaiting OT"
    case 3016:
    return "basketball OT-Finish"
    case 3017:
    return "basketball Delayed"
    case 3018:
    return "basketball Interrupted"
    case 3019:
    return "basketball Abandoned"
        
    //🏐
    case 13001:
    return "volleyball Not started"
    case 13002:
    return "volleyball 1st Set"
    case 13003:
    return "volleyball 1st Set Ended"
    case 13004:
    return "volleyball 2nd Set"
    case 13005:
    return "volleyball 2nd Set Ended"
    case 13006:
    return "volleyball 3rd Set"
    case 13007:
    return "volleyball 3rd Set Ended"
    case 13008:
    return "volleyball 4th Set"
    case 13009:
    return "volleyball 4th Set Ended"
    case 13010:
    return "volleyball 5th Set"
    case 13011:
    return "volleyball 5th Set Ended"
    case 13012:
    return "volleyball 6th Set"
    case 13013:
    return "volleyball 6th Set Ended"
    case 13014:
    return "volleyball 7th Set"
    case 13015:
    return "volleyball End"
    case 13016:
    return "volleyball Awaiting GSet"
    case 13017:
    return "volleyball Golden Set"
    case 13018:
    return "volleyball After GSet End"
    case 13019:
    return "volleyball Walkover [P1 Won]"
    case 13020:
    return "volleyball Walkover [P2 Won]"
    case 13021:
    return "volleyball Retired P1 [P2 Won]"
    case 13022:
    return "volleyball Walkover P2 [P1 Won]"
    case 13023:
    return "volleyball Delayed"
    case 13024:
    return "volleyball Interrupted"
    case 13025:
    return "volleyball Abandoned"
       
    //🎾
    case 5001:
    return "tennis Not started"
    case 5002:
    return "tennis 1st Set"
    case 5003:
    return "tennis 1st Set Ended"
    case 5004:
    return "tennis 2nd Set"
    case 5005:
    return "tennis 2nd Set Ended"
    case 5006:
    return "tennis 3rd Set"
    case 5007:
    return "tennis 3rd Set Ended"
    case 5008:
    return "tennis 4th Set"
    case 5009:
    return "tennis 4th Set Ended"
    case 5010:
    return "tennis 5th Set"
    case 5011:
    return "tennis Ended"
    case 5012:
    return "tennis Walkover [P1 Won]"
    case 5013:
    return "tennis Walkover [P2 Won]"
    case 5014:
    return "tennis Retired P1 [P2 Won]"
    case 5015:
    return "tennis Retired P2 [P1 Won]"
    case 5016:
    return "tennis Retired"
    case 5017:
    return "tennis Defaulted P1 [P2 Won]"
    case 5018:
    return "tennis Defaulted P2 [P1 Won]"
    case 5019:
    return "tennis Delayed"
    case 5020:
    return "tennis Interrupted"
    case 5021:
    return "tennis Abandoned"
        
        
    // 🥊
    case 19001:
    return "boxing Not started"
    case 19020:
    return "boxing Ended"
    case 19021:
    return "boxing Postponed"
    case 19022:
    return "boxing Cancelled"
        
    //🏒️
    case 2001:
    return "iceHockey Not started"
    case 2002:
    return "iceHockey 1st Period"
    case 2003:
    return "iceHockey 1st Period Ended"
    case 2004:
    return "iceHockey 2nd Period"
    case 2005:
    return "iceHockey 2nd Period Ended"
    case 2006:
    return "iceHockey 3rd Period"
    case 2007:
    return "iceHockey Finish"
    case 2008:
    return "iceHockey Awaiting OT"
    case 2009:
    return "iceHockey Over Time"
    case 2010:
    return "iceHockey After OT"
    case 2011:
    return "iceHockey Awaiting PEN"
    case 2012:
    return "iceHockey Penalty"
    case 2013:
    return "iceHockey Penalty-Finish"
    case 2014:
    return "iceHockey Interrupted"
    case 2015:
    return "iceHockey Abandoned"
    case 2016:
    return "iceHockey Ended"
    
    //兵乓球
    case 15001:
    return "table tennis Not started"
    case 15002:
    return "table tennis 1st Game"
    case 15003:
    return "table tennis 1st Game Ended"
    case 15004:
    return "table tennis 2nd Game"
    case 15005:
    return "table tennis 2nd Game Ended"
    case 15006:
    return "table tennis 3rd Game"
    case 15007:
    return "table tennis 3rd Game Ended"
    case 15008:
    return "table tennis 4th Game"
    case 15009:
    return "table tennis 4th Game Ended"
    case 15010:
    return "table tennis 5th Game"
    case 15011:
    return "table tennis 5th Game Ended"
    case 15012:
    return "table tennis 6th Game"
    case 15013:
    return "table tennis 6th Game Ended"
    case 15014:
    return "table tennis 7th Game"
    case 15015:
    return "table tennis Ended"
    case 15016:
    return "table tennis Walkover [P1 Won]"
    case 15017:
    return "table tennis Walkover [P2 Won]"
    case 15018:
    return "table tennis Retired P1 [P2 Won]"
    case 15019:
    return "table tennis Retired P2 [P1 Won]"
    case 15020:
    return "table tennis Defult P1 [P2 Won]"
    case 15021:
    return "table tennis Defult P2 [P1 Won]"
    case 15022:
    return "table tennis Delayed"
    case 15023:
    return "table tennis Interrupted"
    case 15024:
    return "table tennis Abandoned"
        
    //棒球
    case 7001:
    return "baseball Not started"
    case 7003:
    return "baseball Inning 1 Top"
    case 7004:
    return "baseball Break 1st Top 1st Bottom"
    case 7005:
    return "baseball Inning 1 Bottom"
    case 7006:
    return "baseball Inning 1 Ended"
    case 7008:
    return "baseball Inning 2 Top"
    case 7009:
    return "baseball Break 2nd Top 2nd Bottom"
    case 7010:
    return "baseball Inning 2 Bottom"
    case 7011:
    return "baseball Inning 2 Ended"
    case 7013:
    return "baseball Inning 3 Top"
    case 7014:
    return "baseball Break 3rd Top 3rd Bottom"
    case 7015:
    return "baseball Inning 3 Bottom"
    case 7016:
    return "baseball Inning 3 Ended"
    case 7018:
    return "baseball Inning 4 Top"
    case 7019:
    return "baseball Break 4th Top 4th Bottom"
    case 7020:
    return "baseball Inning 4 Bottom"
    case 7021:
    return "baseball Inning 4 Ended"
    case 7023:
    return "baseball Inning 5 Top"
    case 7024:
    return "baseball Break 5th Top 5th Bottom"
    case 7025:
    return "baseball Inning 5 Bottom"
    case 7026:
    return "baseball Inning 5 Ended"
    case 7028:
    return "baseball Inning 6 Top"
    case 7029:
    return "baseball Break 6th Top 6th Bottom"
    case 7030:
    return "baseball Inning 6 Bottom"
    case 7031:
    return "baseball Inning 6 Ended"
    case 7033:
    return "baseball Inning 7 Top"
    case 7034:
    return "baseball Break 7th Top 7th Bottom"
    case 7035:
    return "baseball Inning 7 Bottom"
    case 7036:
    return "baseball Inning 7 Ended"
    case 7038:
    return "baseball Inning 8 Top"
    case 7039:
    return "baseball Break 8th Top 8th Bottom"
    case 7040:
    return "baseball Inning 8 Bottom"
    case 7041:
    return "baseball Inning 8 Ended"
    case 7043:
    return "baseball Inning 9 Top"
    case 7044:
    return "baseball Break 9th Top 9th Bottom"
    case 7045:
    return "baseball Inning 9 Bottom"
    case 7046:
    return "baseball Inning 9 Ended"
    case 7048:
    return "baseball Extra Inning Top"
    case 7049:
    return "baseball Break EI Top EI Bottom"
    case 7050:
    return "baseball Extra Inning Bottom"
    case 7051:
    return "baseball Ended"
    case 7052:
    return "baseball Interrupted"
    case 7053:
    return "baseball Abandoned"
        
        
    //🏸️
    case 47001:
    return "badminton Not started"
    case 47002:
    return "badminton 1st Game"
    case 47003:
    return "badminton 1st Game Ended"
    case 47004:
    return "badminton 2nd Game"
    case 47005:
    return "badminton 2nd Game Ended"
    case 47006:
    return "badminton 3rd Game"
    case 47007:
    return "badminton 3rd Game Ended"
    case 47008:
    return "badminton 4th Game"
    case 47009:
    return "badminton 4th Game Ended"
    case 47010:
    return "badminton 5th Game"
    case 47015:
    return "badminton Ended"
    case 47016:
    return "badminton Walkover [P1 Won]"
    case 47017:
    return "badminton Walkover [P2 Won]"
    case 47018:
    return "badminton Retired P1 [P2 Won]"
    case 47019:
    return "badminton Retired P2 [P1 Won]"
    case 47020:
    return "badminton Defult P1 [P2 Won]"
    case 47021:
    return "badminton Defult P2 [P1 Won]"
    case 47022:
    return "badminton Delayed"
    case 47023:
    return "badminton Interrupted"
    case 47024:
    return "badminton Abandoned"
      
    //美式🏈
    case 6001:
    return "american football Not started"
    case 6002:
    return "american football 1Q"
    case 6003:
    return "american football Pause 1"
    case 6004:
    return "american football 2Q"
    case 6005:
    return "american football Pause 2"
    case 6006:
    return "american football 3Q"
    case 6007:
    return "american football Pause 3"
    case 6008:
    return "american football 4Q"
    case 6009:
    return "american football RT-Finish"
    case 6010:
    return "american football Awaiting OT"
    case 6011:
    return "american football Over Time"
    case 6012:
    return "american football OT-Finish"
    case 6013:
    return "american football Finish"
    case 6014:
    return "american football Interrupted"
    case 6015:
    return "american football Abandoned"
        
    //🎱
    case 16001:
    return "snooker Not started"
    case 16002:
    return "snooker In Progress"
    case 16003:
    return "snooker Frame Break"
    case 16004:
    return "snooker Paused"
    case 16005:
    return "snooker Ended"
    case 16006:
    return "snooker Walkover [P1 Won]"
    case 16007:
    return "snooker Walkover [P2 Won]"
    case 16008:
    return "snooker Retired P1 [P2 Won]"
    case 16009:
    return "snooker Retired P2 [P1 Won]"
    case 16010:
    return "snooker Defult P1 [P2 Won]"
    case 16011:
    return "snooker Defult P2 [P1 Won]"
    case 16012:
    return "snooker Delayed"
    case 16013:
    return "snooker Interrupted"
    case 16014:
    return "snooker Abandoned"
        
    //电子⚽️
    case 177001:
    return "e-soccer Not started"
    case 177002:
    return "e-soccer First Half"
    case 177003:
    return "e-soccer Half Time"
    case 177004:
    return "e-soccer Second Half"
    case 177005:
    return "e-soccer FT-Finish"
    case 177006:
    return "e-soccer Awaiting ET"
    case 177007:
    return "e-soccer ET-First Half"
    case 177008:
    return "e-soccer ET-Half Time"
    case 177009:
    return "e-soccer ET-Second Half"
    case 177010:
    return "e-soccer ET-Finish"
    case 177011:
    return "e-soccer Awaiting Penalty"
    case 177012:
    return "e-soccer Penalty"
    case 177013:
    return "e-soccer Penalty-Finish"
    case 177014:
    return "e-soccer Finish"
    case 177015:
    return "e-soccer Interrupted"
    case 177016:
    return "e-soccer Abandoned"
        
    //电子🏀
    case 178001:
    return "e-basketball Not started"
    case 178002:
    return "e-basketball 1Q"
    case 178003:
    return "e-basketball Break 1"
    case 178004:
    return "e-basketball 2Q"
    case 178005:
    return "e-basketball Half Time"
    case 178006:
    return "e-basketball 3Q"
    case 178007:
    return "e-basketball Break 3"
    case 178008:
    return "e-basketball 4Q"
    case 178009:
    return "e-basketball RT-Finish"
    case 178010:
    return "e-basketball Awaiting OT"
    case 178011:
    return "e-basketball Over Time"
    case 178012:
    return "e-basketball OT-Finish"
    case 178013:
    return "e-basketball Finish"
    case 178014:
    return "e-basketball Delayed"
    case 178015:
    return "e-basketball Interrupted"
    case 178016:
    return "e-basketball Abandoned"
        
    //手qiu
    case 8001:
    return "Handball Not Started"
    case 8002:
    return "Handball First Half"
    case 8003:
    return "Handball Half Time"
    case 8004:
    return "Handball Second Half"
    case 8005:
    return "Handball FT-Finish"
    case 8006:
    return "Handball Awaiting ET"
    case 8007:
    return "Handball ET-First Half"
    case 8008:
    return "Handball ET-Half Time"
    case 8009:
    return "Handball ET-Second Half"
    case 8010:
    return "Handball ET-Finish"
    case 8011:
    return "Handball Awaiting Penalty"
    case 8012:
    return "Handball Penalty"
    case 8013:
    return "Handball Penalty-Finish"
    case 8014:
    return "Handball Finish"
    case 8015:
    return "Handball Interrupted"
    case 8016:
    return "Handball Abandoned"
    
    //沙滩🏐️
    case 51001:
    return "Beach Volleyball Not Started"
    case 51002:
    return "Beach Volleyball 1st Set"
    case 51003:
    return "Beach Volleyball 1st Set Ended"
    case 51004:
    return "Beach Volleyball 2nd Set"
    case 51005:
    return "Beach Volleyball 2nd Set Ended"
    case 51006:
    return "Beach Volleyball 3rd Set"
    case 51007:
    return "Beach Volleyball 3rd Set Ended"
    case 51008:
    return "Beach Volleyball 4th Set"
    case 51009:
    return "Beach Volleyball 4th Set Ended"
    case 51010:
    return "Beach Volleyball 5th Set"
    case 51011:
    return "Beach Volleyball Ended"
    case 51012:
    return "Beach Volleyball Walkover [P1 Won]"
    case 51013:
    return "Beach Volleyball Walkover [P2 Won]"
    case 51014:
    return "Beach Volleyball Retired P1 [P2 Won]"
    case 51015:
    return "Beach Volleyball Retired P2 [P1 Won]"
    case 51016:
    return "Beach Volleyball Interrupted"
    case 51017:
    return "Beach Volleyball Abandoned"
        
    //格豆
    case 18001:
    return "MMA Not Started"
    case 18020:
    return "boxing Ended"
    case 18021:
    return "boxing Postponed"
    case 18022:
    return "boxing Cancelled"
        
    //🏈
    case 4001:
    return "Rugby Not Started"
    case 4002:
    return "Rugby First Half"
    case 4003:
    return "Rugby Half Time"
    case 4004:
    return "Rugby Second Half"
    case 4005:
    return "Rugby FT-Finish"
    case 4006:
    return "Rugby Awaiting OT"
    case 4007:
    return "Rugby Over Time"
    case 4008:
    return "Rugby OT-First Half"
    case 4009:
    return "Rugby OT-Half Time"
    case 4010:
    return "Rugby OT-Second Half"
    case 4011:
    return "Rugby OT-Finish"
    case 4012:
    return "Rugby Awaiting SD"
    case 4013:
    return "Rugby SD"
    case 4014:
    return "Rugby After SD"
    case 4015:
    return "Rugby Awaiting Penalty"
    case 4016:
    return "Rugby Penalty"
    case 4017:
    return "Rugby Penalty-Finish"
    case 4018:
    return "Rugby Postponed"
    case 4019:
    return "Rugby Interrupted"
    case 4020:
    return "Rugby Abandoned"
        
    //水qiu
    case 24001:
    return "Water Polo Not Started"
    case 24020:
    return "Water Polo Ended"
    case 24021:
    return "Water Polo Postponed"
    case 24022:
    return "Water Polo Cancelled"
        
    //f1🏎️
    case 92001:
    return "FORMULA 1 Not Started"
    case 92020:
    return "FORMULA 1 Ended"
    case 92021:
    return "FORMULA 1 Postponed"
    case 92022:
    return "FORMULA 1 Cancelled"
     
    //板qiu
    case 14001:
    return "Cricket Not Started"
    case 14003:
    return "Cricket First Innings, Home Team"
    case 14004:
    return "Cricket First Innings, Away Team"
    case 14006:
    return "Cricket Second Innings, Home Team"
    case 14007:
    return "Cricket Second Innings, Away Team"
    case 14008:
    return "Cricket Awaiting Super Over"
    case 14010:
    return "Cricket Super Over, home team"
    case 14011:
    return "Cricket Super Over, away team"
    case 14012:
    return "Cricket After Super Over"
    case 14013:
    return "Cricket Innings Break"
    case 14014:
    return "Cricket Super Over Break"
    case 14015:
    return "Cricket Lunch Break"
    case 14016:
    return "Cricket Tea Break"
    case 14017:
    return "Cricket Stumps"
    case 14018:
    return "Cricket Ended"
    case 14019:
    return "Cricket Interrupted"
    case 14020:
    return "Cricket Abandoned"
        
        
    default:
        return ".."
    }
}
