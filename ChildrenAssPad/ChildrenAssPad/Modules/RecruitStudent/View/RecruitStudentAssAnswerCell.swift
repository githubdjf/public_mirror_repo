//
//  RecruitStudentAssAnswerCell.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/10/11.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class RecruitStudentAssAnswerCell: UITableViewCell {
    
    var answerLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        
        //answer label
        answerLabel = UILabel()
        answerLabel.font = UIFont.systemFont(ofSize: 16)
        answerLabel.textColor = UIColor.colorWithHexString(hex: "#222222")
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(.required, for: .vertical)
        answerLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(answerLabel)
        
        answerLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 9, left: 20, bottom: 9, right: 20))
        }
    }
}
