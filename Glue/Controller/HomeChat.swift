//
//  HomeChat.swift
//  Glue
//
//  Created by Macbook Pro on 30/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import DefaultsKit

class HomeChat: UIViewController, SideMenuItemContent {
//    var ref: DatabaseReference!
//    var akun = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ref = Database.database().reference()
//        akun = defaults.get(for: Key<User>(Keys.saved_user))!
//        getlistchat()
    }
    
    func getlistchat(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openMenu(_ sender: Any) {
        showSideMenu()
    }
}
