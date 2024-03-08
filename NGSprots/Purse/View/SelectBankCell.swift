//
//  SelectBankCell.swift
//  NGSprots
//
//  Created by Jean on 26/12/2023.
//

import UIKit

class SelectBankCell: UITableViewCell {

    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var selectIV: UIImageView!
    
    var isSelect : Bool?{
        didSet{
            self.selectIV.isHidden = !(isSelect ?? false)
            self.bgView.backgroundColor = isSelect ?? false ? .hexColor(hex: "F7FFF4") : .hexColor(hex: "F5F6F9")
            self.bgView.layer.borderColor = isSelect ?? false ? UIColor.kRgbColor(red: 35, green: 235, blue: 66).cgColor : UIColor.white.cgColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
