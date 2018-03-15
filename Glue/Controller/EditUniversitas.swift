//
//  EditUniversitas.swift
//  Glue
//
//  Created by Macbook Pro on 15/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import DefaultsKit
import PopupDialog
import Alamofire
import JGProgressHUD

class EditUniversitas: FormViewController {
    
    var create = Bool()
    var wilayah_idwilayah = String()
    var universitas = Universitas()
    var wilayahdict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if create {
            self.navigationItem.title = "Buat data universitas"
        }
        
        form +++ Section()
            <<< IntRow(Keys.iduniversitas){
                $0.title = "ID Universitas"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan angka, misal 1"
                if universitas.iduniversitas != "" {
                    $0.value = Int(universitas.iduniversitas)
                }
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                    
                }
            <<< TextRow(Keys.universitas_nama){
                $0.title = "Nama Universitas"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan nama, misal ITS"
                if universitas.universitas_nama != "" {
                    $0.value = universitas.universitas_nama
                }
            }
            <<< ButtonRow(){
                $0.title = "Hapus universitas"
                $0.hidden = Condition(booleanLiteral: universitas.jumlahuser != "0")
                }.onCellSelection({ (cell, row) in
                    let popup = PopupDialog(title: Keys.warning, message: "Anda yakin menghapus?", buttonAlignment: .horizontal, gestureDismissal: true)
                    let buttonOne = CancelButton(title: Keys.tidak) {
                    }
                    let buttonTwo = DestructiveButton(title: Keys.ya) {
                        self.hapusuniv()
                    }
                    popup.addButtons([buttonOne, buttonTwo])
                    self.present(popup, animated: true, completion: nil)
                }).cellSetup({ (cell,row) in
                    cell.tintColor = .flatRed
                })
            +++ Section(){
                $0.hidden = Condition(booleanLiteral: create)
                }
                <<< SwitchRow("switch"){
                    $0.title = "Pindah wilayah"
                    $0.value = false
                }
                <<< PickerInputRow<String>(Keys.wilayah_idwilayah_new){row in
                    row.title = "Wilayah"
                    row.hidden = Condition(stringLiteral: "$switch == true")
                    Keys.getwilayah(completion: {(dict, text) in
                        self.wilayahdict = [String: String]()
                        self.wilayahdict = dict
                        row.options = text
                        row.value = self.universitas.wilayah_nama
                        row.reload()
                    })
                }
        
    }
    
    func hapusuniv(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Menghapus"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.delete,
            Keys.iduniversitas: universitas.iduniversitas
        ]
        Alamofire.request(Keys.URL_CRUD_UNIVERSITAS, method:.post, parameters:parameters).responseString { response in
            hud.dismiss()
            switch response.result {
            case .success:
                if response.result.value == "berhasil"{
                    self.navigationController?.popViewController(animated: true)
                    
                }else if response.result.value == "gagal"{
                    let popup = PopupDialog(title: Keys.error, message: "Proses gagal", gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
                }
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func simpanclick(_ sender: Any) {
        if form.validate().isEmpty {
            let formvalues = self.form.values()
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Menyimpan"
            hud.show(in: self.view)
            let iduniversitas = String(formvalues[Keys.iduniversitas] as! Int)
            var parameters = [Keys.universitas_nama: formvalues[Keys.universitas_nama] as! String]
            if create {
                parameters[Keys.mode] = Keys.create
                parameters[Keys.iduniversitas] = iduniversitas
                parameters[Keys.wilayah_idwilayah] = wilayah_idwilayah
            }else{
                parameters[Keys.mode] = Keys.update
                if iduniversitas != universitas.iduniversitas {
                    parameters[Keys.iduniversitas_new] = iduniversitas
                }
                parameters[Keys.iduniversitas] = universitas.iduniversitas
                
                var wilayah_idwilayah_new = (formvalues[Keys.wilayah_idwilayah_new] ?? "") as! String
                wilayah_idwilayah_new = wilayahdict[wilayah_idwilayah_new]!
                if !wilayah_idwilayah_new.isEmpty && wilayah_idwilayah_new != universitas.wilayah_idwilayah {
                    parameters[Keys.wilayah_idwilayah_new] = wilayah_idwilayah_new
                }
                parameters[Keys.wilayah_idwilayah] = universitas.wilayah_idwilayah
            }
            Alamofire.request(Keys.URL_CRUD_UNIVERSITAS, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil"{
                        self.navigationController?.popViewController(animated: true)
                        
                    }else if response.result.value == "gagal"{
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
    
}
