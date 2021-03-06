//
//  Config.swift
//  Glue
//
//  Created by Macbook Pro on 28/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation
import ChameleonFramework
import INTULocationManager
import Alamofire
import DefaultsKit

public class Keys {
    static let URL_BASE = "http://128.199.190.115/glue/ios/"
    static let URL_CRD_COMMENT = URL_BASE+"crd_comment.php"
    static let URL_CRUD_EVENT = URL_BASE+"crud_event.php"
    static let URL_CRUD_KERJA = URL_BASE+"crud_kerja.php"
    static let URL_CRUD_TAUTAN = URL_BASE+"crud_tautan.php"
    static let URL_CRUD_UNIVERSITAS = URL_BASE+"crud_universitas.php"
    static let URL_CRUD_USER = URL_BASE+"crud_user.php"
    static let URL_CRUD_WILAYAH = URL_BASE+"crud_wilayah.php"
    static let URL_GET_NEARME = URL_BASE+"get_nearme.php"
    static let URL_LIKE_DISLIKE = URL_BASE+"like_dislike.php"
    static let URL_LOGIN = URL_BASE+"login.php"
    static let URL_RESET_PASS = URL_BASE+"resetpass.php"
    static let URL_SIGNUP = URL_BASE+"signup.php"
    static let URL_KODE_PASS = "http://irelandhealthawareness.xyz/glue/mail.php"
    
    static let idevent = "idevent"
    static let event_judul = "event_judul"
    static let event_deskripsi = "event_deskripsi"
    static let event_tanggal = "event_tanggal"
    static let event_waktu = "event_waktu"
    static let event_lokasi = "event_lokasi"
    static let event_foto = "event_foto"
    static let event_thumbnail = "event_thumbnail"
    static let event_published = "event_published"
    static let event_internal = "event_internal"
    
    static let idcomment = "idcomment"
    static let event_idevent = "event_idevent"
    static let comment_text = "comment_text"
    
    static let iduniversitas = "iduniversitas"
    static let wilayah_idwilayah = "wilayah_idwilayah"
    static let universitas_nama = "universitas_nama"
    
    static let idwilayah = "idwilayah"
    static let wilayah_nama = "wilayah_nama"
    
    static let idkerja = "idkerja"
    static let kerja_jabatan = "kerja_jabatan"
    static let kerja_perusahaan = "kerja_perusahaan"
    static let kerja_lokasi = "kerja_lokasi"
    static let kerja_masuk_keluar = "kerja_masuk_keluar"
    
    static let idtautan = "idtautan"
    static let tautan_judul = "tautan_judul"
    static let tautan_text = "tautan_text"
    
    static let user_nrp = "user_nrp"
    static let user_no_kta = "user_no_kta"
    static let user_akses = "user_akses"
    static let user_nama = "user_nama"
    static let user_email = "user_email"
    static let user_password = "user_password"
    static let user_lat = "user_lat"
    static let user_lng = "user_lng"
    static let user_foto = "user_foto"
    static let user_thumbnail = "user_thumbnail"
    static let user_no_hp = "user_no_hp"
    static let user_alamat = "user_alamat"
    static let user_tempat_lahir = "user_tempat_lahir"
    static let user_tanggal_lahir = "user_tanggal_lahir"
    static let user_bio = "user_bio"
    static let user_status = "user_status"
    static let user_jk = "user_jk"
    static let user_agama = "user_agama"
    static let user_goldar = "user_goldar"
    static let user_suku = "user_suku"
    static let user_tahun_beasiswa = "user_tahun_beasiswa"
    static let kuliah_fakultas1 = "kuliah_fakultas1"
    static let kuliah_jurusan1 = "kuliah_jurusan1"
    static let kuliah_masuk_keluar1 = "kuliah_masuk_keluar1"
    static let kuliah_univ2 = "kuliah_univ2"
    static let kuliah_fakultas2 = "kuliah_fakultas2"
    static let kuliah_jurusan2 = "kuliah_jurusan2"
    static let kuliah_masuk_keluar2 = "kuliah_masuk_keluar2"
    static let ishide_no_hp = "ishide_no_hp"
    static let ishide_agama = "ishide_agama"
    static let ishide_suku = "ishide_suku"
    static let ishide_tautan = "ishide_tautan"
    
    static let mode = "mode"
    static let create = "create"
    static let read = "read"
    static let update = "update"
    static let delete = "delete"
    static let own = "own"
    static let order = "order"
    static let yes = "1"
    static let no = "0"
    static let berhasil = "berhasil"
    static let gagal = "gagal"
    static let image = "image"
    static let iduniversitas_new = "iduniversitas_new"
    static let wilayah_idwilayah_new = "wilayah_idwilayah_new"
    static let user_nrp_new = "user_nrp_new"
    static let idwilayah_new = "idwilayah_new"
    static let error_exist = "error_exist"
    static let error_nrp = "error_nrp"
    static let saved_user = "saved_user"
    static let idlocale = "id_ID"
    static let error = "Error"
    static let success = "Success"
    static let admin = "admin"
    static let kode_reset = "kode_reset"
    static let warning = "Warning"
    static let tidak = "Tidak"
    static let ya = "Ya"
    
    
    static func TimeFromString(dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.date(from: dateString)!
    }
    
    static func StringFromTime(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    static func DateFromString(dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }
    
    static func StringFromdate(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func UserAksesName(kode:String) -> String{
        var result = String()
        switch kode {
        case "0":
            result = "Admin"
        case "1":
            result = "Pembina"
        case "2":
            result = "Pengurus"
        case "3":
            result = "Anggota"
        default:
            result = ""
        }
        return result
    }
    
    static func UserAksesCode(kode:String) -> String{
        var result = String()
        switch kode {
        case "Admin":
            result = "0"
        case "Pembina":
            result = "1"
        case "Pengurus":
            result = "2"
        case "Anggota":
            result = "3"
        default:
            result = ""
        }
        return result
    }
    
    static let gradcolors:[UIColor] = [
        UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0),
        UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    ]
    
    static func getlocation(completion: @escaping (String, String) -> ()) {
        var userlat = String()
        var userlng = String()
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                            if (status == INTULocationStatus.success) {
                                                userlat = "\(currentLocation?.coordinate.latitude ?? 0)"
                                                userlng = "\(currentLocation?.coordinate.longitude ?? 0)"
                                            }
                                            else if (status == INTULocationStatus.timedOut) {
                                        
                                            }
                                            completion(userlat, userlng)
        }
    }
    
    
    static func getwilayah(completion: @escaping ([String: String],[String]) -> ()) {
        let parameters = [
            Keys.mode: Keys.read
        ]
        Alamofire.request(Keys.URL_CRUD_WILAYAH, method:.post, parameters:parameters).responseJSON { response in
            var dict = [String: String]()
            var text = [String]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = element as! NSDictionary
                    dict[data[Keys.wilayah_nama] as! String] = (data[Keys.idwilayah] as! String)
                    text.append(data[Keys.wilayah_nama] as! String)
                }
                
            case .failure( _):
               print("Error")
            }
            completion(dict, text)
        }
    }
    
    
    static func getuniversitas(wilayah_idwilayah: String,completion: @escaping ([String: String],[String]) -> ()) {
        let parameters = [
            Keys.mode: Keys.read,
            Keys.wilayah_idwilayah: wilayah_idwilayah
        ]
        Alamofire.request(Keys.URL_CRUD_UNIVERSITAS, method:.post, parameters:parameters).responseJSON { response in
            var dict = [String: String]()
            var text = [String]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = element as! NSDictionary
                    dict[data[Keys.universitas_nama] as! String] = (data[Keys.iduniversitas] as! String)
                    text.append(data[Keys.universitas_nama] as! String)
                }
            case .failure( _):
                print("Error")
            }
            completion(dict, text)
        }
    }
    
    static func getowndata(completion: @escaping (Bool) -> ()) {
        let defaults = Defaults()
        let key = Key<User>(Keys.saved_user)
        let temp = defaults.get(for: key)!
        let parameters = [
            Keys.user_email: temp.user_email,
            Keys.user_password: temp.user_password,
            Keys.own: Keys.yes
        ]
        Alamofire.request(Keys.URL_LOGIN, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
                let JSON = response.result.value as! NSDictionary
                let akun = User()
                akun.Populate(dictionary: JSON)
                defaults.clear(key)
                defaults.set(akun, for: key)
                completion(true)
            case .failure( _):
                print(Keys.error)
                completion(false)
            }
        }
    }

}

