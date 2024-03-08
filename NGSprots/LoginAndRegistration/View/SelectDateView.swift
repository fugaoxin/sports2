//
//  SelectDateView.swift
//  SportsDemo
//
//  Created by Jean on 3/11/2023.
//

import UIKit
protocol SelectDateDelegate{
    func dateSureClick(day:String,month:String,year:String)
}
class SelectDateView: UIView {
    
    var dateDelegate : SelectDateDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var titleLB: UILabel!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectDateView", owner: self, options: nil)?.first as! UIView
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
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        self.datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        self.datePicker.setValue(false, forKeyPath: "highlightsToday")
        self.datePicker.maximumDate = Date()
        self.datePicker.setDate(Date(), animated: true)
    }
    @IBAction func closeClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
    }
    @IBAction func sureClick(_ sender: Any) {
        let date = datePicker.date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd-MMMM-yyyy"
        let datestr = dformatter.string(from: date)
        let message =  "您选择的日期和时间是：\(datestr)"
        print(message)
        let result = datestr.components(separatedBy: "-")
        if result.count == 3 {
            dateDelegate?.dateSureClick(day: result[0], month: result[1], year: result[2])
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
            print("分割结果：\(result)")
        } else {
            print("未能成功分割")
        }
    }
}
