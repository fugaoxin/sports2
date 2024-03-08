//
//  MB_hud.swift
//  AdongPlayer
//
//  Created by wen xi on 16/12/2019.
//  Copyright © 2019 wen xi. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController{
    
    func showHUD(text: String){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.view.addSubview(hud)
        hud.label.text = text
        hud.show(animated: true)
    }
    
    func showHUDNO(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    func hudHide(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showTextHUD(_ text: String?, dismissAfterDelay: TimeInterval) {
        hideHUD()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.text = text
        hideHUD(dismissAfterDelay)
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func hideHUD(_ afterDelay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterDelay) {
            self.hideHUD()
        }
    }
    
}
extension UIWindow{
    func showHUD(text: String){
        let hud = MBProgressHUD.showAdded(to: Tool.keyWindow(), animated: true)
        Tool.keyWindow().addSubview(hud)
        hud.label.text = text
        hud.show(animated: true)
    }
    
    func showHUDNO(){
        let hud = MBProgressHUD.showAdded(to: Tool.keyWindow(), animated: true)
        Tool.keyWindow().addSubview(hud)
        hud.show(animated: true)
    }
    
    func hudHide(){
        MBProgressHUD.hide(for: Tool.keyWindow(), animated: true)
    }
    
    func showTextHUD(_ text: String?, dismissAfterDelay: TimeInterval) {
        hideHUD()
        let hud = MBProgressHUD.showAdded(to: Tool.keyWindow(), animated: true)
        hud.mode = .text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.text = text
        hideHUD(dismissAfterDelay)
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: Tool.keyWindow(), animated: true)
    }
    
    func hideHUD(_ afterDelay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterDelay) {
            self.hideHUD()
        }
    }
}
