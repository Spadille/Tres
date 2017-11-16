//
//  ChatMessageCell.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/9/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import AVFoundation


class ChatMessageCell: UICollectionViewCell {
    
    var chatlogController: ChatLogViewController?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleTrailingAnchor: NSLayoutConstraint?
    var bubbleTopAnchor:NSLayoutConstraint?
    var bubbleLeadingAnchor: NSLayoutConstraint?
    var message:Messages?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textAlignment = .right
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        //tv.textColor = UIColor.white
        tv.isEditable = false
        return tv
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        //aiv.startAnimating()
        return aiv
    }()
    
    let profileImageView :UIImageView = {
        let imageP = UIImageView()
        imageP.image = UIImage(named: "messi")
        imageP.translatesAutoresizingMaskIntoConstraints = false
        imageP.layer.cornerRadius = 16
        imageP.layer.masksToBounds = true
        imageP.contentMode = .scaleToFill
        return imageP
    }()
    
    static let blueColor:UIColor = UIColor(red: 0, green: 137, blue: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = ChatMessageCell.blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Play Video", for: .normal)
        let image = UIImage(named:"play_button")
        button.tintColor = UIColor.white
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc func handlePlay(){
        if let videoUrlString = message?.videoUrl, let url = URL(string:videoUrlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer){
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView{
            self.chatlogController?.performZoomInForImageView(startingImageView: imageView)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.red
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        bubbleView.addSubview(messageImageView)
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleTopAnchor = bubbleView.topAnchor.constraint(equalTo: self.topAnchor)
        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -8)
        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        let constraints: [NSLayoutConstraint] = [
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            bubbleTrailingAnchor!,
            bubbleTopAnchor!,
            bubbleWidthAnchor!,
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor),
            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 4),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,constant: -4),
            textView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            //textView.widthAnchor.constraint(equalToConstant: 200),
            textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor)
        ]
        //bubbleWidthAnchor?.isActive = true
        NSLayoutConstraint.activate(constraints)
        messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
