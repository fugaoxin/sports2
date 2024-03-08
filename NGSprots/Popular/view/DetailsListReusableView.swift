//
//  DetailsListReusableView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/18.
//

import UIKit

protocol DetailsListReusableViewDelegate{
    func detailsZhan(btn: UIButton)
    func detailsBiaoji(btn: UIButton)
}

class DetailsListReusableView: UICollectionReusableView {
    
    @IBOutlet weak var biaojibtn: UIButton!
    @IBOutlet weak var zanbtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bglabel: UILabel!
    
    var delegate: DetailsListReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func clickBiaoji(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        delegate?.detailsBiaoji(btn: sender)
        
    }
    
    @IBAction func clickshoucang(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.detailsZhan(btn: sender)
    }
    
}
