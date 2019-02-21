//
//  Ass_Patten_Style3_View.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 题干: 自适应文字，支持多行
 * 选项: 不可点击、左对齐、高度固定、宽动态计算、当前行剩余位置显示不开，直接换到下一行开始（如果整行显示不开，则tail）
 */

import UIKit

class Ass_Patten_Style3_View: Ass_Patten_View {

    var contentBgView: UIView!
    var headerView: UIView!
    var titleLabel: UILabel!
    var horDashLine: UIView!
    var optionContainerView: ItemContainerView!
    
    let defaultContainerHeight: CGFloat = 54
    let defaultOptionHeight: CGFloat = 44
    
    var curCase: AssCase?
    var optionsDataArray = [AssCaseOption]()
    var optionsViewArray = [FlatNormalItemView]()
    
    var didSelectOptionCallback: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        //bg view
        contentBgView = UIView()
        contentBgView.backgroundColor = UIColor.colorFromRGBA(255, 244, 198)
        addSubview(contentBgView)
        
        //header view
        headerView = UIView()
        headerView.backgroundColor = UIColor.colorFromRGBA(255, 244, 198)
        contentBgView.addSubview(headerView)
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        headerView.addSubview(titleLabel)
        
        //hor dash line
        horDashLine = UIView()
        headerView.addSubview(horDashLine)
        
        //container view
        optionContainerView = ItemContainerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: defaultContainerHeight))
        addSubview(optionContainerView)
    }
    
    override func layoutViews() {
        
        //content bg view
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        //header view
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentBgView)
        }
        
        //title
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(30)
            make.right.equalTo(self.headerView).offset(-30)
            make.top.equalTo(self.headerView).offset(12)
            make.bottom.equalTo(self.headerView).offset(-12)
        }
        
        //hor line
        horDashLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.headerView)
            make.left.equalTo(self.headerView).offset(33)
            make.right.equalTo(self.headerView).offset(-33)
            make.height.equalTo(2)
        }

        //options
        optionContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalTo(self.contentBgView)
            make.height.equalTo(defaultContainerHeight)
            make.bottom.equalTo(self.contentBgView).offset(-10)
        }
        
        headerView.layoutIfNeeded()
        
        addDashLayer(forView: horDashLine, from: CGPoint(x: 0, y: 0), to: CGPoint(x: horDashLine.frame.size.width, y: 0))
        
//        self.snp.makeConstraints { (make) in
//            make.top.equalTo(self.titleLabel)
//            make.bottom.equalTo(self.backView)
//        }
    }
    
    func addDashLayer(forView view: UIView, from fromPoint: CGPoint, to toPoint: CGPoint) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = view.bounds
        shapeLayer.position = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.colorFromRGBA(255, 162, 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [3, 3]
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func reloadView(withData caseData: AssCase, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat) {
        
        //save & clean
        curCase = caseData
        optionsViewArray.removeAll()
        optionContainerView.cleanSubViews()
        optionsDataArray.removeAll()
        optionsDataArray.append(contentsOf: caseData.optionsArray)
        
        //title
        titleLabel.text = caseData.caseTitle
        
        //options
        let contentWidth: CGFloat = frame.width - containerInset.left - containerInset.right
        let itemFont = UIFont.systemFont(ofSize: 16)
        let itemInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        for (idx, itemData) in optionsDataArray.enumerated() {
            
            let itemTitle = "\(itemData.optionType). \(itemData.optionText)"
            let itemRect = CGRect(x: 0, y: 0, width: 0, height: defaultOptionHeight)
            let itemView = FlatNormalItemView(frame: itemRect, index: idx, maxWidth: contentWidth)
            let _ = itemView.initialize(withItemTitle: itemTitle, titleFont: itemFont, lineNumber: 1, breakMode: .byTruncatingTail, contentInset: itemInset, fixWidth: false, fixedWidth: 0, fixHeight: true, fixedHeigth: defaultOptionHeight)
            itemView.actionButton.addTarget(self, action: #selector(didSelectOption(button:)), for: .touchUpInside)
            optionsViewArray.append(itemView)
        }
        
        let containerSize = optionContainerView.loadLeftAlignedItems(optionsViewArray, containerInset: containerInset, spaceX: spaceX, spaceY: spaceY)
        optionContainerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalTo(self.contentBgView)
            make.height.equalTo(containerSize.height)
            make.bottom.equalTo(self.contentBgView).offset(-10)
        }
    }
    
    @objc func didSelectOption(button: UIButton) {
        
        let idx = button.tag - FlatNormalItemView.flatNormalItemViewBaseTag
        let selectedOptionView = optionsViewArray[idx]
        let selectedOption = optionsDataArray[idx]
        
        if let curCase = curCase {
            let caseType = curCase.caseType
            if caseType == .normalSingleSelection {
                //单选
                if !selectedOptionView.isItemSelected {
                    optionsViewArray.forEach{$0.setItemSelectedStatus(isSelected: false)}
                    optionsDataArray.forEach{$0.isSelected = false}
                    selectedOptionView.setItemSelectedStatus(isSelected: true)
                    selectedOption.isSelected = true
                }
            } else if caseType == .normalMultiSelection {
                //多选
                selectedOptionView.setItemSelectedStatus(isSelected: !selectedOptionView.isItemSelected)
                selectedOption.isSelected = selectedOptionView.isItemSelected
            }
        }
        didSelectOptionCallback?(idx)
    }
}


class Ass_Patten_Style3_Cell: AssPatternStyleCell {
    
    var patternView: Ass_Patten_Style3_View!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var defaultPatternHeight: CGFloat {
        get {
            return 70.0
        }
        set {
            super.defaultPatternHeight = newValue
        }
    }
    
    override func initViews() {
        
        let rect = CGRect(x: 0, y: 0, width: parentWidth, height: defaultPatternHeight)
        patternView = Ass_Patten_Style3_View(frame: rect)
        patternView.didSelectOptionCallback = {[weak self] idx in
            
        }
        contentView.addSubview(patternView)
    }
    
    override func layoutViews() {
        
        patternView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
    }
    
    func reloadView(withData caseData: AssCase, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        patternView.reloadView(withData: caseData, containerInset: containerInset, spaceX: spaceY, spaceY: spaceY)
    }
}
