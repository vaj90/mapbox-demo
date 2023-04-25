//
//  AgeInfoController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-22.
//
import UIKit

class AgeInfoController: UIViewController {
    

    var headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        //label.font = UIFont(name: "Ubuntu-Bold", size: 20)
        label.textAlignment = .center
        let attrNormalText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 24)];
        let attrBoldText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)];
        let attributeText = NSMutableAttributedString(string: "What is your", attributes: attrNormalText as [NSAttributedString.Key : Any])
        attributeText.append(NSAttributedString(string: " age range?", attributes: attrBoldText as [NSAttributedString.Key : Any]))
        label.attributedText = attributeText
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        v.addSubview(headerLabel)
        headerLabel.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 0, height: 0)
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
        imgV.addGestureRecognizer(tap)
        imgV.isUserInteractionEnabled = true
        let label = UILabel()
        label.textColor = .white
        label.text = "2/8"
        v.addSubview(imgV)
        v.addSubview(label)
        imgV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 6, paddingLeft: 15,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        label.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 12, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 15,
            width: 0, height: 0)

        v.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.layer.zPosition = 1
        return v
    }()
    
    lazy var bottomNav: UIView = {
        let v  = UIView()
        let lblSkip = UILabel()
        lblSkip.textColor = .white
        lblSkip.text = "SKIP"
        lblSkip.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goSkip))
        lblSkip.addGestureRecognizer(tapSkip)
        lblSkip.isUserInteractionEnabled = true
        
        let lblNext = UILabel()
        lblNext.textColor = .white
        lblNext.text = "NEXT"
        lblNext.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        let tapNext = UITapGestureRecognizer(target: self, action: #selector(goNext))
        lblNext.addGestureRecognizer(tapNext)
        lblNext.isUserInteractionEnabled = true
        
        v.addSubview(lblSkip)
        v.addSubview(lblNext)
        lblSkip.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 20,
            paddingBottom: 15, paddingRight: 0,
            width: 0, height: 0)
        lblNext.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 15, paddingRight: 20,
            width: 0, height: 0)

        v.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        v.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }()
    func createNavBar(){
        let leftImage = UIImage(named: "left-arrow")
        let leftBtnItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(goBack))
        let rightBtnItem = UIBarButtonItem(title: "2/8", style: .plain, target: self, action: nil)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.init(hexString: "#1D82D6")
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtnItem
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = false
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 44, paddingRight: 0,
            width: 0, height: height?.native ?? 44)
        view.addSubview(bottomNav)
        
        bottomNav.anchor(
            top: nil, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 55)
        
        view.addSubview(viewBody)
        viewBody.anchor(
            top: topNav.bottomAnchor, left: topNav.leftAnchor,
            bottom: bottomNav.topAnchor, right: topNav.rightAnchor,
            paddingTop: -15
            , paddingLeft: 0,
            paddingBottom: -15, paddingRight: 0,
            width: 0, height: 0)

    }
    
    @objc private func goBack(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("tapped")
    }
    @objc private func goNext(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("next")
    }
    @objc private func goSkip(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("skip")
    }
}
