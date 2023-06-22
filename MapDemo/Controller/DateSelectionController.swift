//
//  DateSelectionController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-21.
//

import UIKit
import FSCalendar

class DateSelectionController: UIViewController, FSCalendarDelegate  {
    var delegate : SelectDateDelegate?
    var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        v.addSubview(calendar)
        calendar.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 20,
            paddingBottom: 20, paddingRight: 20,
            width: v.frame.width, height: v.frame.height)
        calendar.delegate = self
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let result = formatter.string(from: date)
        delegate?.selectDate(date: result)
    }
   
}

