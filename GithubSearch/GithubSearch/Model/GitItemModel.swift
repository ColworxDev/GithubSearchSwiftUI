//
//  GitItemModel.swift
//  GithubSearch
//
//  Created by Shujat Ali on 10/06/2022.
//

import Foundation

struct SearchResponse: Decodable {
    let total_count: Int?
    let incomplete_results: Bool?
    let items: [GitItemModel]?
}

struct GitItemModel: Decodable {
    let name: String
    let fullName: String
    let score: Double
    let forkCount: Int
    let watcherCount: Int
    let starCount: Int
    let issuesCount: Int
    let language: String
    let repoDescription: String
    
    let avatarUrl: String
    let ownerType: String
    let ownerLoginName: String
    let repoUrl: String
    
    enum OwnerKeys: String, CodingKey {
        case login, url, type, avatar_url
    }
    
    enum RootKeys: String, CodingKey {
        case name, fullName = "full_name", score, forkCount = "forks_count", watcherCount = "watchers_count", starCount = "stargazers_count", issuesCount = "open_issues_count", language, repoDescription = "description"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        score = try values.decodeIfPresent(Double.self, forKey: .score) ?? 0
        forkCount = try values.decodeIfPresent(Int.self, forKey: .forkCount) ?? 0
        watcherCount = try values.decodeIfPresent(Int.self, forKey: .watcherCount) ?? 0
        starCount = try values.decodeIfPresent(Int.self, forKey: .starCount) ?? 0
        issuesCount = try values.decodeIfPresent(Int.self, forKey: .issuesCount) ?? 0
        language = try values.decodeIfPresent(String.self, forKey: .language) ?? ""
        repoDescription = try values.decodeIfPresent(String.self, forKey: .repoDescription) ?? ""
        
        let nestedInfo = try values.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        ownerType = try nestedInfo.decodeIfPresent(String.self, forKey: .type) ?? ""
        ownerLoginName = try nestedInfo.decodeIfPresent(String.self, forKey: .login) ?? ""
        repoUrl = try nestedInfo.decodeIfPresent(String.self, forKey: .url) ?? ""
        avatarUrl = try nestedInfo.decodeIfPresent(String.self, forKey: .avatar_url) ?? ""
    }
}
