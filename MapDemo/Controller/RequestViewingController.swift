//
//  RequestViewingController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-16.
//

import UIKit

class RequestViewingController: UIViewController, SelectDateDelegate, SelectPassengerDelegate {
    var dateSelected: String!
    var paxCnt: Int = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    func selectDate(date: String) {
        print(date)
        dateSelected = date
        lblDate.text = date
    }
    func selectPax(paxCount: Int) {
        print(paxCount)
        paxCnt = paxCount
        lblPax.text = "\(paxCount) PAX"
    }
    lazy var lblDate: UILabel =  {
        var lbl = UILabel()
        lbl.textColor = UIColor.init(hexString: "#1D82D6")
        lbl.textAlignment = .left
        lbl.font = UIFont(name:"Ubuntu-Bold", size: 16)
        return lbl
    }()
    lazy var lblTime: UILabel =  {
        var lbl = UILabel()
        lbl.textColor = UIColor.init(hexString: "#1D82D6")
        lbl.textAlignment = .left
        lbl.font = UIFont(name:"Ubuntu-Bold", size: 16)
        return lbl
    }()
    lazy var lblPax: UILabel =  {
        var lbl = UILabel()
        lbl.textColor = UIColor.init(hexString: "#1D82D6")
        lbl.textAlignment = .left
        lbl.font = UIFont(name:"Ubuntu-Bold", size: 16)
        return lbl
    }()
    
    
    lazy var paragraph: NSMutableParagraphStyle =  {
        let p = NSMutableParagraphStyle()
        p.alignment = .justified
        p.baseWritingDirection = .leftToRight
        return p
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    func createOptionView(imgName: String, lbl: UILabel) -> UIView {
        let v = UIView()
        let imgEl = UIImage(named:imgName)?.withRenderingMode(.alwaysTemplate)
        var imgE = UIImageView(image: imgEl!)
        imgE.tintColor = UIColor.init(hexString: "#1D82D6")
        
        let imgAdd = UIImage(named:"add")?.withRenderingMode(.alwaysTemplate)
        var imgA = UIImageView(image: imgAdd!)
        imgA.tintColor = UIColor.init(hexString: "#1D82D6")
        
        v.addSubview(imgE)
        imgE.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 20, paddingLeft: 30,
            paddingBottom: 20, paddingRight: 0,
            width: 30, height: 30)
        v.addSubview(imgA)
        imgA.anchor(
            top: v.topAnchor, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 30,
            width: 30, height: 30)
        v.addSubview(lbl)
        lbl.anchor(
            top: v.topAnchor, left: imgE.rightAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 30,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        lbl.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        return v
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let lblRequest = UILabel()
        lblRequest.numberOfLines = 0
        lblRequest.textColor = UIColor.init(hexString: "#1D82D6")
        lblRequest.textAlignment = .center
        lblRequest.font = UIFont(name:"Ubuntu-Bold", size: 22)
        lblRequest.text = "Viewing request for \n5301-88 Scott St."
        
        
        let lblAgreement = UILabel()
        lblAgreement.numberOfLines = 0
        lblAgreement.textColor = UIColor.init(hexString: "#1D82D6")
        lblAgreement.textAlignment = .justified
        lblAgreement.font = UIFont(name:"Ubuntu-Light", size: 14.0)
        let attrLight = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 14)];
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string:
                                            "By submitting a viewing request, you confirm that you\n" +
                                           "are not currently engaged in a Buyer Representation\n" +
                                           "Agreement or Customer Service Agreement with\n" +
                                           "another Realtor or real estate brokerage."
                                           ,attributes: attrLight as [NSAttributedString.Key : Any]))
        attrText.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attrText.length))
        lblAgreement.attributedText = attrText
        //containers
        let optCon = UIView()
        optCon.backgroundColor = UIColor.init(hexString: "#e9ebed")
        dateFormatter.dateStyle = .long
        lblDate.text = dateFormatter.string(from: date)
        let dateCon = createOptionView(imgName: "calendar",lbl: lblDate)
        dateCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (datePick (_:))))
        
        lblTime.text = "TIME"
        let timeCon = createOptionView(imgName: "time", lbl: lblTime)
        
        lblPax.text = "0 PAX"
        let paxCon = createOptionView(imgName: "user", lbl: lblPax)
        paxCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (paxPick (_:))))
       
        v.addSubview(lblRequest)
        lblRequest.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 40, paddingLeft: 30,
            paddingBottom: 40, paddingRight: 30,
            width: 0, height: 0)
        
        v.addSubview(optCon)
        optCon.anchor(
            top: lblRequest.bottomAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 40, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 210)
        
        optCon.addSubview(dateCon)
        dateCon.anchor(
            top: optCon.topAnchor, left: optCon.leftAnchor,
            bottom: nil, right: optCon.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 70)
        optCon.addSubview(timeCon)
        timeCon.anchor(
            top: dateCon.bottomAnchor, left: optCon.leftAnchor,
            bottom: nil, right: optCon.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 70)
        optCon.addSubview(paxCon)
        paxCon.anchor(
            top: timeCon.bottomAnchor, left: optCon.leftAnchor,
            bottom: nil, right: optCon.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 70)
        
        
        v.addSubview(lblAgreement)
        lblAgreement.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 30,
            paddingBottom: 40, paddingRight: 30,
            width: 0, height: 0)
        
        v.backgroundColor = .white
        v.layer.cornerRadius = 15
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .white
        imgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgV.isUserInteractionEnabled = true
        
        let topNavLbl = UILabel()
        topNavLbl.numberOfLines = 0
        topNavLbl.textColor = .white
        let attrLight = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 14)];
        let attrBold = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 20)];
        let attributeText = NSMutableAttributedString()
        attributeText.append(NSAttributedString(string: "Awesome!", attributes: attrLight as [NSAttributedString.Key : Any]))
        attributeText.append(NSAttributedString(string: "\nHere are the next steps.", attributes: attrBold as [NSAttributedString.Key : Any]))
        attributeText.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attributeText.length))
        topNavLbl.attributedText = attributeText
        
        v.addSubview(topNavLbl)
        topNavLbl.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 30,
            paddingBottom: 30, paddingRight: 30,
            width: 0, height: 50)

        v.addSubview(imgV)
        imgV.anchor(
            top: nil, left: v.leftAnchor,
            bottom: topNavLbl.topAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 20, paddingRight: 0,
            width: 32, height: 32)

        v.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        v.layer.cornerRadius = 15
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.layer.zPosition = 1
        return v
    }()
    
    lazy var bottomNav: UIView = {
        let v  = UIView()
        let lblSubmit = UILabel()
        lblSubmit.textColor = .white
        lblSubmit.textAlignment = .center
        lblSubmit.text = "SUBMIT VIEWING REQUEST"
        lblSubmit.font = UIFont(name:"Ubuntu-Bold", size: 14.0)
        lblSubmit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goSubmit)))
        lblSubmit.isUserInteractionEnabled = true
        
        v.addSubview(lblSubmit)
        lblSubmit.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 10, paddingRight: 0,
            width: 0, height: 20)
        v.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        v.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }()

    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor =  UIColor.init(hexString: "#1D82D6")
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: /*height?.native ??*/ 150)
        
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
    @objc func datePick(_ sender:UITapGestureRecognizer){
        let vc =  DateSelectionController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @objc func timePick(_ sender:UITapGestureRecognizer){

    }
    @objc func paxPick(_ sender:UITapGestureRecognizer){
        let vc =  PaxSelectionController()
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        vc.paxCount = paxCnt
        self.present(vc, animated: true)
    }
    @objc private func goBack(){
       self.navigationController?.popViewController(animated: true )
    }
    @objc private func dataSelection(){
            
    }
    @objc private func goSubmit(){

    }
}
