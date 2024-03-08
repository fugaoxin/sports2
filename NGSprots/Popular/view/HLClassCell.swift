//
//  HLClassCell.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/28.
//

import UIKit

class HLClassCell: UICollectionViewCell {
    @IBOutlet weak var bgLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var titleW: NSLayoutConstraint!
    @IBOutlet weak var bgW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
