//
//  BuildingDetailsController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-02.
//
//


import UIKit
import SwiftCarousel
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
        self.setUpView()
        
        getBuilding(id: 3){ result, error in
            if let error = error{
            }else{
                if let result = result {
                    self.buildingDetails = result.data
                    self.slideItems = self.buildingDetails.properties.map {
                        self.createSlide(urlString: $0.thumbnail)
                    }
                    self.createSlideView()
                }
            }
        }
        /*self.itemViews = [
            "https://ddfcdn.realtor.ca/listing/TS638171621348600000/reb82/highres/5/c6029395_1.jpg",
            "https://ddfcdn.realtor.ca/listing/TS638168253240900000/reb82/highres/3/c6010313_1.jpg",
            "https://ddfcdn.realtor.ca/listing/TS638171112816070000/reb82/highres/4/c5910004_1.jpg"
        ].map {
            self.createImageView(url: $0)
        }
        self.slideItems = [
            "https://ddfcdn.realtor.ca/listing/TS638171621348600000/reb82/highres/5/c6029395_1.jpg",
            "https://ddfcdn.realtor.ca/listing/TS638168253240900000/reb82/highres/3/c6010313_1.jpg",
            "https://ddfcdn.realtor.ca/listing/TS638171112816070000/reb82/highres/4/c5910004_1.jpg"
        ].map {
            self.createSlide(urlString: $0)
        }
        self.createSlideView()*/
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
        /*let carouselFrame = CGRect(x: view.center.x - 150.0, y: view.center.y - 100.0, width: 400, height: 200)
        carouselFrame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        carouselView = SwiftCarousel(frame: carouselFrame)
        carouselView.items = self.itemViews
        carouselView.resizeType = .withoutResizing(10.0)
        carouselView.resizeType = .visibleItemsPerPage(1)
        carouselView.delegate = self
        carouselView.defaultSelectedIndex = 2
        
        view.addSubview(carouselView)
        carouselView.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 5,
            paddingBottom: 0, paddingRight: 5,
            width: 0, height: 180)*/
        carousel = ZKCarousel()
        carousel.slides = slideItems
        carousel.frame = CGRect()
        view.addSubview(carousel)
        carousel.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 5,
            paddingBottom: 0, paddingRight: 5,
            width: 0, height: 180)
    }
   
    lazy var topNav: UIView = {
        let v  = UIView()
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .white
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        v.addSubview(imgV)
        imgV.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 60, paddingLeft: 10,
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
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        topNav.layer.zPosition = 1
    }
    
    @objc private func goBack(){
        print("tapped")
    }
}

