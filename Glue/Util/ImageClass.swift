//
//  ImageClass.swift
//  Glue
//
//  Created by Macbook Pro on 13/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Foundation

class MemberImage : UIView{
    @IBOutlet weak var memberimage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class NewsImage : UIView{
    
    @IBOutlet weak var newsimage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



