//
//  CheckInSectionHeaderView.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit

class CheckInSectionHeaderView: UIView {
    var obtainedBlock : (()->Void)?
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var obtainedBtn: UIButton!
   
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var promptIV: UIImageView!
    
    var model : CheckInCouponModel?{
        didSet{
            self.titleLB.text = Tool.StringIsEmpty(value: model?.text) ? "Signed In For \(model?.day ?? 0) Days Rewards" : model?.text
            if model?.claimStatus == 2{
                self.obtainedBtn.isEnabled = true
                self.obtainedBtn.setBackgroundImage(UIImage(named: "obtainedBg"), for: .normal)
                self.obtainedBtn.setBackgroundImage(UIImage(named: "obtainedBg"), for: .highlighted)
                self.obtainedBtn.backgroundColor = .clear
                self.obtainedBtn.setTitle("Obtained", for: .normal)
            }else{
                self.obtainedBtn.isEnabled = false
                self.obtainedBtn.setBackgroundImage(nil, for: .normal)
                self.obtainedBtn.setBackgroundImage(nil, for: .highlighted)
                self.obtainedBtn.backgroundColor = .hexColor(hex: "E3E3E3")
                if model?.claimStatus == 1{
                    self.obtainedBtn.setTitle("Received", for: .normal)
                }else{
                    self.obtainedBtn.setTitle("Obtained", for: .normal)
                }
            }
        }
    }
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("CheckInSectionHeaderView", owner: self, options: nil)?.first as! UIView
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
        self.drawDashLine(lineView: self.lineView, lineLength: 2, lineSpacing: 2, lineColor: .hexColor(hex: "BEBEBE"))
    }
    private func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: kScreenW-60, height: 1)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 0.8
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: kScreenW-60, y: 0))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func obtainedClick(_ sender: Any) {
        if self.obtainedBlock != nil{
            self.obtainedBlock!()
        }
    }
}
