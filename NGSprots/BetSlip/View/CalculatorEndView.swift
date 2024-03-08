//
//  CalculatorEndView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/2.
//

import UIKit

protocol CalculatorEndViewDelegate {
    func CalculatorEndViewXTarget()
    func CalculatorEndViewLeftTarget()
    func CalculatorEndViewRightTarget()
}

class CalculatorEndView: UIView {
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var endTips: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var peilv: UILabel!
    
    @IBOutlet weak var benjin: UILabel!
    @IBOutlet weak var benjinType: UILabel!
    @IBOutlet weak var keying: UILabel!
    @IBOutlet weak var keyingType: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    var myDelegate: CalculatorEndViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("CalculatorEndView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        
    }
    
    @IBAction func XBtn(_ sender: UIButton) {
        myDelegate?.CalculatorEndViewXTarget()
    }
    
    @IBAction func clickLeftBtn(_ sender: UIButton) {
        myDelegate?.CalculatorEndViewLeftTarget()
    }
    
    @IBAction func clickRightBtn(_ sender: UIButton) {
        myDelegate?.CalculatorEndViewRightTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
