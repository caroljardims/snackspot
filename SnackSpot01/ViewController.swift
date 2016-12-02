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
    var placesData:[[String]] = []
    var parameters:[String] = []
    
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
                            if let id = place["id"] as? String {
                                if let title = place["title"] as? String {
                                    if let subtitle = place["subtitle"] as? String {
                                        if let lati = place["latitude"] as? String {
                                            if let long = place["longitude"] as? String {
                                                if let cardapio = place["cardapio"] as? String{
                                                    if let aval = place["aval"] as? String {
                                                        var data:[String] = []
                                                        data.append(id)
                                                        data.append(title)
                                                        data.append(subtitle)
                                                        data.append(lati)
                                                        data.append(long)
                                                        data.append(cardapio)
                                                        data.append(aval)
                                                        self.placesData.append(data)
                                                    }
                                                }
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
            
            for d in self.placesData {
                let annotation = MKPointAnnotation()
                annotation.title = d[1]
                annotation.subtitle = d[2]
                annotation.coordinate = CLLocationCoordinate2D(latitude:Double(d[3])!,longitude:Double(d[4])!)
                self.Map.addAnnotation(annotation)
                
            }
            
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
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("SHOW TOP SEXTOU")
            for d in placesData{
                if view.annotation?.coordinate.latitude == Double(d[3]) && view.annotation?.coordinate.longitude == Double(d[4]) {
                    parameters = d
                }
            }
            
            self.performSegue(withIdentifier: "Info", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if segue?.identifier == "Info" {
            let sendId = segue?.destination as! InfoViewController
            sendId.infos = self.parameters
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


