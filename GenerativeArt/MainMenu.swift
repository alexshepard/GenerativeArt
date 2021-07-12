//
//  MainMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: MySketchesMenu()) {
                        Text("My Sketches")
                    }
                }
                
                Section(header: Text("Books & Tutorials")) {
                    NavigationLink(destination: GenerativeDesignBookMenu()) {
                        Text("Generative Design Book")
                    }
                }
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
