//
//  EditTautan.swift
//  Glue
//
//  Created by Macbook Pro on 14/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import PopupDialog
import JGProgressHUD
import Alamofire

class EditTautan: FormViewController {

    var tautan = UserTautan()
    var create = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
            <<< TextRow(Keys.tautan_judul){
                $0.title = "Judul"
                $0.placeholder = "Masukan judul"
                $0.add(rule: RuleRequired())
                if !tautan.tautan_judul.isEmpty {
                    $0.value = tautan.tautan_judul
                }
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< TextRow(Keys.tautan_text){
                $0.title = "Detail"
                $0.placeholder = "Masukan url atau id sosmed"
                $0.add(rule: RuleRequired())
                if !tautan.tautan_text.isEmpty {
                    $0.value = tautan.tautan_text
                }
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< ButtonRow() {
                $0.title = "Hapus"
                $0.hidden = Condition(booleanLiteral: create)
                }.onCellSelection { (cell, row) in
                    let popup = PopupDialog(title: "Peringatan", message: "Anda yakin menghapus?", buttonAlignment: .horizontal, gestureDismissal: true)
                    let buttonOne = CancelButton(title: "Batal") {
                    }
                    let buttonTwo = DestructiveButton(title: "Ya") {
                        self.hapustautan()
                    }
                    popup.addButtons([buttonOne, buttonTwo])
                    self.present(popup, animated: true, completion: nil)
                }.cellSetup({ (cell,row) in
                    cell.tintColor = .flatRed
                })
    }
    
    func hapustautan(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Menghapus"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.delete,
            Keys.idtautan: tautan.idtautan
        ]
        Alamofire.request(Keys.URL_CRUD_TAUTAN, method:.post, parameters:parameters).responseString { response in
            switch response.result {
            case .success:
                if response.result.value == "berhasil"{
                    self.getowndata()
                }
            case .failure( _):
                print(Keys.error)
            }
            hud.dismiss()
        }
    }
    
    func posttautan(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Mengedit"
        hud.show(in: self.view)
        let formvalues = self.form.values()
        let parameters = [
            Keys.mode: Keys.update,
            Keys.idtautan: tautan.idtautan,
            Keys.tautan_judul: formvalues[Keys.tautan_judul] as! String,
            Keys.tautan_text: formvalues[Keys.tautan_text] as! String
        ]
        Alamofire.request(Keys.URL_CRUD_TAUTAN, method:.post, parameters:parameters).responseString { response in
            switch response.result {
            case .success:
                if response.result.value == "berhasil"{
                    
                    self.getowndata()
                }
            case .failure( _):
                print(Keys.error)
            }
            hud.dismiss()
        }
    }
    
    func createtautan(){
        let formvalues = self.form.values()
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Membuat"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.create,
            Keys.user_nrp: tautan.user_nrp,
            Keys.tautan_judul: formvalues[Keys.tautan_judul] as! String,
            Keys.tautan_text: formvalues[Keys.tautan_text] as! String
        ]
        Alamofire.request(Keys.URL_CRUD_TAUTAN, method:.post, parameters:parameters).responseString { response in
            switch response.result {
            case .success:
                if response.result.value == "berhasil"{
                    
                    self.getowndata()
                }
            case .failure( _):
                print(Keys.error)
            }
            hud.dismiss()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func simpanclick(_ sender: Any) {
        if form.validate().isEmpty {
            if create {
                createtautan()
            }else{
                posttautan()
            }
        }
    }
    
    func getowndata(){
        Keys.getowndata(completion: { (result) in
            self.performSegue(withIdentifier: "edittautan_to_editmember", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edittautan_to_editmember"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditMember {
                    childVC.own = true
                    childVC.create = false
                }
            }
        }
    }
}
