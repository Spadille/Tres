//
//  ProfileViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let min_header: CGFloat = 22
    let bar_offset: CGFloat = 110
    
    weak var tableView: UITableView?
    weak var imageHeaderView: UIImageView?
    weak var visualEffectView: UIVisualEffectView?
    var customTitleView: UIView?
    var originalBackgroundImage: UIImage?
    var blurredImageCache: NSMutableDictionary?
    
    var headerHeight: CGFloat?
    var subHeaderHeight: CGFloat?
    var headerSwitchOffset: CGFloat?
    var avatarImageSize: CGFloat?
    var avatarImageCompressedSize: CGFloat?
    var barIsCollapsed: Bool?
    var barAnimationComplete: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = 100.0;
        subHeaderHeight = 100.0;
        avatarImageSize = 70;
        avatarImageCompressedSize = 44;
        barIsCollapsed = false;
        barAnimationComplete = false;
        
        let sharedApplication = UIApplication.shared
        
        let kStatusBarHeight: CGFloat = sharedApplication.statusBarFrame.size.height
        let kNavBarHeight:CGFloat = self.navigationController.navigationBar.frame.size.height
        
        /* To compensate  the adjust scroll insets */
        headerSwitchOffset = headerHeight - (kStatusBarHeight + kNavBarHeight)  - kStatusBarHeight - kNavBarHeight
        
        var views:[String:UIView]?
        views["super"] = self.view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        views["tableView"] = tableView
        
        let bgImage: UIImage = UIImage(named:"vegetation.jpg")
        originalBackgroundImage = bgImage
        
        let headerImageView = UIImageView()
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        self.imageHeaderView = headerImageView
        views["headerImageView"] = headerImageView
        
        let tableHeaderView:UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0 ), size: self.view.frame.size.width))
        tableHeaderView.addSubview(headerImageView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if self.isViewLoaded && self.view.window {
            customTitleView = nil
        }
    }
    
    deinit {
        originalBackgroundImage = nil
        blurredImageCache?.removeAllObjects()
        blurredImageCache = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "item \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let items:[String] = ["Tweets", "Photos", "Favorites"]
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var views: [String:UIView]?
        views["super"] = self.view
        sectionView.addSubview(segmentedControl)
        sectionView.backgroundColor = UIColor.white
        
        segmentedControl.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor)
        segmentedControl.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor)
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        sectionView.addSubview(separator)
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[separator]-0-|", options: 0, metrics: nil, views: ["separator": separator]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separator(0.5)]-0-|", options: 0, metrics: nil, views: ["separator": separator]))
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func configureNavBar() {
        self.view.backgroundColor = UIColor.blue
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.switchToExpandedHeader()
        //[self switchToExpandedHeader];
    }
    
    func switchToExpandedHeader(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView = nil;
        //    if(self.visualEffectView){
        //        [self.visualEffectView removeFromSuperview];
        //        self.visualEffectView = nil;
        //    }
        
        barAnimationComplete = false;
        self.imageHeaderView.image = self.originalBackgroundImage;
        self.tableView?.tableHeaderView?.exchangeSubview(at: 1, withSubviewAt: 2)
    }
    
    func switchToMinifiedHeader(){
        barAnimationComplete = false
        self.navigationItem.titleView = self.customTitleView
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(60, for: .default)
        self.tableView?.tableHeaderView?.exchangeSubview(at: 1, withSubviewAt: 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = scrollView.contentOffset.y
        if yPos > headerSwitchOffset && !barIsCollapsed {
            self.switchToMinifiedHeader()
            barIsCollapsed = true
        } else {
            self.switchToExpandedHeader()
            barIsCollapsed = false
        }
        
        if yPos > headerSwitchOffset + 20 && yPos <= headerSwitchOffset + 20 + 40 {
            let delta: CGFloat = 40 + 20 - (yPos - headerSwitchOffset)
        }
    }
    
//    func fillBlurredImageCache(){
//        let maxBlur:CGFloat = 30;
//        self.blurredImageCache = [NSMutableDictionary new];
//        for (int i = 0; i <= 10; i++)
//        {
//            self.blurredImageCache[[NSNumber numberWithInt:i]] = [self blurWithImageEffects:_originalBackgroundImage andRadius:(maxBlur * i/10)];
//        }
//    }
}
