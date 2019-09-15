//
//  Track.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/14/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import Foundation

struct Track: Codable {
    
    // MARK: - Properties
    
    var id: Int
    var imageUrl: String
    var addingDate: Double
    var name: String = ""
    
    // MARK: - Coding keys for encoding/decoding
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        
        enum DataCodingKeys: String, CodingKey {
            case id = "id"
            case album = "album"
            
            enum AlbumCodingKeys: String, CodingKey {
                case coverImage = "cover_xl"
            }
        }
    }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        
        var images = [String]()
        var ids = [Int]()
        
        while !dataContainer.isAtEnd {
            let idContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.self)
            let albumContainer = try idContainer.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.AlbumCodingKeys.self, forKey: .album)
            
            images.append(try albumContainer.decode(String.self, forKey: .coverImage))
            ids.append(try idContainer.decode(Int.self, forKey: .id))
        }

        guard let image = images.first else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath + [CodingKeys.DataCodingKeys.AlbumCodingKeys.coverImage], debugDescription: "cover_xl cannot be empty"))
        }

        guard let id = ids.first else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath + [CodingKeys.DataCodingKeys.id], debugDescription: "id cannot be empty"))
        }

        self.imageUrl = image
        self.id = id
        self.addingDate = Date().timeIntervalSince1970
    }
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var dataContainer = container.nestedUnkeyedContainer(forKey: .data)
        var idContainer = dataContainer.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.self)
        var albumContainer = idContainer.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.AlbumCodingKeys.self, forKey: .album)
        
        try idContainer.encode(id, forKey: .id)
        try albumContainer.encode(imageUrl, forKey: .coverImage)
    }
    
}
