//
//  Ass_Patten_Style5_View.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/26.
//  Copyright © 2018年 yitai. All rights reserved.
//
/*
 题干  文字

 选项 （文字、单选）


 音频播放  进来自动播放，没有点击播放，播放按钮置灰
 */



import UIKit
import Kingfisher
import Lottie

class Ass_Patten_Style8_View: Ass_Patten_View {

    var titleLabel: UILabel!
    var playView: LOTAnimationView!
    var optionViews: UIView!
    var caseDataObj: AssCase!
    var senderArray = [OptionViewByText]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for:.vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for:.vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(titleLabel)

        let iconImageView = UIImageView()
        iconImageView.image = UIImage.init(named: "trial_logo")
        self.addSubview(iconImageView)

        playView = LOTAnimationView.init(name: "playAnimation")
        playView.loopAnimation = true
        playView.isUserInteractionEnabled = true
        self.addSubview(playView)

        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(50)
            maker.left.equalTo(self.snp.left).offset(42)
            maker.right.equalTo(iconImageView.snp.left).offset(-30)
        }

        iconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(80)
            maker.top.equalTo(self.snp.top).offset(24)
            maker.right.equalTo(playView.snp.left).offset(-2)
        }

        playView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(45)
            maker.width.height.equalTo(48)
            maker.right.equalTo(self.snp.right).offset(-42)
        }

    }


    override func reloadView(withData caseData: AssCase) {

        caseDataObj = caseData

        optionViews = loadCardView(withCase: caseData)

        self.addSubview(optionViews)

        optionViews.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.left.equalTo(self.snp.left).offset(22)
            maker.right.equalTo(self.snp.right).offset(-22)
        }

        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.top).offset(-50)
            maker.bottom.equalTo(optionViews)
        }


    }


    func loadCardView(withCase caseData: AssCase) -> UIView {

        let containerView = UIView()
        containerView.isUserInteractionEnabled = true

        titleLabel.text = caseData.caseTitle

        var topView : OptionViewByText?
        var leftView: OptionViewByText?
        var firstLevelView: OptionViewByText?

        let count = caseData.optionsArray.count

        var hasTopView = false
        var hasLeftView = false
        var hasFirsetLevelView = false


        for i in 0 ..< count {

            let optionView = OptionViewByText.init(caseOption:caseData.optionsArray[i])

            optionView.tag = 501 + i
            senderArray.append(optionView)
            optionView.addTarget(self, action: #selector(selectedOption(sender:)), for: .touchUpInside)

            containerView.addSubview(optionView)
            optionView.textLabel.text = caseData.optionsArray[i].optionText

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

                optionView.snp.remakeConstraints { (maker) in
                    if hasTopView {
                        maker.top.equalTo(topView!.snp.bottom).offset(20)
                    }else {
                        maker.top.equalTo(containerView.snp.bottom).offset(45)
                    }
                    maker.left.equalTo(containerView.snp.left).offset(20)
                    maker.width.equalTo((screenWidth - 40 - 84 - 60) / 4.0 )
                    maker.height.equalTo(60)
                }

                leftView = optionView
                topView = optionView

            }else{

                if let _ = leftView {
                    optionView.snp.remakeConstraints { (maker) in
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

            containerView.snp.remakeConstraints { (maker) in
                maker.top.equalTo(firstLevelView!.snp.top)
                maker.bottom.equalTo(leftView!.snp.bottom)
            }

        }

        return containerView

    }

    @objc func selectedOption(sender: OptionViewByText) {

        for i in 0 ..< caseDataObj.optionsArray.count {

            if i == sender.tag - 501 {

                caseDataObj.optionsArray[i].isSelected = !caseDataObj.optionsArray[i].isSelected
                senderArray[i].isSelected = caseDataObj.optionsArray[i].isSelected

            }else {
                caseDataObj.optionsArray[i].isSelected = false
                senderArray[i].isSelected = false
            }

        }

        for optionObj in caseDataObj.optionsArray {

            if optionObj.isSelected {

                self.isValid = true
                return

            }else {
                self.isValid = false
            }
        }
    }


    @objc func playButtonTapped() {
        
        AVPlayerHelper.default.replay()

    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
