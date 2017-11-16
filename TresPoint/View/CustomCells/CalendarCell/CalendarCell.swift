//
//  CalendarCell.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/13/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CalendarCell: JTAppleCell{
    let dateLabel:UILabel = {
        let tv = UILabel()
        tv.text = "sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textAlignment = .center
        tv.translatesAutoresizingMaskIntoConstraints = false
        //tv.backgroundColor = UIColor.clear
        //tv.textColor = UIColor.white
        return tv
    }()
    
    let selectedView:UIView = {
        let sv = UIView()
        sv.isUserInteractionEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor(rgb: 0x4e3f5d)
        //sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        return sv
    }()
    
//    @objc func handleTap(){
//        print("tap tap tap")
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell(){
        addSubview(selectedView)
        addSubview(dateLabel)
        let constraints: [NSLayoutConstraint] = [
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 40),
            dateLabel.widthAnchor.constraint(equalToConstant: 40),
            selectedView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: 40),
            selectedView.widthAnchor.constraint(equalToConstant: 40),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
