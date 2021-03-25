//
//  Media.swift
//  easypeasy
//
//  Created by Ahmad on 06/10/2020.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "kyleleeheadiconimage234567.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.35) else { return nil }
        self.data = data
    }
    
    init?(withVideo videoUrl: URL, forKey key: String) {
        self.key = key
        self.mimeType = "video/mp4"
        self.filename = "video.mp4"
        
        guard let data = try? Data(contentsOf: videoUrl) else {return nil}
        self.data = data
    }
    
    init?(withVideoData videoData: Data, forKey key: String) {
           self.key = key
           self.mimeType = "video/mp4"
           self.filename = "video.mp4"
           
           //guard let data = try? Data(contentsOf: videoUrl) else {return nil}
           self.data = videoData
       }
    
    init?(withGif gifData: Data, forKey key: String) {
           self.key = key
           self.mimeType = "image/gif"
           self.filename = "animated.gif"
           
           self.data = gifData
       }
    
}
