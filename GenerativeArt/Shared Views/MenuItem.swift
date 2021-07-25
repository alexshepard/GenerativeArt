//
//  MenuItem.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI



struct MenuItem: View {
    var view: AnyView
    var title: String
    var creationDate: String
    
    var body: some View {
        NavigationLink {
            view
        } label: {
            VStack(alignment: .leading) {
                Text(title)
                Text(creationDate)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }

    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(view: AnyView(Text("")), title: "Test", creationDate: "Some Date")
    }
}
