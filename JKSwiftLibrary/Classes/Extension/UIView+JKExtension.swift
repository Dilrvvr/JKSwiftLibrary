//
//  UIView+JKExtension.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import UIKit

// MARK:
// MARK: - Property

public extension JKExtensionWrapper where Base: UIView {
    
    var snapshot: UIImage? { screenshot }
    
    var screenshot: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.base.bounds.size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return nil
        }
        
        self.base.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

// MARK:
// MARK: - Static Function

//public extension JKExtensionWrapper where Base: UIView {

//}

// MARK:
// MARK: - Normal Function

public extension JKExtensionWrapper where Base: UIView {
    
    /// 转场动画
    func transitionCrossDissolve(with duration: TimeInterval = 0.25,
                                 animations: @escaping (() -> Void),
                                 completion: ((Bool) -> Void)? = nil) {
        
        UIView.transition(with: self.base, duration: duration, options: .transitionCrossDissolve, animations: animations, completion: completion)
    }
    
    // MARK:
    // MARK: - indicator
    
    func relayoutIndicatorViewToCenter() {
        
        self.base.jk_indicatorView.center = CGPoint(x: self.base.bounds.width * 0.5, y: self.base.bounds.height * 0.5)
    }
    
    func startIndicatorLoading() {
        
        self.base.bringSubviewToFront(self.base.jk_indicatorView)
        
        self.base.jk_indicatorView.startAnimating()
    }
    
    func stopIndicatorLoading() {
        
        self.base.jk_indicatorView.stopAnimating()
    }
}

// MARK:
// MARK: - extension UIView

public extension UIView {
    
    private static var JKExtensionUIViewIndicatorKey = "JKExtensionUIViewIndicatorKey"
    
    /// indicatorView
    var jk_indicatorView: UIActivityIndicatorView {
        
        get {
            
            var indicatorView: UIActivityIndicatorView
            
            if let associatedIndicatorView = objc_getAssociatedObject(self, &Self.JKExtensionUIViewIndicatorKey) as? UIActivityIndicatorView {
                
                indicatorView = associatedIndicatorView
                
            } else {
                
                if #available(iOS 13.0, *) {
                    indicatorView = UIActivityIndicatorView(style: .medium)
                } else {
                    indicatorView = UIActivityIndicatorView(style: .gray)
                }
                
                objc_setAssociatedObject(self, &Self.JKExtensionUIViewIndicatorKey, indicatorView, .OBJC_ASSOCIATION_RETAIN)
            }
            
            if let _ = indicatorView.superview { return indicatorView }
            
            addSubview(indicatorView)
            
            indicatorView.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
            
            return indicatorView
        }
        
        set {
            
            // 暂不允许自定义
            
            //objc_setAssociatedObject(self, &Self.JKExtensionUIViewIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

