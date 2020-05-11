//
//  Data.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

var previewData: AppData = load("data.json")

func load<T: Decodable>(_ filename: String) -> T {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsURL.appendingPathComponent(filename)
    if fileManager.fileExists(atPath: fileURL.path) {
        return decodeFile(filename: filename, url: fileURL)
    } else {
        return loadDefault(filename, url: fileURL)
    }
}

func decodeFile<T: Decodable>(filename: String, url: URL) -> T {
    let data: Data
    print("Decoding file \(url.absoluteString)")
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Couldn't load file from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Couldn't parse file as \(T.self):\n\(error)")
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: url)
        return loadDefault(filename, url: url)
    }
}

func loadDefault<T: Decodable>(_ filename: String, url: URL) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load file from main bundle:\n\(error)")
    }
    
    do {
        try data.write(to: url, options: .atomic)
        print("Saved file to \(url.absoluteString)")
    } catch {
        print("Error writing file \(error)")
    }
    
    return decodeFile(filename: filename, url: file)
}

//func downloadFile(url: String) {
//    let url = URL(string: url)!
//
//    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
//        if let localURL = localURL {
//            if let string = try? String(contentsOf: localURL) {
//                print(localURL)
//            }
//        }
//    }
//
//    task.resume()
//}\

func downloadFile(url: String, completion: ((Bool) -> ())? = nil) {
    let url:URL = URL(string: url)!
    let session = URLSession.shared

    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData


    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (
        data, response, error) in

        guard let _:Data = data, let _:URLResponse = response  , error == nil else {
            if let c = completion {
                c(false)
            }
            return
        }
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("data.json")
        do {
            if let c = completion {
                c(false)
            }
            try data?.write(to: fileURL, options: .atomic)
        } catch {
            if let c = completion {
                c(false)
            }
        }
    })
    task.resume()
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

