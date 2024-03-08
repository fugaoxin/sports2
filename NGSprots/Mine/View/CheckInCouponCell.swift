//
//  CheckInCouponCell.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit

class CheckInCouponCell: UITableViewCell {
    
    var useBlock : ((_ type:Int)->Void)?
    
    @IBOutlet weak var unitLB: UILabel!
    
    @IBOutlet weak var numberLB: UILabel!
    
    @IBOutlet weak var introLB: UILabel!
    
    @IBOutlet weak var detailLB: UILabel!
    
    @IBOutlet weak var timeLB: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var tagLB: UILabel!
    
    @IBOutlet weak var unActiveIV: UIImageView!
    
    @IBOutlet weak var bgViewRightSpace: NSLayoutConstraint!
    
    @IBOutlet weak var bgViewLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var introLBLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var bgIVH: NSLayoutConstraint!
    
    @IBOutlet weak var useBtn: UIButton!
    
    @IBOutlet weak var useLB: UILabel!
    
    @IBOutlet weak var useIV: UIImageView!
    
    @IBOutlet weak var selectIV: UIImageView!
    
    @IBOutlet weak var unitLBBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var unitLBLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var useBtnH: NSLayoutConstraint!
    @IBOutlet weak var tagimg: UIImageView!
    
    var isRegisterActivity : Bool?{
        didSet{
//            self.tagLB.isHidden = isRegisterActivity ?? false
//            self.tagimg.isHidden = isRegisterActivity ?? false
        }
    }
    var model : itemModel?{
        didSet{
            if model?.type == 3{
                self.tagLB.text = "Deposit"
                tagimg.image = UIImage(named: "tag_Deposit")?.withTintColor(.hexColor(hex: "FF3344"))
            }else{
                self.tagLB.text = "Bet on"
                tagimg.image = UIImage(named: "tag_Deposit")?.withTintColor(.hexColor(hex: "FF9933"))
            }
            if model?.mainValue?.count ?? 0 == 4{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 35)
                self.unitLBBottomSpace.constant = -4
            }else if model?.mainValue?.count ?? 0 <= 3{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 45)
                self.unitLBBottomSpace.constant = -7
            }else{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 27)
                self.unitLBBottomSpace.constant = -3
            }
            if model?.type == 1{
                self.unitLB.text = "₦"
                self.numberLB.text = Tool.StringIsEmpty(value: model?.mainValue) ? "-" : model?.mainValue
            }else{
                self.unitLB.text = ""
                self.numberLB.text = "\(model?.mainValue ?? "-")%"
            }
            if self.unitLB.text == ""{
                self.unitLBLeftSpace.constant = 27
            }else{
                if model?.mainValue?.count ?? 0 > 2{
                    self.unitLBLeftSpace.constant = 22
                }else{
                    self.unitLBLeftSpace.constant = 27
                }
            }
            self.introLB.text = model?.desc ?? "--"
            self.detailLB.text = model?.limitationShow ?? "--"
            self.timeLB.text = model?.validityText ?? "--"
            
            if model?.status == 3 || model?.status == 4{
                self.unActiveIV.isHidden = false
            }else{
                self.unActiveIV.isHidden = true
            }
        }
    }
    var smallModel : itemModel?{
        didSet{
            if smallModel?.type == 3{
                self.tagLB.text = "Deposit"
                tagimg.image = UIImage(named: "tag_Deposit")?.withTintColor(.hexColor(hex: "FF3344"))
            }else{
                self.tagLB.text = "Bet on"
                tagimg.image = UIImage(named: "tag_Deposit")?.withTintColor(.hexColor(hex: "FF9933"))
            }
            if smallModel?.mainValue?.count ?? 0 == 4{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 25)
                self.unitLB.font = UIFont(name: "DIN Alternate Bold",size: 11)
                self.unitLBBottomSpace.constant = -3
            }else if smallModel?.mainValue?.count ?? 0 <= 3{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 35)
                self.unitLB.font = UIFont(name: "DIN Alternate Bold",size: 15)
                self.unitLBBottomSpace.constant = -6
            }else{
                self.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 17)
                self.unitLB.font = UIFont(name: "DIN Alternate Bold",size: 9)
                self.unitLBBottomSpace.constant = -2
            }
            if smallModel?.type == 1{
                self.unitLB.text = "₦"
                self.numberLB.text = Tool.StringIsEmpty(value: smallModel?.mainValue) ? "-" : smallModel?.mainValue
            }else{
                self.unitLB.text = ""
                self.numberLB.text = "\(smallModel?.mainValue ?? "-")%"
            }
            if self.unitLB.text == ""{
                self.unitLBLeftSpace.constant = 27
            }else{
                if smallModel?.mainValue?.count ?? 0 > 2{
                    self.unitLBLeftSpace.constant = 21
                }else{
                    self.unitLBLeftSpace.constant = 27
                }
            }
            self.introLB.text = smallModel?.desc ?? "--"
            self.detailLB.text = smallModel?.limitationShow ?? "--"
            self.timeLB.text = smallModel?.validityText ?? "--"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tagLB.layer.cornerRadius = 8
        self.tagLB.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
        self.tagLB.layer.masksToBounds = true
    }

    @IBAction func useClick(_ sender: Any) {
        if self.useBlock != nil{
            if model != nil{
                if model?.type == 3{
                    self.useBlock!(0)
                }else{
                    self.useBlock!(2)
                }
            }else{
                if smallModel?.type == 3{
                    self.useBlock!(0)
                }else{
                    self.useBlock!(2)
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
