//
//  NewsFilter.swift
//  Glue
//
//  Created by Macbook Pro on 12/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka

class NewsFilter: FormViewController {
    var wilayahdict = [String: String]()
    var delegate: FilterProtocol!
    var admin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
            <<< TextRow(Keys.event_judul){
                $0.title = "Judul"
                $0.placeholder = "Masukan judul"
            }
            <<< TextRow(Keys.event_lokasi){
                $0.title = "Lokasi"
                $0.placeholder = "Masukan lokasi"
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
            }
            <<< ActionSheetRow<String>(Keys.order) {
                $0.title = "Urutkan"
                $0.options = ["Terbaru","Terlama"]
                $0.value = $0.options?.first
            }
            
            <<< SwitchRow(Keys.event_internal){
                $0.hidden = Condition(booleanLiteral: !admin)
                $0.title = "Hanya untuk internal"
            }
            <<< SwitchRow(Keys.event_published){
                $0.hidden = Condition(booleanLiteral: !admin)
                $0.title = "Dipublikasikan"
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
          
            let judul = (formvalues[Keys.event_judul]! ?? "") as! String
            if !judul.isEmpty{
                parameters[Keys.event_judul] = judul
            }
            
            let lokasi = (formvalues[Keys.event_lokasi]! ?? "") as! String
            if !lokasi.isEmpty{
                parameters[Keys.event_lokasi] = lokasi
            }
            
            let akses = formvalues[Keys.user_akses] as! String
            if akses != "Semua"{
                parameters[Keys.user_akses] = Keys.UserAksesCode(kode: akses)
            }
            
            let wilayah = formvalues[Keys.idwilayah] as! String
            if wilayah != "Semua"{
                parameters[Keys.idwilayah] = self.wilayahdict[formvalues[Keys.idwilayah] as! String]!
            }
                
            let order = (formvalues[Keys.order]! ?? "") as! String
            parameters[Keys.order] = (order == "Terbaru" ? "0" : "1")
           
            if admin {
                parameters[Keys.event_internal] = (formvalues[Keys.event_internal] as! Bool ? "1" : "0")
                
                parameters[Keys.event_published] = (formvalues[Keys.event_published] as! Bool ? "1" : "0")
            }
           
            delegate.sharedfilter(data: parameters)
        }
        
    }

}
