//
//  Ass_Patten_Style2_View.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/26.
//  Copyright © 2018年 yitai. All rights reserved.
//


/*
 题干  文字


 选项 （图片， 单选）


 音频播放  进来就自动播放，点击暂停，暂停状态下点击重新播放
 */



import UIKit

class Ass_Patten_Style5_View: Ass_Patten_View {

    var titleLabel: UILabel!
    var playButton: UIButton!
    var optionViews: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for:.vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for:.vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(titleLabel)

        playButton = UIButton()
        playButton.setImage(UIImage.init(named: "trial_play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.addSubview(playButton)


        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(50)
            maker.left.equalTo(self.snp.left).offset(42)
            maker.right.equalTo(playButton.snp.left).offset(124)
        }

        playButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(42)
            maker.width.height.equalTo(36)
            maker.right.equalTo(self.snp.right).offset(-42)
        }

    }


    override func reloadView(withData caseData: AssCase?) {

        optionViews = loadCardView(withCase: caseData)

        self.addSubview(optionViews)

        optionViews.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(60)
            maker.left.equalTo(self.snp.left).offset(22)
            maker.right.equalTo(self.snp.right).offset(-22)
        }

        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.top).offset(-50)
            maker.bottom.equalTo(optionViews)
        }
    }


    func loadCardView(withCase caseData: AssCase?) -> UIView {

        let containerView = UIView()

        titleLabel.text = "1、仔细看下面两张图，找一找一共有几处不同？\n（第二行)\n（最多三行文字）"

        var topView : OptionViewByImage?
        var leftView: OptionViewByImage?
        var firstLevelView: OptionViewByImage?

        //        let count = caseData.optionsArray.count
        let count = 4

        var hasTopView = false
        var hasLeftView = false
        var hasFirsetLevelView = false


        for i in 0 ..< count {

            let optionView = OptionViewByImage()
            optionView.imageView.backgroundColor = UIColor.randomColor
            containerView.addSubview(optionView)

            if let _ = topView {
                hasTopView = true
            }else{
                hasTopView = false
            }

            if let _ = leftView {
                hasLeftView = true
            }else{
                hasLeftView = false
            }


            if i % 4 == 0 {

                optionView.snp.makeConstraints { (maker) in
                    if hasTopView {
                        maker.top.equalTo(topView!.snp.bottom).offset(20)
                    }else {
                        maker.top.equalTo(containerView.snp.bottom).offset(20)
                    }
                    maker.left.equalTo(containerView.snp.left).offset(20)
                    maker.width.height.equalTo((screenWidth - 40 - 84 - 60) / 4.0 )
                }

                leftView = optionView
                topView = optionView

            }else{

                if let _ = leftView {
                    optionView.snp.makeConstraints { (maker) in
                        maker.top.equalTo(leftView!.snp.top)
                        maker.left.equalTo(leftView!.snp.right).offset(20)
                        maker.width.equalTo(leftView!.snp.width)
                        maker.height.equalTo(leftView!.snp.height)
                    }

                    leftView = optionView
                }
            }


            if i == 0 {
                firstLevelView = optionView
                hasFirsetLevelView = true
            }

        }

        if hasFirsetLevelView && hasLeftView {

            containerView.snp.makeConstraints { (maker) in
                maker.top.equalTo(firstLevelView!.snp.top)
                maker.bottom.equalTo(leftView!.snp.bottom)
            }

        }

        return containerView

    }

    @objc func playButtonTapped() {

    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
}
