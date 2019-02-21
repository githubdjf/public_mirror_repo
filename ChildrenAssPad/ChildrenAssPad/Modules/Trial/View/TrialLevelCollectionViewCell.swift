//
//  TrialLevelCollectionViewCell.swift
//  ChildrenAssPad
//
//  Created by 李雪 on 2019/2/19.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit
import Lottie

class TrialLevelCollectionViewCell: UICollectionViewCell {

    typealias StartButtonTappedBlock = () -> Void

    var imageView: UIImageView!
    var startButton: UIButton!
    var curLevelLable: UILabel!
    var startTappedBlock: StartButtonTappedBlock?

    override init(frame: CGRect) {

        super.init(frame: frame)

        imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        self.contentView.addSubview(imageView)

        let animationView = LOTAnimationView(name: "button")
        animationView.isUserInteractionEnabled = true
        animationView.loopAnimation = true
        animationView.play()

        imageView.addSubview(animationView)

        startButton = UIButton()
        startButton.backgroundColor = UIColor.clear
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        animationView.addSubview(startButton)

        curLevelLable = UILabel()
        curLevelLable.text = "第1关"
        curLevelLable.font = UIFont.systemFont(ofSize: 26)
        curLevelLable.textColor = UIColor.colorFromRGBA(255, 231, 129)
        imageView.addSubview(curLevelLable)


        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
        }

        animationView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(imageView.snp.bottom).offset(-50)
            maker.width.equalTo(186)
            maker.height.equalTo(50)
            maker.centerX.equalTo(imageView)
        }

        startButton.snp.makeConstraints { (maker) in
            maker.edges.equalTo(animationView)
        }

        curLevelLable.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(imageView.snp.centerX)
            maker.height.equalTo(15)
            maker.top.equalTo(imageView.snp.top).offset(15)
        }

    }

    @objc func startButtonTapped() {

        if let block = startTappedBlock {
            block()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
