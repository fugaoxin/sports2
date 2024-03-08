//
//  SelectRegionViewNew.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/22.
//

import UIKit

class SelectRegionViewNew: UIView {

    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectRegionViewNew", owner: self, options: nil)?.first as! UIView
    }()
    
    var selectState = ""
    var selectCity = ""
    var confirmSelectCityBlock : ((_ state:String , _ city : String)->Void)?
    
    var model : StatesModel?{
        didSet{
            if model?.states?.count != 0 && self.selectState == ""{
                self.selectState = model?.states?.first ?? ""
            }
            if model?.regions?.count != 0 && self.selectCity == ""{
                self.selectCity = model?.regions?.first ?? ""
            }
            pickerView.reloadAllComponents()
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
        
        self.pickerView.setValue(UIColor.black, forKeyPath: "textColor")
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func close(_ sender: UIButton) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func clickDone(_ sender: UIButton) {
        if self.model?.states?.count == 0 || self.model == nil || self.model?.regions?.count == 0{
            return
        }
        if self.selectCity == "" || self.selectState == ""{
            return
        }
        Tool.keyWindow().hiddenInWindow()
        if self.confirmSelectCityBlock != nil{
            self.confirmSelectCityBlock!( selectState,selectCity)
        }
    }
    
    func requestGetCity(){
        Tool.keyWindow().showHUD(text: "Loading...")
        var param = UserInfoParam()
        param.state = self.selectState
        let api = wxApi.getUserRegionCity(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            Tool.keyWindow().hudHide()
            let result = RequestCallBackViewModel<StatesModel>.deserialize(from: data)
            if(result?.code == 0){
                self.model?.regions = result?.data?.regions ?? []
                self.selectCity = self.model?.regions?.first ?? ""
                self.pickerView.reloadComponent(1)
            }else{
                Tool.keyWindow().showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            Tool.keyWindow().hudHide()
            Tool.keyWindow().showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    

}

extension SelectRegionViewNew: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return model?.states?.count ?? 0
        }
        return model?.regions?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return model?.states?[row]
        }
        return model?.regions?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            selectState = model?.states?[row] ?? ""
            requestGetCity()
        }else{
            selectCity = model?.regions?[row] ?? ""
        }
    }
    
}
