//
//  UbahAkun.swift
//  Glue
//
//  Created by Macbook Pro on 07/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import GenericPasswordRow
import Alamofire
import INTULocationManager
import SKPhotoBrowser
import DefaultsKit

class UbahAkun: FormViewController {
    var userlat = String()
    var userlng = String()
    var own = Bool()
    var create = Bool()
    var notregistered = true
    var admin:Bool = false
    var ishide_nohp:Bool = false
    var ishide_agama:Bool = false
    var ishide_suku:Bool = false
    var ishide_tautan:Bool = false
    var akun = User()
    var result:[Wilayah] = []
    var wilayahdict = [String: String]()
    var univdict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmenttext:String = "$segments != "
        var kategori:[String] = ["Data utama"]
        
        if own {
            let defaults = Defaults()
            akun = defaults.get(for: Key<User>(Keys.saved_user))!
            getlocation()
        }
        
        if !create {
            kategori.append("Data lain")
        }
        
        if akun.user_akses == "0" || akun.user_akses == "1" {
            admin = true
        }
        
        if akun.ishide_no_hp == "1" && !own{
            ishide_nohp = true
        }
        
        if akun.ishide_suku == "1"  && !own{
            ishide_suku = true
        }
        
        if akun.ishide_agama == "1"  && !own{
            ishide_agama = true
        }
        
        if akun.ishide_tautan == "1"  && !own{
            ishide_tautan = true
        }
        
        if !akun.user_email.isEmpty {
            notregistered = false
        }
        
        form +++ Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = kategori
                $0.value = kategori[0]
            }
            +++ Section(){
                $0.tag = kategori[0]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[0])'")
            }
                <<< LabelRow (Keys.user_no_kta) {
                    $0.title = "Nomor Keanggotaan"
                    $0.hidden = Condition(booleanLiteral: create)
                    if !akun.user_nrp.isEmpty{
                        $0.value = akun.user_no_kta
                    }
                }
                <<< IntRow(Keys.user_nrp){
                    $0.title = "NRP"
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "Masukan nrp"
                    if !akun.user_nrp.isEmpty{
                        $0.value = Int(akun.user_nrp)
                    }
                    $0.disabled = Condition(booleanLiteral: (own && !admin) )
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                <<< ActionSheetRow<String>(Keys.user_akses) {
                    $0.title = "Akses akun"
                    $0.selectorTitle = "Pilih akses"
                    $0.add(rule: RuleRequired())
                    $0.disabled = Condition(booleanLiteral: (own && !admin) )
                    $0.options = ["Admin","Pembina","Pengurus","Anggota"]
                    if akun.user_akses.isEmpty{
                        $0.value = $0.options?.last
                    }else{
                         $0.value = Keys.UserAksesName(kode: akun.user_akses)
                    }
                }
                <<< PickerInputRow<String>(Keys.idwilayah){row in
                    row.title = "Wilayah"
                    row.add(rule: RuleRequired())
                    row.tag=Keys.idwilayah
                    getwilayah(completion: { (result) in
                        row.options = result
                        if self.akun.wilayah_nama.isEmpty{
                            row.value = row.options.first
                        }else{
                            row.value = self.akun.wilayah_nama
                        }
                        row.reload()
                    })
                    }.onChange { [weak self] row in
                        if !(row.value?.isEmpty)!{
                            self?.getuniversitas(wilayah_idwilayah: (self?.wilayahdict[row.value!]!)!,
                                                 completion: { (result) in
                                let piluniv:PickerInputRow<String>! = self?.form.rowBy(tag: Keys.iduniversitas)
                                piluniv.options = result
                                let univnama = (self?.akun.universitas_nama)!
                                if !univnama.isEmpty && result.contains(univnama){
                                    piluniv.value = univnama
                                }else{
                                    piluniv.value = ""
                                }
                                piluniv.updateCell()
                            })
                        }
                    }
                <<< PickerInputRow<String>(Keys.iduniversitas){
                    $0.title = "Universitas"
                    $0.add(rule: RuleRequired())
                    $0.hidden = Condition(stringLiteral: "$\(Keys.user_akses) = 'Admin' || $\(Keys.user_akses) = 'Pembina'")
                }
                <<< MultipleSelectorRow<Int>(Keys.user_tahun_beasiswa) {
                    $0.title = "Tahun beasiswa"
                    $0.options = Array(2013...2025)
                    $0.add(rule: RuleRequired())
                    $0.hidden = Condition(stringLiteral: "$\(Keys.user_akses) = 'Admin' || $\(Keys.user_akses) = 'Pembina'")
                    if !akun.user_tahun_beasiswa.isEmpty{
                        let array = akun.user_tahun_beasiswa.components(separatedBy: ",")
                        $0.value = Set(array.map{ Int($0)!})
                    }else{
                        let date = Date()
                        let calendar = Calendar.current
                        $0.value = [calendar.component(.year, from: date)]
                    }
                }
                <<< ButtonRow() {
                    $0.hidden = Condition(booleanLiteral: (create||akun.user_foto.isEmpty||notregistered))
                    $0.title = "Lihat gambar profil terpasang"
                    }.onCellSelection { [weak self] (cell, row) in
                        var images = [SKPhoto]()
                        let photo = SKPhoto.photoWithImageURL((self?.akun.user_foto)!)
                        photo.shouldCachePhotoURLImage = false
                        images.append(photo)
                        let browser = SKPhotoBrowser(photos: images)
                        browser.initializePageIndex(0)
                        self?.present(browser, animated: true, completion: {})
                }
                <<< ImageRow(Keys.image) {
                    $0.hidden = Condition(booleanLiteral: (create || !own || notregistered))
                    $0.title = "Ganti gambar profil"
                    $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                    $0.clearAction = .yes(style: UIAlertActionStyle.destructive)
                }
                <<< NameRow(Keys.user_nama){
                    $0.title = "Nama"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_nama.isEmpty{
                        $0.value = akun.user_nama
                    }
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "Masukan nama"
                    $0.validationOptions = .validatesOnChange
                    
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                <<< EmailRow(Keys.user_email){
                    $0.title = "Email"
                    $0.add(rule: RuleRequired())
                    $0.add(rule: RuleEmail())
                    $0.placeholder = "Masukan email"
                    $0.validationOptions = .validatesOnChange
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_email.isEmpty{
                        $0.value = akun.user_email
                    }
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< GenericPasswordRow(Keys.user_password){
                    $0.add(rule: RuleRequired())
                    $0.hidden = Condition(booleanLiteral: (!own || notregistered))
                    if !akun.user_password.isEmpty{
                        $0.value = akun.user_password
                    }
                    $0.placeholder = "Masukan password anda"
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< PhoneRow(Keys.user_no_hp){
                    $0.title = "Nomor HP"
                    $0.placeholder = "Masukan nomor hp"
                    $0.hidden = Condition(booleanLiteral: (create || ishide_nohp || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_no_hp.isEmpty{
                        $0.value = akun.user_no_hp
                    }
                }
                <<< TextRow(Keys.user_alamat){
                    $0.title = "Alamat"
                    $0.placeholder = "Masukan alamat"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered) )
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_alamat.isEmpty{
                        $0.value = akun.user_alamat
                    }
                }
                <<< TextRow(Keys.user_tempat_lahir){
                    $0.title = "Tempat lahir"
                    $0.placeholder = "Masukan tempat lahir"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_tempat_lahir.isEmpty{
                        $0.value = akun.user_tempat_lahir
                    }
                }
                <<< DateRow(Keys.user_tanggal_lahir){
                    $0.title = "Tanggal lahir"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_tanggal_lahir.isEmpty{
                        $0.value = Keys.DateFromString(dateString: akun.user_tanggal_lahir)
                    }
                    }.cellSetup({ (cell, row) in
                        cell.datePicker.locale = Locale(identifier: Keys.idlocale)
                    })
                <<< SegmentedRow<String>(Keys.user_jk){
                    $0.title = "Jenis kelamin"
                    $0.options = ["Perempuan", "Laki-laki"]
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if akun.user_jk.isEmpty{
                        if (akun.user_jk=="0"){
                            $0.value = "Perempuan"
                        }else{
                            $0.value = "Laki-Laki"
                        }
                    }else{
                        $0.value = $0.options?.first
                    }
                }
            
           
            +++ Section(){
                $0.tag = kategori[1]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[1])'")
            }
        }
    
    func getlocation(){
        if own {
            let locationManager = INTULocationManager.sharedInstance()
            locationManager.requestLocation(withDesiredAccuracy: .city,
                                            timeout: 10.0,
                                            delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                                if (status == INTULocationStatus.success) {
                                                    self.userlat = "\(currentLocation?.coordinate.latitude ?? 0)"
                                                    self.userlng = "\(currentLocation?.coordinate.longitude ?? 0)"
                                                    
                                                }
                                                else if (status == INTULocationStatus.timedOut) {
                                                    
                                                }
                                                else {
                                                    
                                                }
            }
        }
    }
    
    func getwilayah(completion: @escaping ([String]) -> ()) {
        let parameters = [
            Keys.mode: Keys.read
        ]
        var result = [String]()
        Alamofire.request(Keys.URL_CRUD_WILAYAH, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                self.wilayahdict=[String: String]()
                for element in arrJson {
                    let data = element as! NSDictionary
                    self.wilayahdict[data[Keys.wilayah_nama] as! String] = (data[Keys.idwilayah] as! String)
                    result.append(data[Keys.wilayah_nama] as! String)
                }
                completion(result)
            case .failure( _):
                let alertController = UIAlertController(title: "Login", message:
                    "Maaf jaringan error", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func getuniversitas(wilayah_idwilayah: String,completion: @escaping ([String]) -> ()) {
        let parameters = [
            Keys.mode: Keys.read,
            Keys.wilayah_idwilayah: wilayah_idwilayah
        ]
        var result = [String]()
        Alamofire.request(Keys.URL_CRUD_UNIVERSITAS, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                self.univdict=[String: String]()
                for element in arrJson {
                    let data = element as! NSDictionary
                    self.univdict[data[Keys.universitas_nama] as! String] = (data[Keys.iduniversitas] as! String)
                    result.append(data[Keys.universitas_nama] as! String)
                }
                completion(result)
            case .failure( _):
                let alertController = UIAlertController(title: "Login", message:
                    "Maaf jaringan error", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
