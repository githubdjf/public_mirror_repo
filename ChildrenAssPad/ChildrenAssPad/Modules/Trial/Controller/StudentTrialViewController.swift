//
//  StudentTrialViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/26.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Lottie

class StudentTrialViewController: BaseViewController {

    var bgCardView: UIView!
    var cardView: UIView!
    var scrollView: UIScrollView!
    var nextButton: UIButton!
    var progressLabel: UILabel!
    var bottomProgressView: UIView!
    var progressView: UIView!
    var pattenView: Ass_Patten_View!
    let levelVC = TrialLevelViewController()

    var paper: AssPaper!
    var branch: AssBranch!

    var curProgressPercent: Double = 0.0
    var curBranchIndex  = 0
    var curCaseIndex: Int = 0 {
        didSet{

            if branch.caseListArray.count > 0 && progressLabel != nil && progressView != nil {

                curProgressPercent = Double(CGFloat(curCaseIndex + 1)/CGFloat(branch.caseListArray.count))
                progressLabel.text = "\(curCaseIndex + 1)/\(branch.caseListArray.count)"
                progressView.snp.remakeConstraints { (maker) in
                    maker.left.height.top.equalTo(bottomProgressView)
                    maker.width.equalTo(bottomProgressView.snp.width).multipliedBy(curProgressPercent)
                }
            }


            if curCaseIndex == branch.caseListArray.count - 1 {
                nextButton.setTitle(localStringForKey(key: "student_trial_submit"), for: .normal)
            }else{
                nextButton.setTitle(localStringForKey(key: "student_trial_next"), for: .normal)
            }

        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.colorFromRGBA(255, 222, 64)
        loadData()
        initViews()

        showLevelView()

    }


    func loadData() {

        if let exam = FileLoader.loadExamData(fromFile: "first_trial_json5") {

            if exam.paperArray.count > 0 {
                paper = exam.paperArray[0]
            }

            curBranchIndex = paper.curBranch
            branch = paper.branchArray[curBranchIndex]

        }
    }


    func creatPlayer() {

    }
    

    func showLevelView() {

//        var animationView = LOTAnimationView.init()
//
//
//        switch curBranchIndex {
//        case 0:
//            animationView = LOTAnimationView.init(name: "first")
//        case 1:
//            animationView = LOTAnimationView.init(name: "second")
//        case 2:
//             animationView = LOTAnimationView.init(name: "third")
//        case 3:
//             animationView = LOTAnimationView.init(name: "forth")
//        case 4:
//             animationView = LOTAnimationView.init(name: "fifth")
//        case 5:
//             animationView = LOTAnimationView.init(name: "sixth")
//        default:
//            break
//        }
//
//        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        animationView.contentMode = .scaleAspectFit
//        animationView.clipsToBounds = true
//
//        animationView.loopAnimation = false
//        self.view.addSubview(animationView)
//
//        AVPlayerHelper.default.loadAudio(audioUrl: "advance", isLocal: true)
//
//        animationView.play{[weak self] (finished) in
//
//            if let weakSelf = self {
//
//                let vc = ShowAdvancePromptViewController()
//                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                vc.actionBlock = {
//                    animationView.removeFromSuperview()
//                    weakSelf.curCaseIndex = 0
//                    AVPlayerHelper.default.pausePlay()
//                }
//
//                weakSelf.present(vc, animated: false, completion: nil)
//            }
//
//        }
//
//        animationView.snp.makeConstraints { (maker) in
//            maker.edges.equalTo(self.view)
//        }




        levelVC.startBlock = { [weak self] in

            if let weakSelf = self {

                weakSelf.levelVC.view.removeFromSuperview()
            }

        }


        self.view.addSubview(levelVC.view)

        levelVC.view.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view)
        }



        self.curCaseIndex = 0
        self.reloadQuestionView()




    }

    
    @objc func nextButtonTapped() {

        if !pattenView.isValid {
            Prompter.showTextToast(localStringForKey(key: "student_trial_no_select"), inView: self.view)
            return
        }

        if curCaseIndex + 1 == branch.caseListArray.count {

            curBranchIndex = curBranchIndex + 1

            if curBranchIndex != paper.total{
                branch = paper.branchArray[curBranchIndex]
                showLevelView()

            }else{

                for controller in self.navigationController?.viewControllers ?? [] {

//                    if controller.isKind(of: CheckStudentEvaluationProgressViewController.self) {
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
                }
            }

        }else{

            curCaseIndex = curCaseIndex + 1
            curProgressPercent = Double(CGFloat(curCaseIndex)/CGFloat(branch.caseListArray.count))
            reloadQuestionView()
        }



    }


    func reloadQuestionView() {

//        case selectionPatten4 = 4
//
//        /*
//         题干： 文字
//         选项： 单选（图片）
//         音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
//         */
//        case selectionPatten5 = 5
//
//        /*
//         题干： 文字
//         选项： 单选（图片）
//         音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
//         */
//        case selectionPatten6 = 6
//
//        /*
//         题干： 文字
//         选项： 单选（图片）
//         音频：进来就自动播放，点击暂停，暂停状态下点击重新播放
//         */
//        case selectionPatten7 = 7
//
//        /*
//         题干： 文字
//         选项： 单选（图片,gif不可以循环播放）
//         音频：进来自动播放，没有点击播放，播放按钮置灰
//         */
//        case selectionPatten8 = 8


        if branch.caseListArray.count > curCaseIndex {

            for view in scrollView.subviews {
                view.removeFromSuperview()
            }


            if branch.caseListArray[curCaseIndex].casePattern ==  .selectionPatten4 {

                let view = Ass_Patten_Style4_View()
                pattenView = view
                view.reloadView(withData:branch.caseListArray[curCaseIndex])
                scrollView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.top.left.width.equalTo(scrollView)
                }

                scrollView.snp.makeConstraints { (maker) in
                    maker.bottom.equalTo(view.snp.bottom)
                }

            }else if branch.caseListArray[curCaseIndex].casePattern ==  .selectionPatten5 {

                let view = Ass_Patten_Style5_View()
                pattenView = view
                view.reloadView(withData:branch.caseListArray[curCaseIndex])
                scrollView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.top.left.width.equalTo(scrollView)
                }

                scrollView.snp.makeConstraints { (maker) in
                    maker.bottom.equalTo(view.snp.bottom)
                }


            }else if branch.caseListArray[curCaseIndex].casePattern ==  .selectionPatten6 {

                let view = Ass_Patten_Style6_View()
                pattenView = view
                view.reloadView(withData:branch.caseListArray[curCaseIndex])
                scrollView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.top.left.width.equalTo(scrollView)
                }

                scrollView.snp.makeConstraints { (maker) in
                    maker.bottom.equalTo(view.snp.bottom)
                }


            }else if branch.caseListArray[curCaseIndex].casePattern ==  .selectionPatten7 {

                let view = Ass_Patten_Style7_View()
                pattenView = view
                view.reloadView(withData:branch.caseListArray[curCaseIndex])
                scrollView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.top.left.width.equalTo(scrollView)
                }

                scrollView.snp.makeConstraints { (maker) in
                    maker.bottom.equalTo(view.snp.bottom)
                }


            }else if branch.caseListArray[curCaseIndex].casePattern ==  .selectionPatten8 {

                let view = Ass_Patten_Style8_View()
                pattenView = view
                view.reloadView(withData:branch.caseListArray[curCaseIndex])
                scrollView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.top.left.width.equalTo(scrollView)
                }

                scrollView.snp.makeConstraints { (maker) in
                    maker.bottom.equalTo(view.snp.bottom)
                }

            }

            AVPlayerHelper.default.loadAudio(audioUrl: branch.caseListArray[curCaseIndex].caseAudio)
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
        nextButton.setImage(UIImage.init(named: "trial_next_normal"), for: .normal)
        nextButton.setImage(UIImage.init(named: "trial_next_selected"), for: .selected)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cardView.addSubview(nextButton)

        progressLabel = UILabel()
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
        progressView.backgroundColor = UIColor.mainColor
        bottomProgressView.addSubview(progressView)

        curProgressPercent = Double(0)

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
            maker.height.equalTo(71)
            maker.width.equalTo(68)
            maker.bottom.equalTo(bottomProgressView.snp.top).offset(-16)
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
