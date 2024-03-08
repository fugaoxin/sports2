//
//  WXHttps.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/18.
//

import Foundation
import Alamofire
import HandyJSON

var liveNumber = 0
var isTopHiddden = 0
var matchUrl = "https://iapi.ccapykdsd.com"
var virtualMatchUrl = "https://virtualapi.server.newsportspro.com"
let matchToken = "tt_vTzZ4pJ6rksejCfSGQJJagTAZaEThHvV.a7133ea47a1d3e7fcf70976f8670db1d"
let baseUrl = "https://nguapi.lindemo.cc"

//let mybaseUrl = "http://192.168.10.21:8081/wenxi"
//let mybaseUrl = "http://192.168.10.46:8003"

var chuanguanArray = [opModel]()

var gundongIndexArray = Array<(Int,Int)>()

enum wxApi{
    //MARK: -登陆与注册
    //手机注册
    case phoneRegist(param:RegisterParam)
    //手机登陆
    case emailRegist(param:RegisterParam)
    //手机登录
    case phoneLogin(param:LoginParam)
    //邮箱登录
    case emailLogin(param:LoginParam)
    //获取手机验证码
    case getPhoneCode(param:LoginParam)
    //获取邮箱验证码
    case getEmailCode(param:LoginParam)
    //申请通过手机改密码
    case applyResetPassWordByPhone(param:ResetPassWordParam)
    //申请通过邮箱改密码
    case applyResetPassWordByEmail(param:ResetPassWordParam)
    //确认修改密码
    case resetPassWordConfirm(param:ResetPassWordParam)
    //验证身份手机
    case checkUserByPhone(param:CheckUserIdentityParam)
    //验证身份邮箱
    case checkUserByEmail(param:CheckUserIdentityParam)
    
    //MARK: FB
    //游戏
    case gameAccessToken(param:GameTokenParam)
    
    //获取赛事列表信息
    case matchGetList(param:MatchGetListParam)
    //获取单个赛事详情及玩法
    case matchGetMatchDetail(param:MatchDetailParam)
    //获取联赛列表
    case matchGetOnSaleLeagues(param:MatchGetOnSaleLeaguesParam)
    //赛事统计
    case matchStatistical(param: MatchDetailParam)
    //投注前查询指定玩法赔率
    case orderBatchBetMatchMarketOfJumpLine(param: BatchBetMatchMarketOfJumpLineParam)
    //单关投注接口，可批量
    case orderBetSinglePass(param: singlePassParam)
    //投注记录接口
    case orderBetList(param: orderBetParam)
    //串关投注接口
    case orderBetMultiple(param: orderBetMultipleParam)
    //批量获取投注订单状态
    case orderGetStakeOrderStatus(param: StakeOrderStatusParam)
    
    //MARK: 购物车
    //购物车注单列表
    case cartBetSlipList
    //加入购物车
    case cartBetSlipAdd(param: carListModel)
    //移出购物车
    case cartBetSlipRemove(param: carListModel)
    
    //MARK: -系统配置
    //获取银行列表
    case getBankList(param:BaseSystemParam)
    //获取国家地区
    case getCountryAreaList
    
    //MARK: -用户相关
    case getUserInfo
    //增加银行卡
    case addBankCard(param:AddBankParam)
    //获取绑定的银行卡
    case getMyBankCard
    //删除银行卡
    case deleteBankCard(param:DeleteBankOrAddressParam)
    //增加虚拟币地址
    case addCoinAddress(param:AddCoinAddressParam)
    //获取绑定的虚拟币地址列表
    case getMyCoinAddress
    //删除虚拟币地址
    case deleteCoinAddress(param:DeleteBankOrAddressParam)
    //获取sport种类
    case getAllSports(param:BaseSystemParam)
    case getUnLoginSports
    case getLoginSports
    case editShowSports(param:BaseSystemParam)
    //绑定手机号
    case bindPhone(param:BindParam)
    //绑定手机号
    case bindEmail(param:BindParam)
    //登陆后修改密码
    case changePassword(param:ChangePasswordParam)
    //设置支付密码
    case setPayPassword(param:SetPayPassWordParam)
    //申请修改支付密码
    case applyEditPayPassword(param:ApplyChangePayPassWordParam)
    //确认修改支付密码
    case sureEditPayPassword(param:SetPayPassWordParam)
    //验证支付密码
    case checkPayPassword(param:SetPayPassWordParam)
    
    //更改盘口显示方式
    case editHandicapDisplayType(param:HandicapDisplayParam)
    //修改地址
    case editUserAddress(param:UserInfoParam)
    //修改头像
    case editUserHeader(param:UserInfoParam)
    //修改生日
    case editUserBirthday(param:UserInfoParam)
    //修改性别
    case editUserSex(param:UserInfoParam)
    //修改昵称
    case editUserNickname(param:UserInfoParam)
    //修改区域
    case editUserRegion(param:UserInfoParam)
    //获取区域
    case getUserRegion
    //获取区域下城市
    case getUserRegionCity(param:UserInfoParam)
    //获取用户活动任务
    case getUserPromotions(param:BaseSystemParam)
    //退出登陆
    case userLogout
    
    //MARK: -活动
    //注册活动详情
    case registerActivity
    //领取注册活动
    case getRegisterActivity
    //领取注册活动奖励
    case getRegisterActivityBouns(param:ActivityParam)
    //活动具体信息 有些活动不是原生包含h5链接
    case getActivityDetail(param:ActivityParam)
    //首chong活动详情
    case depositActivity
    
    //MARK: -消息通知
    //消息列表
    case getMessageList(param:MessageParam)
    //消息已读
    case readMessage(param:MessageParam)
    //获取未读消息数
    case getUnreadMessageCount
    //公告列表
    case getNoticeList(param:MessageParam)
    
    //MARK: -签到
    //签到
    case checkIn
    //查询签到情况
    case getCheckInDetail(param:CheckInParam)
    //查询本周签到领券详情
    case getCheckInCouponList(param:CheckInParam)
    
    //MARK: -支付
    //获取支付方式列表
    case getPayTypes(param:GetPayTypeParam)
    //充值申请
    case applyRecharge(param:ApplyRechargeParam)
    //提现申请
    case applyWithdraw(param:ApplyWithdrawParam)
    //充提记录http://192.168.10.31:8280/uapi/pay/rwList
    case payRwList(param:payRwListParam)
    //充提详情http://192.168.10.31:8280/uapi/pay/rwDetail
    case payRwDetail(param:payRwDetailParam)
    
    //MARK: -流水
    //列表
    case getRunningWaterList(param:RunningWaterParam)
    //获取筛选条件列表
    case getRunningWaterTypeList
    //获取钱包数据
    case getWalletData(param:BaseSystemParam)
    
    //MARK: -赛事收藏，浏览，置顶
    //收藏比赛
    case collectGame(param:CollectParam)
    //取消收藏比赛
    case cancelCollectGame(param:CancelCollectParam)
    //批量取消收藏比赛
    case batchCancelCollectGame(param:CancelCollectParam)
    //获取收藏比赛
    case getCollectGame
    //收藏联赛
    case collectLeagueMatch(param:CollectParam)
    //取消收藏联赛
    case cancelCollectLeagueMatch(param:CancelCollectParam)
    //批量取消收藏联赛
    case batchCancelCollectLeagueMatch(param:CancelCollectParam)
    //获取收藏联赛
    case getCollectLeagueMatch
    //记录浏览过的比赛
    case recordBrowseGame(param:RecordBrowseParam)
    //批量取消浏览过的比赛
    case batchCancelBrowseGame(param:RecordBrowseParam)
    //获取浏览过的比赛
    case getBrowseGame
    //置顶比赛玩法
    case topGameplay(param:GameplayParam)
    //取消置顶比赛玩法
    case cancelTopGameplay(param:GameplayParam)
    //获取置顶比赛玩法
    case getTopGameplay(param:GameplayParam)
    
    //MARK: -搜索
    //最热门搜索的关健词列表（前几个）（无需登录状态）
    case searchHotKeyList
    //记录搜索关键词
    case searchKeyAdd(param:searchModel)
    //清空所有搜索关键词
    case searchKeyClear
    //移除搜索关键词
    case searchKeyRemove(param:searchModel)
    //个人最近搜索的关键词列表（前几个）
    case searchRecentKeyList
    //根据球队或者赛事名搜索赛事
    case matchQueryMatchByRecommend(param:queryMatchByRecommendParam)
    
    //MARK: -优惠券
    //获取优惠券列表
    case couponList(param:CouponListParam)
    //当前条件下可用优惠券列表+最佳券+可用bonus
    case couponAvailableAndBonus(param:CouponListParam)
    //当前条件下可用优惠券列表+最佳券+无bonus
    case couponAvailable(param:CouponListParam)
    //获取优惠券
    case getCoupon(param:GetCouponParam)
    
    //MARK: -奖金
    //获取奖金列表
    case bonusList(param:CouponListParam)
    //计算当前投注条件下可获得的累积奖金
    case accabonusCalc(param:BounsParam)
    
    //MARK: -virtual
    //获取赛事列表信息
    case virtualMatchGetList(param:VirtualMatchGetListParam)
    //赛事统计
    case virtualMatchStatistical(param:MatchDetailParam)
    //获取单个赛事详情及玩法
    case virtualMatchGetMatchDetail(param:MatchDetailParam)
    //投注框赔率刷新接口
    case virtualOrderOddsCartRefresh(param:BatchBetMatchMarketOfJumpLineParam)
    //单关投注接口
    case virtualOrderSingleBet(param:VirtualSinglePassParam)
    
    //MARK: 游戏
    //游戏列表
    case gameList(param:GameTokenParam)
    //获取游戏详情列表
    case gameDetailsList(param:GameTokenParam)
    //获取游戏的url
    case gameAccessUrl(param:GameTokenParam)
    
    //MARK: 订单
    //获取订单列表
    //http://192.168.10.31:8280/uapi/order/list
    case orderList(param:OrderListParam)
    
    //MARK: 累积奖金
    //累积奖金：奖励详情表
    //uapi/awardTask/accaBonus/list
    case awardTaskAccaBonusList
    //累积奖金：当前情况下能获得的累积奖金的比例
    //uapi/awardTask/accaBonus/status
    case awardTaskAccaBonusStatus(param:accaBonusStatusParam)
    //用户任务的具体信息（包括跳转链接、背景图）
    //uapi/awardTask/req
    case awardTaskReq(param:accaBonusStatusParam)
}

extension wxApi{
    var path: String{
        switch self{
        case .phoneRegist(_):
            return baseUrl + "/uapi/user/signUpByPhone"
        case .emailRegist(_):
            return baseUrl + "/uapi/user/signUpByEmail"
        case .phoneLogin(_):
            return baseUrl + "/uapi/user/signInByPhone"
        case .emailLogin(_):
            return baseUrl + "/uapi/user/signInByEmail"
        case .getPhoneCode(_):
            return baseUrl + "/uapi/common/fetchCaptchaByPhone"
        case .getEmailCode(_):
            return baseUrl + "/uapi/common/fetchCaptchaByEmail"
        case .checkUserByPhone(_):
            return baseUrl + "/uapi/user/verifyPhone"
        case .checkUserByEmail(_):
            return baseUrl + "/uapi/user/verifyEmail"
            
        case .gameAccessToken(_):
            return baseUrl + "/uapi/game/accessToken"
        case .matchGetList(_):
            return matchUrl + "/v1/match/getList"
        case .matchGetMatchDetail(_):
            return matchUrl + "/v1/match/getMatchDetail"
        case .matchGetOnSaleLeagues(_):
            return matchUrl + "/v1/match/getOnSaleLeagues"
        case .matchStatistical(_):
            return matchUrl + "/v1/match/statistical"
        case .orderBatchBetMatchMarketOfJumpLine(_):
            return matchUrl + "/v1/order/batchBetMatchMarketOfJumpLine"
        case .orderBetSinglePass(_):
            return matchUrl + "/v1/order/bet/singlePass"
        case .orderBetList(_):
            return matchUrl + "/v1/order/bet/list"
        case .orderBetMultiple(_):
            return matchUrl + "/v1/order/betMultiple"
        case .orderGetStakeOrderStatus(_):
            return matchUrl + "/v1/order/getStakeOrderStatus"
        case .matchQueryMatchByRecommend(_):
            return matchUrl + "/v1/match/queryMatchByRecommend"
            
        case .cartBetSlipList:
            return baseUrl + "/uapi/cart/betSlipList"
        case .cartBetSlipAdd(_):
            return baseUrl + "/uapi/cart/betSlipAdd"
        case .cartBetSlipRemove(_):
            return baseUrl + "/uapi/cart/betSlipRemove"

        case .applyResetPassWordByPhone(_):
            return baseUrl + "/uapi/user/resetPasswordAskingByPhone"
        case .applyResetPassWordByEmail(_):
            return baseUrl + "/uapi/user/resetPasswordAskingByEmail"
        case .resetPassWordConfirm(_):
            return baseUrl + "/uapi/user/resetPasswordConfirm"
        case .getBankList(_):
            return baseUrl + "/uapi/sys/bankList"
        case .getCountryAreaList:
            return baseUrl + "/uapi/sys/countryList"
            
        case .getUserInfo:
            return baseUrl + "/uapi/user/self"
        case .addBankCard(_):
            return baseUrl + "/uapi/user/addBankCard"
        case .getMyBankCard:
            return baseUrl + "/uapi/user/bankCardList"
        case .deleteBankCard(_):
            return baseUrl + "/uapi/user/removeBankCard"
        case .addCoinAddress(_):
            return baseUrl + "/uapi/user/addCoinAddress"
        case .getMyCoinAddress:
            return baseUrl + "/uapi/user/coinAddressList"
        case .deleteCoinAddress(_):
            return baseUrl + "/uapi/user/removeCoinAddress"
        case .getAllSports(_):
            return baseUrl + "/uapi/visitor/navClassAll"
        case .getUnLoginSports:
            return baseUrl + "/uapi/visitor/navClassListOfTopbar"
        case .getLoginSports:
            return baseUrl + "/uapi/user/navClassListOfTopbar"
        case .editShowSports(_):
            return baseUrl + "/uapi/user/navClassListOfTopbarEdit"
        case .bindPhone(_):
            return baseUrl + "/uapi/user/bindPhone"
        case .bindEmail(_):
            return baseUrl + "/uapi/user/bindEmail"
        case .changePassword(_):
            return baseUrl + "/uapi/user/editPassword"
        case .setPayPassword(_):
            return baseUrl + "/uapi/user/createPayPassword"
        case .applyEditPayPassword(_):
            return baseUrl + "/uapi/user/resetPayPasswordAsking"
        case .sureEditPayPassword(_):
            return baseUrl + "/uapi/user/resetPayPasswordConfirm"
        case .checkPayPassword(_):
            return baseUrl + "/uapi/user/verifyPayPassword"
        case .editUserAddress(_):
            return baseUrl + "/uapi/userEditProfile/address"
        case .editUserHeader(_):
            return baseUrl + "/uapi/userEditProfile/avatar"
        case .editUserBirthday(_):
            return baseUrl + "/uapi/userEditProfile/birthday"
        case .editUserSex(_):
            return baseUrl + "/uapi/userEditProfile/gender"
        case .editUserNickname(_):
            return baseUrl + "/uapi/userEditProfile/nickname"
        case .editUserRegion(_):
            return baseUrl + "/uapi/userEditProfile/region"
        case .getUserRegion:
            return baseUrl + "/uapi/userEditProfile/regionHome"
        case .getUserRegionCity(_):
            return baseUrl + "/uapi/userEditProfile/regionByState"
        case .getMessageList(_):
            return baseUrl + "/uapi/msg/list"
        case .readMessage(_):
            return baseUrl + "/uapi/msg/read"
        case .getUnreadMessageCount:
            return baseUrl + "/uapi/msg/unreadCount"
        case .getNoticeList(_):
            return baseUrl + "/uapi/announcement/list"
        case .checkIn:
            return baseUrl + "/uapi/awardTask/dailyCheckin/do"
        case .getCheckInDetail(_):
            return baseUrl + "/uapi/awardTask/dailyCheckin/list"
        case .getCheckInCouponList(_):
            return baseUrl + "/uapi/coupon/awardClaimList"
        case .getUserPromotions(_):
            return baseUrl + "/uapi/awardTask/list"
        case .userLogout:
            return baseUrl + "/uapi/user/userLoginOut"
            
        case .collectGame(_):
            return baseUrl + "/uapi/favorite/matchAdd"
        case .cancelCollectGame(_):
            return baseUrl + "/uapi/favorite/matchRemove"
        case .batchCancelCollectGame(_):
            return baseUrl + "/uapi/favorite/matchBatchRemove"
        case .getCollectGame:
            return baseUrl + "/uapi/favorite/matchList"
        case .collectLeagueMatch(_):
            return baseUrl + "/uapi/favorite/leagueAdd"
        case .cancelCollectLeagueMatch(_):
            return baseUrl + "/uapi/favorite/leagueRemove"
        case .batchCancelCollectLeagueMatch(_):
            return baseUrl + "/uapi/favorite/leagueBatchRemove"
        case .getCollectLeagueMatch:
            return baseUrl + "/uapi/favorite/leagueList"
        case .recordBrowseGame(_):
            return baseUrl + "/uapi/favorite/matchViewed"
        case .batchCancelBrowseGame(_):
            return baseUrl + "/uapi/favorite/matchViewedBatchRemove"
        case .getBrowseGame:
            return baseUrl + "/uapi/favorite/matchViewedList"
        case .topGameplay(_):
            return baseUrl + "/uapi/favorite/marketTop"
        case .cancelTopGameplay(_):
            return baseUrl + "/uapi/favorite/marketTopRemove"
        case .getTopGameplay(_):
            return baseUrl + "/uapi/favorite/marketTopList"
            
        case .searchHotKeyList:
            return baseUrl + "/uapi/search/hotKeyList"
        case .searchKeyAdd(_):
            return baseUrl + "/uapi/search/keyAdd"
        case .searchKeyClear:
            return baseUrl + "/uapi/search/keyClear"
        case .searchKeyRemove(_):
            return baseUrl + "/uapi/search/keyRemove"
        case .searchRecentKeyList:
            return baseUrl + "/uapi/search/recentKeyList"
        
        case .getPayTypes(_):
            return baseUrl + "/uapi/pay/wayAll"
        case .applyRecharge(_):
            return baseUrl + "/uapi/pay/recharge"
        case .applyWithdraw(_):
            return baseUrl + "/uapi/pay/withdraw"
        case .payRwList(_):
            return baseUrl + "/uapi/pay/rwList"
        case .payRwDetail(_):
            return baseUrl + "/uapi/pay/rwDetail"
        case .getRunningWaterList(_):
            return baseUrl + "/uapi/finance/walletLogList"
        case .getRunningWaterTypeList:
            return baseUrl + "/uapi/finance/walletLogListType"
        case .getWalletData(_):
            return baseUrl + "/uapi/finance/wallet"
            
        case .editHandicapDisplayType(param: _):
            return baseUrl + "/uapi/user/editHandicapDisplayType"
        
        case .getCoupon(_):
            return baseUrl + "/uapi/coupon/claim"
        case .couponList(_):
            return baseUrl + "/uapi/coupon/list"
        case .couponAvailableAndBonus(_):
            return baseUrl + "/uapi/coupon/availableAndBonus"
        case .couponAvailable(_):
            return baseUrl + "/uapi/coupon/available"
            
        case .bonusList(_):
            return baseUrl + "/uapi/bonus/list"
        case .accabonusCalc(_):
            return baseUrl + "/uapi/accabonus/calc"
            
        case .virtualMatchGetList(_):
            return virtualMatchUrl + "/virtual/v1/match/getList"
        case .virtualMatchStatistical(_):
            return virtualMatchUrl + "/virtual/v1/match/statistical"
        case .virtualMatchGetMatchDetail(_):
            return virtualMatchUrl + "/virtual/v1/match/getMatchDetail"
        case .virtualOrderOddsCartRefresh(_):
            return virtualMatchUrl + "/virtual/v1/order/odds/cart/refresh"
        case .virtualOrderSingleBet(_):
            return virtualMatchUrl + "/virtual/v1/order/single/bet"
            
        case .gameList(_):
            return baseUrl + "/uapi/game/list"
        case .gameDetailsList(_):
            return baseUrl + "/uapi/game/details/list"
        case .gameAccessUrl(_):
            return baseUrl + "/uapi/game/accessUrl"
            
        case .orderList(_):
            return baseUrl + "/uapi/order/list"
            
        case .awardTaskAccaBonusList:
            return baseUrl + "/uapi/awardTask/accaBonus/list"
        case .awardTaskAccaBonusStatus(_):
            return baseUrl + "/uapi/awardTask/accaBonus/status"
        case .awardTaskReq(_):
            return baseUrl + "/uapi/awardTask/req"
            
        case .registerActivity:
            return baseUrl + "/uapi/awardTask/noAuth/welcomeBonus/status"
        case .getRegisterActivity:
            return baseUrl + "/uapi/awardTask/welcomeBonus/create"
        case .getRegisterActivityBouns(_):
            return baseUrl + "/uapi/awardTask/welcomeBonus/claim"
        case .getActivityDetail(_):
            return baseUrl + "/uapi/awardTask/req"
        case .depositActivity:
            return baseUrl + "/uapi/awardTask/depositBonus/status"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .phoneRegist(_),
            .emailRegist(_),
            .phoneLogin(_),
            .emailLogin(_),
            .getPhoneCode(_),
            .getEmailCode(_),
            .checkUserByPhone(_),
            .checkUserByEmail(_),
            
            .matchGetList(_),
            .matchGetMatchDetail(_),
            .matchGetOnSaleLeagues(_),
            .matchStatistical(_),
            .orderBatchBetMatchMarketOfJumpLine(_),
            .orderBetSinglePass(_),
            .orderBetList(_),
            .orderBetMultiple(_),
            .orderGetStakeOrderStatus(_),
            
            .cartBetSlipList,
            .cartBetSlipAdd(_),
            .cartBetSlipRemove(_),
            
            .gameAccessToken(_),
            .applyResetPassWordByPhone(_),
            .applyResetPassWordByEmail(_),
            .resetPassWordConfirm(_),
            .getBankList(_),
            .getCountryAreaList,
            .getUserInfo,
            .addBankCard(_),
            .getMyBankCard,
            .deleteBankCard(_),
            .addCoinAddress(_),
            .getMyCoinAddress,
            .deleteCoinAddress(_),
            .getAllSports(_),
            .getUnLoginSports,
            .getLoginSports,
            .editShowSports(_),
            .bindPhone(_),
            .bindEmail(_),
            .changePassword(_),
            .setPayPassword(_),
            .applyEditPayPassword(_),
            .sureEditPayPassword(_),
            .checkPayPassword(_),
            .editUserAddress(_),
            .editUserHeader(_),
            .editUserBirthday(_),
            .editUserSex(_),
            .editUserNickname(_),
            .editUserRegion(_),
            .getUserRegion,
            .getUserRegionCity(_),
            .checkIn,
            .getCheckInDetail(_),
            .getCheckInCouponList(_),
            .getMessageList(_),
            .getUnreadMessageCount,
            .readMessage(_),
            .getNoticeList(_),
            .getUserPromotions(_),
            .userLogout,
            
            .searchHotKeyList,
            .searchKeyAdd(_),
            .searchKeyClear,
            .searchKeyRemove(_),
            .searchRecentKeyList,
            .matchQueryMatchByRecommend(_),
            
            .collectGame(_),
            .cancelCollectGame(_),
            .batchCancelCollectGame(_),
            .getCollectGame,
            .collectLeagueMatch(_),
            .cancelCollectLeagueMatch(_),
            .batchCancelCollectLeagueMatch(_),
            .getCollectLeagueMatch,
            .recordBrowseGame(_),
            .batchCancelBrowseGame(_),
            .getBrowseGame,
            .topGameplay(_),
            .cancelTopGameplay(_),
            .getTopGameplay(_),
            
            .getCoupon(_),
            .couponList(_),
            .couponAvailableAndBonus(_),
            .couponAvailable(_),
            .bonusList(_),
            .accabonusCalc(_),
            .editHandicapDisplayType(_),
            
            .virtualMatchGetList(_),
            .virtualMatchStatistical(_),
            .virtualMatchGetMatchDetail(_),
            .virtualOrderSingleBet(_),
            .virtualOrderOddsCartRefresh(_),
            
            .gameList(_),
            .gameDetailsList(_),
            .gameAccessUrl(_),
            
            .orderList(_),
            
            .awardTaskAccaBonusList,
            .awardTaskAccaBonusStatus(_),
            .awardTaskReq(_),
            .getRunningWaterList(_),
            .getRunningWaterTypeList,
            .getWalletData(_),
            
            .payRwList(_),
            .payRwDetail(_),
            .getPayTypes(_),
            .applyRecharge(_),
            .applyWithdraw(_),
            
            .registerActivity,
            .getRegisterActivity,
            .getRegisterActivityBouns(_),
            .getActivityDetail(_),
            .depositActivity:
            
            return .post
        }
    }
    
    var parameter: Parameters?{
        let prt = Parameters()
        switch self{
        case .phoneRegist(let param):
            return modelToDic(param: param)
        case .emailRegist(let param):
            return modelToDic(param: param)
        case .phoneLogin(let param):
            return modelToDic(param: param)
        case .emailLogin(let param):
            return modelToDic(param: param)
        case .getPhoneCode(let param):
            return modelToDic(param: param)
        case .getEmailCode(let param):
            return modelToDic(param: param)
        case .checkUserByPhone(let param):
            return modelToDic(param: param)
        case .checkUserByEmail(let param):
            return modelToDic(param: param)
            
        case .gameAccessToken(let param):
            return modelToDic(param: param)
        case .matchGetList(let param):
            return modelToDic(param: param)
        case .matchGetMatchDetail(let param):
            return modelToDic(param: param)
        case .matchGetOnSaleLeagues(let param):
            return modelToDic(param: param)
        case .matchStatistical(let param):
            return modelToDic(param: param)
        case .orderBatchBetMatchMarketOfJumpLine(let param):
            return modelToDic(param: param)
        case .orderBetSinglePass(let param):
            return modelToDic(param: param)
        case .orderBetList(let param):
            return modelToDic(param: param)
        case .orderBetMultiple(let param):
            return modelToDic(param: param)
        case .orderGetStakeOrderStatus(let param):
            return modelToDic(param: param)
            
        case .cartBetSlipList:
            return nil
        case .cartBetSlipAdd(let param):
            return modelToDic(param: param)
        case .cartBetSlipRemove(let param):
            return modelToDic(param: param)
            
        case .applyResetPassWordByPhone(let param):
            return modelToDic(param: param)
        case .applyResetPassWordByEmail(let param):
            return modelToDic(param: param)
        case .resetPassWordConfirm(let param):
            return modelToDic(param: param)
        case .getBankList(let param):
            return modelToDic(param: param)
        case .getCountryAreaList:
            return prt
        case .getUserInfo:
            return prt

        case .searchHotKeyList:
            return prt
        case .searchKeyAdd(let param):
            return modelToDic(param: param)
        case .searchKeyClear:
            return prt
        case .searchKeyRemove(let param):
            return modelToDic(param: param)
        case .searchRecentKeyList:
            return prt
        case .matchQueryMatchByRecommend(let param):
            return modelToDic(param: param)
            
        case .addBankCard(let param):
            return modelToDic(param: param)
        case .getMyBankCard:
            return prt
        case .deleteBankCard(let param):
            return modelToDic(param: param)
        case .addCoinAddress(let param):
            return modelToDic(param: param)
        case .getMyCoinAddress:
            return prt
        case .deleteCoinAddress(let param):
            return modelToDic(param: param)
        case .getAllSports(let param):
            return modelToDic(param: param)
        case .getUnLoginSports:
            return prt
        case .getLoginSports:
            return prt
        case .editShowSports(let param):
            return modelToDic(param: param)
        case .bindPhone(let param):
            return modelToDic(param: param)
        case .bindEmail(let param):
            return modelToDic(param: param)
        case .changePassword(let param):
            return modelToDic(param: param)
        case .setPayPassword(let param):
            return modelToDic(param: param)
        case .applyEditPayPassword(let param):
            return modelToDic(param: param)
        case .sureEditPayPassword(let param):
            return modelToDic(param: param)
        case .checkPayPassword(let param):
            return modelToDic(param: param)
        case .editUserAddress(let param):
            return modelToDic(param: param)
        case .editUserHeader(let param):
            return modelToDic(param: param)
        case .editUserBirthday(let param):
            return modelToDic(param: param)
        case .editUserSex(let param):
            return modelToDic(param: param)
        case .editUserNickname(let param):
            return modelToDic(param: param)
        case .editUserRegion(let param):
            return modelToDic(param: param)
        case .getUserRegion:
            return prt
        case .getUserRegionCity(let param):
            return modelToDic(param: param)
        case .checkIn:
            return prt
        case .getCheckInDetail(let param):
            return modelToDic(param: param)
        case .getCheckInCouponList(let param):
            return modelToDic(param: param)
        case .getMessageList(let param):
            return modelToDic(param: param)
        case .getUnreadMessageCount:
            return prt
        case .readMessage(let param):
            return modelToDic(param: param)
        case .getNoticeList(let param):
            return modelToDic(param: param)
        case .getUserPromotions(let param):
            return modelToDic(param: param)
        case .userLogout:
            return prt
            
        case .collectGame(let param):
            return modelToDic(param: param)
        case .cancelCollectGame(let param):
            return modelToDic(param: param)
        case .batchCancelCollectGame(let param):
            return modelToDic(param: param)
        case .getCollectGame:
            return prt
        case .collectLeagueMatch(let param):
            return modelToDic(param: param)
        case .cancelCollectLeagueMatch(let param):
            return modelToDic(param: param)
        case .batchCancelCollectLeagueMatch(let param):
            return modelToDic(param: param)
        case .getCollectLeagueMatch:
            return prt
        case .recordBrowseGame(let param):
            return modelToDic(param: param)
        case .batchCancelBrowseGame(let param):
            return modelToDic(param: param)
        case .getBrowseGame:
            return prt
        case .topGameplay(let param):
            return modelToDic(param: param)
        case .cancelTopGameplay(let param):
            return modelToDic(param: param)
        case .getTopGameplay(let param):
            return modelToDic(param: param)
            
        case .getPayTypes(let param):
            return modelToDic(param: param)
        case .applyRecharge(let param):
            return modelToDic(param: param)
        case .applyWithdraw(let param):
            return modelToDic(param: param)
            
        case .getRunningWaterList(let param):
            return modelToDic(param: param)
        case .getRunningWaterTypeList:
            return prt
        case .getWalletData(let param):
            return modelToDic(param: param)
            
        case .getCoupon(let param):
            return modelToDic(param: param)
        case .couponList(let param):
            return modelToDic(param: param)
        case .couponAvailableAndBonus(let param):
            return modelToDic(param: param)
        case .couponAvailable(let param):
            return modelToDic(param: param)
        case .bonusList(let param):
            return modelToDic(param: param)
        case .accabonusCalc(let param):
            return modelToDic(param: param)
        case .editHandicapDisplayType(let param):
            return modelToDic(param: param)
            
        case .virtualMatchGetList(let param):
            return modelToDic(param: param)
        case .virtualMatchStatistical(let param):
            return modelToDic(param: param)
        case .virtualMatchGetMatchDetail(let param):
            return modelToDic(param: param)
        case .virtualOrderSingleBet(let param):
            return modelToDic(param: param)
        case .virtualOrderOddsCartRefresh(let param):
            return modelToDic(param: param)
            
        case .gameList(let param):
            return modelToDic(param: param)
        case .gameDetailsList(let param):
            return modelToDic(param: param)
        case .gameAccessUrl(let param):
            return modelToDic(param: param)
            
        case .orderList(let param):
            return modelToDic(param: param)
            
        case .payRwList(let param):
            return modelToDic(param: param)
        case .payRwDetail(let param):
            return modelToDic(param: param)
            
        case .awardTaskAccaBonusList:
            return prt
        case .awardTaskAccaBonusStatus(let param):
            return modelToDic(param: param)
        case .awardTaskReq(let param):
            return modelToDic(param: param)
            
           
        case .registerActivity:
            return prt
        case .getRegisterActivity:
            return prt
        case .getRegisterActivityBouns(let param):
            return modelToDic(param: param)
        case .getActivityDetail(let param):
            return modelToDic(param: param)
        case .depositActivity:
            return prt
        }
    }
    
    var encoding: ParameterEncoding{
        return JSONEncoding.default
    }
    
    var headers: HTTPHeaders{
        switch self{
        case .phoneRegist(_),
            .emailRegist(_),
            .phoneLogin(_),
            .emailLogin(_),
            .getPhoneCode(_),
            .getEmailCode(_),
            .checkUserByPhone(_),
            .checkUserByEmail(_),
            .gameAccessToken(_),
            .applyResetPassWordByPhone(_),
            .applyResetPassWordByEmail(_),
            .resetPassWordConfirm(_),
            .getBankList(_),
            .getCountryAreaList,
            .getUserInfo,
            .addBankCard(_),
            .getMyBankCard,
            .deleteBankCard(_),
            .addCoinAddress(_),
            .getMyCoinAddress,
            .deleteCoinAddress(_),
            .getAllSports(_),
            .getUnLoginSports,
            .getLoginSports,
            .applyEditPayPassword(_),
            .sureEditPayPassword(_),
            .changePassword(_),
            .setPayPassword(_),
            .bindPhone(_),
            .bindEmail(_),
            .checkPayPassword(_),
            .editUserAddress(_),
            .editUserHeader(_),
            .editUserBirthday(_),
            .editUserSex(_),
            .editUserNickname(_),
            .editUserRegion(_),
            .getUserRegion,
            .getUserRegionCity(_),
            .checkIn,
            .getCheckInDetail(_),
            .getCheckInCouponList(_),
            .getMessageList(_),
            .getUnreadMessageCount,
            .readMessage(_),
            .getNoticeList(_),
            .getUserPromotions(_),
            .userLogout,
            
            .cartBetSlipList,
            .cartBetSlipAdd,
            .cartBetSlipRemove,
            .editShowSports(_),
            
            .searchHotKeyList,
            .searchKeyAdd(_),
            .searchKeyClear,
            .searchKeyRemove(_),
            .searchRecentKeyList,
            
            .collectGame(_),
            .cancelCollectGame(_),
            .batchCancelCollectGame(_),
            .getCollectGame,
            .collectLeagueMatch(_),
            .cancelCollectLeagueMatch(_),
            .batchCancelCollectLeagueMatch(_),
            .getCollectLeagueMatch,
            .recordBrowseGame(_),
            .batchCancelBrowseGame(_),
            .getBrowseGame,
            .topGameplay(_),
            .cancelTopGameplay(_),
            .getTopGameplay(_),
            
            .getRunningWaterList(_),
            .getRunningWaterTypeList,
            .getWalletData(_),
            
            .getCoupon(_),
            .couponList(_),
            .couponAvailableAndBonus(_),
            .couponAvailable(_),
            .bonusList(_),
            .accabonusCalc(_),
            .editHandicapDisplayType(_),
            
            .gameList(_),
            .gameDetailsList(_),
            .gameAccessUrl(_),
            
            .awardTaskAccaBonusList,
            .awardTaskAccaBonusStatus(_),
            .awardTaskReq(_),
            
            .orderList(_),
            
            .payRwList(_),
            .payRwDetail(_),
            .getPayTypes(_),
            .applyRecharge(_),
            .applyWithdraw(_),
            
            .registerActivity,
            .getRegisterActivity,
            .getRegisterActivityBouns(_),
            .getActivityDetail(_),
            .depositActivity:

            return ["Authorization":LoginModel.getToken()]
            
        case .matchGetList(_),
            .matchGetMatchDetail(_),
            .matchStatistical(_),
            .orderBatchBetMatchMarketOfJumpLine(_),
            .orderBetSinglePass(_),
            .orderBetList(_),
            .orderBetMultiple(_),
            .orderGetStakeOrderStatus(_),
            .matchQueryMatchByRecommend(_),
            
            .virtualMatchGetList(_),
            .virtualMatchStatistical(_),
            .virtualMatchGetMatchDetail(_),
            .virtualOrderSingleBet(_),
            .virtualOrderOddsCartRefresh(_),
            
            .matchGetOnSaleLeagues(_):
            return ["Authorization":Tool.getFBModel()?.token ?? ""]
        }
    }
}

let sharedSession: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 15
    return Alamofire.Session(configuration: configuration)
}()


func AdHttpRequest(url:wxApi, successCallBack: @escaping(String) -> Void, failureCallBack: @escaping(String) -> Void){
    let ret = sharedSession.request(url.path, method: url.method, parameters: url.parameter, encoding: url.encoding, headers: url.headers)
    ret.responseString(encoding: .utf8) { (response) in
        switch response.result{
        case .success(var data):
            if let dict = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as? NSDictionary {
//                // "14010"判断fb平台 token失效
//                if dict["code"] as! Int == 14010 {
//
//                }
                // 判断用户平台 token失效
                if ((dict["code"] as! Int) >= 1100 && (dict["code"] as! Int) <= 1119){
                    Tool.clearFBModel()
                    Tool.clearUserInfoModel()
                    UserDefaults.standard.set(nil, forKey: "token")
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogoutNotice), object: nil, userInfo: nil)
                }
                if dict["code"] as! Int == 8 {
                    let str : String = dict["message"] as! String
                    var first : String = ""
                    var second : String = ""
                    if let index1 = str.lastIndex(of: "["),
                       let index2 = str.lastIndex(of: "-"){
                        first = String(str[index1...index2])
                        let CharSet = CharacterSet(charactersIn: "[-")
                        first = first.trimmingCharacters(in: CharSet)
                    }
                    let f = timeDate(time: first)
                    let freplacedString = str.replacingOccurrences(of: first, with: f)
                    
                    if let index1 = str.lastIndex(of: "-"),
                       let index2 = str.lastIndex(of: "]"){
                        second = String(str[index1...index2])
                        let CharSet = CharacterSet(charactersIn: "-]")
                        second = second.trimmingCharacters(in: CharSet)
                    }
                    let s = timeDate(time: second)
                    let sreplacedString = freplacedString.replacingOccurrences(of: second, with: s)
                    data = data.replacingOccurrences(of: str, with: sreplacedString)
                }
            }
            
            successCallBack(data)
        case .failure(let err):
            failureCallBack(err.localizedDescription)
        }
    }
}

struct RequestCallBackViewModel<T>:HandyJSON{
    var code:Int?
    var message:String?
    var data:T?
}
func timeDate(time: String) -> String{
    let timeStr = String((Double(time) ?? 0) / 1000)
    let timeInterval:TimeInterval = TimeInterval(timeStr)!
    let date = NSDate(timeIntervalSince1970: timeInterval)
    let dformatter = DateFormatter()
    dformatter.dateFormat = "(dd-MMM-yyyy-HH:mm)"
    return dformatter.string(from: date as Date)
}

func modelToDic(param:HandyJSON) -> Parameters{
    if let jsonString = param.toJSONString() {
        print("JSON string:\n\(jsonString)")
        if let dict = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? NSDictionary {
            print("\nConverted to dictionary:\n\(dict)\n")
            let prt = dict as! Parameters
            return prt
        } else {
            print("Failed to convert to dictionary.")
            return NSDictionary() as! Parameters
        }
    } else {
        print("Failed to get JSON string from the object.")
        return NSDictionary() as! Parameters
    }
}

