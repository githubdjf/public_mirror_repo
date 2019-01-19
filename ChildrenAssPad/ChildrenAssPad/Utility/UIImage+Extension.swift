//
//  UIImage+Extension.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/10.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation

extension UIImage {
    
    static func imageFromColor(fillColor color: UIColor) -> UIImage {
        
        return UIImage.imageFromColor(fillColor: color, imageSize: CGSize(width: 1, height: 1)) ?? UIImage()
    }
    
    static func imageFromColor(fillColor color: UIColor, imageSize size: CGSize) -> UIImage? {
        
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(drawRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}



extension UIImage {
    
    //MARK: 压缩图片质量，不能保证一定小于某个大小
    
    static func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression), data.count > maxLength else {
            return image
        }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        return UIImage(data: data)!
    }
    
    //MARK: 压缩图片尺寸，可以保证压缩到小于指定尺寸
    
    static func compressImageSize(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        guard var data = image.jpegData(compressionQuality: 1) else {
            return image
        }
        print("Before compressing size, image size =", data.count / 1024, "KB")
        
        var resultImage: UIImage = image
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: 1)!
            print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
    
    //MARK: 优先压缩质量，如达不到，再压缩尺寸
    
    static func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression), data.count > maxLength else {
            return image
        }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
            print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
}
