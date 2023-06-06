//
//  Extensions.swift
//
//
//  Created by iosdev on 03/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit
import Segmentio


/**
 This is a extension created to extend functions for UIViews in the project
 */
extension UIView {
    
    /// Call this function to apply gradient color for UIView
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    /// Call this function to apply gradient color for UIView
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    /// Call this function to anchor controls in UIView
    func anchor(top: NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?, right:NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft:CGFloat, paddingBottom: CGFloat, paddingRight:CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        
    }
   
    
    func dropShadow(scale: Bool = true) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
    }
    /// Call this function to add backgorind color to UIView
    func addBackground(imageName: String!, contentMode: UIView.ContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
}

/**
 This is a extension created to extend functions for UIViewControllers in the project
 */
extension UIViewController {
    
    /// Call this function to show alert message to user in UIViewController
    func displayMessageToUser(title: String?, msg:String?, style: UIAlertController.Style = .alert) {
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    /// Call this function to add custom back button in navigation controller
    func addBackButton(buttonTitle:String?) {
            let btnLeftMenu: UIButton = UIButton()
            let image = UIImage(named: "icn_arrow_left_blue");
            btnLeftMenu.setImage(image, for: .normal)
            guard let bTitle = buttonTitle else {return}
            let myNormalAttributedTitle = NSAttributedString(string: bTitle,
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 16)!])
            
            btnLeftMenu.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            btnLeftMenu.sizeToFit()
            btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: btnLeftMenu)
            self.navigationItem.leftBarButtonItem = barButton
        }
    
    
    /// Call this function to add custom close button in navigation controller
    func addCloseButton(buttonTitle:String?) {
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "icn_close");
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.tintColor = .white
        // .Normal
        guard let bTitle = buttonTitle else {return}
        
        let myNormalAttributedTitle = NSAttributedString(string: bTitle,
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 16)!])
        
        btnLeftMenu.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (closeButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    /// Call this function to handle the back button action when clicked
    @objc func backButtonClick(sender : UIButton) {
            self.navigationController?.popViewController(animated: true);
    }
    
    /// Call this function to handle the close button action when clicked
    @objc func closeButtonClick(sender : UIButton) {
     self.dismiss(animated: true, completion: nil)
    }
    
    /// Call this function to hide keyboard when tapped anywhere in the UIViewController
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    /// Call this function to hide keyboard when tapped anywhere in the UIViewController
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Call this function to display loading indicator in the UIViewController
    func displayLoading(visible:Bool) {
        
        let clearView: UIView = {
            let v = UIView()
            v.backgroundColor =  UIColor.black.withAlphaComponent(0.2)
            let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            myActivityIndicator.center = view.center
            myActivityIndicator.startAnimating()
            myActivityIndicator.style = .whiteLarge
            v.addSubview(myActivityIndicator)
            return v
        }()
        
        if visible == true {
            view.addSubview(clearView)
            clearView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        }else{
        }
    }
}

/**
 This is a extension created to extend functions for UIColors to create custom color in the project
 */
extension UIColor {
    
    /// Call this static function to set rgb color for controls
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
//    /// Call this static function to set rgb color for main blue color of the app
//    static func mainBlue() -> UIColor {
//        return UIColor.rgb(red: 245, green: 98, blue: 34)
//    }
//
    
    /// Call this static function to set rgb color for main blue color of the app
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 216, green: 248, blue: 236)
    }
    /// Call this static function to set rgb color for main blue color of the app
    static func fontBlue() -> UIColor {
        return UIColor.rgb(red: 26, green: 101, blue: 193)
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func onboardingBlue() -> UIColor {
        return UIColor.rgb(red: 48, green: 135, blue: 232)
    }
    /// Call this static function to set rgb color for main blue color of the app
    static func onboardingGray() -> UIColor {
        return UIColor.rgb(red: 229, green: 235, blue: 244)
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func ongoing_assignedStatusColor() -> UIColor {
        return UIColor.rgb(red: 0, green: 128, blue: 0)
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func onHoldStatusColor() -> UIColor {
      return UIColor.rgb(red: 250, green: 192, blue: 35)
    }
    /// Call this static function to set rgb color for main blue color of the app
    static func othersStatusColor() -> UIColor {
        return UIColor.lightGray
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func solvedStatusColor() -> UIColor {
        return UIColor.mainBlue()
    }
    
    
    
    /// Call this static function to set rgb color for main blue color of the app
    static func dueStatusColor() -> UIColor {
        return UIColor.rgb(red: 156, green: 164, blue: 182)
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func settledStatusColor() -> UIColor {
        return UIColor.rgb(red: 43, green: 172, blue: 62)
    }
    
    /// Call this static function to set rgb color for main blue color of the app
    static func overDueStatusColor() -> UIColor {
        return UIColor.rgb(red: 232, green: 16, blue: 62)
    }
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}




/**
 This is a extension created to extend functions for Strings in the project
 */
extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}
extension String {
    func DateConvert(oldFormat:String)->Date{ // format example: yyyy-MM-dd HH:mm:ss
       let isoDate = self
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
       dateFormatter.dateFormat = oldFormat
       return dateFormatter.date(from:isoDate)!
     }
    
    
    
    
    func isValidEmailString(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    var length: Int {
        return count
    }

    
    func isDecimal()->Bool{
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = Locale.current
        return formatter.number(from: self) != nil
    }

    func isValidEmailAddress(testStr:String) -> Bool {
           let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
           let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
           return emailTest.evaluate(with: testStr)
       }
    
    /// Call this function to validate email address entered by the user
//func isValidEmail() -> Bool {
//
//        do {
//            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
//            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
//        } catch {
//            return false
//        }
//    }
    /// Call this function to validate password entered by the user
    func isValidPassword() -> Bool {
        do {
           let regex = try NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{5,}$", options: .caseInsensitive)
           return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
       } catch {
           return false
       }
    }
    
    /// Call this function to condense white space and trim white space in a string
    func condenseWhitespaceAndTrimWhiteSpace() -> String {
            let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
            let condensedString = components.filter { !$0.isEmpty }.joined(separator: " ")
            let trimmedString = condensedString.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
    
    /// Call this function to convert string to double
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    /// Call this function to trim string
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}


/**
 This is a extension created to extend functions for UITextfields in the project
 */
extension UITextField {
  
    /// Call this function to set gray bottom border to UITextfield
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }

    /// Call this function to set red bottom border to UITextfield
    func setBottomBorderRed() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }

    /// Call this function to set green bottom border to UITextfield
    func setBottomBorderGreen() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.rgb(red: 74, green: 103, blue: 173).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

/**
 This is a extension created to extend functions for UITabBar in the project
 */
extension UITabBar {
    
    /// Call this function to set the height of tabbar
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }
}


/**
 This is a extension created to extend functions for UserDefaults in the project
 */
extension UserDefaults{
    
    /// Call this function to save account fields value to Userdefault
    func setAccount(email: String, lname: String, fname:String, userId:Int) {
        set(email, forKey: "email")
        set(fname, forKey: "fname")
        set(lname, forKey: "lname")
        set(userId, forKey: "userId")

        
    }
    
    func setPropertyId(propertyId:String?){
        set(propertyId, forKey: "propertyId")
    }
    /// Call this function to save account fields value to Userdefault
    func setToken(token: String) {
        set(token, forKey: "token")
      
    }

    /// Call this function to remove user info to USerdefault before logout
    func removeUserDefaultValues() {
        removeObject(forKey: "email")
        removeObject(forKey: "fname")
        removeObject(forKey: "lname")
        removeObject(forKey: "token")

    }
}


/**
 This is a extension created to extend functions for UILabels in the project
 */
extension UILabel {
    
    /// Call this function to set border to top of the UILabel
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    /// Call this function to set border to right of the UILabel
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    /// Call this function to set border to bottom of the UILabel
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    /// Call this function to set border to left of the UILabel
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    /// Call this function to set border to middle of the UILabel
    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}


/**
 This is a extension created to extend functions for Data in the project
 /// create data extension to append the string for creation of body

 */
extension Data {
    
    /// this function is created to append data
    mutating func append(_ string: String) {
    
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}


extension CALayer {
    public func configureGradientBackground(_ colors:CGColor...){
        
        let gradient = CAGradientLayer()
        
        let maxWidth = max(self.bounds.size.height,self.bounds.size.width)
        let squareFrame = CGRect(origin: self.bounds.origin, size: CGSize(width: maxWidth, height: maxWidth))
        gradient.frame = squareFrame
        
        gradient.colors = colors
        
        self.insertSublayer(gradient, at: 0)
    }
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}


extension UIFont {
  var bold: UIFont {
    return with(traits: .traitBold)
  } // bold

  var italic: UIFont {
    return with(traits: .traitItalic)
  } // italic

  var boldItalic: UIFont {
    return with(traits: [.traitBold, .traitItalic])
  } // boldItalic


    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
      return self
    } // guard

    return UIFont(descriptor: descriptor, size: 0)
  } // with(traits:)
} // extension
extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: self)
  }
    
    func next(day:Int)->Date{
       var dayComponent    = DateComponents()
       dayComponent.day    = day
       let theCalendar     = Calendar.current
       let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
       return nextDate!
     }

    func past(day:Int)->Date{
       var pastCount = day
       if(pastCount>0){
           pastCount = day * -1
       }
       var dayComponent    = DateComponents()
       dayComponent.day    = pastCount
       let theCalendar     = Calendar.current
       let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
       return nextDate!
    }
    
    func DateConvert(_ newFormat:String)-> String{
       let formatter = DateFormatter()
       formatter.dateFormat = newFormat
       return formatter.string(from: self)
    }
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
}
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
extension Segmentio{
    func setTabMenuOptions()-> SegmentioOptions {
        let options = SegmentioOptions(
                   backgroundColor: .white,
               segmentPosition: .fixed(maxVisibleItems: 4),
                   scrollEnabled: true,
               indicatorOptions: SegmentioIndicatorOptions(
                   type: .bottom,
                   ratio: 1,
                   height: 5,
                   color: UIColor.mainBlue()
       ),
               horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(
                   type: SegmentioHorizontalSeparatorType.none, // Top, Bottom, TopAndBottom
                   height: 1,
                   color: .gray
       ),
               verticalSeparatorOptions:.none,
                   imageContentMode: .center,
                   labelTextAlignment: .center,
                   segmentStates: SegmentioStates(
                       defaultState: SegmentioState(
                           backgroundColor: .clear,
                           titleFont: UIFont(name: "Ubuntu-Bold", size: 18)!,
                           titleTextColor: .gray
                       ),
                       selectedState: SegmentioState(
                           backgroundColor: .clear,
                           titleFont: UIFont(name: "Ubuntu-Bold", size: 18)!,
                           titleTextColor: UIColor.fontBlue()
                       ),
                       highlightedState: SegmentioState(
                           backgroundColor: UIColor.lightGray.withAlphaComponent(0.8),
                           titleFont: UIFont.boldSystemFont(ofSize: 24),
                           titleTextColor: .gray
                       )
           )
       )
        
        return options
    }
    
}


