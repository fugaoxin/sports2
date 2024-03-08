//
//  AddBankView.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class AddBankView: UIView {
    var addBankCardBlock : (()->Void)?
    
    @IBOutlet weak var addBankBtn: UIButton!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("AddBankView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setUpUI(){
        self.drawLayerDashedLine(width: 4, length: 2, space: 2, cornerRadius: 10, color: .hexColor(hex: "0CD664"))
    }
    
    @IBAction func addClick(_ sender: Any) {
        if self.addBankCardBlock != nil{
            self.addBankCardBlock!()
        }
    }
    func drawLayerDashedLine(width: CGFloat, length: CGFloat, space: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        self.addBankBtn.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = CGRect(x: 0, y: 0, width: kScreenW-30, height: 50)
        borderLayer.position = CGPoint(x: (kScreenW-30)/2, y: 25)
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale
        borderLayer.lineDashPattern = [length,space] as? [NSNumber]
        borderLayer.lineDashPhase = 0.1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.addBankBtn.layer.addSublayer(borderLayer)
    }
}
