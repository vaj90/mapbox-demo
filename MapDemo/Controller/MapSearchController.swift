//
//  MapSearchController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-05-12.
//


import UIKit
import CoreLocation
import MapboxMaps
//import MapboxSearch
//import MapboxSearchUI

class MapSearchController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    internal var mapView: MapView!
    var locationManager: CLLocationManager!
    var geoCoder = CLGeocoder()
    var centerCoordinate: CLLocationCoordinate2D!
    var polygonAnnotationManager: PolygonAnnotationManager!
    var polylineAnnotationManager: PolylineAnnotationManager!
    var resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYmxvY2VzdGF0ZTEiLCJhIjoiY2xjeXd6aW40MDAwbzNxbzQ4a2xzMXQ2biJ9.wOAZ-fxbPhXhLouH7uFpcA")
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        view.backgroundColor = .white
        setUpView()
    }
    var locationTitle : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Toronto - North York"
        label.font = UIFont(name:"Ubuntu-Bold", size: 18)
        return label
    }()
    var headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        let attrNormalText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 24)];
        let attrBoldText = [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)];
        let attributeText = NSMutableAttributedString(string: "What is your", attributes: attrNormalText as [NSAttributedString.Key : Any])
        attributeText.append(NSAttributedString(string: " full name?", attributes: attrBoldText as [NSAttributedString.Key : Any]))
        label.attributedText = attributeText
        return label
    }()

    
    var headerTitle : UIView = {
        let v = UIView()
        
        let imgStar = UIImage(named:"star")?.withRenderingMode(.alwaysTemplate)
        var imgSt = UIImageView(image: imgStar!)
        imgSt.tintColor = UIColor.init(hexString: "#1D82D6")
        imgSt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgSt.isUserInteractionEnabled = true
        
        let imgMarker = UIImage(named:"marker1")?.withRenderingMode(.alwaysTemplate)
        var imgMark = UIImageView(image: imgMarker!)
        imgMark.tintColor = UIColor.init(hexString: "#1D82D6")
        imgMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgMark.isUserInteractionEnabled = true
        
        let lblSearch = UILabel()
        lblSearch.textColor = UIColor.init(hexString: "#1D82D6")
        lblSearch.text = "SEARCH"
        lblSearch.font = UIFont(name:"Ubuntu-Bold", size: 20)

        v.addSubview(imgSt)
        v.addSubview(imgMark)
        v.addSubview(lblSearch)
        lblSearch.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 0,
            width: 0, height: 0)
        lblSearch.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        imgSt.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 20,
            paddingBottom: 20, paddingRight: 0,
            width: 30, height: 30)
        imgMark.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 20,
            width: 30, height: 30)

        v.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }()

    
    lazy var mapContainer : UIView = {
        let v = UIView()
        
        let imgBack = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgB = UIImageView(image: imgBack!)
        imgB.tintColor = UIColor.init(hexString: "#1D82D6")
        imgB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgB.isUserInteractionEnabled = true
        
        v.addSubview(imgB)
        imgB.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: nil,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 20, paddingRight: 0,
            width: 30, height: 30)
  
        let imgMarker = UIImage(named:"marker")?.withRenderingMode(.alwaysTemplate)
        var imgMark = UIImageView(image: imgMarker!)
        imgMark.tintColor = UIColor.init(hexString: "#1D82D6")
        imgMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        imgMark.isUserInteractionEnabled = true

        v.addSubview(locationTitle)
        locationTitle.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: nil,
            paddingTop: 5, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        locationTitle.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        v.addSubview(imgMark)
        imgMark.anchor(
            top: v.topAnchor, left: nil,
            bottom: nil, right: locationTitle.leftAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 5,
            width: 28, height: 28)
        

        
        return v
    }()
    
    
    lazy var viewBody: UIView = {
        let v  = UIView()
        v.addSubview(headerTitle)
        headerTitle.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 0, height: 80)
        
        v.addSubview(mapContainer)
        mapContainer.anchor(
                top: headerTitle.bottomAnchor, left: v.leftAnchor,
                bottom: nil, right: v.rightAnchor,
                paddingTop: 0, paddingLeft: 10,
                paddingBottom: 0, paddingRight: 10,
                width: 0, height: 30)
        
        //default coordinate toronto
        centerCoordinate = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)
        let options = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: CameraOptions(center: centerCoordinate, zoom: 7), styleURI: .streets)
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        polygonAnnotationManager = mapView.annotations.makePolygonAnnotationManager()
        polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        polygonAnnotationManager.delegate = self
        polylineAnnotationManager.delegate = self
        v.addSubview(mapView)
        mapView.anchor(
            top: mapContainer.bottomAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 10, paddingLeft: 10,
            paddingBottom: 0, paddingRight: 10,
            width: 0, height: 350)
        
        mapView.mapboxMap.onNext(event: .mapLoaded){ [weak self] _ in
            guard let self = self else { return }
            //mapView.camera.ease(to: CameraOptions(center: centerCoordinate, zoom: 10, pitch: 5),duration: 1.3)
            addMarker(at: centerCoordinate)
            getGeoJSON(arrIds: [84,85,86])
        }
        v.backgroundColor = UIColor.init(hexString: "#25edd5")
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"down")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = .black
        
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        
        let innerView = UIView()
        innerView.addSubview(imgV)
        imgV.anchor(
            top: nil, left: nil,
            bottom: innerView.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 5, paddingRight: 0,
            width: 25, height: 25)
        imgV.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        
        v.addSubview(innerView)
        innerView.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: -15, paddingRight: 0,
            width: 50, height: 50)
        innerView.backgroundColor =  .white
        innerView.layer.cornerRadius = 20
        innerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        innerView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
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
             width: 0, height: /*height?.native ??*/ 44)
         
         view.addSubview(viewBody)
         viewBody.anchor(
             top: topNav.bottomAnchor, left: topNav.leftAnchor,
             bottom: view.bottomAnchor, right: topNav.rightAnchor,
             paddingTop: -15, paddingLeft: 0,
             paddingBottom: -15, paddingRight: 0,
             width: 0, height: 0)

     }
    @objc private func goBack(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("tapped")
    }
    func getGeoJSON(arrIds: [Int]) {
        var ids = arrIds.map{String($0)}
        let strIds = ids.joined(separator: ",")
        var url = "https://blocestate-mobile-api.azurewebsites.net/api/neighbourhoods/filter?neighbourhoodids=\(strIds)"
        MapManager.instance.get(url: "\(url)") { [self]
            (response, error) in
            if let result = response {
                do{
                    var firstGeo: CLLocationCoordinate2D!
                    let geoJson = try JSONDecoder().decode(GeoJsonModel.self, from: result)
                    var polygonAnnotations: [PolygonAnnotation] = []
                    var polylineAnnotations: [PolylineAnnotation] = []
                    for geo in geoJson.features {
                        let coords = geo.geometry.coordinates.first
                        let identifier = "\(geo.properties.propertyID)"
                        var polygonAnnotation = createPolygon(id: identifier, coords: coords!)
                        var lineAnnotation = createPolyline(id: identifier, coords: coords!)
                        polygonAnnotation.userInfo = [
                            "title": geo.properties.title,
                            "description": geo.properties.description
                        ]
                        polygonAnnotations.append(polygonAnnotation)
                        polylineAnnotations.append(lineAnnotation)
                        if firstGeo == nil {
                            if let center = polygonAnnotation.polygon.center {
                                let lat = center.latitude
                                let lng = center.longitude
                                firstGeo = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            }
                        }
                    }
                    self.polygonAnnotationManager.annotations = polygonAnnotations
                    self.polylineAnnotationManager.annotations = polylineAnnotations
                    if firstGeo != nil {
                        self.mapView.mapboxMap.setCamera(to: CameraOptions(center: firstGeo, zoom: 12, pitch: 5))
                    }
                    
                }catch{
                    print("something went wrong!")
                 }
            }
        }
    }
    func createPolygon(id: String, coords:[[Double]] ) -> PolygonAnnotation{
        var ringCoords : [CLLocationCoordinate2D] = []
        for coord in coords {
            let lng = coord[0]
            let lat = coord[1]
            ringCoords.append(CLLocationCoordinate2DMake(lat,lng))
        }
        let ring = Ring(coordinates: ringCoords)
        let polygon = Polygon(outerRing: ring)
        var polygonAnnotation = PolygonAnnotation(id: id, polygon: polygon)
        polygonAnnotation.fillOpacity = 0.4
        polygonAnnotation.fillColor = StyleColor.init(UIColor.init(hexString: "#1D82D6"))
        return polygonAnnotation
    }
    func createPolyline(id: String, coords:[[Double]] ) -> PolylineAnnotation{
        var ringCoords : [CLLocationCoordinate2D] = []
        for coord in coords {
            let lng = coord[0]
            let lat = coord[1]
            ringCoords.append(CLLocationCoordinate2DMake(lat,lng))
        }
        var lineAnnotation =  PolylineAnnotation(id: id, lineCoordinates: ringCoords)
        lineAnnotation.lineColor = StyleColor.init(UIColor.init(hexString: "#0080FF"))
        lineAnnotation.lineOpacity = 0.4
        lineAnnotation.lineWidth = 1
        return lineAnnotation
    }

    func addMarker(at coordinate: CLLocationCoordinate2D) -> Void {
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        pointAnnotation.image = .init(image: UIImage(named: "marker")!, name: "marker")
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.annotations = [pointAnnotation]
    }
    //updating current coordinate.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}
extension MapSearchController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard let tappedAnnotation = annotations.first else {return}
        DispatchQueue.main.async { [self] in
            resetPolyline()
            if let pManager = self.polylineAnnotationManager,
                let idx = pManager.annotations.firstIndex(where:  { $0.id == tappedAnnotation.id }) {
                var annotation = pManager.annotations[idx]
                annotation.lineOpacity = 1.0
                annotation.lineWidth = 2
                pManager.annotations[idx] = annotation
            }
            if let polyManager = self.polygonAnnotationManager,
                let selectedAnnotation = polyManager.annotations.firstIndex(where:  { $0.id == tappedAnnotation.id }) {
                var pAnnotation = polyManager.annotations[selectedAnnotation]
                if let center = pAnnotation.polygon.center {
                    let lat = center.latitude
                    let lng = center.longitude
                    let reCenter = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    let camOption = CameraOptions(center: reCenter, zoom: 12, pitch: 5)
                    self.mapView.mapboxMap.setCamera(to: camOption)
                }
                if let userInfo = pAnnotation.userInfo {
                    let title: String = userInfo["title"] as! String
                    locationTitle.text = title
                }
            }
        }
    }
    func resetPolyline(){
        let annotations = polylineAnnotationManager.annotations
        for annotation in annotations {
            if let pManager = self.polylineAnnotationManager,
                let idx = pManager.annotations.firstIndex(where:  { $0.id == annotation.id }) {
                var polyAnnotation = annotation
                polyAnnotation.lineOpacity = 0.4
                polyAnnotation.lineWidth = 1
                pManager.annotations[idx] = polyAnnotation
            }
        }
    }
   
}
