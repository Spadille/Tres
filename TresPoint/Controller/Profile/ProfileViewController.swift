//
//  ProfileViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

let min_header: CGFloat = 22
let bar_offset: CGFloat = 110

class ProfileViewController: UIViewController {
    
    let imageProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "messi")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

//    let coverImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
//    let editButton: UIButton = {
//        let butt = UIButton()
//        butt.setTitle("Edit profile", for: .normal)
//        butt.backgroundColor = UIColor(rgb: 0x7EBCDC)
//        butt.translatesAutoresizingMaskIntoConstraints = false
//        butt.setTitleColor(UIColor.white, for: .normal)
//        butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        return butt
//    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isOpaque = false
        cv.perform(#selector(handleContainer), with: nil, afterDelay: 0)
        return cv
    }()
    
    @objc func handleContainer(){
        let vc = 
    }
    
    let barView:UIView = {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var segementView: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["first","second","third"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.blue
        sc.selectedSegmentIndex = 1
        //sc.isUserInteractionEnabled = true
        sc.addTarget(self, action: #selector(handleSegement), for: .valueChanged)
        return sc
    }()
    
    @objc func handleSegement(){
        let title = segementView.titleForSegment(at: segementView.selectedSegmentIndex)
        print(title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpImageProfile()
        setupContainerView()
        setupBarView()
        UIApplication.shared.statusBarStyle = .lightContent
        imageProfile.layer.zPosition = 1
        containerView.layer.zPosition = 2
        barView.layer.zPosition = 0
    }

    func setUpImageProfile(){
        view.addSubview(imageProfile)
        let constraints: [NSLayoutConstraint] = [
            //imageProfile.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            imageProfile.topAnchor.constraint(equalTo: view.topAnchor),
            imageProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageProfile.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageProfile.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupBarView(){
        view.addSubview(barView)
        barView.addSubview(segementView)
        view.addSubview(segementView)
        let constraints:[NSLayoutConstraint] = [
            barView.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 110),
            barView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            barView.heightAnchor.constraint(equalToConstant: 40),
            segementView.topAnchor.constraint(equalTo: barView.topAnchor, constant: 8),
            segementView.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: -8),
            segementView.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 6),
            segementView.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -6)
//            segementView.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 110),
//            segementView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            segementView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            segementView.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupContainerView(){
        view.addSubview(containerView)
        let constraints:[NSLayoutConstraint] = [
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subScrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset < 0 {
            var headerTransform = CATransform3DIdentity
            let headerScaleFactor:CGFloat = -(offset) / imageProfile.bounds.height
            let headerSizevariation = ((imageProfile.bounds.height * (1.0 + headerScaleFactor)) - imageProfile.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            imageProfile.layer.transform = headerTransform
        } else {
            var headerTransform = CATransform3DIdentity
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-(imageProfile.bounds.height-min_header), -offset), 0)
            imageProfile.layer.transform = headerTransform
        }
        
        if (imageProfile.bounds.height-min_header) < offset {
            imageProfile.layer.zPosition = 3
        } else {
            imageProfile.layer.zPosition = 0
        }
        
        if (imageProfile.bounds.height-min_header+bar_offset) < offset {
            barView.layer.zPosition = 3
        } else {
            barView.layer.zPosition = 1
        }
        
        var barTransform = CATransform3DIdentity
        barTransform = CATransform3DTranslate(barTransform, 0, max(-(imageProfile.bounds.height-min_header+bar_offset), -offset), 0)
        barView.layer.transform = barTransform
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
