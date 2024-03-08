//
//  LeagueMatchReusableView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/18.
//

import UIKit


class LeagueMatchReusableView: UICollectionReusableView {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        
    }
    
    @IBAction func clickCollect(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickLDBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func clickVideoBtn(_ sender: UIButton) {
        
    }
    
}
