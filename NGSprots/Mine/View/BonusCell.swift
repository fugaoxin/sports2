//
//  BonusCell.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/9.
//

import UIKit

class BonusCell: UITableViewCell {

    @IBOutlet weak var moneyLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var validityView: UIView!
    @IBOutlet weak var useImg: UIImageView!
    @IBOutlet weak var useBg: UIView!
    @IBOutlet weak var bottomviewH: NSLayoutConstraint!
    @IBOutlet weak var conditionLabel: UILabel!
    var goUse: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickUse(_ sender: UIButton) {
        goUse!()
    }
    
}
