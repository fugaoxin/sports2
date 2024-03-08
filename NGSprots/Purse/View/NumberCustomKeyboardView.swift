//
//  NumberCustomKeyboardView.swift
//  NGSprots
//
//  Created by Jean on 27/12/2023.
//

import UIKit

class NumberCustomKeyboardView: UIView {
    var closeBlock : (()->Void)?
    
    var enterBlock : ((_ enterStr:String)->Void)?
    
    var withDrawBlock : (()->Void)?
    
    var numberStr = ""{
        didSet{
            if numberStr != ""{
                if Float(numberStr)! <= 0{
                    withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                    withdrawBtn.isEnabled = false
                }else{
                    let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
                    if Float(numberStr)! > 0 && Float(numberStr)! <= Float(account.wallets?.first?.balance ?? "0")!{
                        withdrawBtn.backgroundColor = .hexColor(hex: "0CD664")
                        withdrawBtn.isEnabled = true
                    }else{
                        withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                        withdrawBtn.isEnabled = false
                    }
                }
            }else{
                withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                withdrawBtn.isEnabled = false
            }
        }
    }
    var walletModel : WalletModel?{
        didSet{
            if walletModel?.status == 2 || walletModel == nil{
                withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                withdrawBtn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var withdrawBtn: UIButton!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("NumberCustomKeyboardView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setUpUI(){
        
    }
    @IBAction func numberClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        let str = btn.titleLabel?.text

        for character in (numberStr) {
            if character == "."{
                let sourceArray : [String] = numberStr.components(separatedBy: ".")
                let lastStr : String = sourceArray.last!
                if lastStr.count == 2{
                    return
                }
            }
        }
        if  numberStr == "0"{
            return
        }
        numberStr = (numberStr) + (str ?? "")
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if self.walletModel?.status == 2 || self.walletModel == nil{
            withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
            withdrawBtn.isEnabled = false
        }else{
            if Float(numberStr)! > 0 && Float(numberStr)! <= Float(self.walletModel?.balance ?? "0")!{
                withdrawBtn.backgroundColor = .hexColor(hex: "0CD664")
                withdrawBtn.isEnabled = true
            }else{
                withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                withdrawBtn.isEnabled = false
            }
        }
        if self.enterBlock != nil{
            self.enterBlock!(numberStr)
        }
    }
    @IBAction func decimalPointClick(_ sender: Any) {
        let str = numberStr
        if(numberStr == ""){
            return
        }
        for character in (numberStr) {
            if character == "."{
                return
            }
        }
        numberStr = str + "."
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        if self.walletModel?.status == 2 || self.walletModel == nil{
            withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
            withdrawBtn.isEnabled = false
        }else{
            if Float(numberStr)! > 0 && Float(numberStr)! <= Float(self.walletModel?.balance ?? "0")!{
                withdrawBtn.backgroundColor = .hexColor(hex: "0CD664")
                withdrawBtn.isEnabled = true
            }else{
                withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                withdrawBtn.isEnabled = false
            }
        }
        if self.enterBlock != nil{
            self.enterBlock!(numberStr)
        }
    }
    @IBAction func deleteClick(_ sender: Any) {
        if numberStr == ""{
            withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
            withdrawBtn.isEnabled = false
            return
        }

        var str : String = numberStr
        str.removeLast()
        numberStr = str
        if self.walletModel?.status == 2 || self.walletModel == nil{
            withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
            withdrawBtn.isEnabled = false
        }else{
            if numberStr != ""{
                let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
                if Float(numberStr)! <= 0 || Float(numberStr)! > Float(self.walletModel?.balance ?? "0")!{
                    withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                    withdrawBtn.isEnabled = false
                }else{
                    withdrawBtn.backgroundColor = .hexColor(hex: "0CD664")
                    withdrawBtn.isEnabled = true
                }
            }else{
                withdrawBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
                withdrawBtn.isEnabled = false
            }
        }
        if self.enterBlock != nil{
            self.enterBlock!(numberStr)
        }
    }
    @IBAction func withdrawClick(_ sender: Any) {
        if numberStr != "" && Float(numberStr)! <= 0{
            return
        }
        if self.withDrawBlock != nil{
            self.withDrawBlock!()
        }
    }
    
    @IBAction func closeClick(_ sender: Any) {
        if self.closeBlock != nil{
            self.closeBlock!()
        }
    }
}
