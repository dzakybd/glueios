//
//  Universitas.swift
//  Glue
//
//  Created by Macbook Pro on 08/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class Universitas
{
    var iduniversitas:String = ""
    var wilayah_idwilayah:String = ""
    var universitas_nama:String = ""
    var universitas_created:String = ""
    var universitas_updated:String = ""
    
    func Populate(dictionary:NSDictionary) {
        
        iduniversitas = dictionary["iduniversitas"] as! String
        wilayah_idwilayah = dictionary["wilayah_idwilayah"] as! String
        universitas_nama = dictionary["universitas_nama"] as! String
        universitas_created = dictionary["universitas_created"] as! String
        universitas_updated = dictionary["universitas_updated"] as! String
    }
    
}
