//
//  ViewController.swift
//  Glue
//
//  Created by Dzaky ZF on 23/9/17.
//  Copyright © 2017 Dzaky ZF. All rights reserved.
//

import UIKit
import Alamofire
import INTULocationManager
import DefaultsKit

class Login: UIViewController {
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passtext: UITextField!

    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginclick(_ sender: Any) {
        Keys.getlocation { (userlat, userlng) in
            let parameters = [
                Keys.user_email: self.emailtext.text!,
                Keys.user_password: self.passtext.text!,
                Keys.user_lat: userlat,
                Keys.user_lng: userlng
            ]
            
            Alamofire.request(Keys.URL_LOGIN, method:.post, parameters:parameters).responseJSON { response in
                switch response.result {
                case .success:
                    let JSON = response.result.value as! NSDictionary
                    
                    let akun = User()
                    akun.Populate(dictionary: JSON)
                    
                    let defaults = Defaults()
                    defaults.set(akun,for: Key<User>(Keys.saved_user))
                    
                    self.performSegue(withIdentifier: "homesegue", sender: self)
                case .failure( _):
                    let alertController = UIAlertController(title: "Login", message:
                        "Maaf login salah", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

