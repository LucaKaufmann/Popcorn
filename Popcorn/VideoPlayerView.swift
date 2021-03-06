//
//  VideoPlayerView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 22.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import AVFoundation
import PopcornCore

// This is the UIView that contains the AVPlayerLayer for rendering the video
class VideoPlayerUIView: UIView {
    private let player: AVPlayer
    private let playerLayer = AVPlayerLayer()
    private let videoPos: Binding<Double>
    private let videoDuration: Binding<Double>
    private let seeking: Binding<Bool>
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?
  
    init(player: AVPlayer, videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>) {
        self.player = player
        self.videoDuration = videoDuration
        self.videoPos = videoPos
        self.seeking = seeking
        
        super.init(frame: .zero)
    
        backgroundColor = .lightGray
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
                print("failed to set audio session")
        }
        
        // Observe the duration of the player's item so we can display it
        // and use it for updating the seek bar's position
        durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            self.videoDuration.wrappedValue = item.duration.seconds
        })
        
        // Observe the player's time periodically so we can update the seek bar's
        // position as we progress through playback
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we're not seeking currently (don't want to override the slider
            // position if the user is interacting)
            guard !self.seeking.wrappedValue else {
                return
            }
        
            // update videoPos with the new video time (as a percentage)
            self.videoPos.wrappedValue = time.seconds / self.videoDuration.wrappedValue
        }
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
    
        playerLayer.frame = bounds
    }
    
    func cleanUp() {
        // Remove observers we setup in init
        durationObservation?.invalidate()
        durationObservation = nil
        
        if let observation = timeObservation {
            player.removeTimeObserver(observation)
            timeObservation = nil
        }
    }
  
}

// This is the SwiftUI view which wraps the UIKit-based PlayerUIView above
struct VideoPlayerView: UIViewRepresentable {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayerView>) {
        // This function gets called if the bindings change, which could be useful if
        // you need to respond to external changes, but we don't in this example
    }
    
    func makeUIView(context: UIViewRepresentableContext<VideoPlayerView>) -> UIView {
        let uiView = VideoPlayerUIView(player: player,
                                       videoPos: $videoPos,
                                       videoDuration: $videoDuration,
                                       seeking: $seeking)
        return uiView
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        guard let playerUIView = uiView as? VideoPlayerUIView else {
            return
        }
        
        playerUIView.cleanUp()
    }
}

// This is the SwiftUI view that contains the controls for the player
struct VideoPlayerControlsView : View {
    private enum PlaybackState: Int {
        case waitingForSelection
        case buffering
        case playing
    }
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    let itemObserver: PlayerItemObserver
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection
    
    @State private var playerPaused = true
    
    var body: some View {
        HStack {
            // Play/pause button
            Button(action: togglePlayPause) {
                Image(systemName: playerPaused ? "play" : "pause")
                    .padding(.trailing, 10)
            }
            // Current video time
//            Text("\(Utility.formatSecondsToHMS(currentTime))")
            // Slider for seeking / showing video progress
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(Utility.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("\(Utility.formatSecondsToHMS(currentDuration))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(state != .playing)
            // Video duration
//            Text("\(Utility.formatSecondsToHMS(currentDuration))")
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            self.currentTime = time
            if time > 0 {
                 self.state = .playing
             }
        }
        // Listen out for the duration observer publishing changes to the player's item duration
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            self.currentDuration = duration
        }
        // Listen out for the item observer publishing a change to whether the player has an item
        .onReceive(itemObserver.publisher) { hasItem in
            self.state = hasItem ? .buffering : .waitingForSelection
            self.currentTime = 0
            self.currentDuration = 0
        }
    }
    
    private func togglePlayPause() {
        pausePlayer(!playerPaused)
    }
    
    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Set a flag stating that we're seeking so the slider doesn't
            // get updated by the periodic time observer on the player
//            seeking = true
            pausePlayer(true)
        }
        
        // Do the seek if we're finished
        if !editingStarted {
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the seek is finished, resume normal operation
//                self.seeking = false
                self.pausePlayer(false)
            }
        }
    }
}

// This is the SwiftUI view which contains the player and its controls
struct VideoPlayerContainerView : View {
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    
    @State private var videoUrl: String = ""
    
    
    private let player: AVPlayer
  
    init(video: Video) {
        print("URL: \(video.url)")
        player = AVPlayer()
        videoUrl = video.url
        
//        video.getVideoUrl(completion: { url in
//            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
//        })
    }
  
    var body: some View {
        VStack {
            VideoPlayerView(videoPos: $videoPos,
                            videoDuration: $videoDuration,
                            seeking: $seeking,
                            player: player)
            VideoPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player))
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
    
    func setVideo(video: Video) {
        if video.url.contains("youtube") {
            let y = YoutubeDirectLinkExtractor()
            y.extractInfo(for: .urlString(video.url), success: { info in
                    let youtubeUrl = URL(string: info.highestQualityPlayableLink ?? "")!
                    self.player.replaceCurrentItem(with: AVPlayerItem(url: youtubeUrl))
                }, failure: { error in
                    print(error)
                })
        } else if video.url.contains("youtu") {
            let s = video.url.replacingOccurrences(of: "https://youtu.be/", with: "https://www.youtube.com/watch?v=")
            let y = YoutubeDirectLinkExtractor()
            y.extractInfo(for: .urlString(s), success: { info in
                    let youtubeUrl = URL(string: info.highestQualityPlayableLink ?? "")!
                    self.player.replaceCurrentItem(with: AVPlayerItem(url: youtubeUrl))
                }, failure: { error in
                    print(error)
                })
        } else if video.url.contains("local:") {
            let videoName = video.url.replacingOccurrences(of: "local:", with: "")
            print("Getting url for video name: \(videoName)")
            let videoUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
            player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
        } else {
            let videoUrl = URL(string: video.url)!
            player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
        }
        
    }
}

// This is the main SwiftUI view for this app, containing a single PlayerContainerView
struct VideoView: View {
    var videoFile: Video
    var body: some View {
//        VideoPlayerContainerView(url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)
        
        VideoPlayerContainerView(video: videoFile)
    }
}

