//
//  Tool.swift
//  SportsDemo
//
//  Created by Jean on 9/11/2023.
//

import UIKit
import Foundation
private let USER_DEFAULTS = UserDefaults.standard
private let USERINFO_DEFAULT_KEY = "UserInfoModel"
private let FB_DEFAULT_KEY = "FBModel"


class Tool: NSObject {
    //MARK: -----用户信息保存数据
    class func saveUserInfoModel(model: AccountModel){
        var encodedObject: Data?
        if #available(iOS 11.0, *) {
            if let object = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: true) {
                encodedObject = object
            }
        } else {
            encodedObject = NSKeyedArchiver.archivedData(withRootObject: model)
        }
        if (encodedObject != nil) {
            USER_DEFAULTS.set(encodedObject, forKey: USERINFO_DEFAULT_KEY)
            USER_DEFAULTS.synchronize()
        }
    }
    //MARK: -----用户信息读取数据
    class func getuserInfoModel() -> AccountModel? {
        if let decodedObject = USER_DEFAULTS.object(forKey: USERINFO_DEFAULT_KEY) as? Data {
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedObject) as? AccountModel
        }else{
            return nil
        }
    }
    //MARK: -----清除对象数据
    class func clearUserInfoModel () {
        USER_DEFAULTS.removeObject(forKey: USERINFO_DEFAULT_KEY)
        USER_DEFAULTS.synchronize()
    }
    
    //MARK: ----- FB
    class func saveFBModel(model: fbModel){
        var encodedObject: Data?
        if #available(iOS 11.0, *) {
            if let object = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: true) {
                encodedObject = object
            }
        } else {
            encodedObject = NSKeyedArchiver.archivedData(withRootObject: model)
        }
        if (encodedObject != nil) {
            USER_DEFAULTS.set(encodedObject, forKey: FB_DEFAULT_KEY)
            USER_DEFAULTS.synchronize()
        }
    }
    class func getFBModel() -> fbModel? {
        if let decodedObject = USER_DEFAULTS.object(forKey: FB_DEFAULT_KEY) as? Data {
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedObject) as? fbModel
        }else{
            return nil
        }
    }
    class func clearFBModel () {
        USER_DEFAULTS.removeObject(forKey: FB_DEFAULT_KEY)
        USER_DEFAULTS.synchronize()
    }

    
    class func changeLableAttributeString(total:String,changeStr:String,changeColor:UIColor,changeFont:UIFont?) -> NSMutableAttributedString{
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: total)
        if let range = total.range(of: changeStr) {
            let nsRange = NSRange(range, in: total)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: changeColor, range: nsRange)
            if changeFont != nil{
                attributeString.addAttribute(NSAttributedString.Key.font, value: changeFont as Any, range: nsRange)
            }
            print(nsRange)
        } else {
            print("找不到匹配的字符串")
        }
        return attributeString
    }
    
    class func getTimeWithTimestamp(timestampStr: String, dateFormatStr:String) -> String{
        if timestampStr.count < 10{
            return ""
        }
        let s: String = String((Double(timestampStr) ?? 0) / 1000)
        let t: TimeInterval =  TimeInterval(s)!
        let date: Date = Date(timeIntervalSince1970: t)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatStr
        let dateString = formatter.string(from: date)
        return dateString
    }

    //MARK: -根据后台时间戳返回时间
    class func updateTimeToCurrentTime(timeStamp: Double) -> String {
            //获取当前的时间戳
            let currentTime = Date().timeIntervalSince1970
            print(currentTime,   timeStamp, "sdsss")
            //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
            let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
            //时间差
            let reduceTime : TimeInterval = currentTime - timeSta
            //时间差小于60秒
            let hours :Int = Int(reduceTime / 3600)
            let minutes : Int = Int((reduceTime.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds : Int = Int((reduceTime.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
            
            return "\(hours)小时" + "\(minutes)分" + "\(seconds)"
    }
    
    //MARK: -创建二维码图片
    class func createQRForString(qrString: String?, qrImage: UIImage?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            // 返回二维码image
            //let codeImage = UIImage(ciImage: colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            let codeImage = UIImage(ciImage: colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = qrImage {
                let rect = CGRect(x:0, y:0, width:codeImage.size.width,
                                  height:codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width:rect.size.width * 0.25, height:rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x:x, y:y, width:avatarSize.width, height:avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
    
    //MARK: -按钮倒计时
    //倒计时验证码
     class func countDown(_ timeOut: Int, btn: UIButton){
              //倒计时时间
              var timeout = timeOut
              let queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
              let _timer:DispatchSource = DispatchSource.makeTimerSource(flags: [], queue: queue) as! DispatchSource
              _timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1))
              //每秒执行
              _timer.setEventHandler(handler: { () -> Void in
                  if(timeout<=0){ //倒计时结束，关闭
                      _timer.cancel();
                      DispatchQueue.main.sync(execute: { () -> Void in
                          if btn.frame.size.width < 60 || btn.frame.size.width>70{
                              btn.setTitle("Send", for: .normal)
                          }else{
                              btn.setTitle("Send Code", for: .normal)
                          }
                          btn.isEnabled = true
                         
                      })
                  }else{//正在倒计时
                      let seconds = timeout
                      DispatchQueue.main.sync(execute: { () -> Void in
                          let str = String(describing: seconds)
                          btn.setTitle("\(str)s", for: .normal)
                          btn.isEnabled = false
                      })
                      timeout -= 1;
                  }
              })
              _timer.resume()
          }
    
    // MARK: - 当前window
    class func keyWindow() -> UIWindow {
         if #available(iOS 15.0, *) {
             let keyWindow = UIApplication.shared.connectedScenes
                 .map({ $0 as? UIWindowScene })
                 .compactMap({ $0 })
                 .first?.windows.first ?? UIWindow()
             return keyWindow
         }else {
             let keyWindow = UIApplication.shared.windows.first ?? UIWindow()
             return keyWindow
         }
     }
    // MARK: - 判断手机号码规范
    class func checkPhone(str:String)->Bool{
        let phoneRegEx  = "^\\+(00){0,1}(234){1}\\d{10}$"
        let text = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        let phoneResult = text.evaluate(with: str)
        return phoneResult
    }
    // MARK: - 判断邮箱地址规范
    class func checkEmailAddress(str:String)->Bool{
        let emailRegEx  = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let text = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult = text.evaluate(with: str)
        return emailResult
    }
    // MARK: - 判断字符串包含大小写
    class func checkContainLowerAndUpper(str:String)->Bool{
        let capitalLetterRegEx  = ".*(?=.*[a-z])(?=.*[A-Z]).*"
        let text = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = text.evaluate(with: str)
        return capitalResult
    }
    // MARK: - 判断字符串包含数字
    class func checkContainNumber(str:String)->Bool{
        let numberRegEx  = ".*(?=.*?[0-9]).*"
        let text = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = text.evaluate(with: str)
        return numberResult
    }
    // MARK: - 计算文本宽
    class func getLabelWith(text:String,font:UIFont,labelH:CGFloat) -> CGFloat{
         
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
    
        var size = CGSize()
        size.width = CGFloat.greatestFiniteMagnitude
        size.height = labelH

        let boundingRect = attributedText.boundingRect(with: size, options:  [.usesFontLeading,.usesLineFragmentOrigin], context: nil).integral
//        print("Label Width: \(boundingRect.width)")
        return boundingRect.width
    }
    
    // MARK: - 获取用户信息
    class func requestGetUserInfo(completion : @escaping()->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.getUserInfo
        AdHttpRequest(url: api, successCallBack: { data in
            print("UserInfo------\(data)")
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<AccountModel>.deserialize(from: data)
            if(result?.code == 0){
                let login : AccountModel = (result?.data)!
                Tool.saveUserInfoModel(model:login)
            }else{
//                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: BalanceNotice), object: nil, userInfo: nil)
            completion()
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion()
        }
    }
    // MARK: - 获取当前显示的控制器
    class func getCurrentVc() -> UIViewController{
        let rootVc = self.keyWindow().rootViewController
        let currentVc = getCurrentVcFrom(rootVc!)
        return currentVc
    }
    class private func getCurrentVcFrom(_ rootVc:UIViewController) -> UIViewController{
         var currentVc:UIViewController
         var rootCtr = rootVc
         if(rootCtr.presentedViewController != nil) {
           rootCtr = rootVc.presentedViewController!
         }
         if rootVc.isKind(of:UITabBarController.classForCoder()) {
           currentVc = getCurrentVcFrom((rootVc as! UITabBarController).selectedViewController!)
         }else if rootVc.isKind(of:UINavigationController.classForCoder()){
           currentVc = getCurrentVcFrom((rootVc as! UINavigationController).visibleViewController!)
         }else{
           currentVc = rootCtr
         }
         return currentVc
    }
    
    
    class func StringIsEmpty(value: String?) -> Bool {
        //首先判断是否为nil
        if (nil == value) {
            //对象是nil，直接认为是空串
            return true
        }else{
            //然后是否可以转化为String
            if let myValue  = value {
                //然后对String做判断
                return myValue == "" || myValue == "(null)" || 0 == myValue.count
            }else{
                //字符串都不是，直接认为是空串
                return true
            }
        }
    }
    
    class func addAmounts(amount1: String, amount2: String) -> String? {
        let number1 = NSDecimalNumber(string: amount1 )
        let number2 = NSDecimalNumber(string: amount2 )
        
        let sum = number1.adding(number2)
        return sum.stringValue
    }
    // MARK: - 签到
    class func requestCheckIn(completion : @escaping(_ isSuccess : Bool)->Void){
        Tool.keyWindow().showHUD(text: "Loading...")
        let api = wxApi.checkIn
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<Any>.deserialize(from: data)
            if(result?.code == 0){
                Tool.keyWindow().showTextSBimg("Check in successfully", dismissAfterDelay: 1.5, imgstr: "tipsV")
                completion(true)
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion(false)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
            completion(false)
        }
    }
    // MARK: - 获取签到信息
    class func requestGetCheckInDetail(rangeType:String,date:String,completion : @escaping(_ model : CheckInModel?)->Void){
//        Tool.getCurrentVc().showHUD(text: "Loading...")
        let param = CheckInParam(rangeType: rangeType,date: date)
        let api = wxApi.getCheckInDetail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.getCurrentVc().hudHide()
            let result = RequestCallBackViewModel<CheckInModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? CheckInModel())
            }else{
                Tool.getCurrentVc().showTextSB(result?.message, dismissAfterDelay: 1.5)
                completion(nil)
            }
        }) { error in
            Tool.getCurrentVc().hudHide()
            Tool.getCurrentVc().showTextSB(error, dismissAfterDelay: 1.5)
            completion(nil)
        }
    }
    
    // MARK: - 获取fb token
    class func gameAccessTokenRequest(completion : @escaping()->Void){
        var param = GameTokenParam()
        param.gameId = "1"
        param.property1 = "{}"
        param.property2 = "{}"
        let api = wxApi.gameAccessToken(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<fbModel>.deserialize(from: data)
            if(result?.code == 0){
                //print("gameAccessToken===\(result?.data)")
                Tool.saveFBModel(model: result?.data ?? fbModel())
                matchUrl = result?.data?.baseUrl ?? "https://iapi.ccapykdsd.com"
                virtualMatchUrl = result?.data?.virtualUrl ?? "https://virtualapi.server.newsportspro.com"
                completion()
            }else{
            }
        }) { (error) in
        }
    }
    
    //用户任务的具体信息（包括跳转链接、背景图）
    class func lodaAwardTaskReq(id: Int, completion : @escaping(_ model : awardTaskReqModel?)->Void){
        var param = accaBonusStatusParam()
        param.id = id
        let api = wxApi.awardTaskReq(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            let result = RequestCallBackViewModel<awardTaskReqModel>.deserialize(from: data)
            if(result?.code == 0){
                completion(result?.data ?? awardTaskReqModel())
            }else{}
        }) { (error) in }
    }
    
    class func goToLogin(){
        let loginVC = LoginController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .custom
        Tool.getCurrentVc().present(nav, animated: true)
    }
}










