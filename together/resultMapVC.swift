//
//  resultMapVC.swift
//  together
//
//  Created by Chuei-Ching Chiou on 04/08/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MyAnnotation: MKPointAnnotation {
    var tidTag:Int?
}

class resultMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var app = UIApplication.shared.delegate as! AppDelegate
    var lmgr:CLLocationManager?

    var groupPins:[MKPointAnnotation]?


    @IBOutlet weak var mapView: MKMapView!

    @IBAction func mapToUserLoc(_sender: Any) {
        print("user location")
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func mapZoomIn(_ sender: Any) {
        print("zoom in")
        var region = MKCoordinateRegion()
        // 還有另一個建構式: MKCoordinateRegion(center: CLLocationCoordinate2D, span: MKCoordinateSpan)
        
        let latDelta = mapView.region.span.latitudeDelta * 0.5
        let lngDelta = mapView.region.span.longitudeDelta * 0.5
        
        region.span.latitudeDelta = latDelta
        region.span.longitudeDelta = lngDelta
        region.center = mapView.region.center
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func mapZoomOut(_ sender: Any) {
        print("zoom out")
        
        var region = MKCoordinateRegion()
        
        let latDelta = mapView.region.span.latitudeDelta * 2
        let lngDelta = mapView.region.span.longitudeDelta * 2
        
        region.span.latitudeDelta = latDelta
        region.span.longitudeDelta = lngDelta
        region.center = mapView.region.center
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MyAnnotation else {
            return nil
        }
        
        let reuseId = "pin"
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if annView == nil {
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        let btnDetail = UIButton(type: .detailDisclosure)
        btnDetail.tag = annotation.tidTag!
        btnDetail.addTarget(self, action: #selector(btnDetailPress(_:)), for: .touchUpInside)
        
        annView?.rightCalloutAccessoryView = btnDetail

        
        let labelCont = UILabel()
        labelCont.text = annotation.subtitle!
        annView?.detailCalloutAccessoryView = labelCont
        
        
        annView?.canShowCallout = true
        
        return annView
    }
    
    func btnDetailPress( _ sender: UIButton ) {
        
        print("tag: \(sender.tag)")
        app.tid = String(sender.tag)
//        print("app.tag: \(app.tid!)")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail") as! Groupdetail
        show(vc, sender: self)
        
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

        self.initStat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.setNeedsDisplay()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.createGroupPins()
        self.refreshGroupPins()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    private func initStat() {

        if CLLocationManager.locationServicesEnabled() {
            lmgr = CLLocationManager()
            
            lmgr?.delegate = self
            lmgr?.desiredAccuracy = kCLLocationAccuracyBest
            lmgr?.requestWhenInUseAuthorization()
            lmgr?.startUpdatingLocation()
            lmgr?.distanceFilter = CLLocationDistance(10)
            
        }
        
        mapView.delegate = self
        
    }
    
    private func makePin( tid:String, title:String, subtitle:String, coordinate: CLLocationCoordinate2D ) -> MyAnnotation {
//        let annotation:MKPointAnnotation = MKPointAnnotation()
        let annotation:MyAnnotation = MyAnnotation()
        
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinate
        annotation.tidTag = (tid as NSString).integerValue
        
        return annotation
    }
    
    private func createGroupPins() {
        
        let parentVC = parent as! resultMapListVC
        
        if parentVC.groupDict != nil {
            
            self.groupPins = []
            
            for group in parentVC.groupDict! {
                
                let tid = group["tid"]!
                let lat = CLLocationDegrees(group["lat"]!)
                let lng = CLLocationDegrees(group["lng"]!)
                
//                if lat != nil && lng != nil {
//                    print("\(tid): \(lat!), \(lng!)")
//                } else {
//                    print("\(tid)")
//                }
                
                let coor = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                print("\(tid): \(coor.latitude), \(coor.longitude)")

                self.groupPins! += [self.makePin( tid: group["tid"]!, title: group["subject"]!, subtitle: group["detail"]!, coordinate: coor)]
//                self.groupPins! += [self.makePin(title: group["subject"]!, subtitle: group["tid"]!, coordinate: coor)]

            }
        }
        
    }
    
    private func refreshGroupPins() {
        mapView.addAnnotations(self.groupPins!)
    }
    
}
