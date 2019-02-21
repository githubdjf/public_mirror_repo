//
//  OptionView.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class OptionViewByText: UIControl {

    typealias ActionBlock = (_ optionObj: AssCaseOption) -> Void
    var textLabel: UILabel!
    var selectedImageView: UIImageView!
    var actionBlock: ActionBlock?
    var caseOptionObj: AssCaseOption!

    override var isSelected: Bool {

        didSet{


            if isSelected {

                selectedImageView.isHidden = false
                self.layer.borderColor = UIColor.clear.cgColor
                self.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)

            }else{

                selectedImageView.isHidden = true
                self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
                self.backgroundColor = UIColor.white
            }

            caseOptionObj.isSelected = isSelected

        }

    }

    init(caseOption: AssCaseOption) {
        super.init(frame: .zero)

        caseOptionObj = caseOption

        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
        self.layer.borderWidth = 1

        textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        textLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(textLabel)

        selectedImageView = UIImageView()
        selectedImageView.image = UIImage.init(named: "trial_single_selected")
        selectedImageView.isHidden = !caseOption.isSelected
        self.addSubview(selectedImageView)

        textLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(3)
            maker.right.equalTo(selectedImageView.snp.right).offset(-3)
            maker.centerY.equalTo(self)
        }

        selectedImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(36)
            maker.height.equalTo(36)
            maker.centerY.equalTo(self)
            maker.right.equalTo(self.snp.right).offset(-20)
        }

        self.isSelected = caseOption.isSelected

    }


    @objc func tapped() {

        self.isSelected = !self.isSelected

        if let block = self.actionBlock {

            block(caseOptionObj)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
