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

//class LogoView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        let imageView = UIImageView(image: UIImage(named: "Eureka"))
//        imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
//        imageView.autoresizingMask = .flexibleWidth
//        self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
//        imageView.contentMode = .scaleAspectFit
//        addSubview(imageView)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

