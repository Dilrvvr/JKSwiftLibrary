//
//  Date+JKExtension.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import Foundation

// MARK:
// MARK: - Property

public extension JKExtensionWrapper where Base == Date {
    
    /// 时间戳 秒
    var secondTimeStamp: TimeInterval {
        
        toSecondTimeStamp()
    }
    
    /// 时间戳 毫秒
    var millisecondTimeStamp: TimeInterval {
        
        tomMillisecondTimeStamp()
    }
}

// MARK:
// MARK: - Static Function

//public extension JKExtensionWrapper where Base == Date {

//}

// MARK:
// MARK: - Normal Function

public extension JKExtensionWrapper where Base == Date {
    
    /// 时间戳 秒
    func toSecondTimeStamp() -> TimeInterval {
        
        self.base.timeIntervalSince1970
    }
    
    /// 时间戳 毫秒
    func tomMillisecondTimeStamp() -> TimeInterval {
        
        toSecondTimeStamp() * 1000.0
    }
}

// MARK:
// MARK: - 日期格式化

public extension JKExtensionWrapper where Base == Date {
    
    /// "yyyy-MM-dd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
    var format_yyyyMMdd_horizontal_line: String {
        
        return toString(format: "%Y-%m-%d")
    }
    
    /// "yyyyMMdd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
    var format_yyyyMMdd: String {
        
        return toString(format: "%Y%m%d")
    }
    
    /// "yyyyMMddHHmmss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
    var format_yyyyMMddHHmmss: String {
        
        return toString(format: "%Y%m%d%H%M%S")
    }
    
    /// "yyyy-MM-dd HH:mm:ss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
    var format_normal: String {
        
        toString(format: "%Y-%m-%d %H:%M:%S")
    }
    
    /// "yyyy-MM-dd HH:mm:ss.SSSSSS" 打印时间 精确到微秒 date无需增加时区偏移 date/format为空时或出错时返回空字符串
    func toAbsolutePrintTime(_ absoluteTime: CFAbsoluteTime) -> String {
        
        let date = Date(timeIntervalSince1970: kCFAbsoluteTimeIntervalSince1970 + absoluteTime)
        
        var dateString = date.jk.format_normal
        
        // 微秒 小数部分的数字
        let microsecond = (absoluteTime - floor(absoluteTime)) * 1000000.0
        
        let microsecondString = String(format: ".%.0f", microsecond)
        
        dateString += microsecondString
        
        return dateString
    }
    
    /**
     * format格式: "%Y-%m-%d %H:%M:%S"
     * date无需增加时区偏移
     * date/format为空或出错时返回空字符串
     */
    func toString(format: String?) -> String {
        
        guard let _ = format,
              format!.count > 0 else {
                  
                  return ""
              }
        
        var buffer = [CChar](repeating: 0, count: 100)
        
        var time = time_t(self.base.timeIntervalSince1970)
        
        strftime(&buffer, buffer.count, format, localtime(&time))
        
        let dateString = String(cString: buffer, encoding: String.Encoding.utf8) ?? ""
        
        return dateString
    }
}
