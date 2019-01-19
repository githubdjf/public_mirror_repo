//
//  DatePickerViewController.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/10/8.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    
    typealias DateBlock = (_ strDate: String) -> Void
    var datePickerView: UIDatePicker! //picker
    var toolView: UIView!
    var confirmButton: UIButton!
    var dateBlock: DateBlock?
    var dateStr: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, alpha: 0.5)

        initView()

    }


    @objc func confirmButtonTapped(){

        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd"
        dateStr = formatter.string(from: datePickerView.date)

        if let block = dateBlock {
            block(dateStr)
        }
    }

    @objc func dateChanged(){


    }

    func initView() -> Void {

        toolView = UIView()
        toolView.backgroundColor = UIColor.white
        self.view.addSubview(toolView)

        confirmButton = UIButton()
        confirmButton.setTitle("完成", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.backgroundColor = UIColor.mainColor
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        toolView.addSubview(confirmButton)

        let lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString(hex: "#d8d8d8")
        toolView.addSubview(lineView)

        datePickerView = UIDatePicker.init()
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePickerView.setValue(UIColor.colorFromRGBA(34, 34, 34), forKey: "textColor")

        clearSepearatorLine()
        selectBackgroundColor()
        self.view.addSubview(datePickerView)

        datePickerView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view)
            maker.left.width.equalTo(self.view)
            maker.height.equalTo(135)
        }

        toolView.snp.makeConstraints { (maker) in
            maker.height.equalTo(46)
            maker.bottom.equalTo(datePickerView.snp.top)
            maker.left.width.equalTo(self.view)
        }

        lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(1)
            maker.bottom.equalTo(toolView.snp.bottom)
        }

        confirmButton.snp.makeConstraints { (maker) in
            maker.right.top.equalTo(toolView)
            maker.bottom.equalTo(lineView.snp.top)
            maker.width.equalTo(100)
        }

    }

    //移除 datePicker 中间的分割线
    func clearSepearatorLine() {

        for subView in datePickerView.subviews {
            if subView.isKind(of: UIPickerView.self){

                for sub in subView.subviews {
                    if sub.frame.size.height < 1 {
                        sub.isHidden = true
                    }
                }
            }
        }
    }


    //设置选中的背景色
    func selectBackgroundColor() {
        
        let selectView = datePickerView.subviews[0]
        let colorView = UIView.init()
        colorView.backgroundColor = UIColor.colorFromRGBA(240, 240, 250)
        colorView.alpha = 0.2
        selectView.addSubview(colorView)
        colorView.snp.makeConstraints { (maker) in
            maker.left.width.equalTo(selectView)
            maker.centerY.equalTo(selectView)
            maker.height.equalTo(30)
        }
    }


}
