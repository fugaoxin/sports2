//
//  RegisterActivityCell.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class RegisterActivityCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var numberLB: UILabel!
    
    @IBOutlet weak var takeBtn: UIButton!
    
    @IBOutlet weak var checkLB: UILabel!
    
    @IBOutlet weak var promptIV: UIImageView!
    
    var takeCouponBlock : (()->Void)?
    var model : itemModel?{
        didSet{
            
            self.numberLB.text = "\(model?.mainValue ?? "0")NGN"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.numberLB.font = UIFont(name: "Arial Black", size: 27)
        
    }
    
    
    @IBAction func takeClick(_ sender: Any) {
        if self.takeCouponBlock != nil{
            self.takeCouponBlock!()
        }
    }
}
