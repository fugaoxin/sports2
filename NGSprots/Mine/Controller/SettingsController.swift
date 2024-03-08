//
//  SettingsController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit
import MJRefresh

class SettingsController: BaseViewController {

    @IBOutlet weak var oneIV: UIImageView!
    @IBOutlet weak var twoIV: UIImageView!
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    
    @IBOutlet weak var oneSelectIV: UIImageView!
    @IBOutlet weak var twoSelectIV: UIImageView!

    @IBOutlet weak var totalCacheLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.addNavBar(.white)
    
        self.totalCacheLB.text = getCacheFileSize()
        
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        let btn : UIButton?
        if account.handicapDisplayType == 1{
            btn = self.oneBtn
        }else{
            btn = self.twoBtn
        }
        self.selectModeClick(btn as Any)
    }

    @IBAction func selectModeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.hexColor(hex: "0CD664").cgColor
        if btn == self.oneBtn{
            self.twoBtn.layer.borderWidth = 1
            self.twoBtn.layer.borderColor = UIColor.white.cgColor
            self.oneSelectIV.isHidden = false
            self.twoSelectIV.isHidden = true
        }else{
            self.oneBtn.layer.borderWidth = 1
            self.oneBtn.layer.borderColor = UIColor.white.cgColor
            self.oneSelectIV.isHidden = true
            self.twoSelectIV.isHidden = false
            
        }
        editHandicapDisplayType(type: btn.tag)
    }
    @IBAction func changePasswordClick(_ sender: Any) {
        self.pushVC(vc: SelectChangePasswordTypeController())
    }
    
    @IBAction func clearCacheClick(_ sender: Any) {
        self.showHUD(text: "Loading...")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.hideHUD()
            self.totalCacheLB.text = self.clearFileCache()
        }
    }
    
    func getCacheFileSize() -> String{
        var foldSize: UInt64 = 0
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                let folder = try? FileManager.default.attributesOfItem(atPath: temPath) as NSDictionary
                if let c = folder?.fileSize() {
                    foldSize += c
                }
            }
        }
        if foldSize > 1024*1024 {
            return String(format: "%.2f", Double(foldSize)/1024.0/1024.0) + " M"
        }
        else if foldSize > 1024 {
            return String(format: "%.2f", Double(foldSize)/1024.0) + " K"
        }else {
            return String(foldSize) + " B"
        }
    }
    func clearFileCache() -> String {
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                if FileManager.default.fileExists(atPath: temPath) {
                    try? FileManager.default.removeItem(atPath: temPath)
                }
            }
        }
        return getCacheFileSize()
    }
}

extension SettingsController{
    private func editHandicapDisplayType(type: Int){
        self.showHUD(text: "Loading...")
        var param = HandicapDisplayParam()
        param.handicapDisplayType = type
        let api = wxApi.editHandicapDisplayType(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<[CouponModel]>.deserialize(from: data)
            if(result?.code == 0){
                Tool.requestGetUserInfo {}
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
}
