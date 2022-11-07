//
//  JKFitScreen.swift
//  JKSwiftLibrary
//
//  Created by albert on 2022/11/7.
//  屏幕适配工具

import UIKit

/// 当前iPhone最大屏幕宽度
public let JKiPhoneMaxScreenWidth: CGFloat = 428.0

/// 大屏幕时需要放大时使用该scale
public let JKFitZoomLargeScale: CGFloat = {
    
    var screenWidth = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    
    screenWidth = min(screenWidth, JKiPhoneMaxScreenWidth)
    
    let scale = screenWidth / 375.0
    
    return scale
}()

/// 小屏幕缩放，大屏幕不放大
//public let JKFitZoomScale: CGFloat = min(JKFitZoomLargeScale, 1.0)

public func JKFitFloat(_ value: CGFloat) -> CGFloat {
    
    // 改为按屏幕缩放
    return value * JKFitZoomLargeScale//(zoomLarge ? JKFitZoomLargeScale : JKFitZoomScale)
}

public func JKFitFontNormal(_ value: CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: JKFitFloat(value))
}

public func JKFitFontMedium(_ value: CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: JKFitFloat(value), weight: .medium)
}

public func JKFitFontBold(_ value: CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: JKFitFloat(value))
}

// MARK:
// MARK: - 大屏幕放大

/*
public func JKFitFloatZoomLarge(_ value: CGFloat) -> CGFloat {
    
    return JKFitFloat(value, true)
}

public func JKFitFontNormalZoomLarge(_ value: CGFloat) -> UIFont {
    
    return JKFitFontNormal(value, true)
}

public func JKFitFontMediumZoomLarge(_ value: CGFloat) -> UIFont {
    
    return JKFitFontMedium(value, true)
}

public func JKFitFontBoldZoomLarge(_ value: CGFloat) -> UIFont {
    
    return JKFitFontBold(value, true)
}
// */
