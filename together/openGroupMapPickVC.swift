//
//  openGroupMapPickVC.swift
//  together
//
//  Created by Chuei-Ching Chiou on 04/08/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class openGroupMapPickVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var lmgr:CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func mapToUserLoc(_ sender: Any) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)

    }
    
    @IBAction func mapZoomIn(_ sender: Any) {
        var region = MKCoordinateRegion()
        
        let latDelta = mapView.region.span.latitudeDelta * 0.5
        let lngDelta = mapView.region.span.longitudeDelta * 0.5
        
        region.span.latitudeDelta = latDelta
        region.span.longitudeDelta = lngDelta
        region.center = mapView.region.center
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func mapZoomOut(_ sender: Any) {
        var region = MKCoordinateRegion()
        
        let latDelta = mapView.region.span.latitudeDelta * 2
        let lngDelta = mapView.region.span.longitudeDelta * 2
        
        region.span.latitudeDelta = latDelta
        region.span.longitudeDelta = lngDelta
        region.center = mapView.region.center
        
        mapView.setRegion(region, animated: true)
    }
    
    var isMapTapped:Bool!
    var annotation:MKPointAnnotation!
    var location:CLLocation!
    var geocoder:CLGeocoder!
    
    private func initStatMap() {
        mapView.delegate = self
        
        let mapSingleTapReg = UITapGestureRecognizer(target: self, action: #selector(mapTapHandle) )
        mapSingleTapReg.delegate = self as? UIGestureRecognizerDelegate
        
        mapSingleTapReg.numberOfTapsRequired = 1
        mapSingleTapReg.numberOfTouchesRequired = 1
        
        let mapDoubleTapReg = UITapGestureRecognizer(target: self, action: nil)
        mapDoubleTapReg.delegate = self as? UIGestureRecognizerDelegate
        mapDoubleTapReg.numberOfTapsRequired = 2
        mapDoubleTapReg.numberOfTouchesRequired = 1
        
        // to distinguish single- and double-tap
        mapSingleTapReg.require(toFail: mapDoubleTapReg )
        
        // to make mapView recognizing single- and double-tap gestures
        mapView.addGestureRecognizer(mapSingleTapReg)
        mapView.addGestureRecognizer(mapDoubleTapReg)
        
        
    }
    
    var countTap:Int = 0
    func mapTapHandle( tapReg: UITapGestureRecognizer ) {

        mapView.removeAnnotations(mapView.annotations)
        
        countTap += 1
        
        let cgLoc = tapReg.location(in: mapView)
        let coordinate = mapView.convert(cgLoc,toCoordinateFrom: mapView)
        
        print("Tap(\(countTap)) on mapView: \(coordinate.latitude),\(coordinate.longitude)")
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // add annotation
        
//        let annotation = MKPointAnnotation()
        
        self.annotation.coordinate = coordinate
        self.annotation.title = "Tap(\(countTap))"
        self.annotation.subtitle = "\(coordinate.latitude),\(coordinate.longitude)"
        
        mapView.addAnnotation(annotation)
        isMapTapped = true
        
        self.geocoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) in
            
            if error != nil {
                print("Reverse geocoder failed")
                print(error!)
                return
            } else {
                
                for placemark in placemarks! {
                    
                    let addrDict = placemark.addressDictionary
                    
                    for key in (addrDict?.keys)! {
                        let value = addrDict?[key]
                        let keyStr = String(describing: key)
//                        print(keyStr)
//                        if value is String {
//                            print("\(key): \(value!)")
//                        }
                        
                        if keyStr == "FormattedAddressLines" {
                            for p in value as! NSArray {
                                print("\(key): \(p)")
                            }
                        }
                    }
                    
                }
                
            }
            
            
            
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        
        print("locationManager: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
        
        let center = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) )
        
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            lmgr = CLLocationManager()
            
            lmgr?.delegate = self
            lmgr?.desiredAccuracy = kCLLocationAccuracyBest
            lmgr?.requestWhenInUseAuthorization()
            lmgr?.startUpdatingLocation()
            lmgr?.distanceFilter = CLLocationDistance(100)
            
        }
        
        self.initStatMap()
        
        isMapTapped = false
        annotation = MKPointAnnotation()
        geocoder = CLGeocoder()
        

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.setNeedsDisplay()
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segId:String = segue.identifier!
        
        if segId == "segPickPlaceDone" && isMapTapped == true {
            
            let vc = segue.destination as! openGroupVC
            
            print("lat:\(self.annotation.coordinate.latitude), lng:\(self.annotation.coordinate.longitude)")
            
            vc.locationLat = self.annotation.coordinate.latitude
            vc.locationLng = self.annotation.coordinate.longitude
            
            self.geocoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print("Reverse geocoder failed")
                    print(error!)
                    return
                } else {
                    
                    for placemark in placemarks! {
                        let addrDict = placemark.addressDictionary
                        
                        for key in (addrDict?.keys)! {
                            let keyStr = String(describing: key)
                            let value = addrDict?[key]
//                            if value is String {
//                                print("\(key): \(value!)")
//                            }
                        }
                    }

//                    let addrDict = placemarks?[0].addressDictionary
//                    vc.locationAddr = addrDict?["Street"] as? String
                    
                }
                
                
                
            })
            
        }
    }



}
