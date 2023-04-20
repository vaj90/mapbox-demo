//
//  ViewController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-18.
//

import UIKit
import CoreLocation
import MapboxMaps
class ViewController: UIViewController, CLLocationManagerDelegate {
    internal var mapView: MapView!
    var locationManager: CLLocationManager!
    var geoCoder = CLGeocoder()
    var centerCoordinate: CLLocationCoordinate2D!
    private var cameraLocationConsumer: CameraLocationConsumer!
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
        setUpMap();
    }
    func fillDirection(){
        
    }
    func setUpMap(){
        let options = MapInitOptions(resourceOptions: resourceOptions, styleURI: .light)
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)

        mapView.mapboxMap.onNext(event: .mapLoaded){ [weak self] _ in
            guard let self = self else { return }
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)
            self.addMarker(at: centerCoordinate)
            self.addViewAnnotation(at: centerCoordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    func addMarker(at coordinate: CLLocationCoordinate2D) -> Void {
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        pointAnnotation.image = .init(image: UIImage(named: "marker")!, name: "marker")
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.annotations = [pointAnnotation]
    }
    
    func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions( geometry: Point(coordinate),width: 100,height: 40,anchor: .bottom,offsetY: 40)
        let sampleView = createSampleView(withText: "Current Location!")
        try? mapView.viewAnnotations.add(sampleView, options: options)
    }
    private func createSampleView(withText text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
}
public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?
    init(mapView: MapView) {
        self.mapView = mapView
    }
    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: 15, pitch: 45),duration: 1.3)
    }
}
