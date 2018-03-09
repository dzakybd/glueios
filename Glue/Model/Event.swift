//
//  Event.swift
//  Glue
//
//  Created by Macbook Pro on 08/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class Event
{
    var idevent:String = ""
    var user_nrp:String = ""
    var event_judul:String = ""
    var event_deskripsi:String = ""
    var event_tanggal:String = ""
    var event_waktu:String = ""
    var event_lokasi:String = ""
    var event_foto:String = ""
    var event_thumbnail:String = ""
    var event_published:String = ""
    var event_internal:String = ""
    var event_created:String = ""
    var event_updated:String = ""
    var user_no_kta:String = ""
    var user_akses:String = ""
    var user_nama:String = ""
    var user_thumbnail:String = ""
    var iduniversitas:String = ""
    var universitas_nama:String = ""
    var idwilayah:String = ""
    var wilayah_nama:String = ""
    var user_tahun_beasiswa:String = ""
    var isulike:String = ""
    var likes:String = ""
    
    func Populate(dictionary:NSDictionary) {
        
        idevent = dictionary["idevent"] as! String
        user_nrp = dictionary["user_nrp"] as! String
        event_judul = dictionary["event_judul"] as! String
        event_deskripsi = dictionary["event_deskripsi"] as! String
        event_tanggal = dictionary["event_tanggal"] as! String
        event_waktu = dictionary["event_waktu"] as! String
        event_lokasi = dictionary["event_lokasi"] as! String
        event_foto = dictionary["event_foto"] as! String
        event_thumbnail = dictionary["event_thumbnail"] as! String
        event_published = dictionary["event_published"] as! String
        event_internal = dictionary["event_internal"] as! String
        event_created = dictionary["event_created"] as! String
        event_updated = dictionary["event_updated"] as! String
        user_no_kta = dictionary["user_no_kta"] as! String
        user_akses = dictionary["user_akses"] as! String
        user_nama = dictionary["user_nama"] as! String
        user_thumbnail = dictionary["user_thumbnail"] as! String
        iduniversitas = dictionary["iduniversitas"] as! String
        universitas_nama = dictionary["universitas_nama"] as! String
        idwilayah = dictionary["idwilayah"] as! String
        wilayah_nama = dictionary["wilayah_nama"] as! String
        user_tahun_beasiswa = dictionary["user_tahun_beasiswa"] as! String
        isulike = dictionary["isulike"] as! String
        likes = dictionary["likes"] as! String
    }

    
}
