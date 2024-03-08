//
//  StateItemCell.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit

class StateItemCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
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

}
