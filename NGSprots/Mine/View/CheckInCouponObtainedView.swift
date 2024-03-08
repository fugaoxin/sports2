//
//  CheckInCouponObtainedView.swift
//  NGSprots
//
//  Created by Jean on 30/1/2024.
//

import UIKit

class CheckInCouponObtainedView: UIView,UITableViewDelegate,UITableViewDataSource {
    var jumpBlock : ((_ type:Int)->Void)?
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var okBtn: UIButton!
    
    var model : CheckInCouponModel?{
        didSet{
            self.titleLB.text = Tool.StringIsEmpty(value: model?.text) ? "Signed In For \(model?.day ?? 0) Days Rewards" : model?.text
            self.tableView.reloadData()
        }
    }
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("CheckInCouponObtainedView", owner: self, options: nil)?.first as! UIView
    }()
    
    var isRegisterActivity : Bool?{
        didSet{
            self.bgColorDraw()
            self.tableView.reloadData()
        }
    }
    
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
        self.bgColorDraw()
        
        okBtn.layer.borderColor = UIColor.kRgbColor(red: 255, green: 255, blue: 255, alpha: 0.28).cgColor
        okBtn.layer.borderWidth = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CheckInCouponCell", bundle: nil), forCellReuseIdentifier: "CheckInCouponCell")
    }
    func updateFrame(){
        self.view.frame = self.bounds
    }
    func bgColorDraw(){
        let layer = self.view.layer.sublayers?[0]
        if layer is CAGradientLayer{
            self.view.layer.sublayers?.remove(at: 0)
        }
        var colors : Array<CGColor> = []
        if self.isRegisterActivity == true{
            colors = [UIColor.kRgbColor(red: 255, green: 131, blue: 54, alpha: 1).cgColor,UIColor.kRgbColor(red: 255, green: 54, blue: 137, alpha: 1).cgColor]
        }else{
            colors = [UIColor.kRgbColor(red: 12, green: 214, blue: 100, alpha: 1).cgColor,UIColor.kRgbColor(red: 0, green: 171, blue: 178, alpha: 1).cgColor]
        }
        let gradient:CAGradientLayer = CAGradientLayer.init()
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 0, y: 1)
        gradient.colors = colors
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func okClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func checkClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
        if self.jumpBlock != nil{
            self.jumpBlock!(1)
        }
    }
    
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return model?.coupons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckInCouponCell = tableView.dequeueReusableCell(withIdentifier: "CheckInCouponCell") as! CheckInCouponCell
        cell.bgViewLeftSpace.constant = 0
        cell.bgViewRightSpace.constant = 0
        cell.introLBLeftSpace.constant = 110
        cell.numberLB.font = UIFont(name: "DIN Alternate Bold",size: 35)
        cell.detailLB.font =  UIFont(name: "PingFangSC-Semibold",size: 13)
        cell.timeLB.font = UIFont(name: "PingFangSC-Regular",size: 7)
        cell.useBtn.isHidden = false
        cell.useLB.isHidden = false
        cell.useIV.isHidden = false
        
        cell.isRegisterActivity = self.isRegisterActivity
        cell.smallModel = model?.coupons?[indexPath.row]
        
        cell.useBlock = {[weak self]type in
            Tool.keyWindow().hiddenInWindow()
            if self?.jumpBlock != nil{
                self?.jumpBlock!(type)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
