//
//  ContentView.swift
//  GithubSearch
//
//  Created by Shujat Ali on 09/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State var searching = false
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBarView(searchText: $viewModel.searchText, searching: $searching)
                List {
                    Section(header: Text(viewModel.sectionHeading)) {
                        ForEach(viewModel.filteredItems) { item in
                            CustomRowItem(item)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle(searching ? "Searching" : "My Git Search")
                .toolbar {
                    if searching {
                        Button("Cancel") {
                            viewModel.searchText = ""
                            withAnimation {
                                searching = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                    }
                }
                .gesture(DragGesture()
                    .onChanged({ _ in
                        UIApplication.shared.dismissKeyboard()
                    })
                )
            }
        }.onAppear {
            viewModel.performSearch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
