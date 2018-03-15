//
//  EditKerja.swift
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

class EditKerja: FormViewController {
    
    var kerja = UserKerja()
    var create = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let calendar = Calendar.current
        let currentyear = calendar.component(.year, from: Date())
        let angka = Array(1980...currentyear)
        var angkatext = angka.map{String($0)}
        angkatext.append("")
        
        form +++ Section()
            <<< TextRow(Keys.kerja_perusahaan){
                $0.title = "Perusahaan"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan perusahaan"
                if !kerja.kerja_perusahaan.isEmpty {
                    $0.value = kerja.kerja_perusahaan
                }
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            
            <<< TextRow(Keys.kerja_jabatan){
                $0.add(rule: RuleRequired())
                $0.title = "Jabatan"
                $0.placeholder = "Masukan jabatan"
                if !kerja.kerja_jabatan.isEmpty {
                    $0.value = kerja.kerja_jabatan
                }
                $0.validationOptions = .validatesOnChange
                
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow(Keys.kerja_lokasi){
                $0.title = "Lokasi"
                $0.placeholder = "Masukan lokasi"
                if !kerja.kerja_lokasi.isEmpty {
                    $0.value = kerja.kerja_lokasi
                }
            }
            <<< PickerInputRow<String>(Keys.kerja_masuk_keluar + "1"){
                $0.title = "Tahun masuk kerja"
                $0.options = angkatext
                $0.value = ""
            }
            <<< PickerInputRow<String>(Keys.kerja_masuk_keluar + "2"){
                $0.title = "Tahun keluar kerja"
                $0.options = angkatext
                $0.value = ""
            }
            <<< ButtonRow() {
                $0.title = "Hapus"
                $0.hidden = Condition(booleanLiteral: create)
                }.onCellSelection { (cell, row) in
                    let popup = PopupDialog(title: "Peringatan", message: "Anda yakin menghapus?", buttonAlignment: .horizontal, gestureDismissal: true)
                    let buttonOne = CancelButton(title: "Batal") {
                    }
                    let buttonTwo = DestructiveButton(title: "Ya") {
                        self.form.removeAll()
//                        self.hapuskerja()
                    }
                    popup.addButtons([buttonOne, buttonTwo])
                    self.present(popup, animated: true, completion: nil)
                }.cellSetup({ (cell,row) in
                    cell.tintColor = .flatRed
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hapuskerja(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Menghapus"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.delete,
            Keys.idkerja: kerja.idkerja
        ]
        Alamofire.request(Keys.URL_CRUD_KERJA, method:.post, parameters:parameters).responseString { response in
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
    
    func postkerja(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Mengedit"
        hud.show(in: self.view)
        let formvalues = self.form.values()
        let parameters = [
            Keys.mode: Keys.update,
            Keys.idkerja: kerja.idkerja,
            Keys.kerja_jabatan: formvalues[Keys.kerja_jabatan] as! String,
            Keys.kerja_perusahaan: formvalues[Keys.kerja_perusahaan] as! String,
            Keys.kerja_lokasi: formvalues[Keys.kerja_lokasi] as! String,
            Keys.kerja_masuk_keluar: "\(formvalues[Keys.kerja_masuk_keluar + "1"] as! String),\(formvalues[Keys.kerja_masuk_keluar + "2"] as! String)"
        ]
        Alamofire.request(Keys.URL_CRUD_KERJA, method:.post, parameters:parameters).responseString { response in
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
    
    func createkerja(){
        let formvalues = self.form.values()
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Membuat"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.create,
            Keys.user_nrp: kerja.user_nrp,
            Keys.kerja_jabatan: formvalues[Keys.kerja_jabatan] as! String,
            Keys.kerja_perusahaan: formvalues[Keys.kerja_perusahaan] as! String,
            Keys.kerja_lokasi: formvalues[Keys.kerja_lokasi] as! String,
            Keys.kerja_masuk_keluar: "\(formvalues[Keys.kerja_masuk_keluar + "1"] as! String),\(formvalues[Keys.kerja_masuk_keluar + "2"] as! String)"
        ]
        Alamofire.request(Keys.URL_CRUD_KERJA, method:.post, parameters:parameters).responseString { response in
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
    
    func getowndata(){
        Keys.getowndata(completion: { (result) in
            self.performSegue(withIdentifier: "editkerja_to_editmember", sender: self)
        })
    }
    
    @IBAction func simpanclick(_ sender: Any) {
        if form.validate().isEmpty {
            if create {
                createkerja()
            }else{
                postkerja()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editkerja_to_editmember"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditMember {
                    childVC.own = true
                    childVC.create = false
                }
            }
        }
    }
}
