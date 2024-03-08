//
//  SelectBankView.swift
//  NGSprots
//
//  Created by Jean on 26/12/2023.
//

import UIKit

class SelectBankView: UIView ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    var completeSelectBankBlock : ((_ model : BankModel)->Void)?
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationCollection : UILocalizedIndexedCollation!
    
    var dataArr : [[BankModel]] = []
    var sectionTitleArr = [String]()
    
    var selectIndex : IndexPath?
    var modelArr : Array<BankModel>!  {
        didSet{
            self.setUpData()
        }
    }
    
    var isSearch : Bool = false
    var searchArr : Array<BankModel> = []

    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectBankView", owner: self, options: nil)?.first as! UIView
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
        searchTF.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexColor = .hexColor(hex: "101010")
        tableView.sectionIndexBackgroundColor = .white
        tableView.sectionIndexTrackingBackgroundColor = .white
        tableView.register(UINib(nibName: "SelectBankCell", bundle: nil), forCellReuseIdentifier: "SelectBankCell")
        let swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    //滑动手势
    @objc func swipeGesture(swip:UISwipeGestureRecognizer) {
        if swip.direction == .down {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
        }
    }
    func setUpData(){
        
        self.locationCollection = UILocalizedIndexedCollation.current()
        let indexCount = self.locationCollection.sectionTitles.count
        for _ in 0..<indexCount {
            let array = [BankModel]()
            self.dataArr.append(array)
        }
        for model in self.modelArr {
            let sectionNumber = self.locationCollection.section(for: model, collationStringSelector: #selector(getter: BankModel.name))
            self.dataArr[sectionNumber].append(model)
        }

        var tempArray = [Int]()
        for (i , array) in self.dataArr.enumerated() {
            if array.count == 0{
                tempArray.append(i)
            }else{
                self.sectionTitleArr.append(self.locationCollection.sectionTitles[i])
            }
        }
        for i in tempArray.reversed() {
            self.dataArr.remove(at: i)
        }
        
        if self.sectionTitleArr.contains("#"){
            let modelArr : [BankModel] = self.dataArr.last!
            self.dataArr.removeLast()
            self.dataArr.insert(modelArr, at: 0)
            self.sectionTitleArr.removeLast()
            self.sectionTitleArr.insert("#", at: 0)
        }
        self.tableView.reloadData()
    }
    func searchData(){
        if self.isSearch == true{
            self.searchArr.removeAll()
            let charset = CharacterSet(charactersIn: searchTF.text ?? "")
            for model in self.modelArr {
//                if model.name?.uppercased().rangeOfCharacter(from: charset) != nil || model.name?.lowercased().rangeOfCharacter(from: charset) != nil{
//                    self.searchArr.append(model)
//                }
                if model.name?.range(of: searchTF.text ?? "",options: .caseInsensitive) != nil{
                    self.searchArr.append(model)
                }
            }
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != ""{
            self.isSearch = true
        }else{
            self.isSearch = false
        }
        self.searchData()
        self.tableView.reloadData()
    }
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isSearch == true{
            return 1
        }
        return self.sectionTitleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch == true{
            return self.searchArr.count
        }
        return self.dataArr[section].count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.isSearch == true{
            return ["All"]
        }
        return self.sectionTitleArr
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView : UIView = UIView(frame: CGRectMake(0, 0, kScreenW - 40, 34))
        headerView.backgroundColor = .white
        
        let sectionTitleLB : UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: kScreenW - 70, height: 34))
        sectionTitleLB.textColor = .hexColor(hex: "969696")
        sectionTitleLB.font = UIFont(name: "PingFangSC-Semibold",size: 10)
        headerView.addSubview(sectionTitleLB)
        if self.isSearch == true{
           sectionTitleLB.text = "All"
        }else{
           sectionTitleLB.text = self.sectionTitleArr[section]
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SelectBankCell! = tableView.dequeueReusableCell(withIdentifier: "SelectBankCell") as? SelectBankCell
        var model = BankModel()
        if self.isSearch == true{
            model = self.searchArr[indexPath.row]
        }else{
            model = self.dataArr[indexPath.section][indexPath.row]
        }
        cell.nameLB.text = model.name
        cell.imageV.sd_setImage(with: URL(string: model.icon ?? ""),placeholderImage: UIImage(named: "bankCardPlaceholder"))
        cell.selectIV.isHidden = !model.isSelect!
        cell.isSelect = model.isSelect
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearch == false{
            if self.selectIndex != nil{
                if self.selectIndex?.section == indexPath.section && self.selectIndex?.row == indexPath.row{
                    return
                }
            }
            let arr = self.dataArr[indexPath.section]
            arr[indexPath.row].isSelect = true
            if self.selectIndex != nil{
                let otherArr = self.dataArr[self.selectIndex!.section]
                otherArr[self.selectIndex!.row].isSelect = false
            }
            self.selectIndex = indexPath
            if self.completeSelectBankBlock != nil{
                self.completeSelectBankBlock!(arr[indexPath.row])
            }
        }else{
            let select = self.searchArr[indexPath.row]
            for i in 0..<self.dataArr.count{
                let arr : [BankModel] = self.dataArr[i]
                for j in 0..<arr.count{
                    let model = arr[j]
                    if select.id == model.id{
                        self.dataArr[i][j].isSelect = true
                        self.selectIndex = IndexPath(row: j, section: i)
                    }else{
                        self.dataArr[i][j].isSelect = false
                    }
                }
            }
            if self.completeSelectBankBlock != nil{
                self.completeSelectBankBlock!(self.searchArr[indexPath.row])
            }
        }
        self.tableView.reloadData()
        
    }
}
