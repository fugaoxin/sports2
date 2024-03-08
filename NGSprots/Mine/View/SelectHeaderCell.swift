//
//  SelectHeaderCell.swift
//  SportsDemo
//
//  Created by Jean on 3/11/2023.
//

import UIKit

class SelectHeaderCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerIV: UIImageView!
    var isChoose : Bool?{
        didSet{
            if isChoose == true{
                self.bgView.layer.borderWidth = 2
                self.bgView.layer.borderColor = UIColor.hexColor(hex: "0CD664").cgColor
            }else{
                self.bgView.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        headerIV.layer.cornerRadius = 30
        headerIV.layer.masksToBounds = true
        
        self.bgView.layer.cornerRadius = 35
        self.bgView.layer.masksToBounds = true
    }

}
