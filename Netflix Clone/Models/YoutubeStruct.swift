//
//  YoutubeStruct.swift
//  Netflix Clone
//
//  Created by Yash Patil on 03/08/23.
//

import Foundation

struct YoutubeSearchResults: Codable {
    let items : [VideoElement]
}

struct VideoElement: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String?
}
