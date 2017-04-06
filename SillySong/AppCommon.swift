//
//  AppCommon.swift
//  SillySong
//
//  Created by Patrick Paechnatz on 06.04.17.
//  Copyright © 2017 Patrick Paechnatz. All rights reserved.
//

import UIKit
import Foundation

class AppCommon {
    
    //
    // MARK: Constants (Statics)
    //
    
    static let sharedInstance = AppCommon()
    
    //
    // MARK: Public Methods
    //
    
    func isFontNameAvailable(fontName: String) -> Bool {
        
        for name in UIFont.familyNames {
            
            for fontFamilyName in UIFont.fontNames(forFamilyName: name) {
                if fontFamilyName == fontName {
                    return true
                }
            }
        }
        
        return false
    }
}
