//
//  Phone.swift
//  zp_chu
//
//  Created by 李雪 on 2018/7/5.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

//判断设备

func iphoneType() ->String {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
        return String(cString: ptr)
    }
    
    if platform == "iPhone1,1" { return "iPhone 2G"}
    if platform == "iPhone1,2" { return "iPhone 3G"}
    if platform == "iPhone2,1" { return "iPhone 3GS"}
    if platform == "iPhone3,1" { return "iPhone 4"}
    if platform == "iPhone3,2" { return "iPhone 4"}
    if platform == "iPhone3,3" { return "iPhone 4"}
    if platform == "iPhone4,1" { return "iPhone 4S"}
    if platform == "iPhone5,1" { return "iPhone 5"}
    if platform == "iPhone5,2" { return "iPhone 5"}
    if platform == "iPhone5,3" { return "iPhone 5C"}
    if platform == "iPhone5,4" { return "iPhone 5C"}
    if platform == "iPhone6,1" { return "iPhone 5S"}
    if platform == "iPhone6,2" { return "iPhone 5S"}
    if platform == "iPhone7,1" { return "iPhone 6 Plus"}
    if platform == "iPhone7,2" { return "iPhone 6"}
    if platform == "iPhone8,1" { return "iPhone 6S"}
    if platform == "iPhone8,2" { return "iPhone 6S Plus"}
    if platform == "iPhone8,4" { return "iPhone SE"}
    if platform == "iPhone9,1" { return "iPhone 7"}
    if platform == "iPhone9,2" { return "iPhone 7 Plus"}
    if platform == "iPhone10,1" { return "iPhone 8"}
    if platform == "iPhone10,2" { return "iPhone 8 Plus"}
    if platform == "iPhone10,3" { return "iPhone X"}
    if platform == "iPhone10,4" { return "iPhone 8"}
    if platform == "iPhone10,5" { return "iPhone 8 Plus"}
    if platform == "iPhone10,6" { return "iPhone X"}
    if platform == "iPod1,1" { return "iPod Touch 1G"}
    if platform == "iPod2,1" { return "iPod Touch 2G"}
    if platform == "iPod3,1" { return "iPod Touch 3G"}
    if platform == "iPod4,1" { return "iPod Touch 4G"}
    if platform == "iPod5,1" { return "iPod Touch 5G"}
    
    if platform == "iPad1,1" { return "iPad 1"}
    if platform == "iPad2,1" { return "iPad 2"}
    if platform == "iPad2,2" { return "iPad 2"}
    if platform == "iPad2,3" { return "iPad 2"}
    if platform == "iPad2,4" { return "iPad 2"}
    if platform == "iPad2,5" { return "iPad Mini 1"}
    if platform == "iPad2,6" { return "iPad Mini 1"}
    if platform == "iPad2,7" { return "iPad Mini 1"}
    if platform == "iPad3,1" { return "iPad 3"}
    if platform == "iPad3,2" { return "iPad 3"}
    if platform == "iPad3,3" { return "iPad 3"}
    if platform == "iPad3,4" { return "iPad 4"}
    if platform == "iPad3,5" { return "iPad 4"}
    if platform == "iPad3,6" { return "iPad 4"}
    if platform == "iPad4,1" { return "iPad Air"}
    if platform == "iPad4,2" { return "iPad Air"}
    if platform == "iPad4,3" { return "iPad Air"}
    if platform == "iPad4,4" { return "iPad Mini 2"}
    if platform == "iPad4,5" { return "iPad Mini 2"}
    if platform == "iPad4,6" { return "iPad Mini 2"}
    if platform == "iPad4,7" { return "iPad Mini 3"}
    if platform == "iPad4,8" { return "iPad Mini 3"}
    if platform == "iPad4,9" { return "iPad Mini 3"}
    if platform == "iPad5,1" { return "iPad Mini 4"}
    if platform == "iPad5,2" { return "iPad Mini 4"}
    if platform == "iPad5,3" { return "iPad Air 2"}
    if platform == "iPad5,4" { return "iPad Air 2"}
    if platform == "iPad6,3" { return "iPad Pro 9.7"}
    if platform == "iPad6,4" { return "iPad Pro 9.7"}
    if platform == "iPad6,7" { return "iPad Pro 12.9"}
    if platform == "iPad6,8" { return "iPad Pro 12.9"}
    
    if platform == "i386"   { return "iPhone Simulator"}
    if platform == "x86_64" { return "iPhone X"}
    
    return platform
}

func safeTopPadding() -> CGFloat{
    
    return isHasSafeArea() ? 44 : 0
}


func safeBottomPadding() -> CGFloat{
    
    return isHasSafeArea() ? 34 : 0
}

func navBarHeight() -> CGFloat{
    
    return isHasSafeArea() ? 88 : 74
}


func isHasSafeArea() -> Bool {
    return isIPHONE_XOrXS() || isIPHONE_XMax() || isIPHONE_XR()
}

func isIPHONE_XOrXS() -> Bool {
    if let screenSize = UIScreen.main.currentMode?.size {
        return __CGSizeEqualToSize(screenSize, CGSize(width: 1125, height: 2436))
    }
    return false
}

func isIPHONE_XMax() -> Bool {
    if let screenSize = UIScreen.main.currentMode?.size {
        return __CGSizeEqualToSize(screenSize, CGSize(width: 1242, height: 2688))
    }
    return false
}

func isIPHONE_XR() ->  Bool {
    if let screenSize = UIScreen.main.currentMode?.size {
        return __CGSizeEqualToSize(screenSize, CGSize(width: 828, height: 1792))
    }
    return false
}



//尺寸

let screenWidth: CGFloat =  UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let screenWidthScale: CGFloat = screenWidth / 1024
let screenHeightScale: CGFloat = screenHeight / 768


class Phone: NSObject {}
