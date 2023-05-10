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
        MapManager.instance.get(url: "https://blocestatefiles.blob.core.windows.net/geojson/neighbourhoods.geojson") {
            (response, error) in
            if let result = response {
                do{
                    let geoJson = try JSONDecoder().decode(GeoJsonModel.self, from: result)
                    var ringCoords : [CLLocationCoordinate2D] = []
                    var polygonAnnotations: [PolygonAnnotation] = []
                    //let polygon = Polygon(outerRing: ring)
                    for geo in geoJson.features {
                        ringCoords = []
                        let coords = geo.geometry.coordinates.first
                        
                        //print("\(coords)\n")
                        for coord in coords! {
                            let lng = coord[0]
                            let lat = coord[1]
                            ringCoords.append(CLLocationCoordinate2DMake(lat,lng))
                        }

                        let ring = Ring(coordinates: ringCoords)
                        let polygon = Polygon(outerRing: ring)
                        let polygonAnnotation = PolygonAnnotation(polygon: polygon)
                        polygonAnnotations.append(polygonAnnotation)
                    }
                    self.polygonAnnotationManager.annotations = polygonAnnotations
                }catch{
                    print("something went wrong!")
                 }
            }
        }
    }
    
    func setUpMap() {
        //default coordinate toronto
        centerCoordinate = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)
        let options = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: CameraOptions(center: centerCoordinate, zoom: 7), styleURI: .streets)
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        mapView.mapboxMap.onNext(event: .mapLoaded){ [weak self] _ in
            guard let self = self else { return }
            mapView.camera.ease(to: CameraOptions(center: centerCoordinate, zoom: 14, pitch: 5),duration: 1.3)
            addMarker(at: centerCoordinate)
            polygonAnnotationManager = mapView.annotations.makePolygonAnnotationManager()
            
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
