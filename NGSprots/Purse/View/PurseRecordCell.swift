//
//  PurseRecordCell.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit

class PurseRecordCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var typeNameLB: UILabel!
    
    @IBOutlet weak var dateLB: UILabel!
    
    @IBOutlet weak var priceLB: UILabel!
    
    @IBOutlet weak var unitLB: UILabel!
    
    @IBOutlet weak var stateLB: UILabel!
    
    @IBOutlet weak var bonusLB: UILabel!
    
    @IBOutlet weak var priceBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomH: NSLayoutConstraint!
    var model : payRwList?{
        didSet{
            imageV.image = model?.orderType == "deposit" ? UIImage(named: "depositRecord") : UIImage(named: "withdrawRecord")
            typeNameLB.text = model?.orderType
            dateLB.text = timeDate(time: "\((model?.createTime ?? 0)/1000)")
            priceLB.text = model?.orderType == "deposit" ? "+\(model?.orderAmount ?? "")" : "-\(model?.orderAmount ?? "")"
            priceLB.textColor = model?.orderType == "deposit" ? .hexColor(hex: "F01717") : .hexColor(hex: "101010")
            unitLB.textColor = model?.orderType == "deposit" ? .hexColor(hex: "F01717") : .hexColor(hex: "101010")
            stateLB.text = model?.orderType == "deposit" ? depositStatus(key: model?.status ?? 0): withdrawStatus(key: model?.status ?? 0)
            stateLB.textColor = model?.status == 1 ? .hexColor(hex: "F01717") : .hexColor(hex: "2ABF83")
            bonusLB.text = model?.orderType == "deposit" ? "\(model?.BonusAmount ?? "")" : ""
            if model?.orderType == "deposit"{
                if model?.status == 4{
                    stateLB.textColor = .hexColor(hex: "F01717")
                }else{
                    stateLB.textColor = .hexColor(hex: "2ABF83")
                }
            }else{
                if model?.status == 4{
                    stateLB.textColor = .hexColor(hex: "F01717")
                }else{
                    stateLB.textColor = .hexColor(hex: "2ABF83")
                }
            }
        }
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        return dformatter.string(from: date as Date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
  
}
