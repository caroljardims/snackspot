//
//  InfoViewController.swift
//  SnackSpot01
//
//  Created by Caroline Siqueira on 11/11/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    
    var infos:[String] = []
    var aval:Int = 0
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var servimos: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var flag: UISwitch!
    @IBOutlet weak var checkinButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(infos)
        name.text = infos[1]
        servimos.text = infos[5]
        aval = Int(infos[6])!
//        print(aval)
        
        self.starRate()
        if infos[0] == "0" {
            flag.setOn(false, animated: true)
        }
        openPlace()
    }

    
    @IBAction func toggle(_ sender: AnyObject) {
        openPlace()
    }
    
    func openPlace(){
        
        if self.flag.isOn {
            infos[0] = "1"
            self.checkinButton.isEnabled = true
        } else {
            infos[0] = "0"
            self.checkinButton.isEnabled = false
        }
        
        let infosDefault = UserDefaults.standard
        
        if infosDefault.value(forKey: "allLocations") != nil {
            var  locations = infosDefault.value(forKey: "allLocations") as! [[String]]
            var f = false
            var i = 0
            for l in locations {
                if infos[3] == l[3] && infos[4] == l[4]{
                    f = true
                    break
                }
                i += 1
            }
            
            if f { locations[i] = infos }
//            print(locations)
            
            infosDefault.set(locations, forKey: "allLocations")
            infosDefault.synchronize()
        }
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CheckIn" {
            let str = infos[3] + ";;" + infos[4]
            let sendId = segue.destination as! ViewController
            sendId.checkin = str
        }
    }
    
    func starRate(){
        
        if aval < 2{
            star1.image = UIImage(named: "icons-04")
            star2.image = UIImage(named: "icons-04-2")
            star3.image = UIImage(named: "icons-04-2")
            star4.image = UIImage(named: "icons-04-2")
            star5.image = UIImage(named: "icons-04-2")
        }
        else if aval < 3{
            star1.image = UIImage(named: "icons-04")
            star2.image = UIImage(named: "icons-04")
            star3.image = UIImage(named: "icons-04-2")
            star4.image = UIImage(named: "icons-04-2")
            star5.image = UIImage(named: "icons-04-2")
        }
        else if aval < 4{
            star1.image = UIImage(named: "icons-04")
            star2.image = UIImage(named: "icons-04")
            star3.image = UIImage(named: "icons-04")
            star4.image = UIImage(named: "icons-04-2")
            star5.image = UIImage(named: "icons-04-2")
        }
        else if aval < 5{
            star1.image = UIImage(named: "icons-04")
            star2.image = UIImage(named: "icons-04")
            star3.image = UIImage(named: "icons-04")
            star4.image = UIImage(named: "icons-04")
            star5.image = UIImage(named: "icons-04-2")
        }
    }
    
    @IBAction func checkInButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "CheckIn", sender: self)
    
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
