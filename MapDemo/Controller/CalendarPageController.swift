//
//  CalendarPageController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-30.
//
import UIKit
import FSCalendar
class CalendarPageController: UIViewController, FSCalendarDelegate {
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        label.textAlignment = .center
        label.text = "Request a Viewing"
        label.font = UIFont(name:"Ubuntu-Light", size: 26)
        return label
    }()

    var calendar: FSCalendar!
    
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1D82D6")
        
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        
    
        v.addSubview(imgV)
        imgV.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
            width: 32, height: 32)

        v.backgroundColor =  .white
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.layer.zPosition = 1
        return v
    }()
    
    
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: height?.native ?? 44)
        
        let lblViewDate = UILabel()
        lblViewDate.textColor = UIColor.init(hexString: "#68B2F0")
        lblViewDate.text = "VIEWING DATE"
        lblViewDate.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        lblViewDate.textAlignment = .left
        
        view.addSubview(headerLabel)
        headerLabel.anchor(
            top: topNav.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 20, paddingLeft: 10,
            paddingBottom: 15, paddingRight: 10,
            width: 0, height: 0)
        
        view.addSubview(lblViewDate)
        lblViewDate.anchor(
            top: headerLabel.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 10, paddingLeft: 15,
            paddingBottom: 0, paddingRight: 15,
            width: 0, height: 0)
        
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        view.addSubview(calendar)
        calendar.anchor(
            top: lblViewDate.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 10, paddingLeft: 15,
            paddingBottom: 10, paddingRight: 15,
            width: view.frame.width, height: 350)
        calendar.delegate = self
    }
    
    @objc private func goBack(){
        print("tapped")
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM-yyyy"
           let result = formatter.string(from: date)
        print("Date: \(result)")
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }

}
