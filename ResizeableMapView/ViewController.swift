/*
The MIT License (MIT)

Copyright (c) 2015 Johannes Carlén

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dragView: UIView!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    private var locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        locationManager.delegate = self
        
        //        let initialLocation = CLLocation(latitude: 57.705702, longitude: 11.966612)
        //        centerMapOnLocation(initialLocation)
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        dragView.addGestureRecognizer(pan)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        checkLocationAuthorizationStatus()
    }
    
    func pan(rec:UIPanGestureRecognizer) {
        if rec.state == .Changed {
            let currentPoint = rec.locationInView(self.dragView)
            
            let minHeight = 40 + self.dragView.frame.height
            let maxHeight = self.view.frame.height
            let currentHeight = self.containerHeightConstraint.constant
            
            var newHeight = currentHeight + currentPoint.y
            
            if newHeight < minHeight {
                newHeight = minHeight
            } else if newHeight > maxHeight {
                newHeight = maxHeight
            }
            self.containerHeightConstraint.constant = newHeight
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            println("Requesting authorization...")
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println("didUpdateUserLocation")
        println(userLocation)
        let allAnnotations: [MKAnnotation] = [userLocation]
        mapView.showAnnotations(allAnnotations, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("viewForAnnotation")
        println(annotation)
        return nil
    }
}

extension ViewController : CLLocationManagerDelegate {
    
}


