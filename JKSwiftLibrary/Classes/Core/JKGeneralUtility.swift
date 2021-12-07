//
//  JKGeneralUtility.swift
//  JKSwiftLibrary
//
//  Created by AlbertCC on 2021/12/7.
//

import UIKit

open class JKGeneralUtility: NSObject {
    
    /// keyWindow 由使用方赋值 有值时JKKeyWindow将使用该值
    public static var keyWindow: UIWindow?
    
    /// 注册keyWindow 如不注册 JKKeyWindow将自动查找
    public static func registerKeyWindow(_ window: UIWindow) {
        
        keyWindow = window
    }
    
    /// 读取资源图片失败的回调
    public static var resourceImageFailedHandler: ((_ imageName: String) -> UIImage?)?
    
    /**
     * 读取资源中的图片
     * name: 无须添加@2x.png/@3x.png，类似UIImage(named: name)即可
     * pathExtension: 默认 "png"，如其它格式则传对应格式后缀名，不包括小数点
     * 读取失败使用resourceImageFailedHandler处理
     */
    public static func resourceImageNamed(_ name: String?,
                                          pathExtension: String = "png") -> UIImage? {
        
        // 名称为空，直接返回nil
        guard let realName = name else { return nil }
        
        let resourceBundle: Bundle = Bundle(for: Self.self)
        
        guard let bundlePath = resourceBundle.path(forResource: "JKSwiftLibraryResource", ofType: "bundle"),
              let imageBundle = Bundle(path: bundlePath) else {
                  
                  // 读取bundle失败
                  return solveResourceImageReadFailed(imageName: realName)
              }
        
        // 直接根据名称读取图片
        if let namedImage = UIImage(named: realName, in: imageBundle, compatibleWith: nil) {
            
            return namedImage
        }
        
        // 拼接图片全名
        let scale = Int(UIScreen.main.scale)
        let fullName = realName + "@\(scale)x" + "." + pathExtension
        
        // 根据图片全名读取图片
        if let namedImage = UIImage(named: fullName, in: imageBundle, compatibleWith: nil) {
            
            return namedImage
        }
        
        guard let imagePath = imageBundle.path(forResource: fullName, ofType: nil) else {
            
            // 获取图片路径失败
            return solveResourceImageReadFailed(imageName: realName)
        }
        
        // 根据路径使用contentsOfFile读取图片
        if let image = UIImage(contentsOfFile: imagePath) {
            
            return image
        }
        
        // 以上方法全部读取失败，交给外界处理
        return solveResourceImageReadFailed(imageName: realName)
    }
    
    /// 处理读取资源图片失败
    private static func solveResourceImageReadFailed(imageName: String) -> UIImage? {
        
        if let handler = resourceImageFailedHandler {
            
            return handler(imageName)
        }
        
        return nil
    }
}
