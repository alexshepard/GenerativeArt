//
//  MenuItem.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

struct MenuItem: View {
    var title: String
    var creationDate: String
    
    var body: some View {
        VStack {
            Text(title)
            Text(creationDate)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(title: "Test", creationDate: "Some Date")
    }
}
