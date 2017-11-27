//
//  CollectionHeaderView.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/27/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

//class CustomHeaderView:UICollectionReusableView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        let sectionView = UIView()
//        let items:[String] = ["Posts", "Photos", "Favorites"]
//        let segmentedControl: UISegmentedControl = UISegmentedControl(items: items)
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        var views = [String:UIView]()
//        views["super"] = self.view
//        sectionView.addSubview(segmentedControl)
//        sectionView.backgroundColor = UIColor.white
//
//        segmentedControl.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor).isActive = true
//        segmentedControl.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor).isActive = true
//        sectionView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: sectionView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
//        sectionView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: sectionView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
//
//        let separator = UIView()
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        separator.backgroundColor = UIColor.lightGray
//        sectionView.addSubview(separator)
//        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[separator]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["separator": separator]))
//        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separator(0.5)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["separator": separator]))
//    }
//}

