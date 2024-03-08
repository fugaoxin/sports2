//
//  FavouritesNoDataCell.swift
//  NGSprots
//
//  Created by Jean on 13/12/2023.
//

import UIKit

class FavouritesNoDataCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.frame = self.bounds
        self.bgView.layoutEmptyView()
    }
}
