//
//  AddPlaceViewController.swift
//  SnackSpot
//
//  Created by Caroline Siqueira on 05/12/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit
import MapKit

class AddPlaceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var userLocation:CLLocationCoordinate2D? = nil
    var myLocations:[String] = []
    var array:[String] = []
    var aval:String = "0"
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var menu: UITextField!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        name.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        type.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        menu.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAnnotation" {
            let str = array[0] + ";;" + array[1] + ";;" + array[2] + ";;" + array[3] + ";;" + array[4] + ";;" + array[5] + ";;" + array[6] + ";;default"

            let sendId = segue.destination as! ViewController
            sendId.newLocation = str
        }
    }

    @IBAction func sendAdd(_ sender: AnyObject) {
        
        let nameText = name.text
        if (nameText?.isEmpty)! {
            let alert = UIAlertController(title: "Opa!", message: "Como que chama esse lugar mesmo?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ah é! Vou preencher :)", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            var typeText = type.text
            if (typeText?.isEmpty)! { typeText = "DESCUBRA" }
            var menuText = menu.text
            if (menuText?.isEmpty)! { menuText = "DESCUBRA" }
            let id = "custom"
            
            if self.aval == "0" {
                let alert = UIAlertController(title: "Ai!", message: "Esse lugar não vale nem uma estrelinha? :(", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Não! Mas vou dar mesmo assim.", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                array.append(id)
                array.append(nameText!)
                array.append(typeText!)
                array.append(String(format:"%f", (userLocation?.latitude)!))
                array.append(String(format:"%f", (userLocation?.longitude)!))
                array.append(menuText!)
                array.append(self.aval)
                performSegue(withIdentifier: "AddAnnotation", sender: self)
            }
        }
        
    }
    
    let goldenStarImage = UIImage(named: "icons-04")
    let silverStarImage = UIImage(named: "icons-04-2")
    @IBAction func aval1(_ sender: AnyObject) {
        self.aval = "1"
        
        star1.setImage(goldenStarImage, for: .normal)
        star2.setImage(silverStarImage, for: .normal)
        star3.setImage(silverStarImage, for: .normal)
        star4.setImage(silverStarImage, for: .normal)
        star5.setImage(silverStarImage, for: .normal)
    }
    
    @IBAction func aval2(_ sender: AnyObject) {
        self.aval = "2"
        
        star1.setImage(goldenStarImage, for: .normal)
        star2.setImage(goldenStarImage, for: .normal)
        star3.setImage(silverStarImage, for: .normal)
        star4.setImage(silverStarImage, for: .normal)
        star5.setImage(silverStarImage, for: .normal)
    }
    
    @IBAction func aval3(_ sender: AnyObject) {
        self.aval = "3"
        
        star1.setImage(goldenStarImage, for: .normal)
        star2.setImage(goldenStarImage, for: .normal)
        star3.setImage(goldenStarImage, for: .normal)
        star4.setImage(silverStarImage, for: .normal)
        star5.setImage(silverStarImage, for: .normal)
    }
    
    @IBAction func aval4(_ sender: AnyObject) {
        self.aval = "4"
        
        star1.setImage(goldenStarImage, for: .normal)
        star2.setImage(goldenStarImage, for: .normal)
        star3.setImage(goldenStarImage, for: .normal)
        star4.setImage(goldenStarImage, for: .normal)
        star5.setImage(silverStarImage, for: .normal)
    }
    
    @IBAction func aval5(_ sender: AnyObject) {
        self.aval = "5"
        
        star1.setImage(goldenStarImage, for: .normal)
        star2.setImage(goldenStarImage, for: .normal)
        star3.setImage(goldenStarImage, for: .normal)
        star4.setImage(goldenStarImage, for: .normal)
        star5.setImage(goldenStarImage, for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
