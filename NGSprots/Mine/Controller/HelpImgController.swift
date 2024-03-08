//
//  HelpImgController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/12.
//

import UIKit

class HelpImgController: BaseViewController {

    private var scrollview:UIScrollView!
    private var img:UIImageView!
    var str = ""
    var svcHH:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    private func setUI(){
        title = str
        addNavBar(.white)
        
        scrollview = UIScrollView(frame: CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kScreenH - (kStatusBarH + kNavigationBarH)))
        view.addSubview(scrollview)
        scrollview.backgroundColor = .white
        scrollview.contentSize = CGSize(width: kScreenW, height: svcHH)
        scrollview.showsVerticalScrollIndicator = false
        
        img = UIImageView(frame: CGRect(x: 10, y: 0, width: kScreenW - 20, height: svcHH))
        img.image = UIImage(named: str)
        scrollview.addSubview(img)
        img.contentMode = .scaleAspectFit
    }
}
