//
//  SportTypeScreeningController.swift
//  NGSprots
//
//  Created by Jean on 2/12/2023.
//

import UIKit

class SportTypeScreeningController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate {
    lazy var navTitleLB : UILabel? = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
        label.backgroundColor = .white
        label.textColor = .hexColor(hex: "101010")
        label.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        label.textAlignment = .center
        label.text = "Navigation"
        return label
    }()
    lazy var navSelectNumLB : UILabel? = {
        let label = UILabel(frame: CGRect(x: 0, y: 25, width: 90, height: 15))
        label.backgroundColor = .white
        label.textColor = .hexColor(hex: "B8B8B8")
        label.font = UIFont(name: "PingFangSC-Medium", size: 9)
        label.textAlignment = .center
        label.text = "Selected:20/20"
        return label
    }()
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCount = 20
    
    var sportsModel : SportsModel?
    
    var saveSuccessBlock : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBar(.white)
        
        setNavTitle()
        setUpUI()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.sportsModel != nil && self.sportsModel?.all?.count != 0{
            requestSaveSport()
        }
    }
    func setNavTitle(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
        view.backgroundColor = .white
        view.addSubview(self.navTitleLB!)
        view.addSubview(self.navSelectNumLB!)
        self.navigationItem.titleView = view
    }
    func setUpUI(){
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SportTypeScreeningCell", bundle: nil), forCellReuseIdentifier: "SportTypeScreeningCell")
    
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        
        requestSelectSport()
    }
    //MARK: -获取所有sport
    func requestAllSport(select:SportsModel){
        var param = BaseSystemParam()
        param.navType = 1
        let api = wxApi.getAllSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("------\(data)")
            self.hudHide()
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                let model : SportsModel = (result?.data)!
                for i in 0...model.all!.count-1{
                    let item : SportsItemModel = model.all![i]
                    item.select = false
                }
                self.sportsModel = model
                self.setSelectModel(select: select)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func setSelectModel(select:SportsModel){
        var selectArr : [SportsItemModel] = []
        let totalArr : NSMutableArray = NSMutableArray(array: self.sportsModel?.all ?? [])
        for item in (self.sportsModel?.all)!{
            for select in (select.list)!{
                if select.id == item.id{
                    selectArr.append(item)
                }
            }
        }
    
        totalArr.removeObjects(in: selectArr)
        self.sportsModel?.all = (select.list ?? []) + (totalArr as! [SportsItemModel])
        self.tableView.reloadData()
    }
    //MARK: -获取选中sport
    func requestSelectSport(){
        self.showHUD(text: "Loading...")
        let api =  wxApi.getLoginSports
        AdHttpRequest(url: api, successCallBack: { data in
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                let model : SportsModel = (result?.data)!
                for i in 0...model.list!.count-1{
                    let item : SportsItemModel = model.list![i]
                    item.select = true
                }
                self.selectedCount = model.list?.count ?? 0
                self.navSelectNumLB?.text = "Selected:\(self.selectedCount)/20"
                //model 为选中的sports
                self.requestAllSport(select: model)
            }else{
                self.hudHide()
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    //MARK: -保存选中sport
    func requestSaveSport(){
        var param = BaseSystemParam()
        param.navClassIds = []
        for i in 0...(self.sportsModel?.all!.count)!-1{
            let item : SportsItemModel = self.sportsModel?.all![i] ?? SportsItemModel()
            if item.select == true{
                param.navClassIds?.append(item.id ?? 0)
            }
        }
        let api = wxApi.editShowSports(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            let result = RequestCallBackViewModel<SportsModel>.deserialize(from: data)
            if(result?.code == 0){
                if self.saveSuccessBlock != nil{
                    self.saveSuccessBlock!()
                }
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
           
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.sportsModel?.all![indexPath.row]
       
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = self.sportsModel?.all!.remove(at: sourceIndexPath.row)
        self.sportsModel?.all!.insert(mover!, at: destinationIndexPath.row)
    }
   
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.sportsModel?.all!.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SportTypeScreeningCell = tableView.dequeueReusableCell(withIdentifier: "SportTypeScreeningCell") as! SportTypeScreeningCell
        let item : SportsItemModel = self.sportsModel?.all![indexPath.row] ?? SportsItemModel()
        cell.sportNameLB.text = item.name
        if item.games?.count ?? 0 > 0{
            cell.sportIV.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: getTopSportsImg(Id: item.games?[0].sportId ?? 0)))
        }
        cell.selectSport = item.select ?? false
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item : SportsItemModel = self.sportsModel?.all![indexPath.row] ?? SportsItemModel()
        if item.select == false && selectedCount == 20{
            self.showTextSB("Maximum number of choices : 20", dismissAfterDelay: 1.5)
            return
        }
        if item.select == true && selectedCount == 1{
            self.showTextSB("Minimum number of choices : 1", dismissAfterDelay: 1.5)
            return
        }
        if item.select == false{
            selectedCount = selectedCount + 1
        }else{
            selectedCount = selectedCount - 1
        }
        navSelectNumLB?.text = "Selected:\(selectedCount)/20"
        item.select = !(item.select ?? false)
        tableView.reloadData()
       
    }
    
}

