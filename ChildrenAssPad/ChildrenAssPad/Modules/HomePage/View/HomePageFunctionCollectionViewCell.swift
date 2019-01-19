//
//  HomePageFunctionCollectionViewCell.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/9/30.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit

class HomePageFunctionCollectionViewCell: UICollectionViewCell {
    
    var shadowImg: UIImageView!
    var titleL: UILabel!
    var iconImg: UIImageView!
    var enableImg: UIImageView!
    var enableL: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    
    func createUI() -> Void {
        shadowImg = UIImageView()
        contentView.addSubview(shadowImg)
        shadowImg.image = UIImage(named: "home_shadow")
        shadowImg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        enableL = UILabel()
        contentView.addSubview(enableL)
        enableL.textColor = UIColor.colorWithHexString(hex: "069479")
        enableL.font = UIFont.systemFont(ofSize: 14)
        enableL.textAlignment = .center
        enableL.text = localStringForKey(key: "homepage_enable_tip")
        enableL.layer.cornerRadius = 13
        enableL.layer.borderColor = UIColor.colorWithHexString(hex: "069479").cgColor
        enableL.layer.borderWidth = 1
        enableL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 26))
            make.right.equalTo(-20)
            make.top.equalTo(20)
        }
        
        enableImg = UIImageView()
        contentView.addSubview(enableImg)
        enableImg.image = UIImage(named: "home_not_enable")
        enableImg.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 26, height: 26))
            make.top.equalTo(20)
            make.right.equalTo(-20)
        }
        
        titleL = UILabel()
        contentView.addSubview(titleL)
        titleL.textColor = UIColor.colorWithHexString(hex: "222222")
        titleL.font = UIFont.systemFont(ofSize: 20)
        titleL.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.right.equalTo(-90)
            make.height.equalTo(28)
        }
        
        
        iconImg = UIImageView()
        contentView.addSubview(iconImg)
        iconImg.snp.makeConstraints { (make) in
            make.top.equalTo(68)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 160, height: 160))
        }
        
    }
    
    func configureCell(model: HomePageFunctionModel, iconArray: [String], index: IndexPath) -> Void {
        iconImg.image = UIImage(named: iconArray[index.item])
        titleL.text = model.name
        if model.isCan == 0 {
            enableImg.isHidden = false
            enableL.isHidden = true
        } else {
            enableImg.isHidden = true
            enableL.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
