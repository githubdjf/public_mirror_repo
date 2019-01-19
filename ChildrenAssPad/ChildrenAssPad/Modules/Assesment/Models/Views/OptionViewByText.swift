//
//  OptionView.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class OptionViewByText: UIControl {

    typealias ActionBlock = (_ isSelected: Bool) -> Void
    var textLabel: UILabel!
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

        textLabel = UILabel()
        textLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        textLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(textLabel)

        selectedImageView = UIImageView()
        selectedImageView.image = UIImage.init(named: "trial_select_text")
        selectedImageView.isHidden = true
        self.addSubview(selectedImageView)

        textLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(selectedImageView.snp.left).offset(-10)
            maker.centerY.equalTo(self)
        }

        selectedImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(27)
            maker.height.equalTo(20)
            maker.centerY.equalTo(self)
            maker.right.equalTo(self.snp.right).offset(-20)
        }
    }


    @objc func tapped() {

        self.isSelected = !self.isSelected

        if self.isSelected {

            selectedImageView.isHidden = false
            self.layer.borderColor = UIColor.colorFromRGBA(6, 148, 121).cgColor
            textLabel.textColor = UIColor.colorFromRGBA(6, 148, 121)

        }else{

            selectedImageView.isHidden = true
            self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
            textLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        }

        if let block = self.actionBlock {

            block(self.isSelected)
            
        }


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
