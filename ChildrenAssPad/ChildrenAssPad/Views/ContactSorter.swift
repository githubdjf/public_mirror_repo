//
//  ContactSorter.swift
//  EasyPhone
//
//  Created by Jaffer on 2017/8/21.
//  Copyright © 2017年 yitai. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

@objc protocol Sortable {
    
    @objc var sortKey: String {get}
}

/*
 
 func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 
    return UILocalizedIndexedCollation.current().sectionTitles[section]
 }
 
 func sectionIndexTitles(for tableView: UITableView) -> [String]? {
 
    return UILocalizedIndexedCollation.current().sectionTitles
 }
 
 func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
 
    return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
 }
 */

class ContactSorter: NSObject  {
    
    class func sort(contacts: [Sortable]?) -> [[Sortable]]? {
        
        var sectionArray: [[Sortable]]?
        
        guard let rawContacts = contacts else {
            
            return sectionArray
        }
        
        let indexedCollation = UILocalizedIndexedCollation.current()
        
        //获取section标题
        let sectionTitles = indexedCollation.sectionTitles
        
        //创建对应数量的分组
        var tempSectionArray = [[Sortable]]()
        
        for _ in 0 ..< sectionTitles.count {
            
            tempSectionArray.append([Sortable]())
        }
        
        //将需要排序的数据放入相应分区中
        for contact in rawContacts {
            
            let sectionIndex = indexedCollation.section(for: contact, collationStringSelector: #selector(getter: Sortable.sortKey))
            
            var sectionContainer = tempSectionArray[sectionIndex]
            
            sectionContainer.append(contact)
            
            tempSectionArray[sectionIndex] = sectionContainer
        }
        
        //对每个分区中的数据进行排序
        sectionArray = [[Sortable]]()
        
        for sectionContainer in tempSectionArray {
            
            
            var sortedArr = sectionContainer
            
            if sectionContainer.count > 0 {
            
                sortedArr = indexedCollation.sortedArray(from: sectionContainer , collationStringSelector: #selector(getter: Sortable.sortKey)) as! [Sortable]

            }
            
            sectionArray?.append(sortedArr)
        }
        
        return sectionArray
    }
}


extension ContactSorter {
    
    class func sortAsObservable(contacts: [Sortable]?) -> Observable<[[Sortable]]> {
        
        guard let contacts = contacts else {
            
            return Observable.just([[Sortable]]())
        }
        
        guard let sorted = sort(contacts: contacts) else {
            
            return Observable.just([[Sortable]]())
        }
        
        return Observable.just(sorted)
    }
}






