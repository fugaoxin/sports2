//
//  CheckInHeaderView.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit

class CheckInHeaderView: UIView {
    var checkInBlock : (()->Void)?
    
    @IBOutlet weak var changeBgColorView: UIView!
    
    @IBOutlet weak var fuctionBgView: UIView!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var dayCountLB: UILabel!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("CheckInHeaderView", owner: self, options: nil)?.first as! UIView
    }()
    var model : CheckInModel?{
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let currentDate = dateFormatter.string(from: Date())
            self.dayCountLB.text = String(model?.count ?? 0)
            for i in 0..<(model?.checkinStatus?.count ?? 0){
                let item = model?.checkinStatus![i] ?? CheckInItemModel()
                self.setDataUI(tag: i, status: item.status ?? 0)
                if item.date == currentDate{
                    if item.status != 1{
                        self.checkBtn.isEnabled = true
                        self.checkBtn.setBackgroundImage(UIImage(named: "checkInBtnBg"), for: .normal)
                        self.checkBtn.setBackgroundImage(UIImage(named: "checkInBtnBg"), for: .highlighted)
                        self.checkBtn.backgroundColor = .clear
                        self.checkBtn.setTitle("Check in now", for: .normal)
                    }else{
                        self.checkBtn.isEnabled = false
                        self.checkBtn.setBackgroundImage(nil, for: .normal)
                        self.checkBtn.setBackgroundImage(nil, for: .highlighted)
                        self.checkBtn.backgroundColor = .hexColor(hex: "E3E3E3")
                        self.checkBtn.setTitle("Check In Successfully", for: .normal)
                    }
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
        self.checkBtn.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setUpUI(){
        let layer = changeBgColorView.layer.sublayers?[0]
        if layer is CAGradientLayer{
            changeBgColorView.layer.sublayers?.remove(at: 0)
        }
        var colors : Array<CGColor> = []
        colors = [UIColor.kRgbColor(red: 30, green: 198, blue: 97, alpha: 1).cgColor,UIColor.kRgbColor(red: 28, green: 192, blue: 108, alpha: 1).cgColor,UIColor.kRgbColor(red: 24, green: 176, blue: 131, alpha: 1).cgColor,UIColor.kRgbColor(red: 33, green: 205, blue: 87, alpha: 1).cgColor]
        let gradient:CAGradientLayer = CAGradientLayer.init()
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 0, y: 1)
        gradient.colors = colors
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 80)
        changeBgColorView.layer.insertSublayer(gradient, at: 0)
    }

    func setDataUI(tag:Int,status:Int){
        let imageV : UIImageView = (fuctionBgView.viewWithTag(100 + tag) ?? UIImageView()) as! UIImageView
        let label : UILabel = (fuctionBgView.viewWithTag(200 + tag) ?? UILabel()) as! UILabel
        if status == 0{
            imageV.image = UIImage(named: "unCheckIn")
            label.textColor = .hexColor(hex: "FF9900")
        }else if status == 1{
            imageV.image = UIImage(named: "checkIn")
            label.textColor = .hexColor(hex: "009977")
        }else{
            imageV.image = UIImage(named: "passCheckIn")
            label.textColor = .hexColor(hex: "C9C9C9")
        }
    }
    @IBAction func checkClick(_ sender: Any) {
        Tool.requestCheckIn { [self] isSuccess in
            if isSuccess == true{
                self.dayCountLB.text = String((self.model?.count ?? 0) + 1)
                self.checkBtn.isEnabled = false
                self.checkBtn.setBackgroundImage(nil, for: .normal)
                self.checkBtn.setBackgroundImage(nil, for: .highlighted)
                self.checkBtn.backgroundColor = .hexColor(hex: "E3E3E3")
                self.checkBtn.setTitle("Check In Successfully", for: .normal)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let currentDate = dateFormatter.string(from: Date())
                for i in 0..<(self.model?.checkinStatus?.count ?? 0){
                    let item : CheckInItemModel = self.model?.checkinStatus?[i] ?? CheckInItemModel()
                    if item.date == currentDate{
                        self.setDataUI(tag: i, status: 1)
                    }
                }
                if self.checkInBlock != nil{
                    self.checkInBlock!()
                }
            }
        }
    }
    
}
