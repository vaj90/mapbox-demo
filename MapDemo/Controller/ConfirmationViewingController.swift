//
//  ConfirmationViewingController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-16.
//
import UIKit

class ConfirmationViewingController: UIViewController {
    lazy var paragraph: NSMutableParagraphStyle =  {
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        p.baseWritingDirection = .leftToRight
        return p
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let img = UIImage(named:"cross")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .white
        
        v.addSubview(imgV)
        imgV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 15, paddingLeft: 15,
            paddingBottom: 0, paddingRight: 0,
            width: 32, height: 32)
        
        var innerView = UIView()
        v.addSubview(innerView)
        innerView.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 100, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 330, height: 500)
        
        let imgSend = UIImage(named:"email")?.withRenderingMode(.alwaysTemplate)
        var imgS = UIImageView(image: imgSend!)
        imgS.tintColor = .white
        
        innerView.addSubview(imgS)
        imgS.anchor(
            top: innerView.topAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 100, height: 100)
        imgS.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        
        let lblConfirmation = UILabel()
        lblConfirmation.numberOfLines = 0
        lblConfirmation.textColor = .white
        lblConfirmation.textAlignment = .center
        lblConfirmation.font = UIFont(name:"Ubuntu-Bold", size: 24)
        lblConfirmation.text = "Viewing Request Sent!"
        
        innerView.addSubview(lblConfirmation)
        lblConfirmation.anchor(
            top: imgS.bottomAnchor, left: innerView.leftAnchor,
            bottom: nil, right: innerView.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        
        let lblInfo = UILabel()
        lblInfo.numberOfLines = 0
        lblInfo.textColor = .white
        lblInfo.textAlignment = .center
        lblInfo.font = UIFont(name:"Ubuntu-Light", size: 14.0)
        let attrLight = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 16)];
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string:
                                            "A Realtor will be in touch shortly to\n" +
                                            "confirm your viewing request. Note this is\n" +
                                            "NOT a confirmation of your appointment."
                                           ,attributes: attrLight as [NSAttributedString.Key : Any]))
        attrText.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attrText.length))
        lblInfo.attributedText = attrText
        
        innerView.addSubview(lblInfo)
        lblInfo.anchor(
            top: lblConfirmation.bottomAnchor, left: innerView.leftAnchor,
            bottom: nil, right: innerView.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        
        let btnExploreListing = UIButton()
        btnExploreListing.setTitle("Explore other listing", for: .normal)
        btnExploreListing.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btnExploreListing.backgroundColor = .white
        //btnExploreListing.layer.cornerRadius = 5
        btnExploreListing.titleLabel?.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        
        innerView.addSubview(btnExploreListing)
        btnExploreListing.anchor(
            top: nil, left: innerView.leftAnchor,
            bottom: innerView.bottomAnchor, right: innerView.rightAnchor,
            paddingTop: 30, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 60)
        
        innerView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        //innerView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        //innerView.backgroundColor = .red
        v.backgroundColor = UIColor.init(hexString: "#1D82D6")
        return v
    }()
    
   
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        view.addSubview(viewBody)
        viewBody.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)

    }
    
    @objc private func goBack(){
       print("Back")
    }
    @objc private func goSubmit(){
        print("Submit")
    }
}
