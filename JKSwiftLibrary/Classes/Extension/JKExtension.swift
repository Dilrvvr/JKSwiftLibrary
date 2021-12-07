//
//  JKExtension.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import UIKit

public struct JKExtensionWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        
        self.base = base
    }
}

public protocol JKExtensionCompatible: Any {}

public extension JKExtensionCompatible {
    
    static var jk: JKExtensionWrapper<Self>.Type {
        
        get { JKExtensionWrapper<Self>.self }
        
        set {}
    }
    
    var jk: JKExtensionWrapper<Self> {
        
        get { return JKExtensionWrapper(self) }
        
        set {}
    }
}



extension Date: JKExtensionCompatible {}

extension UIDevice: JKExtensionCompatible {}

extension UIView: JKExtensionCompatible {}

//extension UIColor: JKExtensionCompatible {}

//extension UIImage: JKExtensionCompatible {}

//extension String: JKExtensionCompatible {}

//extension UIGestureRecognizer: JKExtensionCompatible {}
