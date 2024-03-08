//
//  BrowseReusableView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/27.
//

import UIKit

protocol BrowseReusabledelegate{
    func browseRightBtn(btn: UIButton)
}

class BrowseReusableView: UICollectionReusableView {

    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var bgbtn: UIButton!
    var delegate: BrowseReusabledelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickRightBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.browseRightBtn(btn: sender)
    }
    
    
}
