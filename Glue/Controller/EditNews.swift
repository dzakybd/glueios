//
//  UbahEvent.swift
//  Glue
//
//  Created by Macbook Pro on 11/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Alamofire
import SKPhotoBrowser
import DefaultsKit
import PopupDialog
import JGProgressHUD

class EditNews: FormViewController {
    var admin:Bool = false
    var akun = User()
    var create = Bool()
    var berita = Event()
    let defaults = Defaults()
    @IBOutlet weak var savebutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        akun = defaults.get(for: Key<User>(Keys.saved_user))!
        
        if akun.user_akses == "0" {
            admin = true
        } else if akun.user_akses == "1" && akun.idwilayah == berita.idwilayah {
            admin = true
        }else if akun.user_akses == "2" && akun.user_nrp == berita.user_nrp {
            admin = true
        }
        
        if create {
            self.navigationItem.title = "Buat berita"
        }else if !create && !admin{
            self.navigationItem.title = "Lihat berita"
            savebutton.title = ""
            savebutton.isEnabled = false
            savebutton.tintColor = UIColor.clear
        }

        form +++ Section("Detail berita")
            +++ Section(){
                var head = HeaderFooterView<NewsImage>(.nibFile(name: "NewsImage", bundle: nil))
                let foto = self.berita.event_thumbnail
                head.onSetupView = { (view, section) -> () in
    
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditNews.tapDetected))
                    view.newsimage.isUserInteractionEnabled = true
                    view.newsimage.addGestureRecognizer(tapGestureRecognizer)
                    if !foto.isEmpty{
                        view.newsimage.sd_setImage(with: URL(string: self.berita.event_thumbnail), placeholderImage: UIImage(named: "icon"))
                    }
                }
                if !create{
                    $0.header = head
                }
            }
            <<< ImageRow(Keys.image) {
                $0.hidden = Condition(booleanLiteral: !admin)
                $0.title = "Ganti gambar berita"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .yes(style: UIAlertActionStyle.destructive)
            }
            <<< TextRow(Keys.event_judul){
                $0.title = "Judul"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan judul"
                $0.disabled = Condition(booleanLiteral: !admin)
                if berita.event_judul.isEmpty{
                    $0.value = ""
                }else{
                    $0.value = berita.event_judul
                }
            }
            <<< TextAreaRow(Keys.event_deskripsi){
                $0.title = "Deskripsi"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan deskripsi"
                $0.disabled = Condition(booleanLiteral: !admin)
                if berita.event_deskripsi.isEmpty{
                    $0.value = ""
                }else{
                    $0.value = berita.event_deskripsi
                }
            }
            <<< DateRow(Keys.event_tanggal){
                $0.title = "Tanggal"
                $0.add(rule: RuleRequired())
                $0.disabled = Condition(booleanLiteral: !admin)
                if !berita.event_tanggal.isEmpty && berita.event_tanggal != "0000-00-00" {
                    $0.value = Keys.DateFromString(dateString: berita.event_tanggal)
                }
                }.cellSetup({ (cell, row) in
                    cell.datePicker.locale = Locale(identifier: Keys.idlocale)
                })
            <<< TimeRow(Keys.event_waktu){
                $0.title = "Waktu"
                $0.add(rule: RuleRequired())
                $0.disabled = Condition(booleanLiteral: !admin)
                if !berita.event_waktu.isEmpty && berita.event_waktu != "00:00:00" {
                    $0.value = Keys.TimeFromString(dateString: berita.event_waktu)
                }
                }.cellSetup({ (cell, row) in
                    cell.datePicker.locale = Locale(identifier: Keys.idlocale)
                })
            <<< TextRow(Keys.event_lokasi){
                $0.title = "Lokasi"
                $0.add(rule: RuleRequired())
                $0.placeholder = "Masukan lokasi"
                $0.disabled = Condition(booleanLiteral: !admin)
                if berita.event_lokasi.isEmpty{
                    $0.value = ""
                }else{
                    $0.value = berita.event_lokasi
                }
            }
            <<< LabelRow (Keys.wilayah_nama) {
                $0.title = "Wilayah"
                $0.hidden = Condition(booleanLiteral: create && berita.user_akses=="0")
                if !berita.wilayah_nama.isEmpty{
                    $0.value = berita.wilayah_nama
                }
            }
            <<< LabelRow (Keys.user_nama) {
                $0.title = "Publisher"
                $0.hidden = Condition(booleanLiteral: create)
                if !berita.user_nama.isEmpty{
                    $0.value = "\(berita.user_nama) (\(Keys.UserAksesName(kode: berita.user_akses)))"
                }
            }
            <<< ButtonRow(){
                $0.hidden = Condition(booleanLiteral: create)
                if berita.isulike == "1"{
                    $0.title = "\(berita.likes) ❤️"
                }else{
                    $0.title = "\(berita.likes) 💔"
                }
                
                }.onCellSelection {  (cell, row) in
                    let parameters = [
                        Keys.mode: (self.berita.isulike == "0" ? Keys.create : Keys.delete),
                        Keys.user_nrp: self.akun.user_nrp,
                        Keys.idevent: self.berita.idevent
                    ]
                    let hud = JGProgressHUD(style: .light)
                    hud.textLabel.text = "Menghapus"
                    hud.show(in: (self.view)!)
                    Alamofire.request(Keys.URL_LIKE_DISLIKE, method:.post, parameters:parameters).responseString { response in
                        hud.dismiss(afterDelay: 1.0)
                        switch response.result {
                        case .success:
                            let responsecode = response.response!.statusCode
                            if responsecode == 200{
                                if self.berita.isulike == "0" {
                                    row.title = "\(String(describing: self.berita.likes)) ❤️"
                                    self.berita.isulike = "1"
                                }else {
                                    row.title = "\(String(describing: self.berita.likes)) 💔"
                                    self.berita.isulike = "0"
                                }

                            }
                        case .failure( _):
                            print(Keys.error)
                        }
                    }
            }
            <<< SwitchRow(Keys.event_published){
                $0.title = "Dipublikasikan"
                $0.hidden = Condition(booleanLiteral: !admin)
                if berita.event_published.isEmpty{
                    $0.value = false
                }else{
                    $0.value = true
                }
            }
            <<< SwitchRow(Keys.event_internal){
                $0.title = "Untuk internal"
                $0.hidden = Condition(booleanLiteral: !admin)
                if berita.event_internal.isEmpty{
                    $0.value = false
                }else{
                    $0.value = true
                }
            }
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func editevent(){
        if form.validate().isEmpty {
            let formvalues = self.form.values(includeHidden: true)
            var parameters = [
                Keys.user_nrp: akun.user_nrp,
                Keys.event_judul: formvalues[Keys.event_judul] as! String,
                Keys.event_deskripsi: formvalues[Keys.event_deskripsi] as! String,
                Keys.event_lokasi: formvalues[Keys.event_lokasi] as! String,
                Keys.event_published: (formvalues[Keys.event_published] as! Bool ? "1" : "0"),
                Keys.event_internal: (formvalues[Keys.event_internal] as! Bool ? "1" : "0"),
            ]
            if create {
                parameters[Keys.mode] = Keys.create
                parameters[Keys.idevent] = berita.idevent
            }else{
                parameters[Keys.mode] = Keys.update
            }
            let imageui = formvalues[Keys.image]! ?? nil
            var imageData : Data!
            if imageui != nil {
                imageData = UIImagePNGRepresentation(imageui as! UIImage)
            }
            let hud = JGProgressHUD(style: .light)
//            hud.textLabel.text = ""
            hud.show(in: self.view)
            Alamofire.upload( multipartFormData: { multipartFormData in
                if imageui != nil {
                    multipartFormData.append(imageData, withName: Keys.image, fileName: "image.png" , mimeType: "image/png")
                }
                for (key, val) in parameters {
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
            }, to: Keys.URL_CRUD_EVENT, encodingCompletion: { encodingResult in
                hud.dismiss(afterDelay: 1.0)
                switch encodingResult {
                case .success(let upload, _, _): upload.responseString { response in
                    if response.result.value == "berhasil" {
                        
                    }
                    }case .failure( _):
                        let popup = PopupDialog(title: "Error", message: "Server bermasalah", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapDetected() {
        var photo:SKPhoto

        if berita.event_foto.isEmpty {
            photo = SKPhoto.photoWithImage(UIImage(named: "icon")!)
        }else{
            photo = SKPhoto.photoWithImageURL(self.berita.event_foto)
            photo.shouldCachePhotoURLImage = false

        }
        
        var images = [SKPhoto]()
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
}


