//
//  DeezerService.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/15/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import Foundation

/// Service for sending requests to API (Singleton).
final class TrackService {
    
    static let shared = TrackService()
    
    let baseUrl = "https://api.deezer.com/search?q="
    private init() {}
    
    /// Method for fetching and parsing response from API.
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
                
                return
            }
            }.resume()
    }
    
    /// Method for fetching track from API.
    func fetchTrack(from url: String, result: @escaping (Result<Track, Error>) -> Void) {
        guard let url = URL(string: url) else {
            let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]) as Error
            result(.failure(error))
            return
        }
        
        fetchResources(url: url) { (response: Result<Track, Error>) in
            switch response {
            case .success(let track):
                result(.success(track))
                
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    /// Method for detching image from URL
    func fetchImage(from url: String, result: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]) as Error
            result(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            if let data = data {
                result(.success(data))
                return
            }
        }.resume()
        
    }
    
}
