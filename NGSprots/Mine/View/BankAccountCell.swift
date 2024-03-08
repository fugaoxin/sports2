//
//  BankAccountCell.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class BankAccountCell: UITableViewCell {
    var deleteBlock : (()->Void)?
    @IBOutlet weak var bankIV: UIImageView!
    
    @IBOutlet weak var bankNameLB: UILabel!
    
    @IBOutlet weak var bankCardNumLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteClick(_ sender: Any) {
        if self.deleteBlock != nil{
            self.deleteBlock!()
        }
    }
}
