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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var servimos: UILabel!
    var aval:Int = 0
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(infos)
        name.text = infos[1]
        servimos.text = infos[5]
        aval = Int(infos[6])!
        print(aval)
        
        self.starRate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
