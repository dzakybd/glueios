//
//  MemberFilter.swift
//  Glue
//
//  Created by Macbook Pro on 13/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
// nama, wilayah, universitas, tahun bea, akses, jk
class MemberFilter: FormViewController {
    var wilayahdict = [String: String]()
    var univdict = [String: String]()
    var delegate: FilterProtocol!
    var admin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
        <<< TextRow(Keys.user_nama){
            $0.title = "Nama"
            $0.placeholder = "Masukan nama"
        }
        <<< ActionSheetRow<String>(Keys.user_akses) {
            $0.title = "Ditulis oleh"
            $0.options = ["Admin","Pembina","Pengurus","Semua"]
            $0.value = $0.options?.last
        }
        <<< PickerInputRow<String>(Keys.idwilayah){row in
            row.title = "Wilayah"
            row.hidden = Condition(stringLiteral: "$\(Keys.user_akses) = 'Admin'")
            Keys.getwilayah(completion: { (dict, text) in
                self.wilayahdict = [String: String]()
                self.wilayahdict = dict
                row.options = text
                row.options.append("Semua")
                row.value = row.options.last
                row.reload()
            })
        }.onChange { row in
            if !(row.value?.isEmpty)! && row.value != "Semua" {
                    Keys.getuniversitas(wilayah_idwilayah: self.wilayahdict[row.value!]!,
                                        completion: { (dict, text) in
                                            let piluniv:PickerInputRow<String>! = self.form.rowBy(tag: Keys.iduniversitas)
                                            self.univdict = [String: String]()
                                            self.univdict = dict
                                            piluniv.options = text
                                            piluniv.options.append("Semua")
                                            piluniv.value = piluniv.options.last
                                            piluniv.updateCell()
                    })
                }
            }
        <<< PickerInputRow<String>(Keys.iduniversitas){
            $0.title = "Universitas"
            $0.hidden = Condition(stringLiteral: "$\(Keys.user_akses) = 'Admin' || $\(Keys.user_akses) = 'Pembina' || $\(Keys.idwilayah) = 'Semua'")
        }
        <<< PickerInputRow<String>(Keys.user_tahun_beasiswa){
            $0.title = "Tahun beasiswa"
            let date = Date()
            let calendar = Calendar.current
            let angka = Array(2000...calendar.component(.year, from: date))
            $0.options = angka.map{String($0)}
            $0.options.append("Semua")
            $0.value = $0.options.last
        }
        <<< PickerInputRow<String>(Keys.user_jk){
            $0.title = "Jenis kelamin"
            $0.options = ["Perempuan", "Laki-laki", "Semua"]
            $0.value = $0.options.last
        }
        <<< ActionSheetRow<String>(Keys.order) {
            $0.title = "Urutkan berdasar nama"
            $0.options = ["A ke Z","Z ke A"]
            $0.value = $0.options?.first
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        if form.validate().isEmpty {
            let formvalues = self.form.values(includeHidden: true)
            var parameters = [String: String]()
            
            let nama = (formvalues[Keys.user_nama]! ?? "") as! String
            if !nama.isEmpty{
                parameters[Keys.user_nama] = nama
            }
            
            let akses = formvalues[Keys.user_akses] as! String
            if akses != "Semua"{
                parameters[Keys.user_akses] = Keys.UserAksesCode(kode: akses)
            }
            
            let tahunbea = formvalues[Keys.user_tahun_beasiswa] as! String
            if tahunbea != "Semua"{
                parameters[Keys.user_akses] = tahunbea
            }
            
            
            let wilayah = formvalues[Keys.idwilayah] as! String
            if wilayah != "Semua"{
                parameters[Keys.idwilayah] = self.wilayahdict[formvalues[Keys.idwilayah] as! String]!
            }
            
            let univ = (formvalues[Keys.iduniversitas]! ?? "") as! String
            if !univ.isEmpty && univ != "Semua"{
                parameters[Keys.iduniversitas] = self.univdict[formvalues[Keys.iduniversitas] as! String]!
            }
            
            let jk = (formvalues[Keys.user_jk]! ?? "") as! String
            if jk != "Semua"{
                parameters[Keys.user_jk] = (jk == "Perempuan" ? "0" : "1")
            }
            
            let order = (formvalues[Keys.order]! ?? "") as! String
            parameters[Keys.order] = (order == "A ke Z" ? "0" : "1")
            
            delegate.sharedfilter(data: parameters)
        }
        
    }


}
