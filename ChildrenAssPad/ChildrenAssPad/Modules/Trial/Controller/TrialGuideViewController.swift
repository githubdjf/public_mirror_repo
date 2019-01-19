//
//  TrialGuideViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/23.
//  Copyright © 2018年 yitai. All rights reserved.
//


//测评引导语

import UIKit
import Kingfisher

class TrialGuideViewController: BaseViewController {

    var titleLabel: UILabel!
    var trialLabel: UILabel!
    var containerCard: UIView!
    var topIconImageView: UIImageView!
    var userNameLabel: UILabel!
    var lineView: UIView!
    var guideTitleLabel: UILabel!
    var guideContentLabel: UILabel!
    var readyLabel: UILabel!
    var startButton: UIButton!
    var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()

    }


    @objc func playButtonTapped() {

    }

    @objc func startButtonTapped() {

    }




    func initViews() {

        let navView = UIView()
        navView.backgroundColor = UIColor.colorFromRGBA(6, 148, 121)
        self.view.addSubview(navView)

        let backButton = UIButton()
        backButton.setImage(UIImage.init(named: "common_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        navView.addSubview(backButton)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "2019秋季测评"
        navView.addSubview(titleLabel)

        trialLabel = UILabel()
        trialLabel.font = UIFont.systemFont(ofSize: 14)
        trialLabel.textColor = UIColor.white
        trialLabel.backgroundColor = UIColor.colorFromRGBA(255, 255, 255, alpha: 0.2)
        trialLabel.layer.cornerRadius = 12
        trialLabel.layer.masksToBounds = true
        trialLabel.text = "  正在为王点测评 — 儿童测评  "
        navView.addSubview(trialLabel)

        let bgView = UIControl()
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.colorFromRGBA(5, 0, 54).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0.15)
        bgView.layer.shadowOpacity = 0.15;
        self.view.addSubview(bgView)


        containerCard = UIView()
        containerCard.backgroundColor = UIColor.white.withAlphaComponent(1)
        containerCard.layer.masksToBounds = true
        containerCard.layer.cornerRadius = 8
        containerCard.isUserInteractionEnabled = false
        bgView.addSubview(containerCard)

        playButton = UIButton()
        playButton.setImage(UIImage.init(named: "trial_play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        containerCard.addSubview(playButton)

        topIconImageView = UIImageView()

        let path = Bundle.main.path(forResource: "animation", ofType: "gif")
        let url = URL.init(fileURLWithPath: path ?? "")
        topIconImageView.kf.setImage(with:ImageResource.init(downloadURL: url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        containerCard.addSubview(topIconImageView)

        userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        userNameLabel.textColor = UIColor.colorFromRGBA(34, 34, 34, alpha: 1)
        userNameLabel.text = "王点"
        containerCard.addSubview(userNameLabel)

        guideTitleLabel = UILabel()
        guideTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        guideTitleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34, alpha: 1)
        guideTitleLabel.text = "小朋友们好，下面的测评游戏需要与你共同来完成："
        containerCard.addSubview(guideTitleLabel)

        lineView = UIView()
        lineView.backgroundColor = UIColor.colorFromRGBA(6, 148, 121)
        containerCard.addSubview(lineView)

        guideContentLabel = UILabel()
        guideContentLabel.font = UIFont.systemFont(ofSize: 15)
        guideContentLabel.textColor = UIColor.colorFromRGBA(15, 15, 15)
        guideContentLabel.text = "在做之前，先说几点游戏规则\n1、我们要有耐心完成所有的测评哦\n2、在测评游戏的过程中，我们要听老师的话\n3、我们的游戏共7关哦\n4、在所有游戏完成后，我们将会对表现好的小朋友，赠送小贴画"
        guideContentLabel.numberOfLines = 0
        guideContentLabel.setContentHuggingPriority(.required, for:.vertical)
        guideContentLabel.setContentCompressionResistancePriority(.required, for:.vertical)
        guideContentLabel.translatesAutoresizingMaskIntoConstraints = false;
        containerCard.addSubview(guideContentLabel)

        readyLabel = UILabel()
        readyLabel.text = localStringForKey(key: "trial_guide_ready")
        readyLabel.font = UIFont.systemFont(ofSize: 16)
        readyLabel.textColor = UIColor.colorFromRGBA(153, 153, 153)
        containerCard.addSubview(readyLabel)

        startButton  = UIButton()
        startButton.setBackgroundImage(UIImage.init(named: "trial_start"), for: .normal)
        startButton.setTitle(localStringForKey(key: "trial_guide_start"), for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.titleLabel?.textColor = UIColor.white
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        containerCard.addSubview(startButton)

        navView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view)
            maker.left.width.equalTo(self.view)
            maker.height.equalTo(navBarHeight())
        }

        backButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(navView).offset(10)
            maker.width.height.equalTo(20)
            maker.left.equalTo(navView.snp.left).offset(20)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(navView)
            maker.height.equalTo(20)
            maker.centerY.equalTo(navView)
        }

        trialLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.height.equalTo(24)
            maker.centerY.equalTo(titleLabel)
        }

        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(20)
            maker.top.equalTo(navView.snp.bottom).offset(20)
            maker.right.equalTo(self.view.snp.right).offset(-20)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-20)
        }

        containerCard.snp.makeConstraints { (maker) in
            maker.edges.equalTo(bgView.snp.edges).inset(UIEdgeInsets.init(top: 4, left: 4, bottom: -4, right: -4))
        }

        topIconImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerCard)
            maker.top.equalTo(containerCard.snp.top).offset(40)
            maker.width.height.equalTo(240)
        }

        playButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerCard.snp.top).offset(42)
            maker.width.height.equalTo(36)
            maker.right.equalTo(containerCard.snp.right).offset(-42)
        }

        userNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(containerCard.snp.left).offset(274)
            maker.height.equalTo(30)
            maker.top.equalTo(topIconImageView.snp.bottom).offset(30)
        }

        lineView.snp.makeConstraints { (maker) in
            maker.right.equalTo(userNameLabel).offset(6)
            maker.left.equalTo(userNameLabel).offset(-6)
            maker.height.equalTo(4)
            maker.top.equalTo(userNameLabel.snp.bottom)
        }

        guideTitleLabel.snp.makeConstraints { (maker) in
            maker.height.centerY.equalTo(userNameLabel)
            maker.left.equalTo(userNameLabel.snp.right)
        }

        guideContentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(userNameLabel)
            maker.right.equalTo(guideTitleLabel)
            maker.top.equalTo(lineView.snp.bottom).offset(10)
        }

        startButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(containerCard.snp.bottom).offset(-70)
            maker.height.equalTo(60)
            maker.width.equalTo(120)
            maker.centerX.equalTo(containerCard)
        }

        readyLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(startButton.snp.top).offset(-5)
            maker.height.equalTo(20)
            maker.centerX.equalTo(startButton)
        }




    }

}
