//
//  BuildingDetailsController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-02.
//
//


import UIKit
import ZKCarousel
class BuildingDetailsController: UIViewController /*SwiftCarouselDelegate*/{
    //var carouselView: SwiftCarousel!
    var carousel: ZKCarousel!
    typealias CompletionHandler = (_ response: Data?, _ error:String?) -> ()
    var buildingDetails: BuildingDetails!
    var itemViews: [UIView]!
    var slideItems: [ZKCarouselSlide]!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        
      
        self.getBuilding(id: 4){ result, error in
            if let error = error{
            }else{
                if let result = result {
                    self.buildingDetails = result.data
                    self.slideItems = self.buildingDetails.properties.map {
                        self.createSlide(urlString: $0.thumbnail)
                    }
                    DispatchQueue.main.async {
                        self.createSlideView()
                    }
                }
            }
        }
        self.setUpView()
    }
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
    func createSlide(urlString: String) -> ZKCarouselSlide {
        let slide: ZKCarouselSlide!
        var img: UIImage!
        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            img = UIImage(data: imageData as Data)
        }
        slide = ZKCarouselSlide(image: img, title: "", description: "")
        return slide
    }
    func createImageView(url: String) -> UIView {
        let v  = UIView()
        let imageView = UIImageView()
        imageView.load(urlString: url)
        imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 200.0, height: 300.0))
        v.addSubview(imageView)
        imageView.anchor(
            top: nil, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 0,
            width: 0, height: 0)
        return v
    }
    func createSlideView()  {
        carousel = ZKCarousel()
        carousel.slides = slideItems
        carousel.frame = CGRect()
        view.addSubview(carousel)
        carousel.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 85, paddingLeft: 5,
            paddingBottom: 0, paddingRight: 5,
            width: 0, height: 180)
        carousel.layer.zPosition = 500
    }
   
    lazy var topNav: UIView = {
        let v  = UIView()
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1D82D6")
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        v.addSubview(imgV)
        imgV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 0,
            width: 25, height: 25)
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        //topNav.backgroundColor = .red
        topNav.layer.zPosition = 1000
    }
    
    @objc private func goBack(){
        print("tapped")
    }
}

