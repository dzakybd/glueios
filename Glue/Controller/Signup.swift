//
//  SignupController.swift
//  Glue
//
//  Created by Macbook Pro on 30/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import GenericPasswordRow
import Alamofire
import INTULocationManager
import DefaultsKit
import PopupDialog
import JGProgressHUD

class Signup: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Data utama")
            <<< ImageRow() {
                $0.tag = Keys.image
                $0.title = "Gambar profil"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .yes(style: UIAlertActionStyle.destructive)
            }
            <<< IntRow(){
                $0.title = "NRP"
                $0.add(rule: RuleRequired())
                $0.placeholder = "misal 5114100001"
                $0.tag = Keys.user_nrp
                $0.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< NameRow(){
                $0.tag = Keys.user_nama
                $0.title = "Nama"
                $0.add(rule: RuleRequired())
                $0.placeholder = "misal Andi"
                $0.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< EmailRow(){
                $0.tag = Keys.user_email
                $0.title = "Email"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.placeholder = "misal andi@gmail.com"
                $0.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< GenericPasswordRow(){
                $0.tag = Keys.user_password
                $0.add(rule: RuleRequired())
                $0.placeholder = "isi password"
                $0.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< PhoneRow(){
                $0.tag = Keys.user_no_hp
                $0.title = "Nomor HP"
                $0.placeholder = "misal 089xxxxx"
            }
        
    }
    
    @IBAction func signupclick(_ sender: Any) {
        if form.validate().isEmpty {
            Keys.getlocation(completion: { (userlat, userlng) in
              
                let formvalues = self.form.values()
                let imageui = formvalues[Keys.image]! ?? nil
                let email = formvalues[Keys.user_email] as! String
                let password = formvalues[Keys.user_password] as! String
                let parameters = [
                    Keys.user_email: email,
                    Keys.user_password: password,
                    Keys.user_nrp: String(formvalues[Keys.user_nrp] as! Int),
                    Keys.user_nama: formvalues[Keys.user_nama] as! String,
                    Keys.user_no_hp: formvalues[Keys.user_no_hp] as! String,
                    Keys.user_lat: userlat,
                    Keys.user_lng: userlng
                ]
                var imageData : Data!
                if imageui != nil {
                    imageData = UIImagePNGRepresentation(imageui as! UIImage)
                }
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = "Mendaftar"
                hud.show(in: self.view)
                Alamofire.upload( multipartFormData: { multipartFormData in
                    if imageui != nil {
                        multipartFormData.append(imageData, withName: Keys.image, fileName: "image.png" , mimeType: "image/png")
                    }
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: .utf8)!, withName: key)
                    }
                }, to: Keys.URL_SIGNUP, encodingCompletion: { encodingResult in
                    hud.dismiss()
                    switch encodingResult {
                    case .success(let upload, _, _): upload.responseString { response in
                        switch response.result.value! {
                        case "berhasil", "":
//                           Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                            Keys.getowndata(completion: { (result) in
//                                self.performSegue(withIdentifier: "signup_to_home", sender: self)
//                            })
                            let popup = PopupDialog(title: Keys.berhasil, message: "Berhasil, silahkan login", gestureDismissal: false)
                            let button = DefaultButton(title: Keys.ya) {
                                self.navigationController!.popViewController(animated: true)
                            }
                            popup.addButtons([button])
                            self.present(popup, animated: true, completion: nil)
//                            }
                        case "error_nrp":
                            let popup = PopupDialog(title: Keys.error, message: "NRP belum terdaftar", gestureDismissal: true)
                            self.present(popup, animated: true, completion: nil)
                        case "error_signed":
                            let popup = PopupDialog(title: Keys.error, message: "Email sudah terdaftar", gestureDismissal: true)
                            self.present(popup, animated: true, completion: nil)
                        default:
                            let popup = PopupDialog(title: Keys.error, message: "Input bermasalah", gestureDismissal: true)
                            self.present(popup, animated: true, completion: nil)
                        }
                        }case .failure( _):
                            let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                            self.present(popup, animated: true, completion: nil)
                    }
                })
                
            })
        }
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
