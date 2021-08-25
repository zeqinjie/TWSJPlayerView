//
//  TWSJPlayerAppDelegate.swift
//  TWSJPlayerView
//
//  Created by zhengzeqin on 2021/8/25.
//

import Foundation

private var kTWObjectAllowOrentitaionRotationKey = "kTWObjectAllowOrentitaionRotationKey"

public extension UIApplicationDelegate  {
    private func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as AnyObject as? T
    }
    
    private func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T, ploicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> T {
        if let object: T = self.associatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key, ploicy: ploicy)
        return object
    }
    
    private func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer, ploicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key, object, ploicy)
    }
    
    /// 是否支持旋转
    var allowOrentitaionRotation: Bool {
        set {
            self.setAssociatedObject(newValue, forKey: &kTWObjectAllowOrentitaionRotationKey, ploicy: .OBJC_ASSOCIATION_ASSIGN)
        } get {
            return self.associatedObject(forKey: &kTWObjectAllowOrentitaionRotationKey, default: false)
        }
    }
    
}
