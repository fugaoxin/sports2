//
//  BetHistoryViewBCell.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/13.
//

import UIKit

class BetHistoryViewBCell: UICollectionViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var typeImg: UIButton!
    @IBOutlet weak var datalabel: UILabel!
    
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var bMoney: UILabel!
    @IBOutlet weak var winMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
