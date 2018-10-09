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
import PopupDialog
import JGProgressHUD

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
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Masuk"
            hud.show(in: self.view)
            
            Alamofire.request(Keys.URL_LOGIN, method:.post, parameters:parameters).responseJSON { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    let JSON = response.result.value as! NSDictionary
                    let akun = User()
                    akun.Populate(dictionary: JSON)
                    let defaults = Defaults()
//                    Auth.auth().signIn(withEmail: akun.user_email, password: akun.user_password) { (user, error) in
//                        akun.user_uid = (user?.uid)!
                    defaults.set(akun,for: Key<User>(Keys.saved_user))
                    self.performSegue(withIdentifier: "homesegue", sender: self)
//                    }
                    
                case .failure( _):
                    let popup = PopupDialog(title: Keys.error, message: "Login salah", gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}

