//
//  VideoDetailView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 22.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    
    @State var videoFile: Video
    
    var body: some View {
//        VStack {
//            VideoView(videoFile: videoFile)
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300, alignment: Alignment.topLeading)
//            Spacer()
//        }
//        .navigationBarTitle(videoFile.title)
        
        PlayerContentView(video: videoFile)
        
    }
}

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailView(videoFile: previewData.topics[0].subTopics[0].videos[0])
    }
}

struct PlayerContentView: View {
    let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
    @State var video: Video?
    var body: some View {
        AVPlayerView(video: self.$video).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
            .onDisappear(perform: {
                self.video = nil
            })
    }
}

struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var video: Video?

    private var player: AVPlayer {
        return AVPlayer()
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        if let player = playerController.player {
            if !player.isPlaying || video == nil {
                setVideo(video: video, player: playerController.player)
            }
        } else {
            playerController.player = player
            setVideo(video: video, player: playerController.player)
        }
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
    
    func setVideo(video: Video?, player: AVPlayer?) {
        guard let videoPlayer = player else {
            return
        }
        if let v = video {
            
            v.getVideoUrl(completion: { url in
                if let u = url {
                    videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: u))
                } else {
                    videoPlayer.replaceCurrentItem(with: nil)
                }
            })
            
            do {
               try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            } catch {
                   print("failed to set audio session")
            }
        } else {
            videoPlayer.replaceCurrentItem(with: nil)
        }
        
    }
}
