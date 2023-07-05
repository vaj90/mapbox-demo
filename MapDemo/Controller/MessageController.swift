//
//  MessageController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-15.
//

import UIKit
import QuartzCore
struct Message: Codable {
    var name: String
    var messageInfo: String
    var msgType: Int
    var dateTime: String
}
class MessageCollectionViewCell : UICollectionViewCell {
    static let identifier = "cell"
    var msgDetail: Message!
    lazy var imgMessage: UIImageView = {
        let imgb = UIImage(named:"star")?.withRenderingMode(.alwaysTemplate)
        let imgMsg = UIImageView(image: imgb!)
        return imgMsg
    }()
    lazy var msgName: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    lazy var msgInfo: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addUIItem(){
        addSubview(imgMessage)
        addSubview(msgName)
        addSubview(msgInfo)
    }
    func configure(){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        paragraph.baseWritingDirection = msgDetail.msgType == 1 ? .leftToRight : .rightToLeft
        let attrBold = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 16)];
        let attrLight = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 12)];
        let msgNameAttr = NSMutableAttributedString()
        msgNameAttr.append(NSAttributedString(string: "\(msgDetail.name)", attributes: attrBold as [NSAttributedString.Key : Any]))
        msgNameAttr.append(NSAttributedString(string: "\n\(msgDetail.dateTime)", attributes: attrLight as [NSAttributedString.Key : Any]))
        msgNameAttr.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: msgNameAttr.length))
        msgName.attributedText = msgNameAttr
        
        let msgInfoAttr = NSMutableAttributedString()
        msgInfoAttr.append(NSAttributedString(string: "\(msgDetail.messageInfo)", attributes: attrLight as [NSAttributedString.Key : Any]))
        msgInfoAttr.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: msgInfoAttr.length))
        msgInfo.attributedText = msgInfoAttr
        positionUIItem()
    }
    func positionUIItem(){
        imgMessage.anchor(
            top: self.topAnchor, left: msgDetail.msgType == 1 ? self.leftAnchor : nil,
            bottom: nil, right: msgDetail.msgType == 1 ? nil : self.rightAnchor,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight:10,
            width: 32, height: 32)
        msgName.anchor(
            top: self.topAnchor, left: msgDetail.msgType == 1 ? imgMessage.rightAnchor : self.leftAnchor,
            bottom: nil, right: msgDetail.msgType == 1 ? self.rightAnchor : imgMessage.leftAnchor,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 20,
            width: 0, height: 40)
        msgInfo.anchor(
            top: msgName.bottomAnchor, left: msgDetail.msgType == 1 ? imgMessage.rightAnchor : self.leftAnchor,
            bottom: nil, right: msgDetail.msgType == 1 ? self.rightAnchor : imgMessage.leftAnchor,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 10, paddingRight: 20,
            width: 0, height: 0)
    }
    override init(frame: CGRect) {
      super.init(frame: frame)
        addUIItem()
    }

}
class MessageController: UIViewController, UITextFieldDelegate {
    var cV: UICollectionView!
    var messages: [Message] = [
        Message(name: "Allan", messageInfo: "Thank you for ordering from Oh My Gulay!. We're currently preparing your order.", msgType: 1, dateTime: "01/30/2023 11:48 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 1, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 1, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 1, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 1, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 1, dateTime: "02/01/2023 09:30 PM"),
        Message(name: "John", messageInfo: "Thanks again.", msgType: 2, dateTime: "02/01/2023 09:30 PM"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
        cV.dataSource = self
        cV.delegate = self
        cV.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: MessageCollectionViewCell.identifier)
        //collectionview.showsHorizontalScrollIndicator = false
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 20)
        cV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
        v.addSubview(cV)
        cV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        //cV.backgroundColor = .red
        return v
    }()
    var msgLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#15A9FC")
        label.textAlignment = .center
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        paragraph.baseWritingDirection = .leftToRight
        let attrName = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 14)];
        let attrOId = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 12)];
        let attributeText = NSMutableAttributedString()
        attributeText.append(NSAttributedString(string: "OHMY127847", attributes: attrName as [NSAttributedString.Key : Any]))
        attributeText.append(NSAttributedString(string: "\nOrder ID", attributes: attrOId as [NSAttributedString.Key : Any]))
        attributeText.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attributeText.length))
        label.attributedText = attributeText
        label.numberOfLines = 0
        return label
    }()
    lazy var topNav: UIView = {
        let v  = UIView()
        let imgb = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgBack = UIImageView(image: imgb!)
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgBack.isUserInteractionEnabled = true
        v.addSubview(imgBack)
        imgBack.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
            width: 32, height: 32)

        v.addSubview(msgLabel)
        msgLabel.anchor(
            top: nil, left: imgBack.rightAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
            width: 0, height: 32)
        
        let imgr = UIImage(named:"reload")?.withRenderingMode(.alwaysTemplate)
        var imgReload = UIImageView(image: imgr!)

        imgReload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reload)))
        imgReload.isUserInteractionEnabled = true
        v.addSubview(imgReload)
        imgReload.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 5, paddingRight: 15,
            width: 32, height: 32)

        return v
    }()
    lazy var txtMessage: UITextField = {
        let t = UITextField()
        t.placeholder = "Type your message here..."
        t.layer.cornerRadius = 10
        t.layer.borderWidth = 1.0
        t.layer.borderColor = UIColor.gray.cgColor
        t.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: t.frame.height))
        //t.leftViewMode = .always
        return t
    }()
    var activeOptionConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var unActiveOptionConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    let imglc = UIImage(named:"lchevron")?.withRenderingMode(.alwaysTemplate)
    let imgrc = UIImage(named:"rchevron")?.withRenderingMode(.alwaysTemplate)
    var isHidden = false
    lazy var imgShowHide: UIImageView = {
        let imgSH = UIImageView(image: imglc!)
        imgSH.tintColor = UIColor.init(hexString: "#CFCFCF")
        imgSH.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(showOtherBtn)))
        imgSH.isUserInteractionEnabled = true
        return imgSH
    }()
    lazy var imgClip: UIImageView = {
        let imgcl = UIImageView(image: UIImage(named:"clip")?.withRenderingMode(.alwaysTemplate))
        imgcl.tintColor = UIColor.init(hexString: "#CFCFCF")
        imgcl.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(attachedFile)))
        imgcl.isUserInteractionEnabled = true
        return imgcl
    }()
    
    lazy var imgCamera: UIImageView = {
        let imgca = UIImageView(image: UIImage(named:"camera")?.withRenderingMode(.alwaysTemplate))
        imgca.tintColor = UIColor.init(hexString: "#CFCFCF")
        imgca.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(attachedFile)))
        imgca.isUserInteractionEnabled = true
        return imgca
    }()
    lazy var innerView: UIView = {
        let iv = UIView()
        
        iv.addSubview(imgShowHide)
        imgShowHide.anchor(
            top: iv.topAnchor, left: iv.leftAnchor,
            bottom: iv.bottomAnchor, right: nil,
            paddingTop: 17, paddingLeft: 0,
            paddingBottom: 17, paddingRight: 10,
            width: 30, height: 25)
        
        iv.addSubview(imgClip)
        imgClip.anchor(
            top: iv.topAnchor, left: imgShowHide.rightAnchor,
            bottom: iv.bottomAnchor, right: nil,
            paddingTop: 17, paddingLeft: 10,
            paddingBottom: 17, paddingRight: 10,
            width: 30, height: 25)
        imgClip.isHidden = isHidden
        
        iv.addSubview(imgCamera)
        imgCamera.anchor(
            top: iv.topAnchor, left: imgClip.rightAnchor,
            bottom: iv.bottomAnchor, right: nil,
            paddingTop: 17, paddingLeft: 10,
            paddingBottom: 17, paddingRight: 0,
            width: 30, height: 25)
        imgCamera.isHidden = isHidden
        
        return iv
    }()
    
    lazy var bottomNav: UIView = {
        let v  = UIView()
        let imgs = UIImage(named:"send")?.withRenderingMode(.alwaysTemplate)
        var imgSend = UIImageView(image: imgs!)
        imgSend.tintColor = UIColor.init(hexString: "#CFCFCF")
        imgSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(send)))
        imgSend.isUserInteractionEnabled = true

        v.addSubview(innerView)
        innerView.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 25)
        
        v.addSubview(imgSend)
        imgSend.anchor(
            top: v.topAnchor, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 17, paddingLeft: 15,
            paddingBottom: 17, paddingRight: 15,
            width: 30, height: 25)
        
        v.addSubview(txtMessage)
        txtMessage.anchor(
            top: v.topAnchor, left: innerView.rightAnchor,
            bottom: v.bottomAnchor, right: imgSend.leftAnchor,
            paddingTop: 15, paddingLeft: 10,
            paddingBottom: 15, paddingRight: 15,
            width: 0, height: 40)
        
        activeOptionConstraints.append(innerView.widthAnchor.constraint(equalToConstant: 120))
        unActiveOptionConstraints.append(innerView.widthAnchor.constraint(equalToConstant: 30))
        showOtherBtn()
        return v
    }()
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true

        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: /*height?.native ??*/ 50)
        
        let borderTopNav: CALayer = CALayer()
        borderTopNav.frame = CGRectMake(0.0, 49, view.frame.size.width, 0.5)
        borderTopNav.masksToBounds = true
        borderTopNav.backgroundColor = UIColor.lightGray.cgColor
        topNav.layer.addSublayer(borderTopNav)
        
        view.addSubview(bottomNav)
        bottomNav.anchor(
            top: nil, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 10, paddingLeft: 0,
            paddingBottom: 10, paddingRight: 0,
            width: 0, height: 65)
        let borderBotNav: CALayer = CALayer()
        borderBotNav.frame = CGRectMake(0.0, 0.0, view.frame.size.width, 0.5)
        borderBotNav.backgroundColor = UIColor.lightGray.cgColor
        bottomNav.layer.addSublayer(borderBotNav)
        
        
        view.addSubview(viewBody)
        viewBody.anchor(
            top: topNav.bottomAnchor, left: topNav.leftAnchor,
            bottom: bottomNav.topAnchor, right: topNav.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
    }

    @objc private func showOtherBtn(){
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imgClip.isHidden = !self.isHidden
            self.imgCamera.isHidden = !self.isHidden
        })
        imgShowHide.image = isHidden ? imgrc : imglc
        
        if isHidden {
            NSLayoutConstraint.activate(activeOptionConstraints)
            NSLayoutConstraint.deactivate(unActiveOptionConstraints)
        }
        else{
            NSLayoutConstraint.activate(unActiveOptionConstraints)
            NSLayoutConstraint.deactivate(activeOptionConstraints)
        }
            
        innerView.updateConstraints()
        innerView.layoutIfNeeded()
        isHidden = !isHidden
    }
    
    @objc private func goBack(){
        print("back")
    }
    @objc private func reload(){
        print("reload")
    }
    @objc private func send(){
        print("send")
    }
    @objc private func attachedFile(){
        print("file")
    }
    @objc private func addImage(){
        print("image")
    }
 
}

extension MessageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCollectionViewCell.identifier, for: indexPath) as! MessageCollectionViewCell
        cell.msgDetail = messages[indexPath.row]
        
        cell.configure()
        let bottomLine = CALayer()
        let h = cell.frame.height - 4
        bottomLine.frame = CGRectMake(0.0, h, cell.frame.width, 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        cell.layer.addSublayer(bottomLine)
        //cell.backgroundColor = .cyan
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let msg = self.messages[indexPath.row]
        
        let approximateWidth = view.frame.width
        let size  = CGSize(width: approximateWidth, height: 100)
        let estimatedFrame = NSString(string: msg.messageInfo).boundingRect(with: size,options: .usesLineFragmentOrigin, context: nil)
        return CGSize(width: approximateWidth, height: estimatedFrame.height + 70)
    }
     
}
