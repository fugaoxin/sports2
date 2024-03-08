//
//  UIBarButton-extension.swift
//  DYZB
//
//  Created by wen xi on 2022/10/31.
//

import UIKit

extension UIBarButtonItem {
    
    //MARK: - 便利构造函数：1、以convenience开头 2、在构造函数中必须明确调用一个系统的构造函数（self）
    convenience init(imageName: String, highImageName: String = "", size: CGSize = .zero) {
        let btn = UIButton()
        
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        if (highImageName != "") {
            btn.setImage(UIImage.init(named: highImageName), for: .highlighted)
        }
        
        if (size == .zero){
            btn.sizeToFit()
        }else{
            btn.frame = CGRect.init(origin: .zero, size: size)
        }
        btn.backgroundColor = .yellow
        
        self.init(customView: btn)
    }
}
