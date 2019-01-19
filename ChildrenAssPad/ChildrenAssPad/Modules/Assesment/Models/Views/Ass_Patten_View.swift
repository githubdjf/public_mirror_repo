//
//  Ass_Patten_View.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class Ass_Patten_View: UIView {

    var assCase: AssCase?
    var assCaseType: AssCaseType {
        return assCase?.caseType ?? .unknow
    }
    
    func initViews() {
        
    }
    
    func layoutViews() {
        
    }
    
    func reloadView(withData caseData: AssCase) {
        
    }
}



class AssPattenCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        
    }
    
    func layoutViews() {
        
    }
    
    func reloadView(withData caseData: AssCase) {
        
    }
}


class AssPatternStyleCell: AssPattenCell {
    
    let parentWidth: CGFloat
    var defaultPatternHeight: CGFloat = 40
    var curIndexPath: IndexPath?
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        self.parentWidth = parentWidth
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = parentWidth
        self.contentView.frame.size.width = parentWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

