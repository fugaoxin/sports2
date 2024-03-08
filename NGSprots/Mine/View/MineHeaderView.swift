//
//  MineHeaderView.swift
//  NGSprots
//
//  Created by Jean on 3/1/2024.
//

import UIKit

class MineHeaderView: UIView {
    var headerFuctionBlock : ((_ type : Int)->Void)?
    
    @IBOutlet weak var headerIV: UIImageView!
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var IDLB: UILabel!
    
    @IBOutlet weak var numberLB: UILabel!
    
    @IBOutlet weak var messageCountLB: UILabel!
    
    @IBOutlet weak var functionBgView: UIView!
    
    @IBOutlet weak var editInfoIV: UIImageView!
    
    @IBOutlet weak var topSpaceH: NSLayoutConstraint!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView
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
        self.functionBgView.layer.cornerRadius = 15
        self.functionBgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.topSpaceH.constant = kNavigationBarH + kStatusBarH
    }
    func setUpData(){
        self.editInfoIV.isHidden = Tool.getuserInfoModel() == nil ? true : false
        let account : AccountModel? = Tool.getuserInfoModel()
        self.headerIV.sd_setImage(with: URL(string: account?.avatar ?? ""), placeholderImage: UIImage(named: "headerPlaceholder"), context: nil)
        self.nameLB.text = (account?.nickname == nil || account?.nickname?.count == 0) ? "--" : account?.nickname
        self.IDLB.text =  "ID：" + String(account?.id ?? 0)
        if account == nil{
            self.nameLB.text = "Please Log In"
            self.IDLB.text =  "Welcome to Bsports"
            self.headerIV.image =  UIImage(named: "headerPlaceholder")
        }
        self.numberLB.text = (account?.wallets?.first?.balance == nil || account?.wallets?.first?.balance?.count == 0) ? "- -" : account?.wallets?.first?.balance
    }
    func drawView() {
        self.layoutIfNeeded()
        self.setNeedsLayout()
     
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: self.functionBgView.bounds.width, y: 0), controlPoint: CGPoint(x: (self.functionBgView.bounds.width)/2, y: 18))
        path.addLine(to: CGPoint(x: self.functionBgView.bounds.width, y: self.functionBgView.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.functionBgView.bounds.height))
        path.close()
        path.usesEvenOddFillRule = true
        path.addClip()
       
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.functionBgView.bounds
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = path.cgPath
        shapeLayer.masksToBounds = true
        self.functionBgView.layer.addSublayer(shapeLayer)
        self.functionBgView.layer.mask = shapeLayer
    }

    @IBAction func goToEditUserInfoClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
//            Tool.getCurrentVc().showTextSB("Please Login", dismissAfterDelay: 1.5)
            Tool.goToLogin()
            return
        }
        if self.headerFuctionBlock != nil{
            self.headerFuctionBlock!(-1)
        }
    }
    
    @IBAction func refreshBalanceClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
            Tool.goToLogin()
            return
        }
        Tool.countDown(60, btn: sender as! UIButton)
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            self.numberLB.text = account.wallets?.first?.balance
        }
    }
    
    @IBAction func functionClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
//            Tool.getCurrentVc().showTextSB("Please Login", dismissAfterDelay: 1.5)
            Tool.goToLogin()
            return
        }
        let btn : UIButton = sender as! UIButton
        if self.headerFuctionBlock != nil{
            self.headerFuctionBlock!(btn.tag - 1000)
        }
    }
    
    @IBAction func gotoPurseClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
//            Tool.getCurrentVc().showTextSB("Please Login", dismissAfterDelay: 1.5)
            Tool.goToLogin()
            return
        }
        if self.headerFuctionBlock != nil{
            self.headerFuctionBlock!(-2)
        }
    }
}
