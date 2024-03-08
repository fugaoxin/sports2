//
//  SelectTimeView.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/9.
//

import UIKit

protocol SelectTimeViewDelegate{
    func XBtn()
    func okAndbok(index: Int, dayTag: Int, startTime: String, endTime: String)
}

class SelectTimeView: UIView {
    
    var delegate: SelectTimeViewDelegate?
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var today: UIButton!
    @IBOutlet weak var yestoday: UIButton!
    @IBOutlet weak var severday: UIButton!
    @IBOutlet weak var zidytime: UIButton!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var dateBgView: UIView!
    @IBOutlet weak var riliBgView: UIView!
    @IBOutlet weak var rilidate: UILabel!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    private var dateType = false
    private var dayTag = 100
    private var oldDayTag = 100
    private var startDate = "2023-10-16"
    private var endDate = "2023-11-15"
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("SelectTimeView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        endDay.layer.borderColor = UIColor.hexColor(hex: "EDEDED").cgColor
        today.backgroundColor = .hexColor(hex: "0CD664")
        dateBgView.isHidden = true
        
        startTime.isUserInteractionEnabled = true
        endTime.isUserInteractionEnabled = true
        let starttap = UITapGestureRecognizer(target: self, action: #selector(clickStart))
        let endtap = UITapGestureRecognizer(target: self, action: #selector(clickEnd))
        startTime.addGestureRecognizer(starttap)
        endTime.addGestureRecognizer(endtap)

        selectDay(tag: 100)
        
        riliView()
    }

    @objc func clickStart(){
        print("开始时间")
        if dateType{
            dateBgView.isHidden = false
        }
    }
    
    @objc func clickEnd(){
        print("结束时间")
        if dateType{
            dateBgView.isHidden = false
        }
    }
    
    func setdaybg(tag: Int){
        oldDayTag = dayTag
        dayTag = tag
        switch tag {
        case 100://今日
            today.backgroundColor = .hexColor(hex: "0CD664")
            yestoday.backgroundColor = .hexColor(hex: "F7F7F7")
            severday.backgroundColor = .hexColor(hex: "F7F7F7")
            zidytime.backgroundColor = .hexColor(hex: "F7F7F7")
            today.setTitleColor(.white, for: .normal)
            yestoday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            severday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            zidytime.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            dateBgView.isHidden = true
            dateType = false
            selectDay(tag: 100)
            break
        case 101:
            today.backgroundColor = .hexColor(hex: "F7F7F7")
            yestoday.backgroundColor = .hexColor(hex: "0CD664")
            severday.backgroundColor = .hexColor(hex: "F7F7F7")
            zidytime.backgroundColor = .hexColor(hex: "F7F7F7")
            today.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            yestoday.setTitleColor(.white, for: .normal)
            severday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            zidytime.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            dateBgView.isHidden = true
            dateType = false
            selectDay(tag: 101)
            break
        case 102:
            today.backgroundColor = .hexColor(hex: "F7F7F7")
            yestoday.backgroundColor = .hexColor(hex: "F7F7F7")
            severday.backgroundColor = .hexColor(hex: "0CD664")
            zidytime.backgroundColor = .hexColor(hex: "F7F7F7")
            today.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            yestoday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            severday.setTitleColor(.white, for: .normal)
            zidytime.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            dateBgView.isHidden = true
            dateType = false
            selectDay(tag: 102)
            break
        default:
            today.backgroundColor = .hexColor(hex: "F7F7F7")
            yestoday.backgroundColor = .hexColor(hex: "F7F7F7")
            severday.backgroundColor = .hexColor(hex: "F7F7F7")
            zidytime.backgroundColor = .hexColor(hex: "0CD664")
            today.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            yestoday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            severday.setTitleColor(.hexColor(hex: "101010"), for: .normal)
            zidytime.setTitleColor(.white, for: .normal)
            dateBgView.isHidden = false
            dateType = true
            break
        }
    }
    
    private func selectDay(tag: Int){
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MMM dd"
        let calendar = Calendar.current
        switch(tag){
        case 100:
            startTime.text = dformatter.string(from: now)
            endTime.text = dformatter.string(from: now)
            startDate = dformatter.string(from: now)
            endDate = dformatter.string(from: now)
            endDay.text = zdyTime(date: startDate, date2: endDate)
            break
        case 101:
            let lastday = calendar.date(byAdding: .day, value: -1, to: now)
            startTime.text = dformatter.string(from: lastday ?? now)
            endTime.text = dformatter.string(from: lastday ?? now)
            startDate =  dformatter.string(from: lastday ?? now)
            endDate =  dformatter.string(from: lastday ?? now)
            endDay.text = zdyTime(date: startDate, date2: endDate)
            break
        case 102:
            let lastday = calendar.date(byAdding: .day, value: -6, to: now)
            startTime.text = dformatter.string(from: lastday ?? now)
            endTime.text = dformatter.string(from: now)
            startDate =  dformatter.string(from: lastday ?? now)
            endDate =  dformatter.string(from: now)
            endDay.text = zdyTime(date: startDate, date2: endDate)
            break
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func XBtn(_ sender: UIButton) {
        delegate?.XBtn()
    }
    
    @IBAction func selectDay(_ sender: UIButton) {
        setdaybg(tag: sender.tag)
    }
    
    @IBAction func okAndbok(_ sender: UIButton) {
        if sender.tag == 50{
            dayTag = oldDayTag
        }
        delegate?.okAndbok(index: sender.tag, dayTag: dayTag, startTime: startDate, endTime: endDate)
    }
    
    @IBAction func dateOkAndbok(_ sender: UIButton) {
        if sender.tag == 52{
            //取消
        }else{
            if selectArray.count > 0{
                if selectArray.count == 1{
                    startDate = selectArray[0] as! String
                    endDate = selectArray[0] as! String
                }else{
                    startDate = selectArray[0] as! String
                    endDate = selectArray[1] as! String
                }
                
                let daysStr = zdyTime(date: chuangTime(dateStr: startDate), date2: chuangTime(dateStr: endDate))
                var day = 0
                if daysStr.contains("s"){
                    day = Int(daysStr.prefix(daysStr.count - 4)) ?? 0
                }else{
                    day = Int(daysStr.prefix(daysStr.count - 3)) ?? 0
                }
                if day > 30{
                    tipsLabel.textColor = .hexColor(hex: "F01717")
                    return
                }else{
                    tipsLabel.textColor = .hexColor(hex: "929AA5")
                }
                
                startTime.text = chuangTime(dateStr: startDate)
                endTime.text = chuangTime(dateStr: endDate)
                endDay.text = daysStr
            }
            
        }
        dateBgView.isHidden = true
    }
    
    private func chuangTime(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateStr) ?? Date()
        let components = DateFormatter()
        components.dateFormat = "MMM dd"
        return components.string(from: date as Date)
    }
    
    private func zdyTime(date: String, date2: String) -> String{
        if date == date2{
            return "1day"
        }
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MMM dd"
        let aa = dformatter.date(from: date) ?? Date()
        let timeInterval:TimeInterval = aa.timeIntervalSince1970
        let aa2 = dformatter.date(from: date2) ?? Date()
        let timeInterval2:TimeInterval = aa2.timeIntervalSince1970
        let dateInt = (Int(timeInterval2) - Int(timeInterval)) / 86400 + 1
        return "\(dateInt)" + "days"
    }
    
    @IBAction func clickLeftBtn(_ sender: UIButton) {
        currentMonth! -= 1
        if currentMonth! < 1{
            currentMonth = 12
            currentYear! -= 1
        }
        getCurrentMonth(year: currentYear!, month: currentMonth!)
    }
    
    @IBAction func clickRightBtn(_ sender: UIButton) {
        currentMonth! += 1
        if currentMonth! > 12 {
            currentMonth = 1
            currentYear! += 1
        }
        getCurrentMonth(year: currentYear!, month: currentMonth!)
    }
    
    private var currentYear:Int?
    private var currentMonth:Int?
    private var currentDay:Int?
    private let btnW = (kScreenW - 30 - 90) / 7.0
    private let btnH = 50.0
    private let unitFlags = Set<Calendar.Component>([.year,.month,.day,.hour,.minute,.second,.weekdayOrdinal])
    private func riliView(){
        let calendar = Calendar.autoupdatingCurrent.dateComponents(unitFlags, from: Date())
        currentYear = calendar.year
        currentMonth = calendar.month
        initRiliUI()
        getCurrentMonth(year: currentYear!, month: currentMonth!)
    }
    
    private func getCurrentMonth(year:Int,month:Int){
        let dateStr = String(format: "%d-%02d", year,month)
        let currentDate = wxgetDate(dateString: dateStr, format: "yyyy-MM")
        rilidate.text = wxgetDateString(date: currentDate!, format: "MMM yyyy")
        for view in self.calendarView.subviews {
            view.removeFromSuperview()
        }
        getTotalDay()
    }
    
    private func getTotalDay(){
        let days = wxgetDaysInYear(year: currentYear!, month: currentMonth!)
        self.initDateBtn(days)
    }
    
    private func wxgetDaysInYear(year:NSInteger,month:NSInteger) -> Int{
        let date = wxgetDate(dateString: "\(year)-\(month)", format: "yyyy-MM")
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date!)
        return range?.count ?? 0
    }
    
    private func getStartIndex() -> Int{
        let dateStr = String(format: "%d-%02d-01", currentYear!,currentMonth!)
        let date = wxgetDate(dateString: dateStr, format: "yyyy-MM-dd")
        return getDateWeekday(date: date!)
    }
    
    private func getDateWeekday(date:Date) ->Int{
        let timeInterval:TimeInterval = date.timeIntervalSince1970
        let days = Int(timeInterval/86400)
        let weekday = ((days + 4)%7+7)%7
        return weekday
    }
    
    lazy var calendarView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 35 + CGFloat(btnH), width: kScreenW, height: CGFloat(btnH * 6)))//5
        view.backgroundColor = .white
        return view
    }()
    
    lazy var weekendView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 35, width: kScreenW, height: CGFloat(btnH)))
        view.backgroundColor = .white
        return view
    }()
    
    lazy var selectArray:NSMutableArray = {
        let array = NSMutableArray()
        return array
    }()
    
    private func initRiliUI(){
        riliBgView.addSubview(weekendView)
        riliBgView.addSubview(calendarView)
        
        let weekdaysTitleArr = ["S","M","T","W","T","F","S"]
        for i in 0 ... 6{
            let lbl = UILabel.init(frame: CGRect(x: 15 + CGFloat(i) * btnW + CGFloat(i * 15), y: 0, width: btnW, height: CGFloat(btnH)))
            lbl.textAlignment = .center
            lbl.font = .boldSystemFont(ofSize: 12)
            self.weekendView.addSubview(lbl)
            lbl.text = weekdaysTitleArr[i]
            if i == 0 || i == 6{
                lbl.textColor = .hexColor(hex: "969696")
            }else{
                lbl.textColor = .hexColor(hex: "0D0D0D")
            }
        }
    }
    
    private func initDateBtn(_ day:Int){
        let startIndex = self.getStartIndex()
        self.setNeedsUpdateConstraints()
        for i in 0 ..< day {
            let row = (i + startIndex + 1) > 7 ? ((i + startIndex) / 7) : 0
            let column = (i + startIndex + 1) > 7 ? ((i + startIndex) - row * 7) : i
            let button = UIButton.init(frame: CGRect(x:15 + CGFloat(column) * btnW + (row > 0 ? 0 : CGFloat(startIndex) * (btnW + 15)) + CGFloat(column * 15), y: CGFloat(row) * CGFloat(btnH), width: btnW, height: CGFloat(btnH)))
            button.setTitle(String(format: "%d", i + 1), for: .normal)
            if ((column == 0 || column == 6) && row > 0) || (row == 0 && i == (6 - startIndex)){
                button.setTitleColor(.hexColor(hex: "969696"), for: .normal)
            }else{
                button.setTitleColor(.hexColor(hex: "0D0D0D"), for: .normal)
            }
            button.tag = i + 1
            
            let dateStr = String(format: "%d-%02d-%02d", currentYear!,currentMonth!,i + 1)
            if dateStr == wxgetDateString(date: Date(), format: "yyyy-MM-dd"){
                button.backgroundColor = .hexColor(hex: "CBFFE6")
            }
            self.getSelectDate(dateStr, button)
            button.addTarget(self, action: #selector(selectDate(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 10
            self.calendarView.addSubview(button)
        }
    }
    
    private func wxgetDateString(date:Date,format:String) -> String{
        let components = DateFormatter()
        components.dateFormat = format
        return components.string(from: date as Date)
    }
    
    private func wxgetDate(dateString:String,format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateString)
        let zone = NSTimeZone.system
        return date?.addingTimeInterval(TimeInterval(zone.secondsFromGMT(for: date!)))
    }
    
    private func getSelectDate(_ dateStr:String,_ button:UIButton){
        var index = 0
        for i in self.selectArray {
            if i as! String == dateStr {
                button.backgroundColor = .hexColor(hex: "0CD664")
                button.setTitleColor(.white, for: .normal)
                button.isSelected = true
//                if selectArray.count > 1{
//                    if index == 0{
//                        let lab = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: btnW, height: 15))
//                        lab.text = "起始"
//                        //lab.backgroundColor = .green
//                        lab.font = .systemFont(ofSize: 8)
//                        lab.textAlignment = .center
//                        button.addSubview(lab)
//                    }
//                    
//                    if index == 1{
//                        let lab = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: btnW, height: 15))
//                        lab.text = "终止"
//                        //lab.backgroundColor = .green
//                        lab.font = .systemFont(ofSize: 7)
//                        lab.textAlignment = .center
//                        button.addSubview(lab)
//                    }
//                }
            }
            index += 1
        }
    }
    
    @objc func selectDate(_ sender:Any){
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        let dateStr = String(format: "%d-%02d-%02d", currentYear!,currentMonth!,btn.tag)
        if btn.isSelected == true{
            if self.selectArray.contains(dateStr) == false{
                if selectArray.count < 2{
                    self.selectArray.add(dateStr)
                }
            }
            btn.backgroundColor = .hexColor(hex: "0CD664")
        }else if btn.isSelected == false{
            btn.backgroundColor = UIColor.clear
            if self.selectArray.contains(dateStr) {
                self.selectArray.remove(dateStr)
            }
        }
        
        if selectArray.count > 1{
            if selectArray[0] as! String != dateStr && selectArray[1] as! String != dateStr{
                bijiao(str: dateStr)
            }
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd"
            let a1 = dformatter.date(from: selectArray[0] as! String)
            let a2 = dformatter.date(from: selectArray[1] as! String) ?? Date()
            if a1?.compare(a2) == ComparisonResult.orderedDescending{
                let c1 = selectArray[0]
                selectArray[0] = selectArray[1]
                selectArray[1] = c1
            }
        }
        
        for view in self.calendarView.subviews {
            view.removeFromSuperview()
        }
        getTotalDay()
        
    }
    
    private func bijiao(str: String){
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let strr = dformatter.date(from: str)
        let str2 = dformatter.date(from: selectArray[1] as! String) ?? Date()
        if strr?.compare(str2) == ComparisonResult.orderedDescending{
            selectArray[1] = str
        }else{
            selectArray[0] = str
        }
    }

}

