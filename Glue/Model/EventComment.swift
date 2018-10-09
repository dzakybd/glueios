//
//  EventComment.swift
//  Glue
//
//  Created by Macbook Pro on 08/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

class EventComment
{
    var idcomment:String = ""
    var user_nrp:String = ""
    var event_idevent:String = ""
    var comment_text:String = ""
    var comment_created:String = ""
    var user_no_kta:String = ""
    var user_akses:String = ""
    var user_nama:String = ""
    var user_thumbnail:String = ""
    
    func Populate(dictionary:NSDictionary) {
        idcomment = dictionary["idcomment"] as? String ?? ""
        user_nrp = dictionary["user_nrp"] as? String ?? ""
        event_idevent = dictionary["event_idevent"] as? String ?? ""
        comment_text = dictionary["comment_text"] as? String ?? ""
        comment_created = dictionary["comment_created"] as? String ?? ""
        user_no_kta = dictionary["user_no_kta"] as? String ?? ""
        user_akses = dictionary["user_akses"] as? String ?? ""
        user_nama = dictionary["user_nama"] as? String ?? ""
        user_thumbnail = dictionary["user_thumbnail"] as? String ?? ""
    }
}
