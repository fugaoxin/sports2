//
//  FooterLineReusableView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/18.
//

import UIKit

protocol FooterLineReusableViewDelegate{
    func showFollowUsList(type: Bool)
    func followUsListType(index: Int)
}

class FooterLineReusableView: UICollectionReusableView {
    
    @IBOutlet weak var vbtn: UIButton!
    @IBOutlet weak var line: UILabel!
    var delegate: FooterLineReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func clickList(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        vbtn.isSelected = !vbtn.isSelected
        delegate?.showFollowUsList(type: sender.isSelected)
    }
    
    @IBAction func clickFollowUs(_ sender: UIButton) {
        delegate?.followUsListType(index: sender.tag)
    }
    
    
}
