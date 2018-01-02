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


struct GPSInformation {
    let latitude: Float
    let longitude: Float
    let elevation: Float
}
struct GoogleLocationInfo: Decodable  {
    let lat: Float
    let lng: Float
}

struct GoogleElevationResult: Decodable  {
    let elevation: Float
    let location: GoogleLocationInfo
    let resolution: Float
}

struct GoogleElevationData: Decodable {
    let results: [GoogleElevationResult]
    let status: String
}

/*
 {
 "results" : [
 {
 "elevation" : 1608.637939453125,
 "location" : {
 "lat" : 39.73915360,
 "lng" : -104.98470340
 },
 "resolution" : 4.771975994110107
 }
 ],
 "status" : "OK"
 }
 */


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let mapView = MKMapView()
    let indicatorsView = UIView()
    let locationManager = CLLocationManager()
    let speedIndicator = UILabel()
    var pathRenderer:MKPolylineRenderer? = nil
    var locations2D = [CLLocationCoordinate2D]()
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
       
        locations2D.append(userLocation.coordinate)
        
        let jsonURLString = "https://maps.googleapis.com/maps/api/elevation/json?locations=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&key=AIzaSyB7rLAjyLu6pKmaVMowA9JBJQMTYJBYjzQ"
        
        print(jsonURLString)
        
        guard let urlString = URL(string: jsonURLString) else { return }
        
        URLSession.shared.dataTask(with: urlString) { (data, response, err) in
            guard let data = data else {return}
            
            do {
                let positionResult = try JSONDecoder().decode(GoogleElevationData.self, from: data)
                let gpsInformation = GPSInformation(latitude: positionResult.results[0].location.lat, longitude: positionResult.results[0].location.lng, elevation: positionResult.results[0].elevation)
                 UserPositions.positions.append(gpsInformation)
            } catch let jsonError {
                print("Error serializing json", jsonError)
            }
            }.resume()
        
        /*print("Nuber of locations \(UserPositions.positions.count)")
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")*/
        
        speedIndicator.text = "Speed: \(userLocation.speed * 3.6). Altitude: \(userLocation.altitude)"
        
        
        let fPolyLine = BackgroundOverlay(coordinates: locations2D, count: locations2D.count)
        
        mapView.addOverlays([fPolyLine], level: MKOverlayLevel.aboveRoads)
        
        let bPolyLine = ForegroundOverlay(coordinates: locations2D, count: locations2D.count)
        
        mapView.addOverlays([bPolyLine], level: MKOverlayLevel.aboveRoads)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        if overlay is ForegroundOverlay {
            renderer.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 1, alpha: 0.5)
            renderer.lineWidth = 10
        } else {
            renderer.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            renderer.lineWidth = 30
        }

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

fileprivate class ForegroundOverlay: MKPolyline{
    
}
fileprivate class BackgroundOverlay: MKPolyline{
    
}

