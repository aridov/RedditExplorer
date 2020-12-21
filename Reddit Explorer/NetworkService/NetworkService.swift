//
//  NetworkService.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import Foundation

fileprivate enum RedditURL: String {
    case top = "https://www.reddit.com/top.json?limit=10"
}

class NetworkService {
    typealias TopRequestResult = (Result<[ChildrenData], Error>) -> Void
    
    var nextPageId = ""
    
    func requestTopEntries(completion: @escaping TopRequestResult) {
        guard let url = URL(string: RedditURL.top.rawValue) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let topData = try JSONDecoder().decode(ResponseTopReddit.self, from: data)
                self.nextPageId = topData.data.after
                completion(.success(topData.data.children))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadNextPage(completion: @escaping TopRequestResult) {
        guard let url = URL(string: "\(RedditURL.top.rawValue)&after=\(nextPageId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let nextPageData = try JSONDecoder().decode(ResponseTopReddit.self, from: data)
                self.nextPageId = nextPageData.data.after
                completion(.success(nextPageData.data.children))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
