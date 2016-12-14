//
//  EditInfosViewController.swift
//  SnackSpot
//
//  Created by Caroline Siqueira on 13/12/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit

class EditInfosViewController: UIViewController {
    
    var info:[String] = []
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newMenu: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.namelabel.text = self.info[1]
        self.newName.placeholder = self.info[1]
        self.newMenu.placeholder = self.info[5]
        newName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        newMenu.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            if self.newName.text != "" {
                info[1] = newName.text!
            }
            if self.newMenu.text != "" {
                info[5] = newMenu.text!
            }
            syncronize()
            let sendId = segue.destination as! InfoViewController
            sendId.infos = self.info
        }
        
        if segue.identifier == "canceledit" {
            let sendId = segue.destination as! InfoViewController
            sendId.infos = self.info
        }

    }

    func syncronize() {
        let infosDefault = UserDefaults.standard
        if infosDefault.value(forKey: "allLocations") != nil {
            var  locations = infosDefault.value(forKey: "allLocations") as! [[String]]
            var f = false
            var i = 0
            for l in locations {
                if info[3] == l[3] && info[4] == l[4]{
                    f = true
                    break
                }
                i += 1
            }
            
            if f { locations[i] = info }

            infosDefault.set(locations, forKey: "allLocations")
            infosDefault.synchronize()
        }
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

