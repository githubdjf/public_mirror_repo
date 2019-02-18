//
//  Ass_Patten_Style9.swift
//  FirstEducation
//
//  Created by Jaffer on 2018/11/27.
//  Copyright © 2018年 yitai. All rights reserved.
//

/*
 * 组合题
 * 题干: 自适应文字，支持多行
 * 子题: 其他样式的题(暂定单选)
 */

import UIKit

class Ass_Patten_Style9_View: Ass_Patten_View {

    var titleLabel: UILabel!
    var subCaseTableView: UITableView!
    
    var curCase: AssCase?
    
    //columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat
    var fetchStyle1CellLayoutParameterCallback: (() -> (Int, UIEdgeInsets, CGFloat, CGFloat))?
    var fetchStyle2CellLayoutParameterCallback: (() -> (Int, UIEdgeInsets, CGFloat, CGFloat))?
    
    deinit {
        subCaseTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        
        //title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.colorFromRGBA(34, 34, 34)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(titleLabel)
        
        //sub case table
        subCaseTableView = UITableView()
        subCaseTableView.tableFooterView = UIView()
        subCaseTableView.delegate = self
        subCaseTableView.dataSource = self
//        subCaseTableView.register(Ass_Patten_Style1_Cell.self, forCellReuseIdentifier: NSStringFromClass(Ass_Patten_Style1_Cell.self))
//        subCaseTableView.register(Ass_Patten_Style2_Cell.self, forCellReuseIdentifier: NSStringFromClass(Ass_Patten_Style2_Cell.self))
        subCaseTableView.separatorStyle = .none
        subCaseTableView.estimatedRowHeight = 200
        subCaseTableView.isScrollEnabled = false
        subCaseTableView.rowHeight = UITableView.automaticDimension
        subCaseTableView.showsVerticalScrollIndicator = false
        subCaseTableView.showsHorizontalScrollIndicator = false
        subCaseTableView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.new], context: nil)
        addSubview(subCaseTableView)
    }
    
    override func layoutViews() {
        
        //title label
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self).offset(-40)
        }
        
        //sub case table
        subCaseTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.width.equalTo(self)
            make.height.equalTo(100)
        }

        self.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.top)
            maker.bottom.equalTo(subCaseTableView.snp.bottom)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let path = keyPath, let result = change, let size = (result[NSKeyValueChangeKey.newKey] as? NSValue)?.cgSizeValue else {
            return
        }
        
        if path == "contentSize" {

            //update table constraints
            subCaseTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                make.left.width.equalTo(self)
                make.height.equalTo(size.height)
            }

        }
    }
    
    override func reloadView(withData caseData: AssCase) {
        
        curCase = caseData
        titleLabel.text = caseData.caseTitle
        subCaseTableView.reloadData()
    }
}


//MARK: UITableViewDelegate && DataSource

extension Ass_Patten_Style9_View: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if let curCaseData = curCase {
            num = curCaseData.subCaseArray.count
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style1CellId = NSStringFromClass(Ass_Patten_Style1_Cell.self)
        let style2CellId = NSStringFromClass(Ass_Patten_Style2_Cell.self)
        
        var cell: UITableViewCell?
        if let curCaseData = curCase {
            if indexPath.row < curCaseData.subCaseArray.count {
                let subCase = curCaseData.subCaseArray[indexPath.row]
                if subCase.caseType == .normalSingleSelection || subCase.caseType == .normalMultiSelection {
                    
                    switch subCase.casePattern {
                    case .selectionPatten1:
                        var style1Cell = tableView.dequeueReusableCell(withIdentifier: style1CellId) as? Ass_Patten_Style1_Cell
                        if style1Cell == nil {
                            style1Cell = Ass_Patten_Style1_Cell(style: .default, reuseIdentifier: style1CellId, parentWidth: frame.width)
                        }
                        var colCount: Int = 2, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        var inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                        if let layout = fetchStyle1CellLayoutParameterCallback?() {
                            colCount = layout.0; spaceX = layout.2; spaceY = layout.3
                            inset = layout.1
                        }
                        style1Cell!.reloadView(withData: subCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style1Cell!
                        
                    case .selectionPatten2:
                        var style2Cell = tableView.dequeueReusableCell(withIdentifier: style2CellId) as? Ass_Patten_Style2_Cell
                        if style2Cell == nil {
                            style2Cell = Ass_Patten_Style2_Cell(style: .default, reuseIdentifier: style2CellId, parentWidth: frame.width)
                        }
                        var colCount: Int = 5, spaceX: CGFloat = 20, spaceY: CGFloat = 10
                        var inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                        if let layout = fetchStyle2CellLayoutParameterCallback?() {
                            colCount = layout.0; spaceX = layout.2; spaceY = layout.3
                            inset = layout.1
                        }
                        style2Cell!.reloadView(withData: subCase, columnCount: colCount, containerInset: inset, spaceX: spaceX, spaceY: spaceY, atIndexPath: indexPath)
                        cell = style2Cell!
                        
                    default:
                        print("pattern not supported!")
                    }
                }
            }
        }
        
        if cell == nil {
            //default pattern
            cell = tableView.dequeueReusableCell(withIdentifier: style1CellId, for: indexPath)
        }

        cell!.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



class Ass_Patten_Style9_Cell: AssPatternStyleCell {
    
    var patternView: Ass_Patten_Style9_View!
    var containerView: UIView!
    
    //columnCount: Int, containerInset: UIEdgeInsets, spaceX: CGFloat, spaceY: CGFloat
    var fetchStyle1CellLayoutParameterCallback: (() -> (Int, UIEdgeInsets, CGFloat, CGFloat))? {
        willSet {
            patternView.fetchStyle1CellLayoutParameterCallback = newValue
        }
    }
    
    var fetchStyle2CellLayoutParameterCallback: (() -> (Int, UIEdgeInsets, CGFloat, CGFloat))? {
        willSet {
            patternView.fetchStyle2CellLayoutParameterCallback = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, parentWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, parentWidth: parentWidth)
        initViews()
        layoutViews()
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

        containerView = UIView()
        self.contentView.addSubview(containerView)

        let rect = CGRect(x: 0, y: 0, width: parentWidth, height: defaultPatternHeight)
        patternView = Ass_Patten_Style9_View(frame: rect)
        containerView.addSubview(patternView)
    }
    
    override func layoutViews() {

        containerView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
            maker.top.equalTo(patternView.snp.top).offset(-20).priority(999)
            maker.bottom.equalTo(patternView.snp.bottom).priority(999)
        }
        
        patternView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.left.width.equalTo(containerView)
        }
    }
    
    func reloadView(withData caseData: AssCase, atIndexPath indexPath: IndexPath) {
        
        curIndexPath = indexPath
        patternView.reloadView(withData: caseData)
    }
}
