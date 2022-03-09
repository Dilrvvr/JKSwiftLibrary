//
//  UIImage+JKExtension.swift
//  JKSwiftLibrary
//
//  Created by albert on 2022/3/9.
//

import Foundation

// MARK:
// MARK: - Property

public extension JKExtensionWrapper where Base: UIImage {
    
    /// 是否有透明通道
    var isAlphaChannelImage: Bool {
        
        guard let cgImage = self.base.cgImage else { return false }
        
        let alphaInfo = cgImage.alphaInfo
        
        var isAlpha = false
        
        switch alphaInfo {
        case .premultipliedLast, .premultipliedFirst, .last, .first:
            isAlpha = true
        default:
            break
        }
        
        return isAlpha
    }
}

// MARK:
// MARK: - Static Function

//public extension JKExtensionWrapper where Base: UIImage {

//}
