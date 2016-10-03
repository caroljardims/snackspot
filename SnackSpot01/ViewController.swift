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
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.Map.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.Map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude:-29.688,longitude:-53.824)
        
        annotation.title = "teste"
        annotation.subtitle = "testinho"
        
        /*
        let myActualSpot = MKPointAnnotation()
        myActualSpot.coordinate = center
        myActualSpot.title = "Estou aqui :)"
        myActualSpot.subtitle = "tem lanche?"
        */
        Map.addAnnotation(annotation)
        // Map.addAnnotation(myActualSpot)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
}


