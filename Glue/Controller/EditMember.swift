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
import SKPhotoBrowser
import DefaultsKit
import PopupDialog
import JGProgressHUD
import SDWebImage

class EditMember: FormViewController {
    var own:Bool = false
    var create = Bool()
    var createtautan = Bool()
    var createkerja = Bool()
    var akun = User()
    var kerja = UserKerja()
    var tautan = UserTautan()
    var notregistered = true
    var admin:Bool = false
    var ishide_nohp:Bool = false
    var ishide_agama:Bool = false
    var ishide_suku:Bool = false
    var ishide_tautan:Bool = false
    var user_akses = ""
    var wilayahdict = [String: String]()
    var univdict = [String: String]()
    let defaults = Defaults()
    
    @IBOutlet weak var savebutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmenttext:String = "$segments != "
        var kategori:[String] = ["Data utama"]
        
        if own {
            akun = defaults.get(for: Key<User>(Keys.saved_user))!
        }
        
        if !akun.user_email.isEmpty {
            notregistered = false
        }
        
        if user_akses == "0" {
            admin = true
        } else if user_akses == "1" && own {
            admin = true
        }else if user_akses == "1" && !own && !notregistered {
            let akuntemp = defaults.get(for: Key<User>(Keys.saved_user))!
            if akun.idwilayah == akuntemp.idwilayah{
                admin = true
            }
        }
        
        print(admin)
        
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
    
        
        if !create && !notregistered  {
            kategori.append("Data lain")
            kategori.append("Pekerjaan")
            kategori.append("Tautan")
        }
        
        if create {
            self.navigationItem.title = "Buat akun"
        }else if !create && !own && !admin{
            self.navigationItem.title = "Lihat akun"
            savebutton.title = ""
            savebutton.isEnabled = false
            savebutton.tintColor = UIColor.clear
        }
        
        let calendar = Calendar.current
        let currentyear = calendar.component(.year, from: Date())
        let angka = Array(1980...currentyear)
        var angkatext = angka.map{String($0)}
        angkatext.append("")
        
        form +++ Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = kategori
                $0.value = kategori[0]
            }
            +++ Section(){
                $0.tag = kategori[0]
                $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[0])'")
                
                var head = HeaderFooterView<MemberImage>(.nibFile(name: "MemberImage", bundle: nil))
                head.onSetupView = { (view, section) -> () in
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditMember.tapDetected))
                    view.memberimage.isUserInteractionEnabled = true
                    view.memberimage.addGestureRecognizer(tapGestureRecognizer)
                    let wid = view.memberimage.frame.size.width/2
                    view.memberimage.layer.cornerRadius = wid
                    let foto = self.akun.user_thumbnail
                    if !foto.isEmpty{
                        view.memberimage.sd_setImage(with: URL(string: foto), placeholderImage: UIImage(named: "icon"))
                    }
                    
                }
                
                if !create{
                    $0.header = head
                }
            }
            <<< ImageRow(Keys.image) {
                $0.hidden = Condition(booleanLiteral: (create || !own || notregistered))
                $0.title = "Ganti gambar profil"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .yes(style: UIAlertActionStyle.destructive)
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
                    $0.placeholder = "misal 5114100001"
                    if !akun.user_nrp.isEmpty{
                        $0.value = Int(akun.user_nrp)
                    }
                    $0.disabled = Condition(booleanLiteral: !admin)
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
                    $0.disabled = Condition(booleanLiteral: !admin)
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
                    row.disabled = Condition(booleanLiteral: !admin)
                    row.hidden = Condition(stringLiteral: "$\(Keys.user_akses) == 'Admin'")
                    Keys.getwilayah(completion: { (dict, text) in
                        self.wilayahdict = [String: String]()
                        self.wilayahdict = dict
                        row.options = text
                        if self.akun.wilayah_nama.isEmpty{
                            row.value = row.options.first
                        }else{
                            row.value = self.akun.wilayah_nama
                        }
                        row.reload()
                    })
                    }.onChange { row in
                        if !(row.value?.isEmpty)! && row.value != nil{
                            Keys.getuniversitas(wilayah_idwilayah: self.wilayahdict[row.value!]!,
                                                 completion: { (dict, text) in
                                let piluniv:PickerInputRow<String>! = self.form.rowBy(tag: Keys.iduniversitas)
                                self.univdict = [String: String]()
                                self.univdict = dict
                                piluniv.options = text
                                let univnama = self.akun.universitas_nama
                                if !univnama.isEmpty && text.contains(univnama){
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
                    $0.disabled = Condition(booleanLiteral: !admin)
                    $0.hidden = Condition(stringLiteral: "$\(Keys.user_akses) == 'Admin' || $\(Keys.user_akses) == 'Pembina'")
                }
                <<< MultipleSelectorRow<String>(Keys.user_tahun_beasiswa) {
                    $0.title = "Tahun beasiswa"
                    $0.options = angkatext
                    $0.add(rule: RuleRequired())
                    $0.disabled = Condition(booleanLiteral: !admin)
                    $0.hidden = Condition(stringLiteral: "$\(Keys.user_akses) == 'Admin' || $\(Keys.user_akses) == 'Pembina'")
                    if !akun.user_tahun_beasiswa.isEmpty{
                        let array = akun.user_tahun_beasiswa.components(separatedBy: ",")
                        $0.value = Set(array)
                    }else{
                        $0.value = [String(currentyear)]
                    }
                }
                <<< NameRow(Keys.user_nama){
                    $0.title = "Nama"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_nama.isEmpty{
                        $0.value = akun.user_nama
                    }
                    $0.add(rule: RuleRequired())
                    $0.placeholder = "misal Andi"
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
                    $0.placeholder = "misal andi@gmail.com"
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
                    $0.hidden = Condition(booleanLiteral: (create || !own || notregistered))
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
                    $0.placeholder = "misal 089xxxxx"
                    $0.hidden = Condition(booleanLiteral: (create || ishide_nohp || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if akun.user_no_hp.isEmpty{
                        $0.value = ""
                    }else{
                        $0.value = akun.user_no_hp
                    }
                    
                }
                <<< TextRow(Keys.user_alamat){
                    $0.title = "Alamat"
                    $0.placeholder = "misal nama jalan / kota"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered) )
                    $0.disabled = Condition(booleanLiteral: !own)
                    if akun.user_alamat.isEmpty{
                        $0.value = ""
                    }else{
                       $0.value = akun.user_alamat
                    }
                }
                <<< TextRow(Keys.user_tempat_lahir){
                    $0.title = "Tempat lahir"
                    $0.placeholder = "misal Surabaya"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if akun.user_tempat_lahir.isEmpty{
                        $0.value = ""
                    }else{
                        $0.value = akun.user_tempat_lahir
                    }
                }
                <<< DateRow(Keys.user_tanggal_lahir){
                    $0.title = "Tanggal lahir"
                    $0.hidden = Condition(booleanLiteral: (create || notregistered))
                    $0.disabled = Condition(booleanLiteral: !own)
                    if !akun.user_tanggal_lahir.isEmpty && akun.user_tanggal_lahir != "0000-00-00" {
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
        
            if !create && !notregistered {
                form +++ Section(){
                    $0.tag = kategori[1]
                    $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[1])'")
                    }
                    <<< TextAreaRow(Keys.user_bio){
                        $0.title = "Bio"
                        $0.placeholder = "isi bio"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.user_bio.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.user_bio
                        }
                    }
                    <<< TextRow(Keys.user_status){
                        $0.title = "Status"
                        $0.placeholder = "misal Lajang"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.user_status.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.user_status
                        }
                    }
                    <<< TextRow(Keys.user_agama){
                        $0.title = "Agama"
//                        $0.placeholder = "Masukan status"
                        $0.hidden = Condition(booleanLiteral: ishide_agama)
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.user_agama.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.user_agama
                        }
                    }
                    <<< TextRow(Keys.user_suku){
                        $0.title = "Suku"
                        $0.placeholder = "misal Madura"
                        $0.hidden = Condition(booleanLiteral: ishide_suku)
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.user_suku.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.user_suku
                        }
                    }
                    <<< TextRow(Keys.user_goldar){
                        $0.title = "Golongan darah"
                        $0.add(rule: RuleMaxLength(maxLength: 5))
                        $0.placeholder = "misal AB"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.user_goldar.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.user_goldar
                        }
                    }
                    +++ Section("Pendidikan"){
                        $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[1])'")
                    }
                    <<< TextRow(Keys.kuliah_fakultas1){
                        $0.title = "Fakultas S1"
                        $0.placeholder = "misal Fakultas Ekonomi dan Bisnis"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_fakultas1.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.kuliah_fakultas1
                        }
                    }
                    <<< TextRow(Keys.kuliah_jurusan1){
                        $0.title = "Jurusan S1"
                        $0.placeholder = "misal Ekonomi Syariah"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_jurusan1.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.kuliah_jurusan1
                        }
                    }
                    <<< PickerInputRow<String>(Keys.kuliah_masuk_keluar1 + "1"){
                        $0.title = "Tahun masuk S1"
                        $0.options = angkatext
                        $0.disabled = Condition(booleanLiteral: !own)
                        if !akun.kuliah_masuk_keluar1.isEmpty{
                            let array = akun.kuliah_masuk_keluar1.components(separatedBy: ",")
                            $0.value = array[0]
                        }
                    }
                    <<< PickerInputRow<String>(Keys.kuliah_masuk_keluar1 + "2"){
                        $0.title = "Tahun lulus S1"
                        $0.options = angkatext
                        $0.disabled = Condition(booleanLiteral: !own)
                        if !akun.kuliah_masuk_keluar1.isEmpty{
                            let array = akun.kuliah_masuk_keluar1.components(separatedBy: ",")
                            $0.value = array[1]
                        }
                    }
                    <<< SwitchRow("S2"){
                        $0.title = "Kuliah S2"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_univ2.isEmpty{
                            $0.value = false
                        }else{
                            $0.value = true
                        }
                    }
                    <<< TextRow(Keys.kuliah_univ2){
                        $0.title = "Universitas S2"
                        $0.placeholder = "misal Universitas Airlangga"
                        $0.hidden = "$S2 == false"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_univ2.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.kuliah_univ2
                        }
                    }
                    <<< TextRow(Keys.kuliah_fakultas2){
                        $0.title = "Fakultas S2"
                        $0.placeholder = "misal Fakultas Ekonomi dan Bisnis"
                        $0.hidden = "$S2 == false"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_fakultas2.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.kuliah_fakultas2
                        }
                    }
                    <<< TextRow(Keys.kuliah_jurusan2){
                        $0.title = "Jurusan S2"
                        $0.placeholder = "misal Ekonomi Syariah"
                        $0.hidden = "$S2 == false"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if akun.kuliah_jurusan2.isEmpty{
                            $0.value = ""
                        }else{
                            $0.value = akun.kuliah_jurusan2
                        }
                    }
                    <<< PickerInputRow<String>(Keys.kuliah_masuk_keluar2 + "1"){
                        $0.title = "Tahun masuk S2"
                        $0.options = angkatext
                        $0.hidden = "$S2 == false"
                        $0.disabled = Condition(booleanLiteral: !own)
                        if !akun.kuliah_masuk_keluar2.isEmpty{
                            let array = akun.kuliah_masuk_keluar2.components(separatedBy: ",")
                            $0.value = array[0]
                        }
                    }
                    <<< PickerInputRow<String>(Keys.kuliah_masuk_keluar2 + "2"){
                        $0.title = "Tahun lulus S2"
                        $0.hidden = "$S2 == false"
                        $0.options = angkatext
                        $0.disabled = Condition(booleanLiteral: !own)
                        if !akun.kuliah_masuk_keluar2.isEmpty{
                            let array = akun.kuliah_masuk_keluar2.components(separatedBy: ",")
                            $0.value = array[1]
                        }
                    }
                
                if own{
                    form +++ Section("Sembunyikan data"){
                        $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[1])'")
                    }
                    <<< CheckRow(Keys.ishide_no_hp) {
                        $0.title = "Nomor hp"
                        if ishide_nohp {
                            $0.value = true
                        }else{
                            $0.value = false
                        }
                    }
                    <<< CheckRow(Keys.ishide_agama) {
                        $0.title = "Agama"
                        if ishide_agama {
                            $0.value = true
                        }else{
                            $0.value = false
                        }
                    }
                    <<< CheckRow(Keys.ishide_suku) {
                        $0.title = "Suku"
                        if ishide_suku {
                            $0.value = true
                        }else{
                            $0.value = false
                        }
                    }
                    <<< CheckRow(Keys.ishide_tautan) {
                        $0.title = "Tautan"
                        if ishide_tautan {
                            $0.value = true
                        }else{
                            $0.value = false
                        }
                    }
                }
            
                form +++ Section(){
                    $0.tag = kategori[2]
                    $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[2])'")
                }
                
                for (index, kerja) in akun.user_kerjas.enumerated(){
                    form +++ Section("Pekerjaan \(index+1)"){
                        $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[2])'")
                    }
                        <<< LabelRow(){
                            $0.title = "Perusahaan"
                            $0.value = kerja.kerja_perusahaan
                            }
                        
                        <<< LabelRow(){
                            $0.title = "Jabatan"
                            $0.value = kerja.kerja_jabatan
                        }
    
                        <<< LabelRow(){
                            $0.title = "Lokasi"
                            $0.value = kerja.kerja_lokasi
                        }
                        <<< LabelRow(){
                            $0.title = "Tahun masuk kerja"
                            if kerja.kerja_masuk_keluar.isEmpty{
                                $0.value = ""
                            }else{
                                let array = kerja.kerja_masuk_keluar.components(separatedBy: ",")
                                $0.value = array[0]
                            }
                        }
                        <<< LabelRow(){
                            $0.title = "Tahun keluar kerja"
                            if kerja.kerja_masuk_keluar.isEmpty{
                                $0.value = ""
                            }else{
                                let array = kerja.kerja_masuk_keluar.components(separatedBy: ",")
                                $0.value = array[1]
                            }
                        }
                        <<< ButtonRow() {
                            $0.hidden = Condition(booleanLiteral: !own)
                            $0.title = "Edit pekerjaan"
                            }.onCellSelection { (cell, row) in
                                self.createkerja = false
                                self.kerja = kerja
                                self.performSegue(withIdentifier: "editmember_to_editkerja", sender: self)
                            }
                }
                
                form +++ Section(){
                    $0.tag = kategori[3]
                    $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[3])'")
                }
                
                for (index, tautan) in akun.user_tautans.enumerated(){
                    form +++ Section("Tautan \(index+1)"){
                        $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[3])'")
                        }
                        <<< LabelRow(){
                            $0.title = "Judul"
                            $0.value = tautan.tautan_judul
                        }
                        <<< LabelRow(){
                            $0.title = "Detail"
                            $0.value = tautan.tautan_text
                        }
                        <<< ButtonRow() {
                            $0.hidden = Condition(booleanLiteral: !own)
                            $0.title = "Edit tautan"
                            }.onCellSelection { (cell, row) in
                                self.createtautan = false
                                self.tautan = tautan
                                self.performSegue(withIdentifier: "editmember_to_edittautan", sender: self)
                            }
                }
                
                if own {
                    form +++ Section()
                        <<< ButtonRow() {
                            $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[2])'")
                            $0.title = "Tambah pekerjaan"
                            }.onCellSelection { (cell, row) in
                                self.createkerja = true
                                self.performSegue(withIdentifier: "editmember_to_editkerja", sender: self)
                        }
                        <<< ButtonRow() {
                            $0.hidden = Condition(stringLiteral: "\(segmenttext)'\(kategori[3])'")
                            $0.title = "Tambah tautan"
                            }.onCellSelection { (cell, row) in
                                self.createtautan = true
                                self.performSegue(withIdentifier: "editmember_to_edittautan", sender: self)
                        }
                }
                
                
                form +++ Section("Opsi lain"){
                    $0.hidden = Condition(booleanLiteral: !(!create && (admin || own)) )
                }
                    <<< ButtonRow() {
                        $0.title = "Hapus akun"
                        }.onCellSelection { (cell, row) in
                            let popup = PopupDialog(title: Keys.warning, message: "Anda yakin menghapus akun?", buttonAlignment: .horizontal, gestureDismissal: true)
                            let buttonOne = CancelButton(title: Keys.tidak) {
                            }
                            let buttonTwo = DestructiveButton(title: Keys.ya) {
                                self.defaults.clear(Key<User>(Keys.saved_user))
                                self.hapusakun()
                            }
                            popup.addButtons([buttonOne, buttonTwo])
                            self.present(popup, animated: true, completion: nil)
                        }.cellSetup({ (cell,row) in
                            cell.tintColor = .flatRed
                        })
                    <<< ButtonRow() {
                        $0.hidden = Condition(booleanLiteral: !own)
                        $0.title = "Keluar"
                        }.onCellSelection { (cell, row) in
                            let popup = PopupDialog(title: Keys.warning, message: "Anda yakin keluar?", buttonAlignment: .horizontal, gestureDismissal: true)
                            let buttonOne = CancelButton(title: Keys.tidak) {
                            }
                            let buttonTwo = DestructiveButton(title: Keys.ya) {
                                self.defaults.clear(Key<User>(Keys.saved_user))
                                 self.performSegue(withIdentifier: "editmember_to_home", sender: self)
                            }
                            popup.addButtons([buttonOne, buttonTwo])
                            self.present(popup, animated: true, completion: nil)
                        }.cellSetup({ (cell,row) in
                            cell.tintColor = .flatRedDark
                        })
            }
        
        }
    
    @IBAction func simpanclick(_ sender: Any) {
        if create {
            editakunadmin()
        }else if !own && !create{
            editakunadmin()
        }else if own && !create {
            editakunowner()
        }
    }
    
    func hapusakun(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Menghapus"
        hud.show(in: self.view)
        let parameters = [
            Keys.mode: Keys.delete,
            Keys.user_nrp: akun.user_nrp
        ]
        Alamofire.request(Keys.URL_CRUD_USER, method:.post, parameters:parameters).responseString { response in
            hud.dismiss()
            switch response.result {
            case .success:
                if response.result.value == "berhasil"{
                    self.performSegue(withIdentifier: "editmember_to_home", sender: self)
                }
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func editakunadmin(){
        if form.validate().isEmpty {
            let formvalues = self.form.values()

            var parameters = [
                Keys.user_nrp: String(formvalues[Keys.user_nrp] as! Int),
                Keys.idwilayah: wilayahdict[formvalues[Keys.idwilayah] as! String]!,
                Keys.iduniversitas: univdict[formvalues[Keys.iduniversitas] as! String]!,
                Keys.user_akses: Keys.UserAksesCode(kode: formvalues[Keys.user_akses] as! String)
            ]
            
            let tahunbea = (formvalues[Keys.user_tahun_beasiswa] ?? "") as! [String]
            if !tahunbea.isEmpty{
                parameters[Keys.user_tahun_beasiswa] = tahunbea.joined(separator:",")
            }
            
            if create {
                parameters[Keys.mode] = Keys.create
            }
            else {
                let usernrp = formvalues[Keys.user_nrp] as! String
                if akun.user_nrp != usernrp{
                    parameters[Keys.user_nrp_new] = usernrp
                }
                parameters[Keys.mode] = Keys.update
                parameters[Keys.own] = Keys.no
            }
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Menyimpan"
            hud.show(in: self.view)
            Alamofire.request(Keys.URL_CRUD_USER, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil" {
                        if self.create {
                            self.dismiss(animated: true, completion: nil)
                        }else {
                            let popup = PopupDialog(title: Keys.berhasil, message: "Proses berhasil", gestureDismissal: true)
                            self.present(popup, animated: true, completion: nil)
                        }
                    }
                    
                case .failure( _):
                    let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func editakunowner(){
        if form.validate().isEmpty {
            Keys.getlocation(completion: { (userlat, userlng) in
                let formvalues = self.form.values(includeHidden: true)
                var parameters = [
                    Keys.mode: Keys.update,
                    Keys.own: Keys.yes,
                    Keys.user_nrp: String(formvalues[Keys.user_nrp] as! Int),
                    Keys.user_nama: formvalues[Keys.user_nama] as! String,
                    Keys.user_email: formvalues[Keys.user_email] as! String,
                    Keys.user_password: formvalues[Keys.user_password] as! String,
                    Keys.user_jk: ((formvalues[Keys.user_jk] as! String) == "Perempuan" ? "0" : "1"),
                    Keys.user_no_hp: formvalues[Keys.user_no_hp] as! String,
                    Keys.user_alamat: formvalues[Keys.user_alamat] as! String,
                    Keys.user_tempat_lahir: formvalues[Keys.user_tempat_lahir] as! String,
                    Keys.user_goldar: formvalues[Keys.user_goldar] as! String,
                    Keys.user_bio: formvalues[Keys.user_bio] as! String,
                    Keys.user_status: formvalues[Keys.user_status] as! String,
                    Keys.user_agama: formvalues[Keys.user_agama] as! String,
                    Keys.user_suku: formvalues[Keys.user_suku] as! String,
                    Keys.kuliah_fakultas1: formvalues[Keys.kuliah_fakultas1] as! String,
                    Keys.kuliah_jurusan1: formvalues[Keys.kuliah_jurusan1] as! String,
                    Keys.kuliah_univ2: formvalues[Keys.kuliah_univ2] as! String,
                    Keys.kuliah_fakultas2: formvalues[Keys.kuliah_fakultas2] as! String,
                    Keys.kuliah_jurusan2: formvalues[Keys.kuliah_jurusan2] as! String,
                    Keys.ishide_agama: (formvalues[Keys.ishide_agama] as! Bool ? "1" : "0"),
                    Keys.ishide_no_hp: (formvalues[Keys.ishide_no_hp] as! Bool ? "1" : "0"),
                    Keys.ishide_tautan: (formvalues[Keys.ishide_tautan] as! Bool ? "1" : "0"),
                    Keys.ishide_suku: (formvalues[Keys.ishide_suku] as! Bool ? "1" : "0"),
                    Keys.user_lat: userlat,
                    Keys.user_lng: userlng
                    ]
                
                if formvalues[Keys.user_tanggal_lahir]! != nil {
                    let tgllhr = Keys.StringFromdate(date: formvalues[Keys.user_tanggal_lahir] as! Date)
                    parameters[Keys.user_tanggal_lahir] = tgllhr
                }else{
                    parameters[Keys.user_tanggal_lahir] = ""
                }
                var mk11 = String()
                var mk12 = String()
                var mk21 = String()
                var mk22 = String()
                if formvalues[Keys.kuliah_masuk_keluar1+"1"]! != nil {
                   mk11 = formvalues[Keys.kuliah_masuk_keluar1+"1"] as! String
                }
                if formvalues[Keys.kuliah_masuk_keluar1+"2"]! != nil {
                    mk12 = formvalues[Keys.kuliah_masuk_keluar1+"2"] as! String
                }
                if formvalues[Keys.kuliah_masuk_keluar2+"1"]! != nil {
                    mk21 = formvalues[Keys.kuliah_masuk_keluar2+"1"] as! String
                }
                if formvalues[Keys.kuliah_masuk_keluar2+"2"]! != nil {
                    mk22 = formvalues[Keys.kuliah_masuk_keluar2+"2"] as! String
                }
                parameters[Keys.kuliah_masuk_keluar1] = mk11 + "," + mk12
                parameters[Keys.kuliah_masuk_keluar2] = mk21 + "," + mk22
                

                let imageui = formvalues[Keys.image]! ?? nil
                var imageData : Data!
                if imageui != nil {
                    imageData = UIImagePNGRepresentation(imageui as! UIImage)
                }
                
                if self.admin {
                    let usernrp = formvalues[Keys.user_nrp] as! String
                    if self.akun.user_nrp != usernrp{
                        parameters[Keys.user_nrp_new] = usernrp
                    }
                    let tahunbea = formvalues[Keys.user_no_hp] as! [String]
                    if !tahunbea.isEmpty{
                        let tahunbea2 = tahunbea.map{String($0)}
                        parameters[Keys.user_tahun_beasiswa] = tahunbea2.joined(separator:",")
                    }
                    parameters[Keys.idwilayah] = self.wilayahdict[formvalues[Keys.idwilayah] as! String]!
                    parameters[Keys.iduniversitas] = self.univdict[formvalues[Keys.iduniversitas] as! String]!
                    parameters[Keys.user_akses] = Keys.UserAksesCode(kode: formvalues[Keys.user_akses] as! String)
                    parameters[Keys.admin] = Keys.yes
                }else{
                    parameters[Keys.admin] = Keys.no
                }
                
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = "Menyimpan"
                hud.show(in: self.view)
                Alamofire.upload( multipartFormData: { multipartFormData in
                    if imageui != nil {
                        multipartFormData.append(imageData, withName: Keys.image, fileName: "image.png" , mimeType: "image/png")
                    }
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: .utf8)!, withName: key)
                    }
                }, to: Keys.URL_CRUD_USER, encodingCompletion: { encodingResult in
                    hud.dismiss()
                    switch encodingResult {
                    case .success(let upload, _, _): upload.responseString { response in
                        if response.result.value == "berhasil" {
                            Keys.getowndata(completion: { (result) in
                                let popup = PopupDialog(title: Keys.berhasil, message: "Proses berhasil", gestureDismissal: true)
                                self.present(popup, animated: true, completion: nil)
                            })
                        }
                    }case .failure( _):
                        let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                        self.present(popup, animated: true, completion: nil)
                    }
                })
            })
        }
    }
    

    @IBAction func cancelclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapDetected() {
        var photo:SKPhoto
        if akun.user_foto.isEmpty {
            photo = SKPhoto.photoWithImage(UIImage(named: "icon")!)
        }else{
            photo = SKPhoto.photoWithImageURL(self.akun.user_foto)
            photo.shouldCachePhotoURLImage = false
        }
        var images = [SKPhoto]()
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editmember_to_editkerja"  {
            if let vc = segue.destination as? EditKerja {
                vc.create = createkerja
                if !createkerja {
                    vc.kerja = kerja
                }
            }
        }
        else if segue.identifier == "editmember_to_edittautan"  {
            if let vc = segue.destination as? EditTautan {
                vc.create = createtautan
                if !createtautan {
                    vc.tautan = tautan
                }
            }
        }
    }

}


