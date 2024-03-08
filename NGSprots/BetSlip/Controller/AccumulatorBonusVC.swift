//
//  AccumulatorBonusVC.swift
//  NGSprots
//
//  Created by Jack Lin on 2024/2/29.
//

import UIKit

class AccumulatorBonusVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        title = "Accumulator Bonus"
        addNavBar(.white)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "AccumulatorBonusCell", bundle: nil), forCellReuseIdentifier: "AccumulatorBonusCell")
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 2920
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AccumulatorBonusCell = tableView.dequeueReusableCell(withIdentifier: "AccumulatorBonusCell") as! AccumulatorBonusCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func goBet(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
