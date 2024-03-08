//
//  DetailClassReusableView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/2.
//

import UIKit

protocol DetailClassReusableViewDelegate{
    func shuanxuan()
}

class DetailClassReusableView: UICollectionReusableView {
    
    var delegate: DetailClassReusableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickShuanxuan(_ sender: UIButton) {
        delegate?.shuanxuan()
    }
}
