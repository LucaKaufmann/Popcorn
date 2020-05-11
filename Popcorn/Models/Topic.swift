//
//  Topic.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation
import SwiftUI


struct Topic: Hashable, Codable, Identifiable {
    var title: String
    var id: Int
    var subTopics: [SubTopic]
    var thumbnails: [Thumbnail]
    
    func getThumbnailUrlFor(tag: String) -> String {
        if let thumbnail = thumbnails.filter { $0.id.contains(tag) }.first {
            return thumbnail.url
        }
        return ""
    }
}
