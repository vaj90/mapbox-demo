//
//  MapSampleController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-18.
//

import UIKit
import CoreLocation
import MapboxMaps
import CoreData

class MapSampleController: UIViewController, CLLocationManagerDelegate {
    internal var mapView: MapView!
    var locationManager: CLLocationManager!
    var geoCoder = CLGeocoder()
    var centerCoordinate: CLLocationCoordinate2D!
    var polygonAnnotationManager: PolygonAnnotationManager!
    var polylineAnnotationManager: PolylineAnnotationManager!
    var selectedNeighbourhoodId : Int!
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
        setUpMap()
    }
    func getGeoJSON() {
        MapManager.instance.get(url: "https://blocestatefiles.blob.core.windows.net/geojson/neighbourhoods.geojson") { [self]
            (response, error) in
            if let result = response {
                do{
                    let geoJson = try JSONDecoder().decode(GeoJsonModel.self, from: result)
                    var polygonAnnotations: [PolygonAnnotation] = []
                    var polylineAnnotations: [PolylineAnnotation] = []
                    for geo in geoJson.features {
                        if geo.properties.title != "" {
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
                        }
                    }
                    self.polygonAnnotationManager.annotations = polygonAnnotations
                    self.polylineAnnotationManager.annotations = polylineAnnotations
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
    func setUpMap() {
        //default coordinate toronto
        centerCoordinate = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)
        let options = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: CameraOptions(center: centerCoordinate, zoom: 7), styleURI: .streets)
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        polygonAnnotationManager = mapView.annotations.makePolygonAnnotationManager()
        polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        polygonAnnotationManager.delegate = self
        polylineAnnotationManager.delegate = self
        self.view.addSubview(mapView)
        mapView.mapboxMap.onNext(event: .mapLoaded){ [weak self] _ in
            guard let self = self else { return }
            mapView.camera.ease(to: CameraOptions(center: centerCoordinate, zoom: 10, pitch: 5),duration: 1.3)
            addMarker(at: centerCoordinate)
            getGeoJSON()
        }
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
extension MapSampleController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard let tappedAnnotation = annotations.first else {return}
        DispatchQueue.main.async { [self] in
            resetPolyline()
            if let pManager = self.polylineAnnotationManager,
               let idx = pManager.annotations.firstIndex(where:  { $0.id == tappedAnnotation.id }) {
               
                var annotation = pManager.annotations[idx]
                annotation.lineOpacity = 1.0
                annotation.lineWidth = 2
                print(annotation.id)
                self.selectedNeighbourhoodId = Int(annotation.id)
                pManager.annotations[idx] = annotation
            }
            if let polyManager = self.polygonAnnotationManager,
                let selectedAnnotation = polyManager.annotations.firstIndex(where:  { $0.id == tappedAnnotation.id }) {
                var pAnnotation = polyManager.annotations[selectedAnnotation]
                if let userInfo = pAnnotation.userInfo {
                    let title: String = userInfo["title"] as! String
                    print(title)
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
