//
//  TrialEndViewController.swift
//  ChildrenAssPad
//
//  Created by 李雪 on 2019/2/20.
//  Copyright © 2019年 yitai. All rights reserved.
//

import UIKit
import Lottie

class TrialEndViewController: BaseViewController {

    var topView: LOTAnimationView!
    var playView: LOTAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

    }


    @objc func playButtonTapped() {

    }


    func initViews() {

        self.view.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)

        let containerCard = UIView()
        containerCard.backgroundColor = UIColor.white
        containerCard.layer.cornerRadius = 8
        containerCard.layer.masksToBounds = true
        self.view.addSubview(containerCard)

        topView = LOTAnimationView.init(name: "end")
        topView.loopAnimation = false
        topView.play()
        containerCard.addSubview(topView)

        playView = LOTAnimationView.init(name: "playAnimation")
        playView.loopAnimation = true
        playView.isUserInteractionEnabled = true
        containerCard.addSubview(playView)

        let tap = UIGestureRecognizer.init(target: self, action: #selector(playButtonTapped))
        playView.addGestureRecognizer(tap)

        let guideLabel = UILabel.init()
        guideLabel.text = "小朋友们好：我们又见面了\n感谢你与我一同完成游戏，小鹿送你一朵小红花\n现在举起你的小手，让老师发现你吧～"
        guideLabel.numberOfLines = 0
        guideLabel.setContentHuggingPriority(.required, for:.vertical)
        guideLabel.setContentCompressionResistancePriority(.required, for:.vertical)
        guideLabel.translatesAutoresizingMaskIntoConstraints = false;

        guideLabel.textAlignment = .center
        guideLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        guideLabel.font = UIFont.systemFont(ofSize: 18)
        containerCard.addSubview(guideLabel)

        containerCard.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).offset(20)
            maker.left.equalTo(self.view.snp.left).offset(20)
            maker.right.equalTo(self.view.snp.right).offset(-20)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-20)
        }

        playView.snp.makeConstraints { (maker) in
            maker.right.equalTo(containerCard.snp.right).offset(-42)
            maker.width.height.equalTo(48)
            maker.top.equalTo(containerCard.snp.top).offset(46)
        }

        topView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerCard)
            maker.width.equalTo(368)
            maker.height.equalTo(285)
            maker.top.equalTo(containerCard.snp.top).offset(142)
        }

        guideLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(18)
            maker.left.equalTo(containerCard.snp.left).offset(42)
            maker.right.equalTo(containerCard.snp.right).offset(-42)
        }
        
    }
    

}
