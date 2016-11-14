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
        
        let requestURL: NSURL = NSURL(string: "https://raw.githubusercontent.com/caroljardims/snackspot/master/localinfos.js")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    if let places = json["places"] as? [[String : AnyObject]] {
                        for place in places {
                           if let title = place["title"] as? String {
                               if let subtitle = place["subtitle"] as? String {
                                    if let lati = place["latitude"] as? String {
                                        if let long = place["longitude"] as? String {
                                            if let aval = place["aval"] as? String {
                                                let annotation = MKPointAnnotation()
                                                annotation.coordinate = CLLocationCoordinate2D(latitude:Double(lati)!,longitude:Double(long)!)
                                                annotation.title = title
                                                annotation.subtitle = subtitle
                                                self.Map.addAnnotation(annotation)
                                                print(title,subtitle, lati, long, aval)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("Error with Json: \(error)")
                }
                
            } else { print(" Deu Merda!") }
        }
        
        task.resume()
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.Map.showsUserLocation = true
        
        
        /*
         let myActualSpot = MKPointAnnotation()
         myActualSpot.coordinate = center
         myActualSpot.title = "Estou aqui :)"
         myActualSpot.subtitle = "tem lanche?"
         */

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
            pinView?.pinTintColor = .orange
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.animatesDrop = true
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


