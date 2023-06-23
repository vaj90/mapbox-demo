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
    let date = Date()
    let tF = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        tF.dateFormat = "hh:mm a"
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let lblTitle = UILabel()
        lblTitle.textColor = UIColor.init(hexString: "#1D82D6")
        lblTitle.text = "Time: "
        lblTitle.font = UIFont(name:"Ubuntu-Bold", size: 18)
        lblTitle.textAlignment = .left
        v.addSubview(lblTitle)
        lblTitle.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 30, paddingLeft: 50,
            paddingBottom: 30, paddingRight: 15,
            width: 50, height: 0)
        let picker = UIDatePicker()
        picker.datePickerMode = .time;
        v.addSubview(picker)
        picker.anchor(
            top: v.topAnchor, left: lblTitle.rightAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
                paddingTop: 30, paddingLeft: 15,
                paddingBottom: 30, paddingRight: 50,
            width: 100, height: 0)

        picker.contentHorizontalAlignment = .center
        picker.contentVerticalAlignment = .center
        picker.addTarget(self, action: #selector(onChangeTime(_:)), for: .valueChanged)
        if timePick != "" {
            let date = tF.date(from: timePick) ?? Date()
            picker.setDate(date, animated: true)
        }
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        return v
    }()
    @objc private func onChangeTime(_ sender: UIDatePicker){
        timePick =  tF.string(from: sender.date)
        delegate?.selectTime(time: timePick)
        //self.dismiss(animated: true)
    }
    
    func setUpView(){
        view.addSubview(viewBody)
        viewBody.anchor(
            top: nil, left: nil,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 300, height: 100)
        viewBody.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewBody.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewBody.backgroundColor = .white
        viewBody.layer.shadowColor = UIColor.init(hexString: "#bababa").cgColor
        viewBody.layer.shadowOpacity = 1
        viewBody.layer.shadowOffset = .zero
        viewBody.layer.shadowRadius = 5
    }
}

