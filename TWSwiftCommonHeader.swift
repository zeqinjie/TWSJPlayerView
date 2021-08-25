//
//  TWSwiftCommonHeader.swift
//  house591
//
//  Created by zhengzeqin on 2017/7/21.
//
//

import Foundation
import UIKit


/******** 尺寸信息 ************/

/// 全屏
let TWSwiftScreen = UIScreen.main.bounds
/// 全屏宽度
let TWSwiftScreenWidth = UIScreen.main.bounds.width
/// 全屏高度，不含状态栏高度
let TWSwiftScreenHeight = UIScreen.main.bounds.height

/// tabbar切换视图控制器高度
let TWSwiftTabbarHeight: CGFloat = 49.0
/// 搜索视图高度
let TWSwiftSearchBarHeight: CGFloat = 45.0

/// 状态栏高度
var TWSwiftStatusBarHeight: CGFloat {
    get {
        if TWSwiftIsIhoneX() {
            return 44.0
        } else {
            return 20.0
        }
    }
}

//tabbar高度
var TWSwiftTabBarHeight: CGFloat {
    get {
        if TWSwiftIsIhoneX() {
            return 83.0
        } else {
            return 49.0
        }
    }
}
//适配iOS 11 配置
var IOS11: Bool {
    get {
        if #available(iOS 11.0, *) {
            return true
        } else {
            return false
        }
    }
}
/// 导航栏高度
let TWSwiftNavigationHeigth: CGFloat = 44.0

/// 状态栏 + 导航栏高度
let TWSwiftStatusAndNavigationHeigth = TWSwiftNavigationHeigth + TWSwiftStatusBarHeight

///IPhoneX 头部
var TWSwiftIPhoneXTopHeigth: CGFloat {
    get {
        if TWSwiftIsIhoneX() {
            return 30.0
        } else {
            return 0.0
        }
    }
}

///IPhoneX 底部留白
var TWSwiftIPhoneXBottomHeigth: CGFloat {
    get {
        if TWSwiftIsIhoneX() {
            return 34.0
        } else {
            return 0.0
        }
    }
}

/// 获取当前window(适配windowScene和application)
private func getCurrentWindow() -> UIWindow? {
    if let window = UIApplication.shared.delegate?.window {
        return window
    }
    if #available(iOS 13.0, *) {
        if let windowScene = UIApplication.shared.connectedScenes.first {
            if let mainWindow = windowScene.value(forKey: "delegate.window") as? UIWindow {
                return mainWindow
            }
            return UIApplication.shared.windows.last
        }
    }
    return UIApplication.shared.keyWindow
}

public func TWSwiftIsIhoneX() -> Bool {
    var bottomSafeInset: CGFloat = 0
    if #available(iOS 11.0, *) {
        bottomSafeInset = getCurrentWindow()?.safeAreaInsets.bottom ?? 0
    }
    return bottomSafeInset > 0
}
