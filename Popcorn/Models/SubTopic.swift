//
//  SubTopic.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

struct SubTopic: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var videos: [Video]
    var filters: [String]
    var hasFilter1: Bool {
        return filters.count >= 1
    }
    var hasFilter2: Bool {
        return filters.count >= 2
    }
    
    func videosWith(filters: [String]) -> [Video] {
        var videos = [Video]()
        for filter in filters {
            let filterResult = self.videos.filter { $0.tags.contains(filter) }
            videos.append(contentsOf: filterResult)
        }
        return videos
    }
}
