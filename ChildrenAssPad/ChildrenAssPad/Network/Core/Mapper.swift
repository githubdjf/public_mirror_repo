//
//  Mapper.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

protocol Mappable {
    init?(jsonData: JSON)
}


class Mapper {
    
    private static func objectFromJSON<T: Mappable>(jsonData: JSON, classType: T.Type) -> T? {
        
        return T(jsonData: jsonData)
    }
    
    
    class func mapToObject<T: Mappable>(data: Any, type: T.Type) throws -> T {
        
        if let data = data as? Data {
            
            guard let jsonObj = try? JSON(data: data) else {
                throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
            }
            
            guard let obj = self.objectFromJSON(jsonData: jsonObj, classType: type) else {
                throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
            }
            
            return obj
            
        } else if let data = data as? JSON {
            
            guard let obj = self.objectFromJSON(jsonData: data, classType: type) else {
                throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
            }
            
            return obj
        } else {
            
            throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
        }
    }
    
    
    class func mapToObjectArray<T: Mappable>(data: Any, type: T.Type) throws -> [T] {
        
        if let data = data as? Data {
            
            guard let jsonArray = try? JSON(data: data) else {
                throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
            }
            
            var objectsArray = [T]()
            for (_, json) in jsonArray {
                let object = try Mapper.mapToObject(data: json.rawData(), type: type)
                objectsArray.append(object)
            }
            return objectsArray
            
        } else if let jsonArray = data as? JSON {
            
            var objectsArray = [T]()
            for json in jsonArray {
                let object = try Mapper.mapToObject(data: json, type: type)
                objectsArray.append(object)
            }
            return objectsArray
            
        } else {
            
            throw APPError.appDataError(APPErrorFactory.generateBusiError(busiCode: APPCode.BusiErrorCode.appDataErrorCode))
        }
    }
}


extension Observable {
    
    func mapToObject<T: Mappable>(type: T.Type) -> Observable<T?> {
        
        return map{ data in
            
            let obj = try Mapper.mapToObject(data: data, type: type)
            return obj
        }
    }
    
    
    func mapToObjectArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        
        return map{ data in
            let objArray = try Mapper.mapToObjectArray(data: data, type: type)
            return objArray
        }
    }
    
}
