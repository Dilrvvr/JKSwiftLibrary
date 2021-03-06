//
//  UIDevice+JKExtension.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import Foundation

// MARK:
// MARK: - Static Property

public extension JKExtensionWrapper where Base: UIDevice {
    
    /// 是否iPhone设备
    static var isDeviceiPhone: Bool { JKisDeviceiPhone }
    
    /// 是否iPad设备
    static var isDeviceiPad: Bool { JKisDeviceiPad }
    
    /// 是否iPhone X设备
    static var isDeviceX: Bool { JKisDeviceX }
    
    /// 设备型号名称 e.g. @"iPhone 12", @"iPhone 12 Pro Max"
    static var deviceModelName: String  {
        
        JKDeviceUtility.deviceModelName
    }
    
    /// 设备硬件标识 e.g. @"iPhone13,2", @"iPhone13,3"
    static var deviceIdentifier: String  {
        
        JKDeviceUtility.deviceIdentifier
    }
    
    /// [设备硬件标识 : 型号名称] 对应字典
    static var deviceIdentifierDictionary: [String : String] {
        
        JKDeviceUtility.deviceIdentifierDictionary
    }
}

// MARK:
// MARK: - Static Function

public extension JKExtensionWrapper where Base: UIDevice {
    
    /// [设备硬件标识 : 型号名称] 字典保存
    static func saveDeviceIdentifierDictionaryTo(path: String?) -> Bool {
        
        JKDeviceUtility.saveDeviceIdentifierDictionaryTo(path: path)
    }
}

// MARK:
// MARK: - Normal Function

//public extension JKExtensionWrapper where Base: UIDevice {

//}
