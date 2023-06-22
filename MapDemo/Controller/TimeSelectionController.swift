//
//  TimeSelectionController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-22.
//
import UIKit

class TimeSelectionController: UIViewController  {
    var delegate : SelectTimeDelegate?
    var timePick: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()

     
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        return v
    }()
    
    
    func setUpView(){
        view.addSubview(viewBody)
        viewBody.anchor(
            top: nil, left: nil,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 300, height: 300)
        viewBody.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewBody.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewBody.backgroundColor = .white
        viewBody.layer.shadowColor = UIColor.init(hexString: "#bababa").cgColor
        viewBody.layer.shadowOpacity = 1
        viewBody.layer.shadowOffset = .zero
        viewBody.layer.shadowRadius = 5
    }
    @objc func submitPax(){
        delegate?.selectTime(time: timePick)
        self.dismiss(animated: true)
    }
}

