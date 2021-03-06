//
//  ChangepassController.swift
//  Glue
//
//  Created by Macbook Pro on 30/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import GenericPasswordRow
import PopupDialog
import JGProgressHUD
import Alamofire

class Changepass: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< SwitchRow("switch"){
                $0.title = "Sudah menerima kode?"
                $0.value = false
            }
            +++ Section("Kirim kode reset"){
                $0.hidden = Condition(stringLiteral: "$switch == true")
            }
            <<< EmailRow(Keys.user_email+"1"){
                $0.title = "Email"
                $0.placeholder = "misal andi@gmail.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< ButtonRow() {
                $0.title = "Kirim"
                }.onCellSelection { (cell, row) in
                    self.kirimkode()
                }
            +++ Section("Reset password"){
                $0.hidden = Condition(stringLiteral: "$switch != true")
            }
            <<< EmailRow(Keys.user_email+"2"){
                $0.title = "Email"
                $0.add(rule: RuleRequired())
                $0.placeholder = "misal andi@gmail.com"
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< TextRow(Keys.kode_reset){
                $0.title = "Kode reset"
                $0.placeholder = "misal 123456"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 6))
                $0.add(rule: RuleMaxLength(maxLength: 6))
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< GenericPasswordRow(Keys.user_password){
                $0.add(rule: RuleRequired())
                $0.placeholder = "isi password"
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< ButtonRow() {
                $0.title = "Reset"
                }.onCellSelection { (cell, row) in
                    
                 self.resetpass()
                }
        
    }
    
    func kirimkode(){
        if form.validate().isEmpty {
            let formvalues = self.form.values()
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Mengirim"
            hud.show(in: self.view)
            let parameters = [
                Keys.user_email: formvalues[Keys.user_email+"1"] as! String
            ]
            Alamofire.request(Keys.URL_KODE_PASS, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil"{
                        let popup = PopupDialog(title: Keys.berhasil, message: "Proses berhasil", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }else if response.result.value == "error_email"{
                        let popup = PopupDialog(title: Keys.error, message: "Email tidak terdaftar", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }else if response.result.value == "error_send"{
                        let popup = PopupDialog(title: Keys.error, message: "Proses gagal", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }
                case .failure( _):
                    let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
    }
    
    func resetpass(){
        if form.validate().isEmpty {
            let formvalues = self.form.values()
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Mengirim"
            hud.show(in: self.view)
            let password = formvalues[Keys.user_password] as! String
            let parameters = [
                Keys.user_email: formvalues[Keys.user_email+"2"] as! String,
                Keys.user_password: password,
                Keys.kode_reset: formvalues[Keys.kode_reset] as! String
            ]
            Alamofire.request(Keys.URL_RESET_PASS, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil"{
//                        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                            let popup = PopupDialog(title: Keys.berhasil, message: "Password diganti, silahkan login", gestureDismissal: false)
                            let button = DefaultButton(title: Keys.ya) {
                                self.navigationController!.popViewController(animated: true)
                            }
                            popup.addButtons([button])
                            self.present(popup, animated: true, completion: nil)
//                        })
//                        
                    }else if response.result.value == "error_email"{
                       let popup = PopupDialog(title: Keys.error, message: "Email tidak terdaftar", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }else if response.result.value == "error_kode"{
                        let popup = PopupDialog(title: Keys.error, message: "Kode salah", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }
                    
                case .failure( _):
                    let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
