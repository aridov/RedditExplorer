//
//  RedditEntry.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import Foundation

struct ResponseTopReddit : Codable {
    let data: ResponseData
}

struct ResponseData: Codable {
    let children: [ChildrenData]
}

struct ChildrenData: Codable {
    let data: RedditEntry
}

struct RedditEntry: Codable {
    let author: String
    let title: String
    let thumbnail: String
    let url_overridden_by_dest: String
    let post_hint: String
    let num_comments: Int
    let created_utc: TimeInterval
}
