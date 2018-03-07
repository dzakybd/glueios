//
//  UserTautan.swift
//  Glue
//
//  Created by Macbook Pro on 07/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class UserTautan
{
    var idtautan:String = ""
    var user_nrp:String = ""
    var tautan_judul:String = ""
    var tautan_text:String = ""
    var tautan_created:String = ""
    var tautan_updated:String = ""
    
    func Populate(dictionary:NSDictionary) {
        
        idtautan = dictionary["idtautan"] as! String
        user_nrp = dictionary["user_nrp"] as! String
        tautan_judul = dictionary["tautan_judul"] as! String
        tautan_text = dictionary["tautan_text"] as! String
        tautan_created = dictionary["tautan_created"] as! String
        tautan_updated = dictionary["tautan_updated"] as! String
    }
    class func PopulateArray(array:NSArray) -> [UserTautan]
    {
        var result:[UserTautan] = []
        for item in array
        {
            var newItem = UserTautan()
            newItem.Populate(dictionary: item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}
