//
//  EditWilayah.swift
//  Glue
//
//  Created by Macbook Pro on 14/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import DefaultsKit
import PopupDialog
import Alamofire
import JGProgressHUD

class EditWilayah: FormViewController {

    var create = Bool()
    var wilayah = Wilayah()
    let defaults = Defaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if create {
            self.navigationItem.title = "Buat data wilayah"
        }
        
        form +++ Section()
            <<< IntRow(Keys.idwilayah){
                    $0.title = "ID Wilayah"
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "misal 1"
                    if wilayah.idwilayah != "" {
                        $0.value = Int(wilayah.idwilayah)
                    }
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
            <<< TextRow(Keys.wilayah_nama){
                $0.title = "Nama Wilayah"
                $0.add(rule: RuleRequired())
                $0.placeholder = "misal Jawa Timur"
                if wilayah.wilayah_nama != "" {
                    $0.value = wilayah.wilayah_nama
                }
            }
            <<< ButtonRow(){
                $0.title = "Hapus wilayah"
                $0.hidden = Condition(booleanLiteral: wilayah.jumlahuser != "0")
                }.onCellSelection({ (cell, row) in
                    
                    let popup = PopupDialog(title: Keys.warning, message: "Anda yakin menghapus?", buttonAlignment: .horizontal, gestureDismissal: true)
                    let buttonOne = CancelButton(title: Keys.tidak) {
                    }
                    let buttonTwo = DestructiveButton(title: Keys.ya) {
                        self.hapuswilayah()
                    }
                    popup.addButtons([buttonOne, buttonTwo])
                    self.present(popup, animated: true, completion: nil)
                }).cellSetup({ (cell,row) in
                    cell.tintColor = .flatRed
                })
            <<< ButtonRow(){
                $0.title = "Daftar universitas"
                $0.hidden = Condition(booleanLiteral: create)
                }.onCellSelection({ (cell, row) in
                    self.performSegue(withIdentifier: "editwilayah_to_homeuniversitas", sender: self)
                })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editwilayah_to_homeuniversitas"  {
            if let vc = segue.destination as? HomeUniversitas {
                vc.wilayah_idwilayah = wilayah.idwilayah
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hapuswilayah(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Menghapus"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.delete,
            Keys.idwilayah: wilayah.idwilayah
        ]
        Alamofire.request(Keys.URL_CRUD_WILAYAH, method:.post, parameters:parameters).responseString { response in
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
    
    @IBAction func simpanclick(_ sender: Any) {
        if form.validate().isEmpty {
            let formvalues = self.form.values()
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Menyimpan"
            hud.show(in: self.view)
            let idwilayah = String(formvalues[Keys.idwilayah] as! Int)
            var parameters = [Keys.wilayah_nama: formvalues[Keys.wilayah_nama] as! String]
            if create {
                parameters[Keys.mode] = Keys.create
                parameters[Keys.idwilayah] = idwilayah
            }else{
                parameters[Keys.mode] = Keys.update
                if idwilayah != wilayah.idwilayah {
                    parameters[Keys.idwilayah_new] = idwilayah
                }
                parameters[Keys.idwilayah] = wilayah.idwilayah
            }
            Alamofire.request(Keys.URL_CRUD_WILAYAH, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil"{
                        self.navigationController?.popViewController(animated: true)

                    }else if response.result.value == "gagal"{
                        let popup = PopupDialog(title: Keys.gagal, message: "Proses gagal", gestureDismissal: true)
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
