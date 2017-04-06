//
//  String.swift
//  SillySong
//
//  Created by Patrick Paechnatz on 06.04.17.
//  Copyright © 2017 Patrick Paechnatz. All rights reserved.
//

import Foundation

extension String {
    
    /*
     * add capitalization for given strings
     */
    func capitalizingFirstLetter() -> String {
        
        if self.isEmpty { return self }
        
        let first = String(self.characters.prefix(1)).capitalized
        let other = String(self.characters.dropFirst())
        
        return first + other
    }

}
