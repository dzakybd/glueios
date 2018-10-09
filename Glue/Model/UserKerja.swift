//
//  UserKerja.swift
//  Glue
//
//  Created by Macbook Pro on 07/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class UserKerja: Codable
{
    var idkerja:String = ""
    var user_nrp:String = ""
    var kerja_jabatan:String = ""
    var kerja_perusahaan:String = ""
    var kerja_lokasi:String = ""
    var kerja_masuk_keluar:String = ""
    
    func Populate(dictionary:NSDictionary) {
        idkerja = dictionary["idkerja"] as? String ?? ""
        user_nrp = dictionary["user_nrp"] as? String ?? ""
        kerja_jabatan = dictionary["kerja_jabatan"] as? String ?? ""
        kerja_perusahaan = dictionary["kerja_perusahaan"] as? String ?? ""
        kerja_lokasi = dictionary["kerja_lokasi"] as? String ?? ""
        kerja_masuk_keluar = dictionary["kerja_masuk_keluar"] as? String ?? ""
    }

    class func PopulateArray(array:NSArray) -> [UserKerja]
    {
        var result:[UserKerja] = []
        for item in array
        {
            let newItem = UserKerja()
            newItem.Populate(dictionary: item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}
