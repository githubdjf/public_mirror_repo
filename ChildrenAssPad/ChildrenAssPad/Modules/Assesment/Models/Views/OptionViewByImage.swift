//
//  OptionViewByImage.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/26.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class OptionViewByImage: UIControl {

    typealias ActionBlock = (_ isSelected: Bool) -> Void
    var imageView: UIImageView!
    var selectedImageView: UIImageView!
    var actionBlock: ActionBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
        self.layer.borderWidth = 1
        self.isSelected = false
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        imageView = UIImageView()
        imageView.backgroundColor = UIColor.randomColor
        self.addSubview(imageView)

        selectedImageView = UIImageView()
        selectedImageView.image = UIImage.init(named: "trial_select_image")
        selectedImageView.isHidden = true
        self.addSubview(selectedImageView)

        imageView.snp.makeConstraints { (maker) in
           maker.edges.equalTo(self.snp.edges).inset(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15))
        }

        selectedImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
    }


    @objc func tapped() {

        self.isSelected = !self.isSelected

        if self.isSelected {

            selectedImageView.isHidden = false
            self.layer.borderColor = UIColor.colorFromRGBA(6, 148, 121).cgColor

        }else{

            selectedImageView.isHidden = true
            self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
        }

        if let block = self.actionBlock {

            block(self.isSelected)
        }


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
