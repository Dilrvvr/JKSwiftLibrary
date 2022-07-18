//
//  JKUtility.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import Foundation

// MARK:
// MARK: - Public Constant

/// 屏幕bounds
public var JKScreenBounds: CGRect { UIScreen.main.bounds }

/// 竖屏的屏幕bounds
public var JKPortraitScreenBounds: CGRect {
    
    if JKisPortrait { return UIScreen.main.bounds }
    
    return CGRect(x: 0.0, y: 0.0, width: min(JKScreenWidth, JKScreenHeight), height: max(JKScreenWidth, JKScreenHeight))
}

/// 屏幕scale
public var JKScreenScale: CGFloat { UIScreen.main.scale }

/// 屏幕宽度
public var JKScreenWidth: CGFloat { JKScreenBounds.width }

/// 屏幕高度
public var JKScreenHeight: CGFloat { JKScreenBounds.height }

/// 是否横屏
public var JKisLandscape: Bool { JKScreenWidth > JKScreenHeight }

/// 是否竖屏
public var JKisPortrait: Bool { JKScreenHeight >= JKScreenWidth }

/// 当前的windowScene
@available(iOS 13.0, *)
public var JKCurrentWindowScene: UIWindowScene? {
    
    let connectedScenes = UIApplication.shared.connectedScenes
    
    if connectedScenes.count < 1 {
        
        return nil
    }
    
    if connectedScenes.count == 1 {
        
        if let windowScene = connectedScenes.first as? UIWindowScene {
            
            return windowScene
        }
        
        return nil
    }
    
    for scene in UIApplication.shared.connectedScenes {
        
        guard scene is UIWindowScene else { continue }
        
        let windowScene = scene as! UIWindowScene
        
        guard windowScene.activationState == .foregroundActive else {
            
            continue
        }
        
        return windowScene
    }
    
    return nil
}

/// 当前windowScene的window
public var JKCurrentSceneWindow: UIWindow? {
    
    if #available(iOS 13.0, *) {
        
        guard let windowScene = JKCurrentWindowScene else {
            
            return nil
        }
        
        if #available(iOS 15.0, *) {
            
            if let keyWindow = windowScene.keyWindow {
                
                return keyWindow
            }
        }
        
        guard windowScene.windows.count > 0 else {
            
            return nil
        }
        
        if windowScene.windows.count == 1 {
            
            return windowScene.windows.first!
        }
        
        for window in windowScene.windows {
            
            if window.isHidden { continue }
            
            if window.isKeyWindow {
                
                return window
            }
            
            // TODO: - JKTODO 分屏
            if (window.bounds.height == JKScreenHeight) {
                
                return window
            }
        }
    }
    
    return nil
}

/// 当前的主window
public var JKKeyWindow: UIWindow {
    
    //UIApplication.shared.delegate!.window!!
    
    if let keyWindow = JKGeneralUtility.keyWindow {
        
        return keyWindow
    }
    
    guard let appDelegate = UIApplication.shared.delegate else {
        
        return JKPrivateReplaceWindow_
    }
    
    let isResponds = appDelegate.responds(to: #selector(getter: UIApplicationDelegate.window))
    
    if isResponds {
        
        if let window = appDelegate.window as? UIWindow {
            
            return window
        }
    }
    
    if let keyWindow = JKCurrentSceneWindow {
        
        return keyWindow
    }
    
    return JKPrivateReplaceWindow_
}

/// 创建新的window后注册到当前的windowScene   isObserve: 是否监听通知
public func JKRegisterWindowToCurrentWindowScene(_ window: UIWindow?, isObserve: Bool) {
    
    guard let realWindow = window else { return }
    
    // 注册window
    if #available(iOS 13.0, *) {
        
        guard let windowScene = JKCurrentWindowScene else { return }
        
        realWindow.windowScene = windowScene
        
        guard isObserve else { return }
        
        NotificationCenter.default.addObserver(forName: UIScene.willConnectNotification, object: nil, queue: nil) { [weak realWindow] note in
            
            guard let _ = realWindow,
                  let noteWindowScene = note.object as? UIWindowScene else {
                      
                      return
                  }
            
            realWindow?.windowScene = noteWindowScene
        }
    }
}

/// 安全区域 insets
public var JKSafeAreaInsets: UIEdgeInsets {
    
    if #available(iOS 11.0, *) {
        
        return JKKeyWindow.safeAreaInsets
    }
    
    return .zero
}

/// 状态栏高度
public var JKStatusBarHeight: CGFloat {
    
    if #available(iOS 11.0, *) {
        
        if JKisDeviceiPad {
            
            return JKKeyWindow.safeAreaInsets.top > 0.0 ? JKKeyWindow.safeAreaInsets.top : 24.0
        }
        
        return JKKeyWindow.safeAreaInsets.top
    }
    
    return 20.0
}

/// 导航条高度
public var JKNavigationBarHeight: CGFloat {
    
    // 小屏iPad高度为70，这里全部处理为74
    if JKisDeviceiPad { return 74.0 }
    
    if JKisLandscape {
        
        return min(JKScreenWidth, JKScreenHeight) > 400.0 ? 44.0 : 32.0
    }
    
    return JKStatusBarHeight + 44.0
}

/// 底部安全区域高度
public var JKBottomSafeAreaInset: CGFloat { JKSafeAreaInsets.bottom }

/// TabBar高度
public var JKTabBarHeight: CGFloat {
    
    if JKisPortrait { // 竖屏
        
        return JKBottomSafeAreaInset + 49.0
    }
    
    // 横屏
    
    if JKisDeviceiPad ||
        min(JKScreenWidth, JKScreenHeight) > 400.0 { // iPad和大屏iPhone
        
        return JKBottomSafeAreaInset + 49.0
    }
    
    return JKBottomSafeAreaInset + 32.0
}

/// 分隔线粗细
public let JKLineThickness: CGFloat = (1.0 / UIScreen.main.scale)

/// 分隔线颜色 浅色模式
public let JKLineLightColor: UIColor = UIColor(red: 60.0 / 255.0, green: 60.0 / 255.0, blue: 67.0 / 255.0, alpha: 0.29)

/// 分隔线颜色 深色模式
public let JKLineDarkColor: UIColor = UIColor(red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 88.0 / 255.0, alpha: 0.6)

// MARK:
// MARK: - Public Function

/// 让手机振动一下
public func JKVibrateDevice() {
    
    // iPad没有振动
    if (JKisDeviceiPad) { return }
    
    if #available(iOS 10.0, *) {
        
        let feedbackGenertor = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenertor.impactOccurred()
    }
}

/// 退出键盘
public func JKHideKeyboard() {
    
    JKEndEditing()
}

/// 退出键盘
public func JKEndEditing() {
    
    DispatchQueue.main.async {
        
        JKKeyWindow.endEditing(true)
    }
}

/// 按比例计算宽度
public func JKGetScaleWidth(currentHeight: CGFloat,
                            scaleWidth: CGFloat,
                            scaleHeight: CGFloat) -> CGFloat {
    
    // 参数校验
    var isValidParam = (currentHeight >= 0.0)
    if !isValidParam {
        assert(isValidParam, "currentHeight不可小于0")
        return 0.0
    }
    
    isValidParam = (scaleWidth >= 0.0)
    if !isValidParam {
        assert(isValidParam, "scaleWidth不可小于0")
        return 0.0
    }
    
    isValidParam = (scaleHeight > 0.0)
    if !isValidParam {
        assert(isValidParam, "scaleHeight必须大于0")
        return 0.0
    }
    
    // 计算比例
    let scale = scaleWidth / scaleHeight
    
    // W / H
    // ? / h
    
    return scale * currentHeight
}

/// 按比例计算高度
public func JKGetScaleHeight(currentWidth: CGFloat,
                             scaleWidth: CGFloat,
                             scaleHeight: CGFloat) -> CGFloat {
    
    // 参数校验
    var isValidParam: Bool = (currentWidth >= 0.0)
    if !isValidParam {
        assert(isValidParam, "currentHeight不可小于0")
        return 0.0
    }
    
    isValidParam = (scaleWidth > 0.0)
    if !isValidParam {
        assert(isValidParam, "scaleWidth必须大于0")
        return 0.0
    }
    
    isValidParam = (scaleHeight > 0.0)
    if !isValidParam {
        assert(isValidParam, "scaleHeight必须大于0")
        return 0.0
    }
    
    // 计算比例
    let scale = scaleWidth / scaleHeight
    
    if scale <= 0.0 { return 0.0 }
    
    // W / H
    // w / ?
    
    return currentWidth / scale
}

// MARK:
// MARK: - 日期格式化

/// "yyyyMMdd HH:mm:ss.SSSSSS" 打印时间 精确到微秒 date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKAbsolutePrintTime(_ absoluteTime: CFAbsoluteTime) -> String {
    
    let date = Date(timeIntervalSince1970: kCFAbsoluteTimeIntervalSince1970 + absoluteTime)
    
    var dateString = JKStringFromDateNormal(date: date)
    
    // 微秒 小数部分的数字
    let microsecond = (absoluteTime - floor(absoluteTime)) * 1000000.0
    
    let microsecondString = String(format: ".%.0f", microsecond)
    
    dateString += microsecondString
    
    return dateString
}

/// "HHmmss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKStringFromDate_HHmmss(date: Date?) -> String {
    
    return JKStringFromDate(date: date, format: "%H%M%S")
}

/// "HH:mm:ss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKStringFromDate_HHmmss_colon(date: Date?) -> String {
    
    return JKStringFromDate(date: date, format: "%H:%M:%S")
}

/// "yyyyMMdd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKStringFromDate_yyyyMMdd(date: Date?) -> String {
    
    return JKStringFromDate(date: date, format: "%Y%m%d")
}

/// "yyyy-MM-dd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKStringFromDate_yyyyMMdd_horizontal_line(date: Date?) -> String {
    
    return JKStringFromDate(date: date, format: "%Y-%m-%d")
}

/// "yyyyMMdd HH:mm:ss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
public func JKStringFromDateNormal(date: Date?) -> String {
    
    return JKStringFromDate(date: date, format: "%Y-%m-%d %H:%M:%S")
}

/**
 * format格式: "%Y-%m-%d %H:%M:%S"
 * date无需增加时区偏移
 * date/format为空或出错时返回空字符串
 */
public func JKStringFromDate(date: Date?, format: String?) -> String {
    
    guard let _ = date,
          let _ = format,
          format!.count > 0 else {
              
              return ""
          }
    
    var buffer = [CChar](repeating: 0, count: 100)
    
    var time = time_t(date!.timeIntervalSince1970)
    
    strftime(&buffer, buffer.count, format, localtime(&time))
    
    let dateString = String(cString: buffer, encoding: String.Encoding.utf8) ?? ""
    
    return dateString
}

// MARK:
// MARK: - Color Function

/// RGB快速创建UIColor
public func JKRGBColor(_ r: CGFloat,
                       _ g: CGFloat,
                       _ b: CGFloat,
                       _ a: CGFloat = 1.0) -> UIColor {
    
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 相同RGB快速创建UIColor
public func JKSameRGBColor(_ rgb: CGFloat,
                           _ a: CGFloat = 1.0) -> UIColor {
    
    return UIColor(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: a)
}

/// 系统红色  #FF3B30  255,59,48
public func JKSystemRedColor() -> UIColor {
    
    return UIColor.systemRed
}

/// 系统蓝色  #007AFF  0,122,255
public func JKSystemBlueColor() -> UIColor {
    
    return UIColor.systemBlue
}

/// 根据颜色创建图片
public func JKCreateImage(color: UIColor?,
                          size: CGSize,
                          opaque: Bool = false,
                          scale: CGFloat = 0.0) -> UIImage? {
    
    guard let realColor = color else { return nil }
    
    let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    
    context.setFillColor(realColor.cgColor)
    context.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return image
}

// MARK:
// MARK: - 倒计时

/// 自定义全局队列
public let JKGlobalQueue = DispatchQueue(label: "com.albert.global")

/// queue: 传nil将默认主队列  handler: 回调默认在主线程执行
public func JKDispatchTimer(queue: DispatchQueue?,
                            target: AnyObject?,
                            delay: TimeInterval,
                            timeInterval: TimeInterval,
                            isRepeat: Bool,
                            handler: ((_ innerTimer: DispatchSourceTimer) -> Void)?) -> DispatchSourceTimer {
    
    let realQueue = queue ?? DispatchQueue.main
    
    let timer = DispatchSource.makeTimerSource(flags: [], queue: realQueue)
    
    timer.schedule(wallDeadline: .now() + delay, repeating: (isRepeat ? timeInterval : 0.0))
    
    weak var weakTarget = target
    weak var weakTimer = timer
    
    timer.setEventHandler {
        
        guard let innerTimer = weakTimer else { return }
        
        guard let _ = weakTarget else { // target 已销毁
            
            innerTimer.cancel()
            
            return
        }
        
        if let innerHandler = handler {
            
            DispatchQueue.main.async {
                
                innerHandler(innerTimer)
            }
        }
    }
    
    timer.resume()
    
    return timer
}

// MARK:
// MARK: - Debug Function

/// 随机颜色
public func JKRandomColor(_ alpha: CGFloat = 1.0) -> UIColor {
    
    let r = CGFloat(arc4random_uniform(256)) / 255.0
    let g = CGFloat(arc4random_uniform(256)) / 255.0
    let b = CGFloat(arc4random_uniform(256)) / 255.0
    
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
}

// MARK:
// MARK: - Private

fileprivate let JKPrivateReplaceWindow_: UIWindow = {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    window.isUserInteractionEnabled = false
    
    return window
}()
