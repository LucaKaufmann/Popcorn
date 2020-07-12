//
//  Video.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

public struct Video: Hashable, Codable, Identifiable {
    public var id: Int
    public var title: String
    public var url: String
    public var tags: [String]
    public var author: String
}
