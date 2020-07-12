//
//  Video+getYoutubeUrl.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 12.7.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation
import PopcornCore

extension Video {
    func getVideoUrl(completion: @escaping (URL?) -> ()) {
        if url.contains("youtube") {
            let y = YoutubeDirectLinkExtractor()
            y.extractInfo(for: .urlString(url), success: { info in
                    let youtubeUrl = URL(string: info.highestQualityPlayableLink ?? "")!
                    completion(youtubeUrl)
                }, failure: { error in
                    print(error)
                })
        } else if url.contains("youtu") {
            let s = url.replacingOccurrences(of: "https://youtu.be/", with: "https://www.youtube.com/watch?v=")
            let y = YoutubeDirectLinkExtractor()
            y.extractInfo(for: .urlString(s), success: { info in
                let youtubeUrl = URL(string: info.highestQualityPlayableLink ?? "")!
                completion(youtubeUrl)
            }, failure: { error in
                print(error)
            })
        } else if url.contains("local:") {
            let videoName = url.replacingOccurrences(of: "local:", with: "")
            print("Getting url for video name: \(videoName)")
            let videoUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
            completion(videoUrl)
        } else {
            let videoUrl = URL(string: url)!
            completion(videoUrl)
        }
        
    }
}

