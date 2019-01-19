//
//  Local.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/9.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation

func localStringForKey(key: String, tableName: String? = "LocalizedString", comment: String = "") -> String {
    
    return NSLocalizedString(key, tableName: tableName, comment: comment)
}
