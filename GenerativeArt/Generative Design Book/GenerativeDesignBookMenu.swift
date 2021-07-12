//
//  GenerativeDesignBookMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

struct GenerativeDesignBookMenu: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                Section("Chapter One: Colors") {
                    NavigationLink {
                        HelloColor()
                    } label: {
                        MenuItem(title: HelloColor.name, creationDate: HelloColor.date)
                    }
                }
            }
            .navigationBarTitle("Generative Design", displayMode: .inline)
        } else {
            Text("iOS 14 Fallback view")
        }
    }
}

struct GenerativeDesignBookMenu_Previews: PreviewProvider {
    static var previews: some View {
        GenerativeDesignBookMenu()
    }
}
