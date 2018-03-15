//
//  user.swift
//  Glue
//
//  Created by Macbook Pro on 07/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class User: Codable{
    var user_nrp:String = ""
    var user_no_kta:String = ""
    var user_akses:String = ""
    var user_nama:String = ""
    var user_email:String = ""
    var user_password:String = ""
    var user_lat:String = ""
    var user_lng:String = ""
    var user_foto:String = ""
    var user_thumbnail:String = ""
    var user_no_hp:String = ""
    var user_alamat:String = ""
    var user_tempat_lahir:String = ""
    var user_tanggal_lahir:String = ""
    var user_bio:String = ""
    var user_status:String = ""
    var user_jk:String = ""
    var user_agama:String = ""
    var user_goldar:String = ""
    var user_suku:String = ""
    var user_tahun_beasiswa:String = ""
    var kuliah_fakultas1:String = ""
    var kuliah_jurusan1:String = ""
    var kuliah_masuk_keluar1:String = ""
    var kuliah_univ2:String = ""
    var kuliah_fakultas2:String = ""
    var kuliah_jurusan2:String = ""
    var kuliah_masuk_keluar2:String = ""
    var ishide_no_hp:String = ""
    var ishide_agama:String = ""
    var ishide_suku:String = ""
    var ishide_tautan:String = ""
    var iduniversitas:String = ""
    var universitas_nama:String = ""
    var idwilayah:String = ""
    var wilayah_nama:String = ""
    var user_kerjas:[UserKerja] = []
    var user_tautans:[UserTautan] = []
    
    func Populate(dictionary:NSDictionary) {
        
        user_nrp = dictionary["user_nrp"] as! String
        user_no_kta = dictionary["user_no_kta"] as! String
        user_akses = dictionary["user_akses"] as! String
        user_nama = dictionary["user_nama"] as! String
        user_email = dictionary["user_email"] as! String
        user_password = dictionary["user_password"] as! String
        user_lat = dictionary["user_lat"] as! String
        user_lng = dictionary["user_lng"] as! String
        user_foto = dictionary["user_foto"] as! String
        user_thumbnail = dictionary["user_thumbnail"] as! String
        user_no_hp = dictionary["user_no_hp"] as! String
        user_alamat = dictionary["user_alamat"] as! String
        user_tempat_lahir = dictionary["user_tempat_lahir"] as! String
        user_tanggal_lahir = dictionary["user_tanggal_lahir"] as! String
        user_bio = dictionary["user_bio"] as! String
        user_status = dictionary["user_status"] as! String
        user_jk = dictionary["user_jk"] as! String
        user_agama = dictionary["user_agama"] as! String
        user_goldar = dictionary["user_goldar"] as! String
        user_suku = dictionary["user_suku"] as! String
        user_tahun_beasiswa = dictionary["user_tahun_beasiswa"] as! String
        kuliah_fakultas1 = dictionary["kuliah_fakultas1"] as! String
        kuliah_jurusan1 = dictionary["kuliah_jurusan1"] as! String
        kuliah_masuk_keluar1 = dictionary["kuliah_masuk_keluar1"] as! String
        kuliah_univ2 = dictionary["kuliah_univ2"] as! String
        kuliah_fakultas2 = dictionary["kuliah_fakultas2"] as! String
        kuliah_jurusan2 = dictionary["kuliah_jurusan2"] as! String
        kuliah_masuk_keluar2 = dictionary["kuliah_masuk_keluar2"] as! String
        ishide_no_hp = dictionary["ishide_no_hp"] as! String
        ishide_agama = dictionary["ishide_agama"] as! String
        ishide_suku = dictionary["ishide_suku"] as! String
        ishide_tautan = dictionary["ishide_tautan"] as! String
        iduniversitas = dictionary["iduniversitas"] as! String
        universitas_nama = dictionary["universitas_nama"] as! String
        idwilayah = dictionary["idwilayah"] as! String
        wilayah_nama = dictionary["wilayah_nama"] as! String
        user_kerjas = UserKerja.PopulateArray(array: dictionary["user_kerja"] as! [NSArray] as NSArray)
        user_tautans = UserTautan.PopulateArray(array: dictionary["user_tautan"] as! [NSArray] as NSArray)
    }
    
}
