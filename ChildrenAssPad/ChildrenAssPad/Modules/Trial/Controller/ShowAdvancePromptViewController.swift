//
//  ShowLevelPromptViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/12/19.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class ShowAdvancePromptViewController: BaseViewController {

    typealias ActionBlock = ()->Void
    var bottomImageView: UIImageView!
    var topHeaderImageView: UIImageView!
    var promptLabel: UILabel!
    var confirmButton: UIButton!
    var actionBlock: ActionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, alpha: 0.5)

        bottomImageView = UIImageView.init()
        bottomImageView.isUserInteractionEnabled = true
        bottomImageView.image = UIImage.init(named: "trial_advance_prompt")
        self.view.addSubview(bottomImageView)

        topHeaderImageView = UIImageView.init()
        topHeaderImageView.image = UIImage.init(named: "trial_header_top")
        self.view.addSubview(topHeaderImageView)

        confirmButton = UIButton()
        confirmButton.setBackgroundImage(UIImage.init(named: "trial_start"), for: .normal)
        confirmButton.setTitle(localStringForKey(key: "show_advance_prompt_go"), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.titleLabel?.textColor = UIColor.white
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bottomImageView.addSubview(confirmButton)

        promptLabel = UILabel()
        promptLabel.text = localStringForKey(key: "show_advance_prompt")
        promptLabel.font = UIFont.systemFont(ofSize:16)
        promptLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
        bottomImageView.addSubview(promptLabel)

        bottomImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view.center)
            maker.width.equalTo(416)
            maker.height.equalTo(276)
        }

        topHeaderImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomImageView.snp.top).offset(-27)
            maker.width.height.equalTo(120)
            maker.centerX.equalTo(bottomImageView.snp.centerX)
        }

        promptLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topHeaderImageView.snp.bottom).offset(25)
            maker.left.equalTo(bottomImageView.snp.left).offset(72)
            maker.right.equalTo(bottomImageView.snp.right).offset(-72)
        }

        confirmButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(promptLabel.snp.centerX)
            maker.height.equalTo(60)
            maker.width.equalTo(120)
            maker.bottom.equalTo(bottomImageView.snp.bottom).offset(-28)
        }

        
    }


    @objc func confirmButtonTapped() {


        if let block = actionBlock {
            block()
        }

        self.dismiss(animated: false, completion: nil)

    }


}
