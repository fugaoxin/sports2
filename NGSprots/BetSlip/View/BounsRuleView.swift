//
//  BounsRuleView.swift
//  NGSprots
//
//  Created by Jack Lin on 2024/2/29.
//

import UIKit

class BounsRuleView: UIView {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var leftview: UIView!
    @IBOutlet weak var rightview: UIView!
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BounsRuleView", owner: self, options: nil)?.first as! UIView
    }()
    
    var close: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        tableview.layer.cornerRadius = 15
        tableview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        leftview.layer.cornerRadius = 15
        leftview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        rightview.layer.cornerRadius = 15
        rightview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private var listModels = Array<accaBonusListItemModel>()
    func loadUI(models: [accaBonusListItemModel]){
        listModels = models
        tableview.reloadData()
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        close!()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

extension BounsRuleView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.selectionStyle = .none
        if indexPath.row%2 == 0{
            cell.label1.backgroundColor = .hexColor(hex: "EDEEF0")
            cell.label2.backgroundColor = .hexColor(hex: "F0F1F2")
        }else{
            cell.label1.backgroundColor = .clear
            cell.label2.backgroundColor = .clear
        }
        let model = listModels[indexPath.row]
        cell.label1.text = "\(model.numOfSelections ?? 0)"
        cell.label2.text = model.bonusText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
