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
    var caseOptionObj: AssCaseOption!

    override var isSelected: Bool {

        didSet{

            if isSelected {

                selectedImageView.isHidden = false
                self.layer.borderColor = UIColor.colorFromRGBA(255, 222, 64).cgColor
            }else{
                
                selectedImageView.isHidden = true
                self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
            }

            caseOptionObj.isSelected = isSelected
        }
    }

    
    init(caseOption: AssCaseOption) {
        super.init(frame: .zero)
        caseOptionObj = caseOption

        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.colorFromRGBA(216, 216, 216).cgColor
        self.layer.borderWidth = 1

        imageView = UIImageView()
        imageView.contentMode = .center
        self.addSubview(imageView)

        selectedImageView = UIImageView()
        selectedImageView.image = UIImage.init(named: "trial_single_selected")
        selectedImageView.isHidden = !caseOption.isSelected
        self.addSubview(selectedImageView)

        imageView.snp.makeConstraints { (maker) in
           maker.edges.equalTo(self.snp.edges).inset(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15))
        }

        selectedImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(36)
            maker.height.equalTo(36)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
        }

        self.isSelected = caseOption.isSelected

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
