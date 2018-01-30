//
//  Config.swift
//  Glue
//
//  Created by Macbook Pro on 28/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation

let LOGIN_URL = "http://128.199.190.115/genbi/login/in";
let MEMBER_URL = "http://128.199.190.115/genbi/login/member/";
let NEWS_URL = "http://128.199.190.115/genbi/login/news_detail";
let REGIS_URL = "http://128.199.190.115/genbi/login/regis";
let DRAWER_URL = "http://128.199.190.115/genbi/login/drawer";
let INPUT_URL = "http://128.199.190.115/genbi/login/inputs";
let SHOW_URL = "http://128.199.190.115/genbi/login/show";
let EDIT_URL = "http://128.199.190.115/genbi/login/edit";
//Keys for email and password as defined in our $_POST['key'] in login.php
let KEY_USERNAME = "username";
let KEY_PASSWORD = "password";
let KEY_USRID = "usr_id";
let KEY_ID = "id_pengguna";
let KEY_NAMA_PENGGUNA = "nama_pengguna";
let KEY_NAME = "usr_nama";
let KEY_UNIV = "usr_univ";
let KEY_GROSS = "GrossTonnage";
let KEY_REG = "RegisteredOwner";
let KEY_CLASS = "ClassificationSociety";
let KEY_FLAG = "Flag";
let KEY_SHIP = "ShippingRoute";
let KEY_L = "Length";
let KEY_B = "Breadth";
let KEY_H = "High";
let KEY_NAMES = "NameOfSurveyor";

let KEY_ADDRESS = "address";
let KEY_VC = "vc";
let JSON_ARRAY = "result";
//If server response is equal to this that means login is successful
let LOGIN_SUCCESS = "success";

//Keys for Sharedpreferences
//This would be the name of our shared preferences
let SHARED_PREF_NAME = "myloginapp";

//This would be used to store the email of current logged in user
let EMAIL_SHARED_PREF = "email";

//We will use this to store the boolean in sharedpreference to track user is loggedin or not
let LOGGEDIN_SHARED_PREF = "loggedin";

