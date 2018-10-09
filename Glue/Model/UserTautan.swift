//
//  UserTautan.swift
//  Glue
//
//  Created by Macbook Pro on 07/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class UserTautan: Codable
{
    var idtautan:String = ""
    var user_nrp:String = ""
    var tautan_judul:String = ""
    var tautan_text:String = ""
    
    func Populate(dictionary:NSDictionary) {
        idtautan = dictionary["idtautan"] as? String ?? ""
        user_nrp = dictionary["user_nrp"] as? String ?? ""
        tautan_judul = dictionary["tautan_judul"] as? String ?? ""
        tautan_text = dictionary["tautan_text"] as? String ?? ""
    }
    
    class func PopulateArray(array:NSArray) -> [UserTautan]{
        var result:[UserTautan] = []
        for item in array
        {
            let newItem = UserTautan()
            newItem.Populate(dictionary: item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}
