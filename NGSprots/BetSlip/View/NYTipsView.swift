//
//  NYTipsView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/14.
//

import UIKit

protocol NYTipsViewDelegate{
    func clickLeftBtn()
    func clickRightBtn()
}

class NYTipsView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    var delegate:NYTipsViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("NYTipsView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        leftBtn.layer.borderWidth = 0.5
        leftBtn.layer.borderColor = UIColor.hexColor(hex: "C1C4C9").cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        delegate?.clickLeftBtn()
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        delegate?.clickRightBtn()
    }
    
}
