//
//  PlayerTimeObserver.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 27.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Combine
import AVKit

class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false
    
    init(player: AVPlayer) {
        self.player = player
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we've not been told to pause our updates
            guard !self.paused else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
}


class PlayerItemObserver {
    let publisher = PassthroughSubject<Bool, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
            guard let self = self else { return }
            // Publish whether the player has an item or not
            self.publisher.send(player.currentItem != nil)
        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?
    
    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath).sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(duration.seconds)
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
