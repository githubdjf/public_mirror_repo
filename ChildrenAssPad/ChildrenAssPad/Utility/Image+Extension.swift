//
//  ImageView+Extension.swift
//  zp_chu
//
//  Created by 李雪 on 2018/7/27.
//  Copyright © 2018年 yitai. All rights reserved.
//


extension UIImage {

    class func getImageWithColor(color:UIColor)->UIImage{

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
