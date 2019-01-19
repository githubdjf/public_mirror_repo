//
//  StudentTrialViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/26.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON

class StudentTrialViewController: BaseViewController {

    var bgCardView: UIView!
    var cardView: UIView!
    var scrollView: UIScrollView!
    var nextButton: UIButton!
    var progressLabel: UILabel!
    var bottomProgressView: UIView!
    var progressView: UIView!
    var curProgressPercent = 0.7

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.colorFromRGBA(242, 244, 245)
        initViews()
        reloadQuestionView()

    }

    
    @objc func nextButtonTapped() {

    }


    func reloadQuestionView() {

        let view = Ass_Patten_Style5_View()
        view.reloadView(withData:nil)
        scrollView.addSubview(view)

        view.snp.makeConstraints { (maker) in
            maker.top.left.width.equalTo(scrollView)
        }

        scrollView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view.snp.bottom)
        }

    }

    func initViews() {

        bgCardView = UIView()
        bgCardView.layer.shadowColor = UIColor.colorFromRGBA(0, 0, 0, alpha: 0.3).cgColor
        bgCardView.layer.shadowRadius = 8
        bgCardView.layer.shadowOffset =  CGSize.init(width: 0, height: 0)
        self.view.addSubview(bgCardView)

        cardView = UIView()
        cardView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        cardView.layer.cornerRadius = 8
        cardView.layer.masksToBounds = true
        bgCardView.addSubview(cardView)

        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        cardView.addSubview(scrollView)

        nextButton = UIButton()
        nextButton.setBackgroundImage(UIImage.init(named: "trial_start"), for: .normal)
        nextButton.setTitle(localStringForKey(key: "student_trial_next"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cardView.addSubview(nextButton)

        progressLabel = UILabel()
        progressLabel.text = "5/25"
        progressLabel.font = UIFont.systemFont(ofSize: 16)
        progressLabel.textColor = UIColor.colorFromRGBA(153, 153, 153)
        cardView.addSubview(progressLabel)

        bottomProgressView = UIView()
        bottomProgressView.layer.cornerRadius = 4
        bottomProgressView.layer.masksToBounds = true
        bottomProgressView.backgroundColor = UIColor.colorFromRGBA(240, 240, 240)
        cardView.addSubview(bottomProgressView)

        progressView = UIView()
        progressView.layer.cornerRadius = 4
        progressView.layer.masksToBounds = true
        progressView.backgroundColor = UIColor.colorFromRGBA(6, 148, 121)
        bottomProgressView.addSubview(progressView)


        bgCardView.snp.makeConstraints { (maker) in

            maker.top.equalToSuperview().offset(18)
            maker.left.equalToSuperview().offset(18)
            maker.right.equalToSuperview().offset(-18)
            maker.bottom.equalToSuperview().offset(-18)
        }

        cardView.snp.makeConstraints { (maker) in

            maker.top.equalToSuperview().offset(4)
            maker.left.equalToSuperview().offset(4)
            maker.right.equalToSuperview().offset(-4)
            maker.bottom.equalToSuperview().offset(-4)
        }

        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardView)
            maker.left.width.equalTo(cardView)
            maker.height.equalTo(450 + 42 + 50)
        }

        nextButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(cardView.snp.right).offset(-42)
            maker.height.equalTo(60)
            maker.width.equalTo(120)
            maker.bottom.equalTo(bottomProgressView.snp.top).offset(-40)
        }


        bottomProgressView.snp.makeConstraints { (maker) in
            maker.left.equalTo(cardView.snp.left).offset(42)
            maker.right.equalTo(cardView.snp.right).offset(-42)
            maker.height.equalTo(8)
            maker.bottom.equalTo(cardView.snp.bottom).offset(-20)
        }

        progressView.snp.makeConstraints { (maker) in
            maker.left.height.top.equalTo(bottomProgressView)
            maker.width.equalTo(bottomProgressView.snp.width).multipliedBy(curProgressPercent)
        }

        progressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(progressView)
            maker.height.equalTo(22)
            maker.bottom.equalTo(progressView.snp.top).offset(-10)
        }

    }
    

}
