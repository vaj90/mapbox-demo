//
//  DateSelectionController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-21.
//

import UIKit
import FSCalendar

class DateSelectionController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance  {
    var delegate : SelectDateDelegate?
    var calendar: FSCalendar!
    var datePick: String!
    let dF = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        dF.dateFormat = "MMMM dd, yyyy"
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
        if datePick != "" {
            calendar.select(dF.date(from: datePick))
        }
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
        let result = dF.string(from: date)
        delegate?.selectDate(date: result)
        self.dismiss(animated: true)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            return false
        }
        else {
            return true
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let dateString = dF.string(from: date)

        if datePick == dateString {
            return UIColor.init(hexString: "#1D82D6")
        }
        
        return appearance.selectionColor
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date .compare(Date()) == .orderedAscending {
            return UIColor.init(hexString: "#e9ebed")
        }
        return appearance.titleDefaultColor
    }
}

