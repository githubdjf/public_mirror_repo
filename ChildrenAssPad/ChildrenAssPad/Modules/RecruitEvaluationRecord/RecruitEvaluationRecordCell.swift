//
//  RecruitEvaluationRecordCell.swift
//  FirstEducation
//
//  Created by 黄逸诚 on 2018/9/29.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SnapKit

class RecruitEvaluationRecordCell: UITableViewCell {
    
    typealias ActionBlock = () ->Void
    
    var name:UILabel!
    var sex:UILabel!
    var birthday:UILabel!
    var parentPhone:UILabel!
    var parentName:UILabel!
    var evaluationDate:UILabel!
    var report:UIButton!
    
    var reportBlock:ActionBlock?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        name = getIndexView()
        self.contentView.addSubview(name)
        name.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(self.contentView.snp.left)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        sex = getIndexView()
        self.contentView.addSubview(sex)
        sex.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(name.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        birthday = getIndexView()
        self.contentView.addSubview(birthday)
        birthday.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(sex.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        parentName = getIndexView()
        self.contentView.addSubview(parentName)
        parentName.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(birthday.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        parentPhone = getIndexView()
        self.contentView.addSubview(parentPhone)
        parentPhone.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(parentName.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        evaluationDate = getIndexView()
        self.contentView.addSubview(evaluationDate)
        evaluationDate.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(parentPhone.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        report = UIButton.init()
        report.isEnabled = false
        self.contentView.addSubview(report)
        report.setTitle("查看", for: .normal)
        report.setTitleColor(UIColor.colorWithHexString(hex: "#0a6fa9"), for: .normal)
        report.isUserInteractionEnabled = false
        report.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(evaluationDate.snp.right)
            maker.width.equalTo(self.contentView).dividedBy(7)
        }
        
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHexString(hex: "#f0f0f0")
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints{ (maker) in
            maker.bottom.equalTo(self.contentView.snp.bottom)
            maker.height.equalTo(2)
            maker.left.equalTo(self.contentView.snp.left).offset(20)
            maker.right.equalTo(self.contentView.snp.right).offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getIndexView() -> UILabel {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexString(hex: "#555555")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }
    

}
