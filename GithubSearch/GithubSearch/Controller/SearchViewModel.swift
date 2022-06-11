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
    @Published var isLoading = false
    private var sQuery = ""
    var sectionHeading: String {
        return "Records for \(sQuery): \(results.count)"
    }
    
    var filteredItems: [SearchResultVM] {
        get {
            let items =  results.filter({ item -> Bool in
                return item.description1.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
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
        sQuery = search
        searchText = ""
        //        if search.isEmpty {
        //            return
        //        }
        
        guard let gUrl = URL(
            string: "https://api.github.com/search/repositories?q=\(sQuery)"
        ) else { return }
        isLoading = true
        let task = URLSession.shared.dataTask(with: gUrl) { (data: Data?, urlResp: URLResponse?, err: Error?) in
            
            DispatchQueue.main.async { [weak self] in
                do {
                    if let data = data {
                        let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                        
                        self?.results = (response.items ?? []).map {
                            print($0)
                            return SearchResultVM($0)
                        }
                    }
                    self?.isLoading = false
                } catch {
                    self?.isLoading = false
                    print("*** ERROR *** \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
    }
    
    func didSelectItem(_ item: SearchResultVM) {
        if item.description1.hasPrefix("No results,") {
            performSearch()
        }
    }
}


struct SearchResultVM: Identifiable, Hashable {
    
    let id = UUID()
    let title: String
    let description1: String
    let favouriteCount: String
    let language: String
    let repoURL: String
    
    init(_ gitItem: GitItemModel) {
        title = gitItem.name
        description1 = gitItem.repoDescription
        favouriteCount = "\(gitItem.forkCount)"
        language = gitItem.language
        repoURL = gitItem.repoUrl
    }
    
    private init() {
        title = ""
        description1 = "No results, Click Search to search from Git"
        favouriteCount = ""
        language = ""
        repoURL = ""
    }
    
    static func emptyItem() -> SearchResultVM {
        return SearchResultVM()
    }
}
