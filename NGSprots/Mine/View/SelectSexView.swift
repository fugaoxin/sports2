//
//  SelectSexView.swift
//  SportsDemo
//
//  Created by Jean on 3/11/2023.
//

import UIKit
protocol SelectSexDelegate{
    func sexSureClick(code:String)
}
class SelectSexView: UIView {

    var selectSexDelegate : SelectSexDelegate?
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleLB: UILabel!
    @IBOutlet weak var femaleLB: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var maleIV: UIImageView!
    @IBOutlet weak var femaleIV: UIImageView!
    
    var sex = "0"{
        didSet{
            changeState()
        }
    }
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectSexView", owner: self, options: nil)?.first as! UIView
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
       changeState()
    }
    func changeState(){
        maleBtn.isSelected = sex=="0" ? true : false
        maleBtn.backgroundColor = sex=="0"  ? .hexColor(hex: "0CD664") : .hexColor(hex: "F5F6F9")
        maleIV.image = sex=="0" ? UIImage(named: "male") : UIImage(named: "maleBlack")
        femaleBtn.isSelected = sex=="1" ? true : false
        femaleBtn.backgroundColor = sex=="1" ? .hexColor(hex: "0CD664") : .hexColor(hex: "F5F6F9")
        femaleIV.image = sex=="1" ? UIImage(named: "female") : UIImage(named: "femaleBlack")
    }
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func maleClick(_ sender: Any) {
        sex = "0"
        changeState()
    }
    
    @IBAction func femaleClick(_ sender: Any) {
        sex = "1"
        changeState()
    }
    
    @IBAction func sureClick(_ sender: Any) {
        selectSexDelegate?.sexSureClick(code: maleBtn.isSelected ? "0" : "1")
        Tool.keyWindow().hiddenInWindow()
    }
}
