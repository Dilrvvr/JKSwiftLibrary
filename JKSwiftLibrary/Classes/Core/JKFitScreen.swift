//
//  JKFitScreen.swift
//  JKSwiftLibrary
//
//  Created by albert on 2022/11/7.
//  屏幕适配工具

import UIKit

// MARK: 
// MARK: - 按屏幕缩放

///*
/// 大屏幕时需要放大时使用该scale
public let JKFitZoomLargeScale: CGFloat = {
    
    var screenWidth = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    
    screenWidth = min(screenWidth, JKiPhoneScreenMaxWidth)
    
    let scale = screenWidth / 375.0
    
    return scale
}()

public func JKFitFloat(_ value: CGFloat) -> CGFloat {
    
    // 改为按屏幕缩放
    value * JKFitZoomLargeScale
}

public func JKFitFontNormal(_ value: CGFloat) -> UIFont {
    
    UIFont.systemFont(ofSize: JKFitFloat(value))
}

public func JKFitFontMedium(_ value: CGFloat) -> UIFont {
    
    UIFont.systemFont(ofSize: JKFitFloat(value), weight: .medium)
}

public func JKFitFontSemiBold(_ value: CGFloat) -> UIFont {
    
    UIFont.systemFont(ofSize: JKFitFloat(value), weight: .semibold)
}

public func JKFitFontBold(_ value: CGFloat) -> UIFont {
    
    UIFont.boldSystemFont(ofSize: JKFitFloat(value))
}
// */

// MARK:
// MARK: - 小屏幕缩放，大屏幕不放大

/*
/// 小屏幕缩放，大屏幕不放大时使用该scale
public let JKFitZoomScale: CGFloat = min(JKFitZoomLargeScale, 1.0)

public func JKFitFloat(_ value: CGFloat) -> CGFloat {
    
    value * JKFitZoomLargeScale
}

public func JKFitFontNormal(_ value: CGFloat) -> UIFont {
    
    JKFitFontNormal(value)
}

public func JKFitFontMedium(_ value: CGFloat) -> UIFont {
    
    JKFitFontMedium(value)
}

public func JKFitFontSemiBold(_ value: CGFloat) -> UIFont {
    
    UIFont.systemFont(ofSize: JKFitFloat(value), weight: .semibold)
}

public func JKFitFontBold(_ value: CGFloat) -> UIFont {
    
    JKFitFontBold(value)
}
// */
