//
//  UserProfileViewController.swift
//  SnackSpot
//
//  Created by Caroline Siqueira on 09/12/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var places: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let infosDefault = UserDefaults.standard
        
        if infosDefault.value(forKey: "userLogged") != nil {
            var userInfos = infosDefault.value(forKey: "userLogged") as! [String]
            self.name.text = userInfos[0]
            
            //            print(userInfos)
            if let url = NSURL(string: userInfos[1]) {
                if let data = NSData(contentsOf: url as URL){
                    image.image = UIImage(data: data as Data)
                }
            }
        }
        
        if infosDefault.value(forKey: "userCheckin") != nil &&  infosDefault.value(forKey: "AllLocations") != nil {
            var userCheckin = infosDefault.value(forKey: "userCheckin") as! [String]
            let allLocations = infosDefault.value(forKey: "AllLocations") as! [[String]]
            var text = ""
            userCheckin = userCheckin.reversed()
            for c in userCheckin {
                let arr = c.components(separatedBy: ";;")
                for l in allLocations{
                    if arr[0] == l[3] && arr[1] == l[4] {
                        text = text + l[1] + "\n"
                    }
                }
            }
            self.places.text = text

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
