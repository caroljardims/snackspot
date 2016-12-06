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
    var userLocation:CLLocationCoordinate2D? = nil
    var newLocation:String = ""
    var checkin:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let locationsDefault = UserDefaults.standard
        
        
        if locationsDefault.value(forKey: "myLocations") != nil {
            // print("HERE I AM MOTHERFUCKER")
            var myLocations = locationsDefault.value(forKey: "myLocations") as! [String]
            if newLocation != "" { myLocations.append(newLocation) }
            locationsDefault.set(myLocations, forKey: "myLocations")
            locationsDefault.synchronize()
            let array = locationsDefault.object(forKey: "myLocations") as! [String]
            for x in array {
                let new = x.components(separatedBy: ";;")
                self.placesData.append(new)
                // for i in new { print(i) }
            }
        } else {
            if newLocation != "" {
                locationsDefault.set([newLocation], forKey: "myLocations")
                locationsDefault.synchronize()
            }
        }
        
        
        
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
                print(d)
                let annotation = MKPointAnnotation()
                print(">>>>>" + self.checkin)
                if self.checkin != "" {
                    let aux = self.checkin.components(separatedBy: ";;")
                    if aux[0] == d[3] && aux[1] == d[4]{
                        annotation.subtitle = "Você está aqui!"
                    } else {
                        annotation.subtitle = d[2]
                    }
                } else {
                    annotation.subtitle = d[2]
                }
                annotation.title = d[1]
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
        
        Map.delegate = self
        // Map.addAnnotation(myActualSpot)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //se l'annotation è la posizione dell'Utente allora esci dalla funzione e mostra il punto blu
        if annotation is MKUserLocation {
            return nil
        }
        
        //creo un id da associare ad ogni annotationView
        let reuseId = "ponto"
        //se esistono troppi punti nella mappa, prende quello non visto e lo riutilizza nella porzione di mappa vista
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        //se non è stata ancora creata un'AnnotationView la crea
        if pinView == nil {
            //creo un pin di tipo MKAnnotationView che rappresenta l'oggetto reale da inserire in mappa
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //cambio l'immagine standard del point annotation con una creata da me
            pinView!.image = UIImage(named: "pinUnchecked")
            
            if self.checkin != "" {
                let aux = self.checkin.components(separatedBy: ";;")
                if aux[0] == String(format: "%f", annotation.coordinate.latitude) && aux[1] == String(format: "%f", annotation.coordinate.longitude){
                    pinView?.image = UIImage(named: "pinChecked")
                } else {
                    pinView!.image = UIImage(named: "pinUnchecked")
                }
            } else {
                pinView!.image = UIImage(named: "pinUnchecked")
            }
            
            //sblocco la possibilità di cliccarlo per vedere i dettagli
            pinView!.canShowCallout = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else {
            //se esiste lo modifico con il nuovo point richiesto
            pinView!.annotation = annotation
        }
        //restituisce un pointAnnotation nuovo o modificato
        return pinView
    }

    
//    let calloutButton = UIButton(type: .detailDisclosure)
//    pinView!.rightCalloutAccessoryView = calloutButton
//    pinView!.animatesDrop = true
    
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
        if segue?.identifier == "AddScreen" {
            self.locationManager.startUpdatingLocation()
            self.userLocation = self.locationManager.location?.coordinate
            let sendId = segue?.destination as! AddPlaceViewController
            sendId.userLocation = self.userLocation

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.Map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        self.userLocation = manager.location?.coordinate
        
    }
    
    @IBAction func whereUser(_ sender: AnyObject) {
        self.locationManager.startUpdatingLocation()
        self.userLocation = self.locationManager.location?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
}

