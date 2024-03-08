//
//  LeagueMatchListCell.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/17.
//

import UIKit

protocol LeagueMatchListCellDelegate{
    func leagueMatchListOd()
}

class LeagueMatchListCell: UICollectionViewCell {
    
    @IBOutlet weak var leftLogo: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLogo: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftScore: UILabel!
    @IBOutlet weak var rightScore: UILabel!
    @IBOutlet weak var saitime: UILabel!
    @IBOutlet weak var overtime: UILabel!
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var VSLabel: UILabel!
    @IBOutlet weak var VSLabel2: UILabel!
    
    var delegate: LeagueMatchListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.register(UINib(nibName: "BettingCell", bundle: nil), forCellWithReuseIdentifier: "BettingCell")
    }
    
}

extension LeagueMatchListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BettingCellDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BettingCell", for: indexPath) as! BettingCell
        cell.odLabel.tag = 10000 + indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenW - 50)/4, height: 80)
    }
    
    func clickOdLabel(index: Int) {
        print("\(index - 10000)")
        delegate?.leagueMatchListOd()
    }
}

