//
//  CalendarPageController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-30.
//
import UIKit
import FSCalendar
import SwiftCarousel
class CalendarPageController: UIViewController, FSCalendarDelegate, SwiftCarouselDelegate {
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        label.textAlignment = .center
        label.text = "Request a Viewing"
        label.font = UIFont(name:"Ubuntu-Light", size: 26)
        return label
    }()
    var arrOfBtns: [UIButton] = []
    var calendar: FSCalendar!
    var carouselView: SwiftCarousel!
    
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
        
        let lblViewTime = UILabel()
        lblViewTime.textColor = UIColor.init(hexString: "#68B2F0")
        lblViewTime.text = "AVAILABLE TIME"
        lblViewTime.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        lblViewTime.textAlignment = .left
        
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
    
        view.addSubview(lblViewTime)
        lblViewTime.anchor(
            top: calendar.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 10, paddingLeft: 15,
            paddingBottom: 0, paddingRight: 15,
            width: 0, height: 0)
        
        let carouselFrame = CGRect(x: view.center.x - 200.0, y: view.center.y - 100.0, width: view.frame.width, height: 80)
        carouselFrame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        carouselView = SwiftCarousel(frame: carouselFrame)
        var arrTime: [String] = [];
        for i in 0...23 {
            for j in 0...1 {
                var strTime = ( i < 10 ) ? "0\(i):" : "\(i):"
                strTime += (j == 0) ? "00" : "\(j*30)"
                strTime += (i <= 12) ? " am" : " pm"
                arrTime.append(strTime)
          }
        }
        print(arrTime)
        let itemsViews = arrTime.map {
            createTimeBtn(string: $0)
        }
        //carouselView.backgroundColor = .red
        carouselView.items = itemsViews
        carouselView.resizeType = .withoutResizing(10.0)
        carouselView.resizeType = .visibleItemsPerPage(5)
        carouselView.delegate = self
        carouselView.defaultSelectedIndex = 9
    
        view.addSubview(carouselView)
    
        carouselView.anchor(
            top: lblViewTime.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 10, paddingLeft: 15,
            paddingBottom: 0, paddingRight: 15,
            width: 0, height: 100)
    }
    func createTimeBtn(string: String) -> UIView {
        let v  = UIView()
        let strArr = string.components(separatedBy: .whitespaces)
        let btnTime = UIButton()
        btnTime.setTitle(string, for: .normal)
        btnTime.setTitleColor(UIColor.init(hexString: "#1F94F5"), for: .normal)
        btnTime.backgroundColor = .white
        btnTime.layer.cornerRadius = 10
        btnTime.titleLabel?.font = UIFont(name:"Ubuntu-Bold", size: 16)
        btnTime.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnTime.layer.borderColor = UIColor.init(hexString: "#1F94F5").cgColor
        btnTime.layer.borderWidth = 1.5
        btnTime.layer.masksToBounds = true
        btnTime.titleLabel?.numberOfLines = 2
        let title = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let timeValue = NSAttributedString(string: "\(strArr[0])\n", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let typeType = NSAttributedString(string: strArr[1], attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        title.append(timeValue)
        title.append(typeType)
        btnTime.setAttributedTitle(title, for: .normal)
        
        v.addSubview(btnTime)
        btnTime.anchor(
            top: v.topAnchor, left: nil,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 10, paddingLeft: 5,
            paddingBottom: 10, paddingRight: 5,
            width: 50, height: 0)
        btnTime.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        btnTime.addTarget(self, action: #selector(selectedBtn(sender:)), for: .touchUpInside)
        btnTime.accessibilityValue = string
        arrOfBtns.append(btnTime)
        
        return v
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
    @objc private func goBack(){
        print("tapped")
    }
    @objc private func setTime(){
        print("time")
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
