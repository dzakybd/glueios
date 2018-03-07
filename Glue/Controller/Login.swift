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

class Login: UIViewController {
    @IBOutlet weak var emailtext: UITextField!
    
    @IBOutlet weak var passtext: UITextField!
    var userlat = String()
    var userlng = String()
    
    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginclick(_ sender: Any) {
      
        let parameters = [
            Keys.user_email: emailtext.text!,
            Keys.user_password: passtext.text!,
            Keys.user_lat: userlat,
            Keys.user_lng: userlng
        ]
        
        Alamofire.request(Keys.URL_LOGIN, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
            let JSON = response.result.value as? NSDictionary
            
            let defaults = UserDefaults.standard
            for (key, value) in JSON! {
                let temp = key as? String
                defaults.set(value, forKey: temp!)
            }
            self.performSegue(withIdentifier: "homesegue", sender: self)
            case .failure( _):
                let alertController = UIAlertController(title: "Login", message:
                    "Maaf login salah", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                            if (status == INTULocationStatus.success) {
                                                self.userlat = "\(currentLocation?.coordinate.latitude ?? 0)"
                                                self.userlng = "\(currentLocation?.coordinate.longitude ?? 0)"
                                                
                                                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                // currentLocation contains the device's current location
                                            }
                                            else if (status == INTULocationStatus.timedOut) {
                                                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                // However, currentLocation contains the best location available (if any) as of right now,
                                                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                            }
                                            else {
                                                // An error occurred, more info is available by looking at the specific status returned.
                                            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

