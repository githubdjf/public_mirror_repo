//
//  Ass_Patten_PassThroughView.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/9/30.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 单选，必选 通过/未通过
 */


import UIKit

fileprivate let passThroughItemBaseTag = 1000

class Ass_Patten_PassThroughView: Ass_Patten_View {

    var contentBgView: UIView!
    var titleLabel: UILabel!
    var firstButton: UIButton!
    var secondButton: UIButton!
    var optionButtonArray = [UIButton]()
    
    @objc func caseOptionClicked(button: UIButton) {
        
        if let curCase = assCase {
            if curCase.optionsArray.count >= 2 {
                
                //reset
                let firstOption = curCase.optionsArray[0]
                setOptionItemSelectedStatus(forItemButton: firstButton, caseOption: firstOption, isSelected: false)
                
                let secondOption = curCase.optionsArray[1]
                setOptionItemSelectedStatus(forItemButton: secondButton, caseOption: secondOption, isSelected: false)
                
                //set
                let index = button.tag - passThroughItemBaseTag
                let caseOption = curCase.optionsArray[index]
                let optionButton = optionButtonArray[index]
                setOptionItemSelectedStatus(forItemButton: optionButton, caseOption: caseOption, isSelected: true)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        //content view
        contentBgView = UIView()
        contentBgView.backgroundColor = UIColor.white
        addSubview(contentBgView)
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.colorWithHexString(hex: "#222222")
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentBgView.addSubview(titleLabel)
        
        //pass
        firstButton = UIButton()
        firstButton.backgroundColor = UIColor.white
        firstButton.layer.cornerRadius = 5
        firstButton.layer.borderWidth = 1
        firstButton.layer.masksToBounds = true
        firstButton.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize:16)
        firstButton.setTitleColor(UIColor.colorWithHexString(hex: "#555555"), for: .normal)
//        firstButton.setTitleColor(UIColor.colorWithHexString(hex: "#ffffff"), for: .selected)
        firstButton.tag = passThroughItemBaseTag + 0
        firstButton.addTarget(self, action: #selector(caseOptionClicked(button:)), for: .touchUpInside)
        contentBgView.addSubview(firstButton)
        optionButtonArray.append(firstButton)

        //unpass
        secondButton = UIButton()
        secondButton.backgroundColor = UIColor.white
        secondButton.layer.cornerRadius = 5
        secondButton.layer.borderWidth = 1
        secondButton.layer.masksToBounds = true
        secondButton.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize:16)
        secondButton.setTitleColor(UIColor.colorWithHexString(hex: "#555555"), for: .normal)
        secondButton.tag = passThroughItemBaseTag + 1
        secondButton.addTarget(self, action: #selector(caseOptionClicked(button:)), for: .touchUpInside)
        contentBgView.addSubview(secondButton)
        optionButtonArray.append(secondButton)
    }
    
    override func layoutViews() {
        
        //content view
        contentBgView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
            make.bottom.greaterThanOrEqualTo(titleLabel)
            make.bottom.greaterThanOrEqualTo(firstButton)
        }
        
        //title label
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.contentBgView).offset(20)
            make.top.equalTo(self.contentBgView).offset(5)
        }
        
        //pass
        firstButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(30)
            make.top.equalTo(self.titleLabel)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }
    
        //unpass
        secondButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self.firstButton.snp.right).offset(10)
            make.right.equalTo(self).offset(-20)
            make.top.width.height.equalTo(self.firstButton)
        }
    }
    
    override func reloadView(withData caseData: AssCase) {
        
        //save
        assCase = caseData
        
        //update
        titleLabel.text = caseData.caseTitle
        
        if caseData.optionsArray.count >= 2 {
            
            let optionFirst = caseData.optionsArray[0]
            firstButton.setTitle(optionFirst.optionText, for: .normal)
            setOptionItemSelectedStatus(forItemButton: firstButton, caseOption: optionFirst, isSelected: optionFirst.isSelected)
            
            let optionSecond = caseData.optionsArray[1]
            secondButton.setTitle(optionSecond.optionText, for: .normal)
            setOptionItemSelectedStatus(forItemButton: secondButton, caseOption: optionSecond, isSelected: optionSecond.isSelected)
        }
        
        layoutViews()
    }
    
    func setOptionItemSelectedStatus(forItemButton itemButton: UIButton, caseOption: AssCaseOption, isSelected: Bool) {
        
        caseOption.isSelected = isSelected
        
        if isSelected {
            itemButton.setTitleColor(UIColor.colorWithHexString(hex: "#ffffff"), for: .normal)
            itemButton.backgroundColor = UIColor.mainColor
            itemButton.layer.borderColor = UIColor.mainColor.cgColor
        } else {
            itemButton.setTitleColor(UIColor.colorWithHexString(hex: "#555555"), for: .normal)
            itemButton.backgroundColor = UIColor.colorWithHexString(hex: "#ffffff")
            itemButton.layer.borderColor = UIColor.colorWithHexString(hex: "#d8d8d8").cgColor
        }
    }
}


class AssPattenPassThroughCell: AssPattenCell {
    
    var caseView: Ass_Patten_PassThroughView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        caseView = Ass_Patten_PassThroughView()
        contentView.addSubview(caseView)
    }
    
    override func layoutViews() {
        
        caseView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
    }
    
    override func reloadView(withData caseData: AssCase) {
        
        caseView.reloadView(withData: caseData)
        
        layoutViews()
    }
}
