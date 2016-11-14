//
//  ViewController.swift
//  SnackSpot01
//
//  Created by Caroline Siqueira on 14/09/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    

    @IBOutlet weak var Map: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
            }
        }
        
        task.resume()
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.Map.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:-29.712860,longitude:-53.716847)
        annotation.title = "Lancheria do Menezes"
        annotation.subtitle = "lanches e almoço"
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude:-29.711385,longitude:-53.715995)
        annotation2.title = "Posto da UFSM"
        annotation2.subtitle = "conveniências"
        
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2D(latitude:-29.713931,longitude:-53.714774)
        annotation3.title = "Xis do HUSM"
        annotation3.subtitle = "lanches e almoços"
        
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate = CLLocationCoordinate2D(latitude:-29.715718,longitude:-53.715030)
        annotation4.title = "Lancheria do CCNE"
        annotation4.subtitle = "lanches"
        
        /*
         let myActualSpot = MKPointAnnotation()
         myActualSpot.coordinate = center
         myActualSpot.title = "Estou aqui :)"
         myActualSpot.subtitle = "tem lanche?"
         */
        Map.addAnnotation(annotation)
        Map.addAnnotation(annotation2)
        Map.addAnnotation(annotation3)
        Map.addAnnotation(annotation4)
        Map.delegate = self
        // Map.addAnnotation(myActualSpot)

        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
            pinView?.pinTintColor = .orange
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("SHOW TOP SEXTOU")
            performSegue(withIdentifier: "Info", sender: view)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if (segue?.identifier == "Info") {
            
            _ = segue!.destination as! InfoViewController
            
        }
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.Map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
}


