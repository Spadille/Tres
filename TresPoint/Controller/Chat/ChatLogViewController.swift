//
//  ChatLogViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/8/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogViewController: UICollectionViewController,UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let cellId = "cellId"
    
    var messages = [Messages]()
    
    lazy var textField : UITextField = {
        let textF = UITextField()
        textF.placeholder = "Enter message..."
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.delegate = self
        return textF
    }()
    
    var user:User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        let userReference = Database.database().reference().child("user-messages").child(uid).child(toId)
        userReference.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (shot) in
                guard let dict = shot.value as? [String:AnyObject] else {
                    return
                }
                let message = Messages(dict: dict)
//                message.text = dict["text"] as? String
//                message.toId = dict["toId"] as? String
//                message.timestamp = dict["timeStamp"] as? String
//                message.fromId = dict["fromId"] as? String
//                message.imageUrl = dict["imageUrl"] as? String
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        if self.messages.count > 0 {
                            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCells()
        //observeMessages()
        collectionView?.backgroundColor = UIColor.white      // Do any additional setup after loading the view.
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        collectionView?.keyboardDismissMode = .interactive
//        setupInputComponents()
        setupKeyboardObserver()
//        handleTap()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "uploadImage")
        //uploadImageView.backgroundColor = UIColor.brown
        uploadImageView.contentMode = .scaleAspectFit
        containerView.addSubview(uploadImageView)
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        
        let imageConstraints: [NSLayoutConstraint] = [
            uploadImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 40),
            uploadImageView.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        
        let sendButton = UIButton(type: .system)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(self.textField)
        containerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        let textConstraints:[NSLayoutConstraint] = [
            self.textField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor),
            self.textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            //textField.widthAnchor.constraint(equalToConstant: 100),
            self.textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            self.textField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ]
        NSLayoutConstraint.activate(textConstraints)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func setupKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillshow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillhide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardDidShow(){
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func bottomLayoutConstraints(_ notification: NSNotification, _ open: Bool) {
        if let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            let newFrame = view.convert(frame, from: (UIApplication.shared.delegate?.window)!)
            contrainerViewBottomAnchor?.constant = open ? newFrame.origin.y - view.frame.height : newFrame.origin.y - view.frame.height
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func handleTap(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func keyboardwillshow(notification:NSNotification){
        bottomLayoutConstraints(notification, true)
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func keyboardwillhide(notification:NSNotification){
        bottomLayoutConstraints(notification, false)
    }
    
    @objc func handleUploadTap(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(picker, animated: true, completion: nil)
            } else {
                //print("error no camera")
                let newalert = UIAlertController(title: "No Camera", message: "Please select photo library", preferredStyle: .alert)
                newalert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(newalert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            //print("action come to here")
            //picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
  //      self.present(picker, animated: true, completion: nil)
    }
    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width/3)
        collectionView!.collectionViewLayout = layout
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            handleVideoUrl(videoUrl: videoUrl)
        } else {
            handleImageSelectedForInfo(info: info)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func handleVideoUrl(videoUrl:URL){
        let filename = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("messages_movies").child(filename).putFile(from: videoUrl, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("failed upload of video \(error.debugDescription)")
                return
            }
            
            if let storageUrl = metadata?.downloadURL()?.absoluteString {
                if let thumbnailImage = self.thumbnailImageVideoUrl(videoUrl: videoUrl){
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in
                        let width = thumbnailImage.size.width > thumbnailImage.size.height ? thumbnailImage.size.height : thumbnailImage.size.width
                        let height = thumbnailImage.size.width > thumbnailImage.size.height ? thumbnailImage.size.width : thumbnailImage.size.height
                        let properties: [String:Any] = ["imageUrl":imageUrl, "imageWidth": width, "imageHeight":height, "videoUrl":storageUrl]
                        self.sendMessageWithProperties(properties: properties)
                    })
                }
            }
        })
        uploadTask.observe(.progress) { (snapshot) in
            //print(snapshot.progress?.completedUnitCount)
        }
        
        uploadTask.observe(.success) { (snapshot) in
            
        }
    }
    
    private func thumbnailImageVideoUrl(videoUrl:URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do{
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            print("\(cgImage.height) and \(cgImage.width)")
            return UIImage(cgImage: cgImage)
        }catch let err{
            print(err.localizedDescription)
        }
        return nil
    }
    
    private func handleImageSelectedForInfo(info:[String:Any]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageURL) in
                self.sendMessageWithImageUrl(imageUrl: imageURL, image: selectedImage)
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseStorageUsingImage(image:UIImage, completion:@escaping (_ imageUrl:String)->()){
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    //self.sendMessageWithImageUrl(imageUrl: imageURL,image:image)
                    completion(imageURL)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabvc = self.tabBarController as? TabBarViewController {
            tabvc.customTabBar?.isHidden = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabvc = self.tabBarController as? TabBarViewController {
            tabvc.customTabBar?.isHidden = false
        }
        NotificationCenter.default.removeObserver(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var contrainerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents(){
        let containerView = UIView()
        //containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        contrainerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let constraints: [NSLayoutConstraint] = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contrainerViewBottomAnchor!,
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let sendButton = UIButton(type: .system)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(textField)
        
        let textConstraints:[NSLayoutConstraint] = [
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            //textField.widthAnchor.constraint(equalToConstant: 100),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            textField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ]
        NSLayoutConstraint.activate(textConstraints)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    @objc func handleSend(){
        if self.textField.text == nil {
            return
        }
        let properties:[String:Any] = ["text":textField.text!]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties:[String:Any]){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = String(Date().timeIntervalSince1970)
        var value:[String: Any] = ["toId":toId!, "fromId":fromId!,"timeStamp":timeStamp]
        properties.forEach({ value[$0] = $1 })
        childRef.updateChildValues(value) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            self.textField.text = nil
            if self.messages.count > 0 {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!).child(toId!)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1])
            let recipMessageRef = Database.database().reference().child("user-messages").child(toId!).child(fromId!)
            recipMessageRef.updateChildValues([messageId:1])
        }
    }
    
    
    private func sendMessageWithImageUrl(imageUrl:String, image: UIImage){
        let properties:[String:Any] = ["imageUrl":imageUrl, "imageWidth": image.size.width , "imageHeight":image.size.height]
        sendMessageWithProperties(properties: properties)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("234")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        //cell.backgroundColor = UIColor.blue
        let message = messages[indexPath.row]
        cell.chatlogController = self
        cell.textView.text = message.text
        cell.message = message
        setUpTextLayout(message: message, cell: cell)
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = getEstimateHeightForView(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        if message.videoUrl != nil {
            cell.playButton.isHidden = false
        }else {
            cell.playButton.isHidden = true
        }
    
        return cell
    }
    
    private func setUpTextLayout(message: Messages, cell: ChatMessageCell){
        if let profileImageURL = self.user?.profileImage {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
        }

        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleTrailingAnchor?.isActive = true
            cell.bubbleLeadingAnchor?.isActive = false
        }else {
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleTrailingAnchor?.isActive = false
            cell.bubbleLeadingAnchor?.isActive = true
        }
    }
    
    
    private func getEstimateHeightForView(text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let width: CGFloat = view.frame.width
        let message = messages[indexPath.item]
        if let text = message.text {
            height = getEstimateHeightForView(text: text).height + 20
            //width = getEstimateHeightForView(text: text).width + 32
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        return CGSize(width: width , height: height)
    }
    
    
    //custom zooming logic
    
    var startingFrame: CGRect?
    var backgroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInForImageView(startingImageView:UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            backgroundView = UIView(frame: keyWindow.frame)
            backgroundView?.backgroundColor = UIColor.black
            backgroundView?.alpha = 0
            keyWindow.addSubview(backgroundView!)
            keyWindow.addSubview(zoomingImageView)
            let height = (startingFrame?.height)!/(startingFrame?.width)! * keyWindow.frame.width
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView?.alpha = 1
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                self.inputContainerView.alpha = 0
            }, completion: nil)
        }
        UIApplication.shared.keyWindow?.addSubview(zoomingImageView)
    }

    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                zoomOutImageView.layer.cornerRadius = 16
                zoomOutImageView.clipsToBounds = true
                self.backgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
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
