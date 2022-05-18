//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation

// 专门的一个文件, 存储背景相关的概念.
extension EmojiArtModel {
    
    enum Background: Equatable, Codable {
        // 一个更好的设计, 比 optinal 更好. 明确的标明, 这是空的状态.
        case blank
        case url(URL)
        case imageData(Data)
        
        enum CodingKeys: String, CodingKey {
            case url = "theURL"
            case imageData
        }
        
        // 这是一个 Enum. 这里是选择使用, 特定的 Key, 对应特定的 case 的方式, 来进行的初始化.
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let url = try? container.decode(URL.self, forKey: .url) {
                self = .url(url)
            } else if let imageData = try? container.decode(Data.self, forKey: .imageData) {
                self = .imageData(imageData)
            } else {
                self = .blank
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .url(let url): try container.encode(url, forKey: .url)
            case .imageData(let data): try container.encode(data, forKey: .imageData)
            case .blank: break
            }
        }
        
        // 使用 Enum, 要定义特定的方法, 来方便 Enum 的相关值的提取.
        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }
        
        // 使用 Enum, 要定义特定的方法, 来方便 Enum 的相关值的提取.
        var imageData: Data? {
            switch self {
            case .imageData(let data): return data
            default: return nil
            }
        }
    }
}
