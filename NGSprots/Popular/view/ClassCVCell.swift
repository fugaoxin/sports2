//
//  ClassCVCell.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/16.
//

import UIKit

class ClassCVCell: UICollectionViewCell {

    @IBOutlet weak var bgLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var insertTimers:Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        self.bgLabel.layer.masksToBounds = true
        self.bgLabel.layer.cornerRadius = 10
       
        self.insertTimers = Timer.scheduledTimer(withTimeInterval: TimeInterval(4), repeats: true, block: { (timer) in
            UIView.animate(withDuration: 0.8) {
                self.logoImage.frame.size = CGSize(width: self.logoImage.frame.width/1.1, height: self.logoImage.frame.height/1.1)
            }
        })
    }
}
