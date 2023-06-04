//
//  BuildingDetailsController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-02.
//
//


import UIKit
class BuildingDetailsController: UIViewController{
    typealias CompletionHandler = (_ response: Data?, _ error:String?) -> ()
    var buildingDetails: BuildingDetails!
    var views: [UIView]!
    var propertyViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        self.setUpView()
        
    }
    lazy var buildingInfo: UIView = {
        let v = UIView()
        let contentScroll = UIScrollView()
        let lblName =  UILabel()
        lblName.textColor = UIColor.init(hexString: "#1d82d6")
        lblName.text = self.buildingDetails.building.buildingName
        lblName.font = UIFont(name:"Ubuntu-Bold", size: 17.0)
        
        let lblAddress =  UILabel()
        lblAddress.textColor = UIColor.init(hexString: "#1d82d6")
        lblAddress.text = self.buildingDetails.building.address
        lblAddress.font = UIFont(name:"Ubuntu-Light", size: 13.0)
        
        let lblBuilder =  UILabel()
        lblBuilder.textColor = UIColor.init(hexString: "#1d82d6")
        lblBuilder.text = "by \(self.buildingDetails.building.builder) | Built in \(self.buildingDetails.building.yearBuilt)"
        lblBuilder.font = UIFont(name:"Ubuntu-Bold", size: 13.0)
        
        let lblDescription =  UILabel()
        lblDescription.textColor = UIColor.init(hexString: "#1d82d6")
        lblDescription.text = "DESCRIPTION"
        lblDescription.font = UIFont(name:"Ubuntu-Bold", size: 13.0)
        
        let lblDescInfo =  UILabel()
        lblDescInfo.textColor = UIColor.init(hexString: "#1d82d6")
        lblDescInfo.text = "\(self.buildingDetails.building.description)"
        lblDescInfo.translatesAutoresizingMaskIntoConstraints = false
        lblDescInfo.numberOfLines = 0
        lblDescInfo.lineBreakMode = .byWordWrapping
        lblDescription.textAlignment = .justified
        lblDescInfo.font = UIFont(name:"Ubuntu-Light", size: 13.0)
        
        v.addSubview(contentScroll)
        contentScroll.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        contentScroll.delegate = self
        contentScroll.contentSize = CGSize(width: view.frame.size.width, height: 800)
        contentScroll.addSubview(lblName)
        
        lblName.anchor(
            top: contentScroll.topAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 15, paddingRight: 0,
            width: 0, height: 0)
        contentScroll.addSubview(lblAddress)
        lblAddress.anchor(
            top: lblName.bottomAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 15, paddingRight: 0,
            width: 0, height: 0)
        contentScroll.addSubview(lblBuilder)
        lblBuilder.anchor(
            top: lblAddress.bottomAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 30, paddingRight: 0,
            width: 0, height: 0)
        contentScroll.addSubview(lblDescription)
        lblDescription.anchor(
            top: lblBuilder.bottomAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 30, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        contentScroll.addSubview(lblDescInfo)
        lblDescInfo.anchor(
            top: lblDescription.bottomAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 10, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        
        contentScroll.addSubview(sPropertyView)
        sPropertyView.anchor(
            top: lblDescInfo.bottomAnchor, left: contentScroll.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 30, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: v.frame.width, height: 200)
        sPropertyView.delegate = self
        return v
    }()
    
    func getBuilding(id: Int, completion: @escaping(BuildingDetailsResponse?, String?) -> Void) {
        getBuildingDetailsById(id: id) { (result, error) in
            if let error = error {
                completion(nil, error)
            }else{
                if let result = result {
                    do{
                        let bDetails = try JSONDecoder().decode( BuildingDetailsResponse.self, from: result)
                        completion(bDetails, nil)
                    }catch{
                        completion(nil, "something went wrong!")
                 }
                }
            }
        }
    }
    func createBuidingView(url: String) -> UIView {
        let v = UIView()
        let imageView = UIImageView()
        imageView.load(urlString: url)
        v.addSubview(imageView)
        imageView.anchor(
            top: nil, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: v.frame.width, height: 300)
        imageView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }
    func createBuidingProperty(buildingProperty: Property) -> UIView {
        let v = UIView()
        let innerView = UIView()
        let imageView = UIImageView()
        imageView.load(urlString: buildingProperty.thumbnail)
        
        v.addSubview(innerView)
        innerView.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 150 )
        innerView.addSubview(imageView)
        imageView.anchor(
            top: nil, left: innerView.leftAnchor,
            bottom: nil, right: innerView.rightAnchor,
            paddingTop: 10, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 150)
        imageView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        let lblProp =  UILabel()
        lblProp.textColor = UIColor.init(hexString: "#1d82d6")
        lblProp.numberOfLines = 0
        lblProp.text = "$\(buildingProperty.targetPrice)\n" +
            "\(buildingProperty.address)\n" +
            "\(String(describing: buildingProperty.bedroom ?? 0)) BR |" +
            "\(String(describing: buildingProperty.bathroom ?? 0)) BA"
        lblProp.font = UIFont(name:"Ubuntu-Light", size: 13.0)
        lblProp.lineBreakMode = .byTruncatingTail
        lblProp.adjustsFontSizeToFitWidth = false
        v.addSubview(lblProp)
        lblProp.anchor(
            top: innerView.bottomAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0 )
        v.clipsToBounds = true
        
        return v
    }
    lazy var scrollView: UIScrollView = {
        let sView = UIScrollView()
        sView.showsHorizontalScrollIndicator = false
        sView.isPagingEnabled = true
        sView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: 200)
        for i in 0..<views.count {
            sView.addSubview(views[i])
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y:0, width: view.frame.width, height: 200)
        }
        return sView
    }()
    lazy var sPropertyView: UIScrollView = {
        let sView = UIScrollView()
        sView.showsHorizontalScrollIndicator = false
        sView.isPagingEnabled = true
        sView.contentSize = CGSize(width: 150 * CGFloat(propertyViews.count), height: 200)
        for i in 0..<propertyViews.count {
            sView.addSubview(propertyViews[i])
            propertyViews[i].frame = CGRect(x: i>0 ? (150 * CGFloat(i)) : 0  , y:0, width: 120, height: 200)
        }
        return sView
    }()
    lazy var pageControl: UIPageControl = {
        let pControl = UIPageControl()
        pControl.numberOfPages = views.count
        pControl.addTarget(self, action: #selector(pageControlTapHandler(_:)), for: .valueChanged)
        return pControl
    }()
    
    @objc private func pageControlTapHandler(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x:CGFloat(current) * view.frame.size.width , y: 0), animated: true)
    }
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .white //UIColor.init(hexString: "#1D82D6")
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        v.addSubview(imgV)
        imgV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 0,
            width: 25, height: 25)
        return v
    }()
    func getBuildingDetailsById(id: Int,completion:@escaping(CompletionHandler)){
        let url = URL(string: "https://blocestate-mobile-api.azurewebsites.net/api/building/details")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        let body = ["buildingId": "\(id)"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = bodyData
            let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                    completion(nil, error.localizedDescription)
                }
                if let data = data {
                    completion(data, nil)
                }
            })
            task.resume()
        }
        catch _ {
            print ("Oops something went wrong")
        }
    }

    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 32)
        topNav.layer.zPosition = 1000
        self.getBuilding(id: 3){ result, error in
            if let error = error{
            }else{
                if let result = result {
                    self.buildingDetails = result.data
                    self.views = self.buildingDetails.building.media.map {
                        self.createBuidingView(url: $0.url)
                    }
                    self.propertyViews = self.buildingDetails.properties.map {
                        self.createBuidingProperty(buildingProperty: $0)
                    }
                    DispatchQueue.main.async {
                        self.createView()
                    }
                }
            }
        }
    }
    
    func createView(){
        view.addSubview(scrollView)
        scrollView.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: view.frame.width, height: 200)

        view.addSubview(pageControl)
        pageControl.anchor(
            top: scrollView.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: -30, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 30)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        scrollView.delegate = self
        
        view.addSubview(buildingInfo)
        buildingInfo.anchor(
            top: pageControl.bottomAnchor, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 30, paddingLeft: 20,
            paddingBottom: 0, paddingRight: 20,
            width: 0, height: 0)
        
    }
    
    @objc private func goBack(){
        print("tapped")
    }
}
extension BuildingDetailsController:  UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        
    }
}
