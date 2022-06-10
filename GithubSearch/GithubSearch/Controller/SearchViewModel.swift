//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Shujat Ali on 10/06/2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
            didSet { isSearchEnabled = (searchText.count > 2) }
        }
    @Published var isSearchEnabled = false
    @Published private var results = [SearchResultVM]()
    
    var sectionHeading: String {
        return "Records \(results.count)"
    }
    
    var filteredItems: [SearchResultVM] {
        get {
            let items =  results.filter({ item -> Bool in
                return item.description.hasPrefix(searchText) || searchText.isEmpty
            })
            
            if items.isEmpty {
                return [SearchResultVM.emptyItem()]
            }
            
            return items
        }
    }
    
    func performSearch() {
        
        var search = searchText.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed
        ) ?? ""
        
        if search.isEmpty {
            search = "test"
        }
//        if search.isEmpty {
//            return
//        }
        
        guard let gUrl = URL(
            string: "https://api.github.com/search/repositories?q=\(search)"
        ) else { return }
        
        let task = URLSession.shared.dataTask(with: gUrl) { (data: Data?, urlResp: URLResponse?, err: Error?) in
            do {
                if let data = data {
                    let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.results = (response.items ?? []).map {
                            SearchResultVM($0)
                        }
                    }
                }
            } catch {
                print("*** ERROR *** \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


struct SearchResultVM: Identifiable, Hashable {
    
    let id = UUID()
    let title: String
    let description: String
    let favouriteCount: String
    let language: String
    let repoURL: String
    
    init(_ gitItem: GitItemModel) {
        title = gitItem.name
        description = gitItem.repoDescription
        favouriteCount = "\(gitItem.forkCount)"
        language = gitItem.language
        repoURL = gitItem.repoUrl
    }
    
    private init() {
        title = ""
        description = "No results"
        favouriteCount = ""
        language = ""
        repoURL = ""
    }
    
    static func emptyItem() -> SearchResultVM {
        return SearchResultVM()
    }
}
