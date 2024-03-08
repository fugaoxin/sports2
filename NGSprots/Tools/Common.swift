//
//  Common.swift
//  DYZB
//
//  Created by wen xi on 2022/10/31.
//

import UIKit

var kStatusBarH : CGFloat {
    get{
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
             let scene = UIApplication.shared.connectedScenes.first
             guard let windowScene = scene as? UIWindowScene else { return 0 }
             guard let statusBarManager = windowScene.statusBarManager else { return 0 }
             statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}
let kNavigationBarH : CGFloat = 44
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let ktabBarH : CGFloat = 49
var kbottomSafeH : CGFloat{
    get{
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
}
