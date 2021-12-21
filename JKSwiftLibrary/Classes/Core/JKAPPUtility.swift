//
//  JKAPPUtility.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/13.
//

import UIKit

public struct JKAPPUtility {
    
    private static var infoDictionary: [String : Any] { Bundle.main.infoDictionary ?? [String : Any]() }
    
    // MARK:
    // MARK: - Property
    
    /// APP名称
    public static var displayName: String? {
        
        if let appName = infoDictionary["CFBundleDisplayName"] as? String {
            
            return appName
        }
        
        if let appName = infoDictionary["CFBundleName"] as? String {
            
            return appName
        }
        
        return nil
    }
    
    /// 当前版本号
    public static var currentVersion: String? {
        
        if let version = infoDictionary["CFBundleShortVersionString"] as? String {
            
            return version
        }
        
        return nil
    }
    
    /// 当前Build
    public static var currentBuild: String? {
        
        if let version = infoDictionary["CFBundleVersion"] as? String {
            
            return version
        }
        
        return nil
    }
    
    // MARK:
    // MARK: - Method
    
    /// 跳转当前app设置
    public static func openAppSetting() {
        
        jumpToAppSetting()
    }
    
    /// 跳转当前app设置
    public static func jumpToAppSetting() {
        
        openUrlWithString(urlString: UIApplication.openSettingsURLString)
    }
    
    /// UIApplication 打开url 字符串
    public static func openUrlWithString(urlString: String?) {
        
        guard let _ = urlString else {
            
            return
        }
        
        let url = URL(string: urlString!)
        
        openUrl(url: url)
    }
    
    /// UIApplication 打开url
    public static func openUrl(url: URL?) {
        
        guard let realUrl = url,
              UIApplication.shared.canOpenURL(url!) else {
                  
                  return
              }
        
        UIApplication.shared.open(realUrl, options: [:], completionHandler: nil)
    }
}
