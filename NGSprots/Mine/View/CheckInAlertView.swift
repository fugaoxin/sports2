//
//  CheckInAlertView.swift
//  NGSprots
//
//  Created by Jean on 30/1/2024.
//

import UIKit

class CheckInAlertView: UIView {
    
    @IBOutlet weak var dayCountLB: UILabel!
    
    @IBOutlet weak var checkInBtn: UIButton!
    
    var checkInAlertCloseBlock : (()->Void)?
    var model : CheckInModel?{
        didSet{
            self.dayCountLB.text = String(model?.count ?? 0)
            for i in 0..<(model?.checkinStatus?.count ?? 0){
                self.setDataUI(tag: i, status: model?.checkinStatus?[i].status ?? 0)
            }
        }
    }
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("CheckInAlertView", owner: self, options: nil)?.first as! UIView
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
       
    }
    func setDataUI(tag:Int,status:Int){
        let bgV = self.view.viewWithTag(1000+tag)
        let imageV : UIImageView = (bgV?.viewWithTag(100) ?? UIImageView()) as! UIImageView
        let label : UILabel = (bgV?.viewWithTag(200) ?? UILabel()) as! UILabel
        if status == 0{
            bgV?.backgroundColor = .hexColor(hex: "FEF9ED")
            imageV.image = UIImage(named: "unCheckIn")
            label.textColor = .hexColor(hex: "FF9900")
        }else if status == 1{
            bgV?.backgroundColor = .hexColor(hex: "E0FFF8")
            imageV.image = UIImage(named: "checkIn")
            label.textColor = .hexColor(hex: "009977")
        }else{
            bgV?.backgroundColor = .hexColor(hex: "F4F4F4")
            imageV.image = UIImage(named: "passCheckIn")
            label.textColor = .hexColor(hex: "C9C9C9")
        }
    }
    func setBtnUI(){
        self.checkInBtn.isEnabled = true
        self.checkInBtn.setBackgroundImage(UIImage(named: "checkInBtnBg"), for: .normal)
        self.checkInBtn.setBackgroundImage(UIImage(named: "checkInBtnBg"), for: .highlighted)
        self.checkInBtn.backgroundColor = .clear
        self.checkInBtn.setTitle("Check in now", for: .normal)
    }
    @IBAction func checkInClick(_ sender: Any) {
        Tool.requestCheckIn { [self] isSuccess in
            if isSuccess == true{
                self.dayCountLB.text = String((self.model?.count ?? 0) + 1)
                self.checkInBtn.isEnabled = false
                self.checkInBtn.setBackgroundImage(nil, for: .normal)
                self.checkInBtn.setBackgroundImage(nil, for: .highlighted)
                self.checkInBtn.backgroundColor = .hexColor(hex: "E3E3E3")
                self.checkInBtn.setTitle("Check In Successfully", for: .normal)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let currentDate = dateFormatter.string(from: Date())
                for i in 0..<(self.model?.checkinStatus?.count ?? 0){
                    let item : CheckInItemModel = self.model?.checkinStatus?[i] ?? CheckInItemModel()
                    if item.date == currentDate{
                        self.setDataUI(tag: i, status: 1)
                    }
                }
                
            }
        }
    }
    
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
        if self.checkInAlertCloseBlock != nil{
            self.checkInAlertCloseBlock!()
        }
    }
}
