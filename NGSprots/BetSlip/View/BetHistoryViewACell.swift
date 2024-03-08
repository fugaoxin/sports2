//
//  BetHistoryViewACell.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/13.
//

import UIKit

class BetHistoryViewACell: UICollectionViewCell {

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftscore: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightscore: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var vs2Label: UILabel!
    
    @IBOutlet weak var wflabel: UILabel!
    @IBOutlet weak var peilv: UILabel!
    
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var betMoney: UILabel!
    @IBOutlet weak var keyinMoney: UILabel!
    @IBOutlet weak var sellfor: UIButton!
    @IBOutlet weak var line: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickSellforBtn(_ sender: UIButton) {
    }
    

}
