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
                HStack {
                    SearchBarView(searchText: $viewModel.searchText, searching: $searching)
                    Button("Search") {
                        viewModel.performSearch()
                    }
                    .frame(width: 70, height: 25)
                    .overlay(
                            RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue, lineWidth: 2)
                            )
                    
                }.padding([.trailing], 20)
                List {
                    if viewModel.isLoading {
                        HStack() {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        Section(header: Text(viewModel.sectionHeading)) {
                            ForEach(viewModel.filteredItems) { item in
                                CustomRowItem(item).onTapGesture {
                                    viewModel.didSelectItem(item)
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .gesture(DragGesture()
                    .onChanged({ _ in
                        UIApplication.shared.dismissKeyboard()
                    })
                )
            }
            .navigationBarTitle(Text(searching ? "Searching" : "My Git Search"))
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.performSearch()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
