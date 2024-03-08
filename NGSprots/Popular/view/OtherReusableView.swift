//
//  OtherReusableView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/15.
//

import UIKit

protocol OtherReusableViewDelegate{
    func OtherSportRightBtn(btn: UIButton)
}

class OtherReusableView: UICollectionReusableView {
    
    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mtLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var bgBtn: UIButton!
    @IBOutlet weak var bgView: UILabel!
    var delegate: OtherReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        
    }
    
    @IBAction func shoucangBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        rightBtn.isSelected = !rightBtn.isSelected
        delegate?.OtherSportRightBtn(btn: sender)
    }
    
}
