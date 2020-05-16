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
    var filters: [String]?
    var subfilters: [String]?
    var hasFilters: Bool {
        return filters?.count ?? 0 >= 1
    }
    var hasSubFilters: Bool {
        return subfilters?.count ?? 0 >= 1
    }
    
    func videosWith(filters: [String]) -> [Video] {
        var videos = [Video]()
        for filter in filters {
            let filterResult = self.videos.filter { $0.tags.contains(filter) }
            videos.append(contentsOf: filterResult)
        }
        return videos
    }
    
    func videosWith(filter: String) -> [Video] {
        return self.videos.filter { $0.tags.contains(filter) }
    }
    
    func videosWith(filter: String, subfilter: String) -> [Video] {
        var filteredVideos = [Video]()
        if filter == "all" {
            filteredVideos = self.videos
        } else {
            filteredVideos = self.videos.filter { $0.tags.contains(filter) }
        }
        if subfilter != "all" {
            filteredVideos = filteredVideos.filter{ $0.tags.contains(subfilter) }
        }
        return filteredVideos
    }
    
    func contains(tag: String) -> Bool {
        return subfilters?.contains(where: {$0.caseInsensitiveCompare(tag) == .orderedSame}) ?? false
    }
}
