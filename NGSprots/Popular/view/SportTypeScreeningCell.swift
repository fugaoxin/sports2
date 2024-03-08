//
//  SportTypeScreeningCell.swift
//  NGSprots
//
//  Created by Jean on 2/12/2023.
//

import UIKit

class SportTypeScreeningCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var sportNameLB: UILabel!
    
    @IBOutlet weak var sportIV: UIImageView!
    
    @IBOutlet weak var selectIV: UIImageView!
    var selectSport:Bool = false{
        didSet{
            if selectSport == true{
                selectIV.layer.borderColor = UIColor.clear.cgColor
                selectIV.image = UIImage(named: "sportScreen")
            }else{
                selectIV.image = UIImage(named: "")
                selectIV.layer.borderWidth = 1
                selectIV.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .hexColor(hex: "F5F5F7")
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
    }
}
