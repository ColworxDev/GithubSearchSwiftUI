//
//  CustomRowItem.swift
//  GithubSearch
//
//  Created by Shujat Ali on 10/06/2022.
//

import SwiftUI

struct CustomRowItem: View {
    let title: String
    let subtitle: String
    let favCount: String
    let language: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.title)
            Text(subtitle).font(Font.body)
            if !title.isEmpty {
                HStack {
                    Label(favCount, systemImage: "star.fill")
                    Label(language, systemImage: "circle.fill")
                    Spacer()
                }.foregroundColor(Color.blue)
            }
            
            Spacer()
        }.padding(.all, 5)
    }
}

extension CustomRowItem {
    init(_ model: SearchResultVM) {
        title = model.title
        subtitle = model.description1
        favCount = model.favouriteCount
        language = model.language
    }
}


struct CustomRowItem_Previews: PreviewProvider {
    static var previews: some View {
        CustomRowItem(title: "dummy repository name", subtitle: "repository link", favCount: "100k", language: "swift")
            .previewLayout(.fixed(width: UIScreen.screenWidth, height: 100))
    }
}
