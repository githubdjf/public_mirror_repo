//
//  PersonalCenterCell.swift
//  FirstEducation
//
//  Created by 黄逸诚 on 2018/9/28.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SnapKit

class PersonalCenterCell: UITableViewCell {
    var titleLabel :UILabel!
    var iconImage :UIImageView!
    var lineView :UIView!
    var arrow :UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImage = UIImageView.init()
        self.contentView.addSubview(iconImage)
        
        iconImage.snp.makeConstraints{ (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(20)
            maker.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.colorFromRGBA(4, 4, 4)
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(iconImage.snp.right).offset(10)
        }
        
        arrow = UIImageView.init(image: UIImage.init(named: "right_arrow"))
        
        self.contentView.addSubview(arrow)
        
        arrow.snp.makeConstraints{ (maker) in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.right.equalTo(self.contentView.snp.right).offset(-20)
        }
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.colorFromRGBA(240, 240, 240)
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
    
    
}
