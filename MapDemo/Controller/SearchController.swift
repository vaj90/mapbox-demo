//
//  ViewController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-18.
//

import UIKit

class SearchController: UIViewController {
    
    var isRent: Bool = false
    var isBuy: Bool = false
    var isBothRentAndBuy: Bool = false
    var arrOfBtns: [UIButton] = []
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        let attrNormalText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 24)];
        let attrBoldText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)];
        let attributeText = NSMutableAttributedString(string: "What is your", attributes: attrNormalText as [NSAttributedString.Key : Any])
        attributeText.append(NSAttributedString(string: " search type?", attributes: attrBoldText as [NSAttributedString.Key : Any]))
        label.attributedText = attributeText
        return label
    }()
    lazy var rangeRentBudgetCon: UIView = {
        let v  = UIView()
        //let rangeSliderRent =  NMRan
        
        return v
    }()
    
    lazy var searchOptionContainer: UIView  = {
        let v  = UIView()
        let btnToRent = UIButton()
        btnToRent.setTitle("To Rent", for: .normal)
        btnToRent.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btnToRent.backgroundColor = .white
        btnToRent.layer.cornerRadius = 5
        btnToRent.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btnToRent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnToRent.addTarget(self, action: #selector(selectedBtn(sender:)), for: .touchUpInside)
        btnToRent.accessibilityValue = "ToRent"
        
        let btnToBuy = UIButton()
        btnToBuy.setTitle("To Buy", for: .normal)
        btnToBuy.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btnToBuy.backgroundColor = .white
        btnToBuy.layer.cornerRadius = 5
        btnToBuy.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btnToBuy.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnToBuy.addTarget(self, action: #selector(selectedBtn(sender:)), for: .touchUpInside)
        btnToBuy.accessibilityValue = "ToBuy"
        
        let btnToRentAndBuy = UIButton()
        btnToRentAndBuy.setTitle("To Both", for: .normal)
        btnToRentAndBuy.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btnToRentAndBuy.backgroundColor = .white
        btnToRentAndBuy.layer.cornerRadius = 5
        btnToRentAndBuy.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btnToRentAndBuy.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnToRentAndBuy.addTarget(self, action: #selector(selectedBtn(sender:)), for: .touchUpInside)
        btnToRentAndBuy.accessibilityValue = "ToRentAndBuy"
        
        v.addSubview(btnToRent)
        btnToRent.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 20, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 240, height: 40)
        
        v.addSubview(btnToBuy)
        btnToBuy.anchor(
            top: btnToRent.bottomAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 240, height: 40)

        v.addSubview(btnToRentAndBuy)
        btnToRentAndBuy.anchor(
            top: btnToBuy.bottomAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 240, height: 40)
        
        btnToRent.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        btnToBuy.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        btnToRentAndBuy.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        arrOfBtns.append(btnToRent)
        arrOfBtns.append(btnToBuy)
        arrOfBtns.append(btnToRentAndBuy)
        return v
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
            paddingTop: 40, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 0, height: 0)
        v.addSubview(searchOptionContainer)
        searchOptionContainer.anchor(
            top: headerLabel.bottomAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 0, height: 200)
        v.backgroundColor = UIColor.init(hexString: "#1D82D6")
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1D82D6")
        
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        
        let lblStep = UILabel()
        lblStep.textColor = UIColor.init(hexString: "#1D82D6")
        lblStep.text = "1/8"
        lblStep.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        lblStep.textAlignment = .center
        
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goSkip))
        lblStep.addGestureRecognizer(tapSkip)
        lblStep.isUserInteractionEnabled = true
        
        v.addSubview(imgV)
        v.addSubview(lblStep)
        imgV.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
            width: 32, height: 32)
        lblStep.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 5, paddingRight: 15,
            width: 32, height: 32)

        v.backgroundColor =  .white
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.layer.zPosition = 1
        return v
    }()
    
    lazy var bottomNav: UIView = {
        let v  = UIView()
        let lblSkip = UILabel()
        lblSkip.textColor = UIColor.init(hexString: "#68B2F0")
        lblSkip.text = "SKIP"
        lblSkip.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goSkip))
        lblSkip.addGestureRecognizer(tapSkip)
        lblSkip.isUserInteractionEnabled = true
        
        let lblNext = UILabel()
        lblNext.textColor = UIColor.init(hexString: "#1D82D6")
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
            paddingBottom: 20, paddingRight: 0,
            width: 0, height: 0)
        lblNext.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 20,
            width: 0, height: 0)

        v.backgroundColor =  .white
        v.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }()
    /*func createNavBar(){
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
    }*/
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: /*height?.native ??*/ 44)
        
        view.addSubview(bottomNav)
        bottomNav.anchor(
            top: nil, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 65)
        
        view.addSubview(viewBody)
        viewBody.anchor(
            top: topNav.bottomAnchor, left: topNav.leftAnchor,
            bottom: bottomNav.topAnchor, right: topNav.rightAnchor,
            paddingTop: -15, paddingLeft: 0,
            paddingBottom: -15, paddingRight: 0,
            width: 0, height: 0)

    }
    
    @objc private func goBack(){
       self.navigationController?.popViewController(animated: true )
    }
    @objc private func goNext(){
        let nextController = AgeInfoController()
        self.navigationController?.pushViewController(nextController, animated: true )
        print("next")
    }
    @objc private func goSkip(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("skip")
    }
 
    @objc func selectedBtn(sender : UIButton) {
        let valStr: String!
        valStr = sender.accessibilityValue?.description
        print(valStr!)
        deselectButtons()
        sender.backgroundColor = UIColor.init(hexString: "#1F94F5")
        sender.setTitleColor(.white, for: .normal)
    }
    func deselectButtons(){
        for btn in arrOfBtns
        {
            btn.backgroundColor = .white
            btn.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        }
    }
}

