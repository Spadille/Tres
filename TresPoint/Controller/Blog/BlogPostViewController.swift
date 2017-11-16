//
//  BlogPostViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

class BlogPostViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        navigationItem.title = "TresPoint News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add_pressed"), style: .plain, target: self, action: #selector(goToPost))
        setupIcon()
        setupTabView()
    
        let post1 = Post()
        post1.name = "test 1"
        post1.statusText = "this is a test message for test 1, we can only input what we want to conclude the result that we are here again"
        let post2 = Post()
        post2.name = "test 2"
        post2.statusText = "try the test with another length. this is a test message for test 1, we can only input what we want to conclude the result that we are here againnnnnnn"
        posts.append(post1)
        posts.append(post2)
    }
    
    @objc func goToPost(){
        let pv = PostViewController()
        self.present(pv, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let cellId = "BlogCell"
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: tabView.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
            let knownheight:CGFloat = 8+44+4+4+200+8+24+8+44+32
            return CGSize(width: tabView.frame.width, height: rect.height + knownheight)
        }
        return CGSize(width: tabView.frame.width, height: 500)
    }
    
    let icon:UIImageView = {
        let ic = UIImageView()
        ic.image = UIImage(named:"TresPointLogin")
        ic.contentMode = .scaleAspectFill
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    
    let tabView: UICollectionView = {
        let tab = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.backgroundColor = UIColor(rgb: 0xE5E6E7)
        tab.layer.borderColor = UIColor.white.cgColor
        tab.layer.borderWidth = 1
        tab.layer.cornerRadius = 16
        tab.layer.masksToBounds = true
        return tab
    }()
    
    func setupIcon(){
        self.view.addSubview(icon)
        let constraints: [NSLayoutConstraint] = [
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 120),
            icon.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTabView(){
        self.view.addSubview(tabView)
        tabView.alwaysBounceVertical = true
        tabView.register(BlogCell.self, forCellWithReuseIdentifier: cellId)
        tabView.delegate = self
        tabView.dataSource = self
        let constraints:[NSLayoutConstraint] = [
            tabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            tabView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tabView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension BlogPostViewController: UICollectionViewDelegate{
    
}

extension BlogPostViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BlogCell
        let post = posts[indexPath.row]
        if let name = post.name, let status = post.statusText {
            cell.nameLabel.text = name
            cell.statusTextView.text = status
        }
        if let profileImageName = post.profileImage {
            cell.profileImageView.image = UIImage(named: profileImageName)
        }
        return cell
    }
}
