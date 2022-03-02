//
//  JKAuthorization.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/21.
//

import UIKit
import Photos
import AppTrackingTransparency
import MediaPlayer
import CoreLocation
import UserNotifications
import CoreTelephony

/// 权限提示协议
public protocol JKAuthorizationTipProtocol {
    
    var title: String { get }
    
    var message: String { get }
    
    var cancelTitle: String? { get }
    
    var verifyTitle: String { get }
}

/// 权限类型
@objc public enum JKAuthorizationType: Int {
    
    /// 未知
    case unknown = 0
    
    /// 相册权限
    case photoLibrary = 1
    
    /// 相册权限 有限访问
    case photoLibraryLimited = 101
    
    /// 相机权限
    case camera = 2
    
    /// 麦克风权限
    case microphone = 3
    
    /// 媒体资料库权限
    case mediaLibrary = 4
    
    /// 追踪权限 iOS14
    case tracking = 5
    
    /// 定位权限
    case location = 6
    
    /// 推送权限
    case notification = 7
    
    /// 联网权限 - 蜂窝网络
    case network = 8
}

/// 权限状态
@objc public enum JKAuthorizationStatus: Int {
    
    /// 未决定授权，将自动请求权限
    case notDetermined = 0
    
    /// 受限 可能是家长控制等
    case restricted = 1
    
    /// 无权限
    case denied = 2
    
    /// 已授权 定位请使用authorizedAlways/authorizedWhenInUse判断
    case authorized = 3
    
    /// 相册部分权限
    case limited = 4
    
    /// 定位 始终允许
    case authorizedAlways = 301
    
    /// 定位 使用APP期间
    case authorizedWhenInUse = 302
    
    /// 推送通知权限 临时授权(iOS 12.0) 会有两个按钮让用户选择是否继续接受推送
    case provisional = 311
    
    /// 推送通知权限 临时授权iOS 14.0 仅限app clips
    case ephemeral = 312
}

/// 联网权限 - 蜂窝网络
@objc public enum JKNetworkAuthorizationStatus: Int {
    
    /// 蜂窝网络权限 未知
    case restrictedStateUnknown = 0
    
    /// 蜂窝网络权限 无权限
    case restricted = 1
    
    /// 蜂窝网络权限 有权限
    case notRestricted = 2
}

/// 定位权限 请求类型
@objc public enum JKLocationAuthorizationRequestType: Int {
    
    /// 始终
    case always = 0
    
    /// 使用APP期间
    case whenInUse = 1
}

public class JKAuthorization: NSObject {
    
    // MARK:
    // MARK: - 相册权限
    
    /// 检查相册权限  isAddOnly: 是否仅检查写入权限，限iOS 14及以上
    @objc public final class func checkPhotoLibraryAuthorization(isAddOnly: Bool = false,
                                                                 _ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        var status = PHPhotoLibrary.authorizationStatus()
        
        if #available(iOS 14, *) {
            
            let level: PHAccessLevel = isAddOnly ? .addOnly : .readWrite
            
            status = PHPhotoLibrary.authorizationStatus(for: level)
        }
        
        switch status {
            
        case .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorized)
            
        case .limited:
            
            completionHandler(isNotDeterminedAtFirst, .limited)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            requestPhotoLibraryAuthorization { authorizationStatus in
                
                completionHandler(isNotDeterminedAtFirst, authorizationStatus)
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    /// 请求相册权限
    private static func requestPhotoLibraryAuthorization(isAddOnly: Bool = false,
                                                         _ completionHandler: @escaping (_ status: JKAuthorizationStatus) -> Void) {
        
        if #available(iOS 14, *) {
            
            var accessLevel = PHAccessLevel.readWrite
            
            if isAddOnly {
                
                accessLevel = .addOnly
            }
            
            PHPhotoLibrary.requestAuthorization(for: accessLevel) { authorizationStatus in
                
                var status: JKAuthorizationStatus = .denied
                
                switch authorizationStatus {
                    
                case .authorized:
                    
                    status = .authorized
                    
                case .limited:
                    
                    status = .limited
                    
                default:
                    break
                }
                
                DispatchQueue.main.async {
                    
                    completionHandler(status)
                }
            }
            
        } else {
            
            PHPhotoLibrary.requestAuthorization { authorizationStatus in
                
                let isAuthed = (authorizationStatus == .authorized)
                
                DispatchQueue.main.async {
                    
                    completionHandler(isAuthed ? .authorized : .denied)
                }
            }
        }
    }
    
    // MARK:
    // MARK: - 相机权限
    
    /// 检查相机权限
    @objc public final class func checkCameraAuthorization(_ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorized)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
                
                DispatchQueue.main.async {
                    
                    completionHandler(isNotDeterminedAtFirst, (isAuthorized ? .authorized : .denied))
                }
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    // MARK:
    // MARK: - 麦克风权限
    
    /// 检查麦克风权限
    @objc public final class func checkMicrophoneAuthorization(_ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
            
        case .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorized)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            AVCaptureDevice.requestAccess(for: .audio) { isAuthorized in
                
                DispatchQueue.main.async {
                    
                    completionHandler(isNotDeterminedAtFirst, (isAuthorized ? .authorized : .denied))
                }
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    // MARK:
    // MARK: - 媒体资料库权限
    
    /// 检查媒体资料库权限
    @objc public final class func checkMediaLibraryAuthorization(_ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        let status = MPMediaLibrary.authorizationStatus()
        
        switch status {
            
        case .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorized)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            MPMediaLibrary.requestAuthorization { authorizationStatus in
                
                let isAuthorized = (authorizationStatus == .authorized)
                
                DispatchQueue.main.async {
                    
                    completionHandler(isNotDeterminedAtFirst, (isAuthorized ? .authorized : .denied))
                }
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    // MARK:
    // MARK: - 追踪权限
    
    /// 检查追踪权限
    @available(iOS 14, *)
    @objc public final class func checkTrackingAuthorization(_ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        let status = ATTrackingManager.trackingAuthorizationStatus
        
        switch status {
            
        case .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorized)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            ATTrackingManager.requestTrackingAuthorization { authorizationStatus in
                
                let isAuthorized = (authorizationStatus == .authorized)
                
                DispatchQueue.main.async {
                    
                    completionHandler(isNotDeterminedAtFirst, (isAuthorized ? .authorized : .denied))
                }
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    // MARK:
    // MARK: - 定位权限
    
    /// 检查定位权限
    @objc public final class func checkLocationAuthorization(requestType: JKLocationAuthorizationRequestType,
                                                             _ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        if !CLLocationManager.locationServicesEnabled() {
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
            return
        }
        
        var locationManager: CLLocationManager
        
        if let _ = privateLocationManager {
            
            locationManager = privateLocationManager!
            
        } else {
            
            locationManager = CLLocationManager()
            
            privateLocationManager = locationManager
        }
        
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
            
        case .authorizedAlways, .authorized:
            
            completionHandler(isNotDeterminedAtFirst, .authorizedAlways)
            
        case .authorizedWhenInUse:
            
            completionHandler(isNotDeterminedAtFirst, .authorizedWhenInUse)
            
        case .denied:
            
            completionHandler(isNotDeterminedAtFirst, .denied)
            
        case .notDetermined:
            
            isNotDeterminedAtFirst = true
            
            locationManager.delegate = Self.privateInstance
            
            Self.privateInstance.locationAuthorizationDidChangeHandler = { authorizationStatus in
                
                if authorizationStatus == .notDetermined { return }
                
                DispatchQueue.main.async {
                    
                    switch authorizationStatus {
                        
                    case .authorizedWhenInUse:
                        
                        completionHandler(isNotDeterminedAtFirst, .authorizedWhenInUse)
                        
                    case .authorizedAlways:
                        
                        completionHandler(isNotDeterminedAtFirst, .authorizedAlways)
                        
                    default:
                        
                        completionHandler(isNotDeterminedAtFirst, .denied)
                    }
                }
            }
            
            switch requestType {
                
            case .whenInUse:
                
                locationManager.requestWhenInUseAuthorization()
                
            default:
                
                locationManager.requestAlwaysAuthorization()
            }
            
        default:
            
            completionHandler(isNotDeterminedAtFirst, .restricted)
        }
    }
    
    // MARK:
    // MARK: - 推送权限
    
    /// 检查推送权限
    @objc public final class func checkUserNotificationAuthorization(requestOptions: UNAuthorizationOptions,
                                                                     _ completionHandler: @escaping (_ isNotDeterminedAtFirst: Bool, _ status: JKAuthorizationStatus) -> Void) {
        
        var isNotDeterminedAtFirst = false
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            
            let status = settings.authorizationStatus
            
            DispatchQueue.main.async {
                
                switch status {
                    
                case .denied:
                    
                    completionHandler(isNotDeterminedAtFirst, .denied)
                    
                case .authorized:
                    
                    completionHandler(isNotDeterminedAtFirst, .authorized)
                    
                case .provisional:
                    
                    completionHandler(isNotDeterminedAtFirst, .provisional)
                    
                case .ephemeral:
                    
                    completionHandler(isNotDeterminedAtFirst, .ephemeral)
                    
                case .notDetermined:
                    
                    isNotDeterminedAtFirst = true
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: requestOptions) { isGranted, error in
                        
                        DispatchQueue.main.async {
                            
                            completionHandler(isNotDeterminedAtFirst, (isGranted ? .authorized : .denied))
                        }
                    }
                    
                default:
                    
                    completionHandler(isNotDeterminedAtFirst, .restricted)
                }
            }
        }
    }
    
    // MARK:
    // MARK: - 联网权限 - 蜂窝网络
    
    /// 检查联网(蜂窝网络)权限 暂无法自动请求权限
    @objc private final class func checkNetworkAuthorization(_ completionHandler: @escaping (_ status: JKNetworkAuthorizationStatus) -> Void) {
        
        var cellularData: CTCellularData
        
        if let _ = privateCellularData {
            
            cellularData = privateCellularData!
            
        } else {
            
            cellularData = CTCellularData()
            
            privateCellularData = cellularData
        }
        
        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
            
            DispatchQueue.main.async {
                
                switch state {
                    
                case .restricted:
                    
                    completionHandler(.restricted)
                    
                case .notRestricted:
                    
                    completionHandler(.notRestricted)
                    
                default:
                    
                    completionHandler(.restrictedStateUnknown)
                }
                
                privateCellularData?.cellularDataRestrictionDidUpdateNotifier = nil
                privateCellularData = nil
            }
        }
    }
    
    // MARK:
    // MARK: - Private Property
    
    private static let privateInstance = JKAuthorization()
    
    private static var customTipAlertHandler: ((_ superView: UIView?, _ tip: JKAuthorizationTipProtocol) -> Void)?
    
    private static var privateCellularData: CTCellularData?
    
    private static var privateLocationManager: CLLocationManager?
    
    /// 定位权限发生变化
    private var locationAuthorizationDidChangeHandler: ((_ authorizationStatus: CLAuthorizationStatus) -> Void)?
}

// MARK:
// MARK: - CLLocationManagerDelegate

extension JKAuthorization: CLLocationManagerDelegate {
    
    public final func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if #available(iOS 14.0, *) {} else {
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == .notDetermined { return }
            
            if let handler = locationAuthorizationDidChangeHandler {
                
                handler(status)
            }
            
            JKAuthorization.privateLocationManager = nil
            locationAuthorizationDidChangeHandler = nil
        }
    }
    
    public final func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            
            let status = manager.authorizationStatus
            
            if status == .notDetermined { return }
            
            if let handler = locationAuthorizationDidChangeHandler {
                
                handler(status)
            }
            
            JKAuthorization.privateLocationManager = nil
            locationAuthorizationDidChangeHandler = nil
        }
    }
}

// MARK:
// MARK: - 权限提示

public extension JKAuthorization {
    
    /// 权限提示弹窗 UIAlertController
    @objc final class func showTipAlert(viewController: UIViewController?, type: JKAuthorizationType) {
        
        guard let vc = viewController,
              let tip = tipWithAuthorizationType(type) else {
                  
                  return
              }
        
        showTipAlert(viewController: vc, tip: tip)
    }
    
    /// 自定义权限提示弹窗 UIView
    @objc final class func showCustomTipAlert(superView: UIView?, type: JKAuthorizationType) {
        
        guard let tip = tipWithAuthorizationType(type) else { return }
        
        showCustomTipAlert(superView: superView, tip: tip)
    }
    
    /// 权限提示弹窗 UIAlertController
    static func showTipAlert(viewController: UIViewController?, tip: JKAuthorizationTipProtocol) {
        
        guard let vc = viewController else { return }
        
        let alert = UIAlertController(title: tip.title, message: tip.message, preferredStyle: .alert)
        
        if let cancelTitle = tip.cancelTitle {
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { _ in
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: tip.verifyTitle, style: .default, handler: { _ in
            
            JKAPPUtility.jumpToAppSetting()
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    /// 自定义权限提示弹窗 UIView 需使用makeCustomTipAlert自定义
    static func showCustomTipAlert(superView: UIView?, tip: JKAuthorizationTipProtocol) {
        
        if let handler = customTipAlertHandler {
            
            handler(superView, tip)
        }
    }
    
    /// 自定义弹窗提示 view
    static func makeCustomTipAlert(_ handler: ((_ superView: UIView?, _ tip: JKAuthorizationTipProtocol) -> Void)?) {
        
        customTipAlertHandler = handler
    }
    
    static func tipWithAuthorizationType(_ type: JKAuthorizationType) -> JKAuthorizationTipProtocol? {
        
        var tip: JKAuthorizationTipProtocol? = nil
        
        switch type {
            
        case .photoLibrary:
            
            tip = Tip.photoLibrary
            
        case .photoLibraryLimited:
            
            tip = Tip.photoLibraryLimited
            
        case .camera:
            
            tip = Tip.camera
            
        case .microphone:
            
            tip = Tip.microphone
            
        case .mediaLibrary:
            
            tip = Tip.mediaLibrary
            
        case .tracking:
            
            tip = Tip.tracking
            
        case .location:
            
            tip = Tip.location
            
        case .notification:
            
            tip = Tip.notification
            
        case .network:
            
            tip = Tip.networkTip
            
        default:
            break
        }
        
        return tip
    }
}

// MARK:
// MARK: - 权限提示协议实例

public extension JKAuthorization {
    
    struct Tip {
        
        /// 相册 权限提示
        public static let photoLibrary = PhotoLibraryTip()
        
        /// 相册 有限访问 权限提示
        public static let photoLibraryLimited = PhotoLibraryLimitedTip()
        
        /// 相机 权限提示
        public static let camera = CameraTip()
        
        /// 麦克风 权限提示
        public static let microphone = MicrophoneTip()
        
        /// 媒体资料库 权限提示
        public static let mediaLibrary = MediaLibraryTip()
        
        /// 追踪权限 iOS14 权限提示
        public static let tracking = TrackingTip()
        
        /// 定位 权限提示
        public static let location = LocationTip()
        
        /// 推送 权限提示
        public static let notification = NotificationTip()
        
        /// 联网 - 蜂窝网络 权限提示
        public static let networkTip = NetworkTip()
    }
}

// MARK:
// MARK: - JKAuthorizationTipProtocol

public extension JKAuthorization {
    
    /// 相册 权限提示
    struct PhotoLibraryTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问照片" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"照片\" 中允许访问照片"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
        
        /// 部分权限提示标题
        public var limitedTitle: String { "无法访问所有照片" }
        
        /// 部分权限提示内容
        public var limitedTMessage: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"照片\" 中允许访问所有照片"
        }
    }
    
    /// 相册 有限权限提示
    struct PhotoLibraryLimitedTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问所有照片" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"照片\" 中允许访问所有照片"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 相机 权限提示
    struct CameraTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问相机" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"相机\" 中允许访问相机"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 麦克风 权限提示
    struct MicrophoneTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问麦克风" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"麦克风\" 中允许访问麦克风"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 媒体资料库 权限提示
    struct MediaLibraryTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问媒体资料库" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"媒体与Apple Music\" 中允许访问媒体资料库"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 追踪权限 iOS14 权限提示
    struct TrackingTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问跟踪信息" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"允许跟踪\" 中打开对应权限"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 定位 权限提示
    struct LocationTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法访问位置" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"位置\" 中允许访问位置"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 推送 权限提示
    struct NotificationTip: JKAuthorizationTipProtocol {
        
        public var title: String { "无法通知" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"通知\" 中允许通知"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
    
    /// 联网 - 蜂窝网络 权限提示
    struct NetworkTip: JKAuthorizationTipProtocol {
        
        public var title: String { "网络受限" }
        
        public var message: String {
            
            "请前往 \"设置\" - \"\(JKAPPUtility.displayName ?? "此APP")\" - \"无线数据\" 中允许网络权限"
        }
        
        public var cancelTitle: String? { "取消" }
        
        public var verifyTitle: String { "去设置" }
    }
}
