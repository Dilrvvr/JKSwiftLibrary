//
//  JKProtocol.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/9/17.
//  协议

import UIKit

// MARK:
// MARK: - X设备类型协议

/// X设备类型协议
public protocol JKDeviceTypeProtocol {
    
    /// X设备的屏幕尺寸
    var screenSize: CGSize { get }
    
    /// 是否X设备
    var isDeviceX: Bool { get }
}
