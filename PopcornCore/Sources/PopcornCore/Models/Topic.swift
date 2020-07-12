//
//  Topic.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation
import SwiftUI


public struct Topic: Hashable, Codable, Identifiable {
    public var title: String
    public var id: Int
    public var subTopics: [SubTopic]
    public var thumbnails: [Thumbnail]
    public var topicThumbnailUrl: String
    
    public func getThumbnailUrlFor(tag: String) -> String {
        if let thumbnail = thumbnails.filter({ $0.id.contains(tag) }).first {
            return thumbnail.url
        }
        return ""
    }
}
