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
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var labelname: UIButton!
    
    
    let locationManager = CLLocationManager()
    var placesData:[[String]] = []
    var parameters:[String] = []
    var userLocation:CLLocationCoordinate2D? = nil
    var newLocation:String = ""
    var checkin:String = ""
    var userFBInfo:[String:AnyObject] = [:]
    var arrayFBInfo:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infosDefault = UserDefaults.standard
        
        
        if infosDefault.value(forKey: "myLocations") != nil {
            print("HERE I AM MOTHERFUCKER")
            var myLocations = infosDefault.value(forKey: "myLocations") as! [String]
            if newLocation != "" { myLocations.append(newLocation) }
            infosDefault.set(myLocations, forKey: "myLocations")
            infosDefault.synchronize()
            let array = infosDefault.object(forKey: "myLocations") as! [String]
            for x in array {
                let new = x.components(separatedBy: ";;")
                self.placesData.append(new)
            }
        } else {
            if newLocation != "" {
                infosDefault.set([newLocation], forKey: "myLocations")
                infosDefault.synchronize()
            }
        }
        
        if !checkin.isEmpty {
            if infosDefault.value(forKey: "userCheckin") != nil {
                var userCheckin = infosDefault.value(forKey: "userCheckin") as! [String]
                userCheckin.append(self.checkin)
                infosDefault.set(userCheckin, forKey: "userCheckin")
            } else {
                infosDefault.set([self.checkin], forKey: "userCheckin")
                infosDefault.synchronize()
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
            
            infosDefault.set(self.placesData, forKey: "AllLocations")
            infosDefault.synchronize()
            
            for d in self.placesData {
//                print(d)
                let annotation = MKPointAnnotation()
//                print(">>>>>" + self.checkin)
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
        
        
        if infosDefault.value(forKey: "userLogged") != nil {
            
            var userInfos = infosDefault.value(forKey: "userLogged") as! [String]
            self.labelname.setTitle(userInfos[0], for: .normal)
            
//            print(userInfos)
            if let url = NSURL(string: userInfos[1]) {
                if let data = NSData(contentsOf: url as URL){
                    profilePicture.image = UIImage(data: data as Data)
                }
            }
            
        } else {
         
            if let username = userFBInfo["first_name"] {
                arrayFBInfo.append((username as! String))
                self.labelname.setTitle((username as? String), for: .normal)

            }
//            if let email = userFBInfo["email"]{
//                arrayFBInfo.append((email as! String))
//            }
            if let picData = userFBInfo["picture"]  {
                let pic = picData["data"] as! [String : AnyObject]
                arrayFBInfo.append((pic["url"] as! String))
                if let url = NSURL(string: pic["url"] as! String) {
                    if let data = NSData(contentsOf: url as URL){
                        profilePicture.image = UIImage(data: data as Data)
                    }
                }
            }
            
            infosDefault.set(arrayFBInfo, forKey: "userLogged")
            infosDefault.synchronize()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "ponto"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
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

            pinView!.canShowCallout = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else {
            pinView!.annotation = annotation
        }

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

