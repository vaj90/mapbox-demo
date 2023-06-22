//
//  PaxSelectionController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-22.
//

import UIKit


class PaxSelectionController: UIViewController, UITextFieldDelegate {
    var paxCount: Int = 0
    var delegate : SelectPassengerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    func createBtn(imgName: String) -> UIButton{
        let btn = UIButton()
        btn.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btn.backgroundColor = UIColor.init(hexString: "#e9ebed")
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btn.layer.borderColor = UIColor.init(hexString: "#e9ebed").cgColor
        btn.layer.borderWidth = 1
        let img = UIImage(named:imgName)?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        //btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.configuration?.imagePadding = 5
        return btn
    }
    lazy var paxField: UITextField = {
        let tf = UITextField()
        tf.text = "\(paxCount)"
        return tf
    }()
    lazy var viewBody: UIView = {
        let v  = UIView()
        let img = UIImage(named:"cross")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1D82D6")
        
        imgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeModal)))
        imgV.isUserInteractionEnabled = true
        
        v.addSubview(imgV)
        imgV.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 15, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 15,
            width: 32, height: 32)
        
        let lblTitle = UILabel()
        lblTitle.textColor = UIColor.init(hexString: "#1D82D6")
        lblTitle.text = "Party Count"
        lblTitle.font = UIFont(name:"Ubuntu-Light", size: 18)
        lblTitle.textAlignment = .center
        v.addSubview(lblTitle)
        lblTitle.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 50, paddingLeft: 15,
            paddingBottom: 20, paddingRight: 15,
            width: v.frame.width, height: 30)
        lblTitle.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        let paxDiv = UIView()
        v.addSubview(paxDiv)
        paxDiv.anchor(
            top: lblTitle.bottomAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 15,
            paddingBottom: 20, paddingRight: 15,
            width: v.frame.width, height: 50)
        paxDiv.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        paxField.delegate = self
        paxField.isEnabled = false
        paxField.textAlignment = .center
        paxField.borderStyle = .roundedRect
        paxDiv.addSubview(paxField)
        paxField.anchor(
            top: paxDiv.topAnchor, left: nil,
            bottom: paxDiv.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 20,
            paddingBottom: 0, paddingRight: 20,
            width: 80, height: 30)
        
        paxField.centerXAnchor.constraint(equalTo: paxDiv.centerXAnchor).isActive = true
        paxField.centerYAnchor.constraint(equalTo: paxDiv.centerYAnchor).isActive = true
        
        let btnAdd = createBtn(imgName: "add")
        btnAdd.addTarget(self, action: #selector(paxAdd(_:)), for: .touchUpInside)
        let btnSub = createBtn(imgName: "minus")
        btnSub.addTarget(self, action: #selector(paxSub(_:)), for: .touchUpInside)
        paxDiv.addSubview(btnAdd)
        btnAdd.anchor(
            top: paxDiv.topAnchor, left: paxField.rightAnchor,
            bottom: paxDiv.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 40,
            paddingBottom: 0, paddingRight: 0,
            width: 50, height: 50)
        paxDiv.addSubview(btnSub)
        btnSub.anchor(
            top: paxDiv.topAnchor, left: nil,
            bottom: paxDiv.bottomAnchor, right: paxField.leftAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 40,
            width: 50, height: 50)
        
        
        
        let btnOk = UIButton()
        btnOk.setTitle("Okay", for: .normal)
        btnOk.setTitleColor(.white, for: .normal)
        btnOk.backgroundColor = UIColor.init(hexString: "#1D82D6")
        btnOk.layer.cornerRadius = 5
        btnOk.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btnOk.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnOk.addTarget(self, action: #selector(submitPax(sender:)), for: .touchUpInside)
        
        v.addSubview(btnOk)
        btnOk.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 25, paddingRight: 15,
            width: 0, height: 50)
        v.backgroundColor = .red
        return v
    }()
    
    
    func setUpView(){
        view.addSubview(viewBody)
        viewBody.anchor(
            top: nil, left: nil,
            bottom: view.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: view.frame.width, height: 280)
        viewBody.backgroundColor = .white
        viewBody.layer.shadowColor = UIColor.init(hexString: "#bababa").cgColor
        viewBody.layer.shadowOpacity = 5
        viewBody.layer.shadowOffset = .zero
        viewBody.layer.shadowRadius = 5
    }
    @objc func closeModal(){
        self.dismiss(animated: true)
    }
    @objc func submitPax(sender: UIButton){
        delegate?.selectPax(paxCount: paxCount)
        self.dismiss(animated: true)
    }
    @objc private func paxAdd(_ sender: UIButton){
        paxCount = paxCount + 1
        paxField.text = "\(paxCount)"
    }
    @objc private func paxSub(_ sender: UIButton){
        if(paxCount > 0){
            paxCount = paxCount - 1
        }
        paxField.text = "\(paxCount)"
    }
}
