//
//  Video.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

struct Video: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
}
