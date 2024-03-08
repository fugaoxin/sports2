//
//  RegisterActivityHeaderView.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class RegisterActivityHeaderView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var introLB: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("RegisterActivityHeaderView", owner: self, options: nil)?.first as! UIView
    }()
    var model : RegisterActivityTaskModel?{
        didSet{
            if model?.coupons?.count == 0 || model?.coupons == nil{
                self.bgView.layer.cornerRadius = 20
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }else{
                self.bgView.layer.cornerRadius = 20
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            self.introLB.text = "Complete The Above \(model?.processes?.count ?? 0) Tasks To Get Rewards"
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
        self.bgView.layer.cornerRadius = 20
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RegisterActivityStepCell", bundle: nil), forCellReuseIdentifier: "RegisterActivityStepCell")
        
       
    }
    ///tableView 相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.processes?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RegisterActivityStepCell = tableView.dequeueReusableCell(withIdentifier: "RegisterActivityStepCell") as! RegisterActivityStepCell
        let stepModel = self.model?.processes?[indexPath.row]
        cell.model = stepModel
        return cell
    }
}
