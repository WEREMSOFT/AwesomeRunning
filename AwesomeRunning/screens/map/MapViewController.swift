//
//  ViewController.swift
//  AwesomeRunning
//
//  Created by Pablo Weremczuk on 12/8/17.
//  Copyright © 2017 Pablo Weremczuk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var positions = [CLLocationCoordinate2D]()
    let mapView = MKMapView()
    let indicatorsView = UIView()
    let locationManager = CLLocationManager()
    let speedIndicator = UILabel()
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [mapView, indicatorsView])
        stackView.frame = view.frame
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupIndicatorsView()
    
        speedIndicator.frame = CGRect(x: 0, y: 0, width: 500, height: 100)
        
        speedIndicator.textColor = .white
        speedIndicator.text = "????"
        indicatorsView.addSubview(speedIndicator)
        setupStackView()
        
        addMapTrackingButton()
        determineMyCurrentLocation()
    }

    fileprivate func setupIndicatorsView(){
        indicatorsView.backgroundColor = UIColor.blue
        indicatorsView.frame = view.frame

    }
    
    fileprivate func createStopButton() {
        let button: UIButton = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5037171872, blue: 0.895086453, alpha: 1)
        button.layer.cornerRadius = 10;
        button.setTitle("Stop Tracking", for: .normal)
        self.mapView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: 100)
        button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
        
        //button.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        //button.widthAnchor.constraint(equalTo: mapView.widthAnchor).isActive = true
        //button.widthAnchor.constraint(equalTo: mapView.frame.width).isActive = true
    }
    
    fileprivate func setupMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addMapTrackingButton(){
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let image = "☸︎".image(nil)
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x:5, y: 25), size: CGSize(width: 35, height: 35))
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(MapViewController.centerMapOnUserButtonClicked), for:.touchUpInside)
        mapView.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        print("center button clicked");
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        let latDelta:CLLocationDegrees = 0.001
        let lonDelta:CLLocationDegrees = 0.001
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let region  = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.setUserTrackingMode(.follow, animated: true)

    }
    
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        
        print("authorization Status: \(CLLocationManager.authorizationStatus().rawValue)")
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 20
            //locationManager.start
            //locationManager.startUpdatingHeading)(
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        positions.append(userLocation.coordinate)
        print("Nuber of locations \(positions.count)")
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        speedIndicator.text = "Speed: \(userLocation.speed). Altitude: \(userLocation.altitude)"

        
        let polyLine = MKPolyline(coordinates: positions, count: positions.count)

        
        mapView.addOverlays([polyLine], level: MKOverlayLevel.aboveRoads)
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 10
        
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

