//
//  MessageDetailController.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class MessageDetailController: BaseViewController {
     
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var timeLB: UILabel!
    
    @IBOutlet weak var detailTV: UITextView!
    
    var model : MessageItemModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Information Details"
        self.addNavBar(.white)
        detailTV.backgroundColor = .white
        
        self.titleLB.text = model?.title
        let time = Tool.getTimeWithTimestamp(timestampStr: String(model?.createTime ?? 0), dateFormatStr: "yyyy-MM-dd HH:mm:ss")
        self.timeLB.text = time
        
        self.detailTV.text = model?.body
    }


}
