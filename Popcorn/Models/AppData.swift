//
//  AppData.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 4.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

struct AppData: Hashable, Codable {
    var title: String
    var mainColor: String
    var accentColor: String
    var backgroundColor: String
    var url: String
    var topics: [Topic]
}
