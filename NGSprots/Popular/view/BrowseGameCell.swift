//
//  BrowseGameCell.swift
//  NGSprots
//
//  Created by Jean on 15/12/2023.
//

import UIKit

class BrowseGameCell: UICollectionViewCell {

    @IBOutlet weak var LeagueMatchIV: UIImageView!
    
    @IBOutlet weak var LeagueMatchNameLB: UILabel!
    
    @IBOutlet weak var teamNameLB: UILabel!
    
    @IBOutlet weak var timeLB: UILabel!
    
    var model : BrowseGameItemModel? {
        didSet{
            LeagueMatchIV.sd_setImage(with: URL(string: model?.lLogoUrl ?? ""), placeholderImage: UIImage(named: "zuqiu_icon"))
            LeagueMatchNameLB.text = model?.lName
            teamNameLB.text = "\(model?.hTName ?? "") - \(model?.aTName ?? "")"
            timeLB.text = self.timeDate(time: "\((model?.beginTime ?? 0)/1000)")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }
}
