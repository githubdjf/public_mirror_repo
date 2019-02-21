//
//  TrialGuideViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//


//测评引导语

import UIKit
import Lottie

class TrialGuideViewController: BaseViewController {

    var topView: LOTAnimationView!
    var playView: LOTAnimationView!


    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()

    }


    @objc func playButtonTapped() {

    }

    @objc func goButtonTapped() {

        let vc = StudentTrialViewController()

        self.navigationController?.pushViewController(vc, animated: true)

    }




    func initViews() {

        self.view.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)

        let containerCard = UIView()
        containerCard.backgroundColor = UIColor.white
        containerCard.layer.cornerRadius = 8
        containerCard.layer.masksToBounds = true
        self.view.addSubview(containerCard)

        topView = LOTAnimationView.init(name: "welcome")
        topView.loopAnimation = false
        containerCard.addSubview(topView)


        playView = LOTAnimationView.init(name: "playAnimation")
        playView.loopAnimation = true
        playView.isUserInteractionEnabled = true
        containerCard.addSubview(playView)

        let tap = UIGestureRecognizer.init(target: self, action: #selector(playButtonTapped))
        playView.addGestureRecognizer(tap)

        let guideLabel = UILabel.init()
        guideLabel.text = "小朋友们好：我叫小鹿，现在我邀请你和我一起完成一个游戏。\n 在做游戏前呢，小鹿想要与小朋友讲一下游戏规则"
        guideLabel.numberOfLines = 0
        guideLabel.textAlignment = .center
        guideLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        guideLabel.font = UIFont.systemFont(ofSize: 18)
        containerCard.addSubview(guideLabel)

        let round1 = UIView()
        round1.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)
        round1.layer.cornerRadius = 10
        round1.layer.masksToBounds = true
        containerCard.addSubview(round1)


        let round2 = UIView()
        round2.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)
        round2.layer.cornerRadius = 10
        round2.layer.masksToBounds = true
        containerCard.addSubview(round2)


        let rule1 = UILabel()

        let pre = "1、在玩游戏时，我们需要把"
        let attPre = NSMutableAttributedString(string: pre)
        attPre.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: pre.count))
        attPre.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorFromRGBA(34, 34, 34), range: NSRange(location: 0, length: pre.count))

        let mid = "所有的关卡一起做完"
        let attMid = NSMutableAttributedString(string: mid)
        attMid.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: mid.count))
        attMid.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorFromRGBA(235, 96, 41), range: NSRange(location: 0, length: mid.count))

        let suff = "哦，做完的小同学会看到页面上小鹿奖励的小红花"
        let attSuff = NSMutableAttributedString(string: suff)
        attSuff.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: suff.count))
        attSuff.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorFromRGBA(34, 34, 34), range: NSRange(location: 0, length: suff.count))

        attPre.append(attMid)
        attPre.append(attSuff)

        rule1.attributedText = attPre
        containerCard.addSubview(rule1)


        let rule2 = UILabel()
        rule2.font = UIFont.systemFont(ofSize: 16)
        rule2.textColor = UIColor.colorFromRGBA(34, 34, 34)
        rule2.text = "2、在没有听清楚的地方，可以找小鹿的喇叭哦，会为你再次播放，或举起小手，问问老师"
        containerCard.addSubview(rule2)

        let promptLabel = UILabel()
        promptLabel.font = UIFont.systemFont(ofSize: 16)
        promptLabel.textColor = UIColor.colorFromRGBA(85, 85, 85)
        promptLabel.textAlignment = .center
        promptLabel.text = "准备好了吗？"
        containerCard.addSubview(promptLabel)


        let goButton = UIButton()
        goButton.setImage(UIImage.init(named: "trial_go@2x"), for: .normal)
        goButton.setImage(UIImage.init(named: "trial_go_select@2x"), for: .highlighted)
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        containerCard.addSubview(goButton)

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
            maker.width.equalTo(300)
            maker.height.equalTo(300)
            maker.top.equalTo(containerCard.snp.top).offset(70)
        }

        guideLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(18)
            maker.left.equalTo(containerCard.snp.left).offset(42)
            maker.right.equalTo(containerCard.snp.right).offset(-42)
            maker.height.equalTo(60)
        }

        round1.snp.makeConstraints { (maker) in
            maker.left.equalTo(containerCard.snp.left).offset(130)
            maker.width.height.equalTo(10)
            maker.top.equalTo(guideLabel.snp.bottom).offset(20)
        }

        rule1.snp.makeConstraints { (maker) in
            maker.left.equalTo(round1.snp.right).offset(20)
            maker.height.equalTo(20)
            maker.centerY.equalTo(round1)
        }

        round2.snp.makeConstraints { (maker) in
            maker.width.height.left.equalTo(round1)
            maker.top.equalTo(round1.snp.bottom).offset(20)
        }

        rule2.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(round2)
            maker.height.left.equalTo(rule1)
        }

        promptLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerCard)
            maker.height.equalTo(20)
            maker.top.equalTo(rule2.snp.bottom).offset(32)
        }

        goButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerCard)
            maker.width.height.equalTo(90)
            maker.top.equalTo(promptLabel.snp.bottom).offset(10)
        }

    }

}
