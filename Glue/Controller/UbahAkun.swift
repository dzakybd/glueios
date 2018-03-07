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

class UbahAkun: FormViewController {
    var userlat = String()
    var userlng = String()
    var own = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let kategori:[String] = ["Data utama", "Data lain", "Pekerjaan", "Tautan"]
        let segmenttext:String = "$segments != "
        
        form +++ Section("Pilih data untuk diubah")
            <<< SegmentedRow<String>("segments"){
                $0.options = kategori
                $0.value = kategori[0]
            }
            +++ Section(){
                $0.tag = kategori[0]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[0])'")
            }
                <<< ImageRow() {
                    $0.tag="image"
                    $0.title = "Ganti gambar profil"
                    $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                    $0.clearAction = .yes(style: UIAlertActionStyle.destructive)
                }
                <<< ButtonRow() {
                    $0.title = "Lihat gambar profil terpasang"
                }.onCellSelection { [weak self] (cell, row) in
                    
                    }
                <<< IntRow(){
                    $0.title = "NRP"
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "Masukan nrp anda"
                    $0.tag="nrp"
                    $0.disabled = Condition(booleanLiteral: own)
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< NameRow(){
                    $0.tag="nama"
                    $0.title = "Nama"
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "Masukan nama anda"
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< EmailRow(){
                    $0.tag="email"
                    $0.title = "Email"
                    $0.add(rule: RuleRequired())
                    $0.add(rule: RuleEmail())
                    $0.placeholder = "Masukan email anda"
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< GenericPasswordRow(){
                    $0.tag="password"
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "Masukan password anda"
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                }
                <<< PhoneRow(){
                    $0.tag="nohp"
                    $0.title = "Nomor HP"
                    $0.placeholder = "Masukan nomor hp anda"
                }
            +++ Section(){
                $0.tag = kategori[1]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[1])'")
            }
            +++ Section(){
                $0.tag = kategori[2]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[2])'")
            }
            +++ Section(){
                $0.tag = kategori[3]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[3])'")
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
    
    func imageshow() {
        // 1. create URL Array
        var images = [SKPhoto]()
//        let photo = SKPhoto.photoWithImageURL(defaults.string(forKey: Keys.user_foto)!)
//        photo.shouldCachePhotoURLImage = false
//        images.append(photo)
//        
//        // 2. create PhotoBrowser Instance, and present.
//        let browser = SKPhotoBrowser(photos: images)
//        browser.initializePageIndex(0)
//        present(browser, animated: true, completion: {})
    }
    
    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
