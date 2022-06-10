//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by Shujat Ali on 09/06/2022.
//

import SwiftUI

@main
struct GithubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


extension UIApplication {
     func dismissKeyboard() {
         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
