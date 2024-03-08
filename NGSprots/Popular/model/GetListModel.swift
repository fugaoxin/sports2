//
//  MatchGetListModel.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/30.
//

import Foundation
import HandyJSON

struct matchGetListModel:HandyJSON {
    //当前页码
    var current:Int?
    //每页显示行数
    var size: Int?
    //总条数
    var total: Int?
    //记录列表
    var records: [recordModel]?
}

struct myMatchGetListModel:HandyJSON {
    //联赛id
    var id:Int?
    //联赛名字
    var na: String?
    //联赛图标地址
    var lurl: String?
    //展开或关闭
    var type:String?
    //收藏
    var sctype:Bool?
    //记录列表
    var records: [recordModel]?
}

struct recordModel:HandyJSON {
    //收藏
    var sctype:Bool?
    //比分列表，提供各个赛事阶段的比分
    var nsg:[nsgModel]?
    //赔率列表
    var mg: [mgModel]?
    //单个赛事玩法总数
    var tms: Int?
    //盘口组标签集合 , see enum: market_tag
    var tps: [String]?
    //联赛信息
    var lg:lgModel?
    //球队信息，第一个是主队，第二个是客队
    var ts: [tsModel]?
    //比赛时钟信息，滚球走表信息
    var mc: mcModel?
    //赛事 ID
    var id:Int?
    //赛事开赛时间
    var bt: Int?
    //赛事进行状态，返回赛事进行状态code，具体请对照枚举 , see enum: match_status
    var ms: Int?
    //赛制的场次、局数、节数
    var fid: Int?
    //赛制 , see enum: match_format
    var fmt:Int?
    //中立场标记，0 非中立场 ，1 中立场
    var ne: Int?
    var vs: vsModel?
    //动画直接地址集合
    var `as`: [String]?
    //运动ID , see enum: sports
    var sid:Int?
    //主/客发球，1主队发球，2客队发球, see enum: serving_side
    var ssi: Int?
    //赛事类型 1 冠军投注赛事，2 正常赛事 , see enum: match_type
    var ty: Int?
    //冠军赛赛事名称，用于展示名称
    var nm: String?
    //比分板
    var sb: [sbModel]?
    
    //virtual
    //联赛图标地址
    var lurl: String?
    //联赛名称
    var na: String?
    //EBlock名称
    var bnm: String?
    //赛事开赛时间倒计时 
    var cd: Int?
}

struct vsModel:HandyJSON {
    var flvHD:String?
    var flvSD:String?
    var m3u8HD: String?
    var m3u8SD: String?
    var web:String?
    var have: Bool?
    
    var url: String?
}

struct nsgModel:HandyJSON {
    //赛事阶段 , see enum: period
    var pe:Int?
    //比分类型，如 比分、角球、红黄牌等类型 , see enum: result_type_group
    var tyg: Int?
    //比分，数组形式，第一个数是主队分，第二个数是客对分
    var sc:[Int]?
}

struct mgModel:HandyJSON {
    //玩法类型，如 亚盘、大小球等 , see enum: market_type
    var mty:Int?
    //玩法阶段，如足球上半场、全场等，和玩法类型组合成一个玩法 , see enum: period
    var pe: Int?
    //玩法赔率集合，带线玩法，数组里是多个，或者一个玩法，不带线玩法，数组就是一条数据
    var mks:[mksModel]?
    //玩法展示分类数组， 如：热门、角球、波胆等，返回英文字母简称 , see enum: market_tag
    var tps: [String]?
    //玩法名称
    var nm:String?
    //标记
    var bjtype:Bool?
    //展开
    var zantype:Bool?
}

struct mksModel:HandyJSON {
    //玩法选项
    var op:[opModel]?
    //玩法ID
    var id: Int?
    //玩法销售状态，0暂停，1开售，-1未开售（未开售状态一般是不展示的） , see enum: market_curt_sale_status_enum
    var ss:Int?
    //是否支持串关，0 不可串关，1 可串关
    var au: Int?
}

struct opModel:HandyJSON {
    //选项全称，投注框一般用全称展示
    var na:String?
    //选项简称(全名or简名，订单相关为全名，否则为简名)， 赔率列表一般都用简称展示
    var nm: String?
    //选项类型，主、客、大、小等，投注时需要提交该字段作为选中的选项参数 , see enum: selection_type
    var ty:Int?
    //欧盘赔率，目前我们只提供欧洲盘赔率，投注是请提交该字段赔率值作为选项赔率，赔率小于0代表锁盘
    var od: String?
    var bod:Int?
    var odt: Int?
    
    //玩法销售状态，0暂停，1开售，-1未开售
    var ss: Int?
    //玩法ID
    var mksId: Int?
    //玩法名称
    var ngnm: String?
    var ngnmType: Bool?
    
    //赛事 ID
    var recordsId: Int?
    //冠军赛赛事名称
    var recordsnm: String?
    //联赛名称
    var lgna: String?
    //赛事开赛时间
    var recordsbt: Int?
    //是否支持串关，0 不可串关，1 可串关
    var au: Int?
    //玩法展示分类数组， 如：热门、角球、波胆等
    var tps: String?
    //投注选项名称(全名or简名，目前为全名)
    var opsOnm: String?
    
    var selectType: Bool? = true
}

struct lgModel:HandyJSON {
    //联赛名称
    var na:String?
    //联赛ID
    var id: Int?
    //联赛等级，可用于联赛排序，值越小，联赛等级越高
    var or:Int?
    //联赛图标地址
    var lurl: String?
    //运动种类id , see enum: sports
    var sid:Int?
    //区域id
    var rid: Int?
    //区域名称
    var rnm:String?
    //是否热门
    var hot: Bool?
    //联赛分组
    var slid: Int?
    //EBlock名称
    var bnm: String?
}

struct tsModel:HandyJSON {
    //球队名称
    var na:String?
    //球队id
    var id: Int?
    //球队图标地址
    var lurl:String?
}

struct mcModel:HandyJSON {
    //走表时间，以秒为单位，如250秒，客户端用秒去转换成时分秒时间
    var s:Int?
    //赛事阶段，如 足球上半场，篮球第一节等 , see enum: match_period
    var pe: Int?
    //是否走表，true为走表，false为停表
    var r:Bool?
    //走表类型 , see enum: clock_type, 1、正序， 2、倒序
    var tp: Int?
}

struct sbModel:HandyJSON {
    //斯诺克，谁在打球
    var sv:String?
    //斯诺克，剩余红球的数量
    var srr: Int?
}
