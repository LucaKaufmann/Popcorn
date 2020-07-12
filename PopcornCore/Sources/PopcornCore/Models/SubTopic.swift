//
//  SubTopic.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

public struct SubTopic: Hashable, Codable, Identifiable {
    public var id: Int
    public var title: String
    public var videos: [Video]
    public var filters: [String]?
    public var subfilters: [String]?
    public var hasFilters: Bool {
        return filters?.count ?? 0 >= 1
    }
    public var hasSubFilters: Bool {
        return subfilters?.count ?? 0 >= 1
    }
    
    public func videosWith(filters: [String]) -> [Video] {
        var videos = [Video]()
        for filter in filters {
            let filterResult = self.videos.filter { $0.tags.contains(filter) }
            videos.append(contentsOf: filterResult)
        }
        return videos
    }
    
    public func videosWith(filter: String) -> [Video] {
        return self.videos.filter { $0.tags.contains(filter) }
    }
    
    public func videosWith(filter: String, subfilter: String) -> [Video] {
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
    
    public func contains(tag: String) -> Bool {
        return subfilters?.contains(where: {$0.caseInsensitiveCompare(tag) == .orderedSame}) ?? false
    }
}
