//
//  DetailsListCVBCell.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/18.
//

import UIKit

protocol DetailsListCVBCellDelegate{
    func CVBPeilvBg(index: Int)
}

class DetailsListCVBCell: UICollectionViewCell {
    
    @IBOutlet weak var peilvBg1: UIView!
    @IBOutlet weak var wf1: UILabel!
    @IBOutlet weak var peilv1: UILabel!
    @IBOutlet weak var suo1: UIImageView!
    
    @IBOutlet weak var peilvBg2: UIView!
    @IBOutlet weak var wf2: UILabel!
    @IBOutlet weak var peilv2: UILabel!
    @IBOutlet weak var suo2: UIImageView!
    
    @IBOutlet weak var peilvBg3: UIView!
    @IBOutlet weak var wf3: UILabel!
    @IBOutlet weak var peilv3: UILabel!
    @IBOutlet weak var suo3: UIImageView!
    @IBOutlet weak var bglabel: UILabel!
    
    var delegate: DetailsListCVBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        peilvBg1.isUserInteractionEnabled = true
        let plb1tap = UITapGestureRecognizer(target: self, action: #selector(clickPeilvBg1))
        peilvBg1.addGestureRecognizer(plb1tap)
        
        peilvBg2.isUserInteractionEnabled = true
        let plb2tap = UITapGestureRecognizer(target: self, action: #selector(clickPeilvBg2))
        peilvBg2.addGestureRecognizer(plb2tap)
        
        peilvBg3.isUserInteractionEnabled = true
        let plb3tap = UITapGestureRecognizer(target: self, action: #selector(clickPeilvBg3))
        peilvBg3.addGestureRecognizer(plb3tap)
    }
    
    @objc func clickPeilvBg1(){
        delegate?.CVBPeilvBg(index: peilvBg1.tag)
    }
    
    @objc func clickPeilvBg2(){
        delegate?.CVBPeilvBg(index: peilvBg2.tag)
    }

    @objc func clickPeilvBg3(){
        delegate?.CVBPeilvBg(index: peilvBg3.tag)
    }

}
