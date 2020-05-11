//
//  Thumbnail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 11.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

struct Thumbnail: Hashable, Codable, Identifiable {
    var id: String
    var url: String
}
