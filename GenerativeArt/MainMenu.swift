//
//  MainMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI


struct MenuItem: View {
    var title: String
    var creationDate: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(creationDate)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct MainMenu: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                List {
                    Section("July 2021") {
                        NavigationLink {
                            AcrossShapes()
                        } label: {
                            MenuItem(title: "Across Shapes", creationDate: "5 July 2021")
                        }
                    }
                }
                .navigationBarTitle("My Generative Art")
            }
        } else {
            Text("iOS 14 Fallback view")
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
