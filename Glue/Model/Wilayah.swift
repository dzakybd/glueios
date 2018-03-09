//
//  Wilayah.swift
//  Glue
//
//  Created by Macbook Pro on 08/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class Wilayah
{
    var idwilayah:String = ""
    var wilayah_nama:String = ""
    var wilayah_created:String = ""
    var wilayah_updated:String = ""
    
    func Populate(dictionary:NSDictionary) {
        
        idwilayah = dictionary["idwilayah"] as! String
        wilayah_nama = dictionary["wilayah_nama"] as! String
        wilayah_created = dictionary["wilayah_created"] as! String
        wilayah_updated = dictionary["wilayah_updated"] as! String
    }
}
