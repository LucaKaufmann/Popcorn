//
//  AppData.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 4.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

public struct AppData: Hashable, Codable {
    public var title: String
    public var mainColor: String
    public var accentColor: String
    public var backgroundColor: String
    public var font: String
    public var url: String
    public var aboutUrl: String
    public var topics: [Topic]
}
