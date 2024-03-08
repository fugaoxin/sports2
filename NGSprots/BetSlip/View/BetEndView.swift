//
//  BetEndView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/13.
//

import UIKit

protocol BetEndViewDelegate {
    func CalculatorEndViewLeftTarget()
    func CalculatorEndViewRightTarget()
}

class BetEndView: UIView {

    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endBtn: UIButton!
    
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var peilv: UILabel!
    
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var peilv2: UILabel!
    
    @IBOutlet weak var benjin: UILabel!
    @IBOutlet weak var keying: UILabel!
    
    @IBOutlet weak var bonusLabel: UILabel!
    var delegate: BetEndViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BetEndView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    @IBAction func clickLeftBtn(_ sender: UIButton) {
        delegate?.CalculatorEndViewLeftTarget()
    }
    
    @IBAction func clickRightBtn(_ sender: UIButton) {
        delegate?.CalculatorEndViewRightTarget()
    }
    
    
    
    
}
