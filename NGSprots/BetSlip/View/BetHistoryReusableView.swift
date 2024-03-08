//
//  BetHistoryReusableView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/13.
//

import UIKit

class BetHistoryReusableView: UICollectionReusableView {

    @IBOutlet weak var logoImg: UIButton!
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var statuslabel: UILabel!
    
    @IBOutlet weak var cimg: UIImageView!
    @IBOutlet weak var cnum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
