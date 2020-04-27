//
//  AVPlayer+isPlaying.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 27.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
