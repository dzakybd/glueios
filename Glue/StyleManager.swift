//
//  StyleManager.swift
//  Glue
//
//  Created by Macbook Pro on 05/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import Foundation
import ChameleonFramework

typealias Style = StyleManager

//MARK: - StyleManager
final class StyleManager {
    
    static let gradcolors:[UIColor] = [
        UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0),
        UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    ]
    
    // MARK: - StyleManager
    
    static func setUpTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryTheme(), withSecondaryColor: nil, andContentStyle: content())
    }
    
    // MARK: - Theme
    
    
    static func primaryTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func theme() -> UIColor {
        return FlatYellow()
    }
    
    static func toolBarTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func tintTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func titleTextTheme() -> UIColor {
        return FlatWhite()
    }
    
    static func titleTheme() -> UIColor {
        return FlatWhite()
    }
    
    static func textTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func backgroudTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func positiveTheme() -> UIColor {
        return gradcolors[0]
    }
    
    static func negativeTheme() -> UIColor {
        return gradcolors[1]
    }
    
    static func clearTheme() -> UIColor {
        return UIColor.clear
    }
    
    // MARK: - Content
    
    static func content() -> UIContentStyle {
        return UIContentStyle.light
    }
    
}


