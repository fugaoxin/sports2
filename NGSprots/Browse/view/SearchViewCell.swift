//
//  SearchViewCell.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit

protocol SearchViewCelldelegate{
    func searchDelectBtn(btn: UIButton)
}

class SearchViewCell: UICollectionViewCell {
    @IBOutlet weak var dtl: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: SearchViewCelldelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func delectBtn(_ sender: UIButton) {
        delegate?.searchDelectBtn(btn: sender)
    }
    
}
