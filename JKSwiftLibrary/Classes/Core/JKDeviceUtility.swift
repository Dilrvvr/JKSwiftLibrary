//
//  JKDeviceUtility.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import Foundation

// MARK:
// MARK: - X设备类型

/// iPhone X类型
private struct JKDeviceTypeX: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 375.0, height: 812.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

/// iPhone X max类型
private struct JKDeviceTypeXMax: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 414.0, height: 896.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

/// iPhone12/13 类型
private struct JKDeviceType12: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 390.0, height: 844.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

/// iPhone12/13 max 类型
private struct JKDeviceType12Max: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 428.0, height: 926.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

/// iPhone 14 Pro
private struct JKDeviceType14: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 393.0, height: 852.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

/// iPhone14 Pro Max 类型
private struct JKDeviceType14Max: JKDeviceTypeProtocol {
    
    var screenSize: CGSize { CGSize(width: 430.0, height: 932.0) }
    
    var isDeviceX: Bool { __CGSizeEqualToSize(screenSize, JKPortraitScreenBounds.size) }
}

// MARK: - JKMARK 如有新增设备在此添加，并在`JKisDeviceX`中补充 & 更新❗️❗️❗️JKMaxScreenDeviceType❗️❗️❗️
// 如iPhone未来支持分屏时需要修改JKisSplitScreenCapable

/// ❗️❗️❗️屏幕最宽的iPhone设备类型❗️❗️❗️
private var JKMaxScreenDeviceType: JKDeviceTypeProtocol {
    
    JKDeviceType14Max()
}

/// 目前iPhone屏幕最大宽度
public let JKiPhoneScreenMaxWidth: CGFloat = {
    
    JKMaxScreenDeviceType.screenSize.width
}()

/// 是否iPhone设备
public let JKisDeviceiPhone: Bool = (UIDevice.current.userInterfaceIdiom == .phone)

/// 是否iPad设备
public let JKisDeviceiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)

/// 是否可以分屏
public var JKisSplitScreenCapable: Bool { JKisDeviceiPad }

/// 是否iPhone X设备
public let JKisDeviceX: Bool = {
    
    guard JKisDeviceiPhone else { // 非iPhone
        
        return false
    }
    
    var deviceX: Bool = false
    
    if #available(iOS 11.0, *) {
        
        deviceX = (JKDeviceTypeX().isDeviceX ||
                   JKDeviceTypeXMax().isDeviceX ||
                   JKDeviceType12().isDeviceX ||
                   JKDeviceType12Max().isDeviceX ||
                   JKDeviceType14().isDeviceX ||
                   JKDeviceType14Max().isDeviceX)
    }
    
    return deviceX
}()

// MARK:
// MARK: - 设备型号

public struct JKDeviceUtility {
    
    /// 设备型号名称 e.g. @"iPhone 12", @"iPhone 12 Pro Max"
    public static let deviceModelName: String = {
        
        if let modelName = deviceIdentifierDictionary[deviceIdentifier] {
            
            return modelName
        }
        
        if deviceIdentifier.lowercased().hasPrefix("arm") {
            
            return "Simulator"
        }
        
        return UnknownText + "(\(deviceIdentifier)"
    }()
    
    /// 设备硬件标识 e.g. @"iPhone13,2", @"iPhone13,3"
    public static let deviceIdentifier: String = {
        
        // OC需要#import "sys/utsname.h"
        var systemInfo = utsname()
        
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let machineString = machineMirror.children.reduce("") { identifier, element in
            
            guard let value = element.value as? Int8, value != 0 else {
                
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return machineString
    }()
    
    /// [设备硬件标识 : 型号名称] 字典保存
    public static func saveDeviceIdentifierDictionaryTo(path: String?) -> Bool {
        
        guard let filePath = path else {
            
            return false
        }
        
        let isSuccess = JKJSONUtility.writeJsonObjectToPath(obj: deviceIdentifierDictionary, path: filePath)
        
        return isSuccess
    }
    
    // MARK:
    // MARK: - Private Property
    
    private static var UnknownText: String { "unknown" }
    
    // MARK:
    // MARK: - Device Identifier & Device Model Name Dictionary
    
    /// https://github.com/sqlitebrowser/sqlitebrowser
    /// 使用DB Browser for SQLite查看里面的device_traits.db文件，导出json
    /// /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/usr/standalone/
    /// /Applications/Xcode.app/Contents/Developer/Platforms/WatchOS.platform/usr/standalone/
    /// /Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/usr/standalone/
    /// 使用printDeviceIdentifier方法进行打印
    
    /// [设备硬件标识 : 型号名称] 对应字典
    public static var deviceIdentifierDictionary: [String : String] {
        [
            // iPhone
            
            "iPhone1,1" : "iPhone",
            
            "iPhone1,2" : "iPhone 3G",
            
            "iPhone2,1" : "iPhone 3GS",
            
            "iPhone3,1" : "iPhone 4",
            "iPhone3,2" : "iPhone 4",
            "iPhone3,3" : "iPhone 4",
            
            "iPhone4,1" : "iPhone 4S",
            
            "iPhone5,1" : "iPhone 5",
            "iPhone5,2" : "iPhone 5",
            
            "iPhone5,3" : "iPhone 5c",
            "iPhone5,4" : "iPhone 5c",
            
            "iPhone6,1" : "iPhone 5s",
            "iPhone6,2" : "iPhone 5s",
            
            "iPhone7,2" : "iPhone 6",
            "iPhone7,1" : "iPhone 6 Plus",
            
            "iPhone8,1" : "iPhone 6s",
            "iPhone8,2" : "iPhone 6s Plus",
            
            "iPhone8,4" : "iPhone SE (1st generation)",
            
            "iPhone9,1" : "iPhone 7",
            "iPhone9,3" : "iPhone 7",
            "iPhone9,2" : "iPhone 7 Plus",
            "iPhone9,4" : "iPhone 7 Plus",
            
            "iPhone10,1" : "iPhone 8",
            "iPhone10,4" : "iPhone 8",
            "iPhone10,2" : "iPhone 8 Plus",
            "iPhone10,5" : "iPhone 8 Plus",
            
            "iPhone10,3" : "iPhone X",
            "iPhone10,6" : "iPhone X",
            
            "iPhone11,8" : "iPhone XR",
            "iPhone11,2" : "iPhone XS",
            "iPhone11,4" : "iPhone XS Max",
            "iPhone11,6" : "iPhone XS Max",
            
            "iPhone12,1" : "iPhone 11",
            "iPhone12,3" : "iPhone 11 Pro",
            "iPhone12,5" : "iPhone 11 Pro Max",
            
            "iPhone12,8" : "iPhone SE (2nd generation)",
            
            "iPhone13,1" : "iPhone 12 mini",
            "iPhone13,2" : "iPhone 12",
            "iPhone13,3" : "iPhone 12 Pro",
            "iPhone13,4" : "iPhone 12 Pro Max",
            
            "iPhone14,4" : "iPhone 13 mini",
            "iPhone14,5" : "iPhone 13",
            "iPhone14,2" : "iPhone 13 Pro",
            "iPhone14,3" : "iPhone 13 Pro Max",
            
            "iPhone14,6" : "iPhone SE (3rd generation)",
            
            "iPhone14,7" : "iPhone 14",
            "iPhone14,8" : "iPhone 14 Plus",
            "iPhone15,2" : "iPhone 14 Pro",
            "iPhone15,3" : "iPhone 14 Pro Max",
            
            "iPhone15,4" : "iPhone 15",
            "iPhone15,5" : "iPhone 15 Plus",
            "iPhone16,1" : "iPhone 15 Pro",
            "iPhone16,2" : "iPhone 15 Pro Max",
            
            
            // iPod touch
            
            "iPod1,1" : "iPod touch",
            
            "iPod2,1" : "iPod touch (2nd generation)",
            
            "iPod3,1" : "iPod touch (3rd generation)",
            
            "iPod4,1" : "iPod touch (4th generation)",
            
            "iPod5,1" : "iPod touch (5th generation)",
            
            "iPod7,1" : "iPod touch (6th generation)",
            
            "iPod9,1" : "iPod touch (7th generation)",
            
            
            // iPad
            
            "iPad1,1" : "iPad",
            "iPad1,2" : "iPad",
            
            "iPad2,1" : "iPad 2",
            "iPad2,2" : "iPad 2",
            "iPad2,3" : "iPad 2",
            "iPad2,4" : "iPad 2",
            
            "iPad3,1" : "iPad (3rd generation)",
            "iPad3,2" : "iPad (3rd generation)",
            "iPad3,3" : "iPad (3rd generation)",
            
            "iPad3,4" : "iPad (4th generation)",
            "iPad3,5" : "iPad (4th generation)",
            "iPad3,6" : "iPad (4th generation)",
            
            "iPad6,11" : "iPad (5th generation)",
            "iPad6,12" : "iPad (5th generation)",
            
            "iPad7,5" : "iPad (6th generation)",
            "iPad7,6" : "iPad (6th generation)",
            
            "iPad7,11" : "iPad (7th generation)",
            "iPad7,12" : "iPad (7th generation)",
            
            "iPad11,6" : "iPad (8th generation)",
            "iPad11,7" : "iPad (8th generation)",
            
            "iPad12,1" : "iPad (9th generation)",
            "iPad12,2" : "iPad (9th generation)",
            
            "iPad13,18" : "iPad (10th generation)",
            "iPad13,19" : "iPad (10th generation)",
            
            
            // iPad mini
            
            "iPad2,5" : "iPad mini",
            "iPad2,6" : "iPad mini",
            "iPad2,7" : "iPad mini",
            
            "iPad4,4" : "iPad mini 2",
            "iPad4,5" : "iPad mini 2",
            "iPad4,6" : "iPad mini 2",
            
            "iPad4,7" : "iPad mini 3",
            "iPad4,8" : "iPad mini 3",
            "iPad4,9" : "iPad mini 3",
            
            "iPad5,1" : "iPad mini 4",
            "iPad5,2" : "iPad mini 4",
            
            "iPad11,1" : "iPad mini (5th generation)",
            "iPad11,2" : "iPad mini (5th generation)",
            
            "iPad14,1" : "iPad mini (6th generation)",
            "iPad14,2" : "iPad mini (6th generation)",
            
            
            // iPad Air
            
            "iPad4,1" : "iPad Air",
            "iPad4,2" : "iPad Air",
            "iPad4,3" : "iPad Air",
            
            "iPad5,3" : "iPad Air 2",
            "iPad5,4" : "iPad Air 2",
            
            "iPad11,3" : "iPad Air (3rd generation)",
            "iPad11,4" : "iPad Air (3rd generation)",
            
            "iPad13,1" : "iPad Air (4th generation)",
            "iPad13,2" : "iPad Air (4th generation)",
            
            "iPad13,16" : "iPad Air (5th generation)",
            "iPad13,17" : "iPad Air (5th generation)",
            
            
            // iPad Pro
            
            "iPad6,3" : "iPad Pro (9.7-inch)",
            "iPad6,4" : "iPad Pro (9.7-inch)",
            
            "iPad6,7" : "iPad Pro (12.9-inch)",
            "iPad6,8" : "iPad Pro (12.9-inch)",
            
            "iPad7,1" : "iPad Pro (12.9-inch) (2nd generation)",
            "iPad7,2" : "iPad Pro (12.9-inch) (2nd generation)",
            
            "iPad7,3" : "iPad Pro (10.5-inch)",
            "iPad7,4" : "iPad Pro (10.5-inch)",
            
            "iPad8,1" : "iPad Pro (11-inch)",
            "iPad8,2" : "iPad Pro (11-inch)",
            "iPad8,3" : "iPad Pro (11-inch)",
            "iPad8,4" : "iPad Pro (11-inch)",
            
            "iPad8,5" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,6" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,7" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,8" : "iPad Pro (12.9-inch) (3rd generation)",
            
            "iPad8,9" : "iPad Pro (11-inch) (2nd generation)",
            "iPad8,10" : "iPad Pro (11-inch) (2nd generation)",
            
            "iPad8,11" : "iPad Pro (12.9-inch) (4th generation)",
            "iPad8,12" : "iPad Pro (12.9-inch) (4th generation)",
            
            "iPad13,4" : "iPad Pro (11-inch) (3rd generation)",
            "iPad13,5" : "iPad Pro (11-inch) (3rd generation)",
            "iPad13,6" : "iPad Pro (11-inch) (3rd generation)",
            "iPad13,7" : "iPad Pro (11-inch) (3rd generation)",
            
            "iPad13,8" : "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,9" : "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,10" : "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,11" : "iPad Pro (12.9-inch) (5th generation)",
            
            "iPad14,3" : "iPad Pro (11-inch) (4th generation)",
            "iPad14,4" : "iPad Pro (11-inch) (4th generation)",
            
            "iPad14,5" : "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,6" : "iPad Pro (12.9-inch) (6th generation)",
            
            "iPad14,3-A" : "iPad Pro (11-inch) (4th generation)",
            "iPad14,3-B" : "iPad Pro (11-inch) (4th generation)",
            "iPad14,4-A" : "iPad Pro (11-inch) (4th generation)",
            "iPad14,4-B" : "iPad Pro (11-inch) (4th generation)",
            
            "iPad14,5-A" : "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,5-B" : "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,6-A" : "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,6-B" : "iPad Pro (12.9-inch) (6th generation)",
            
            
            // Apple Watch
            
            "Watch1,1" : "Apple Watch (1st generation) 38mm",
            "Watch1,2" : "Apple Watch (1st generation) 42mm",
            
            "Watch2,6" : "Apple Watch Series 1 38mm",
            "Watch2,7" : "Apple Watch Series 1 42mm",
            
            "Watch2,3" : "Apple Watch Series 2 38mm",
            "Watch2,4" : "Apple Watch Series 2 42mm",
            
            "Watch3,1" : "Apple Watch Series 3 (GPS + Cellular) 38mm",
            "Watch3,2" : "Apple Watch Series 3 (GPS + Cellular) 42mm",
            
            "Watch3,3" : "Apple Watch Series 3 (GPS) 38mm",
            "Watch3,4" : "Apple Watch Series 3 (GPS) 42mm",
            
            "Watch4,1" : "Apple Watch Series 4",
            "Watch4,2" : "Apple Watch Series 4",
            "Watch4,3" : "Apple Watch Series 4",
            "Watch4,4" : "Apple Watch Series 4",
            
            "Watch5,1" : "Apple Watch Series 5",
            "Watch5,2" : "Apple Watch Series 5",
            "Watch5,3" : "Apple Watch Series 5",
            "Watch5,4" : "Apple Watch Series 5",
            
            "Watch5,9" : "Apple Watch SE (GPS)",
            "Watch5,10" : "Apple Watch SE (GPS)",
            "Watch5,11" : "Apple Watch SE (GPS + Cellular)",
            "Watch5,12" : "Apple Watch SE (GPS + Cellular)",
            
            "Watch6,1" : "Apple Watch Series 6 (GPS)",
            "Watch6,2" : "Apple Watch Series 6 (GPS)",
            "Watch6,3" : "Apple Watch Series 6 (GPS + Cellular)",
            "Watch6,4" : "Apple Watch Series 6 (GPS + Cellular)",
            
            "Watch6,6" : "Apple Watch Series 7 (GPS)",
            "Watch6,7" : "Apple Watch Series 7 (GPS)",
            "Watch6,8" : "Apple Watch Series 7 (GPS + Cellular)",
            "Watch6,9" : "Apple Watch Series 7 (GPS + Cellular)",
            
            "Watch6,10" : "Apple Watch SE (GPS)",
            "Watch6,11" : "Apple Watch SE (GPS)",
            "Watch6,12" : "Apple Watch SE (GPS + Cellular)",
            "Watch6,13" : "Apple Watch SE (GPS + Cellular)",
            
            "Watch6,14" : "Apple Watch Series 8 (GPS)",
            "Watch6,15" : "Apple Watch Series 8 (GPS)",
            "Watch6,16" : "Apple Watch Series 8 (GPS + Cellular)",
            "Watch6,17" : "Apple Watch Series 8 (GPS + Cellular)",
            
            "Watch6,18" : "Apple Watch Ultra",
            
            "Watch7,1" : "Apple Watch Series 9 (GPS)",
            "Watch7,2" : "Apple Watch Series 9 (GPS)",
            "Watch7,3" : "Apple Watch Series 9 (GPS + Cellular)",
            "Watch7,4" : "Apple Watch Series 9 (GPS + Cellular)",
            
            "Watch7,5" : "Apple Watch Ultra 2",
            
            
            // Apple TV
            
            "AppleTV1,1" : "Apple TV (1st generation)",
            
            "AppleTV2,1" : "Apple TV (2nd generation)",
            
            "AppleTV3,1" : "Apple TV (3rd generation)",
            "AppleTV3,2" : "Apple TV (3rd generation)",
            
            "AppleTV5,3" : "Apple TV (4th generation)",
            
            "AppleTV6,2" : "Apple TV 4K",
            "AppleTV11,1" : "Apple TV 4K (2nd generation)",
            "AppleTV14,1" : "Apple TV 4K (3rd generation)",
            
            
            // Simulator
            
            "i386" : "Simulator",
            "x86_64" : "Simulator",
        ]
    }
    
    /// 打印 [设备硬件标识 : 型号名称] 对应字典
    private func printDeviceIdentifier() {
        
        // iOSDevices替换为对应的文件名称
        guard let url = Bundle.main.url(forResource: "iOSDevices", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let jsonArr = try? JSONSerialization.jsonObject(with: jsonData) as? [[String : Any]] else {
            
            return
        }
        
        var iPhoneArr = [DeviceModel]()
        var iPodArr = [DeviceModel]()
        var iPadArr = [DeviceModel]()
        var iPadAirArr = [DeviceModel]()
        var iPadProArr = [DeviceModel]()
        var iPadMiniArr = [DeviceModel]()
        var watchArr = [DeviceModel]()
        var tvArr = [DeviceModel]()
        
        jsonArr.forEach {
            
            guard let productType = $0["ProductType"] as? String,
                  let productDescription = $0["ProductDescription"] as? String else {
                
                return
            }
            
            let md = DeviceModel(productType: productType, productDescription: productDescription)
            
            if md.productType.hasPrefix("iPhone") {
                
                iPhoneArr.append(md)
                
                return
            }
            
            if md.productType.hasPrefix("iPod") {
                
                iPodArr.append(md)
                
                return
            }
            
            if md.productType.hasPrefix("iPad") {
                
                let desLowerCased = md.productDescription.lowercased()
                
                if desLowerCased.contains("mini") {
                    
                    iPadMiniArr.append(md)
                    
                    return
                }
                
                if desLowerCased.contains("air") {
                    
                    iPadAirArr.append(md)
                    
                    return
                }
                
                if desLowerCased.contains("pro") {
                    
                    iPadProArr.append(md)
                    
                    return
                }
                
                iPadArr.append(md)
                
                return
            }
            
            if md.productType.hasPrefix("Watch") {
                
                watchArr.append(md)
                
                return
            }
            
            if md.productType.hasPrefix("AppleTV") {
                
                tvArr.append(md)
                
                return
            }
        }
        
        let mdArr = [
            iPhoneArr,
            iPodArr,
            iPadArr,
            iPadMiniArr,
            iPadAirArr,
            iPadProArr,
            watchArr,
            tvArr
        ]
        
        for var arr in mdArr {
            
            if arr.count < 1 { continue }
            
            print("// ===================================================")
            
            arr.sort { d1, d2 in
                
                d1.productType.compare(d2.productType) == .orderedAscending
            }
            
            arr.forEach({
                
                print("\"\($0.productType)\" : \"\($0.productDescription)\",")
            })
        }
    }
    
    private struct DeviceModel {
        
        var productType = ""
        
        var productDescription = ""
    }
}
