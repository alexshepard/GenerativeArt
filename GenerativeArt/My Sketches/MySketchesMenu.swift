//
//  MySketchesMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI

struct MySketchesMenu: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                Section("July 2021") {
                    NavigationLink {
                        AcrossShapes()
                    } label: {
                        MenuItem(title: AcrossShapes.name, creationDate: AcrossShapes.date)
                    }
                    NavigationLink {
                        AcrossComplementaryShapes()
                    } label: {
                        MenuItem(title: AcrossComplementaryShapes.name, creationDate: AcrossComplementaryShapes.date)
                    }
                    NavigationLink {
                        PerlinAcrossShapes()
                    } label: {
                        MenuItem(title: PerlinAcrossShapes.name, creationDate: PerlinAcrossShapes.date)
                    }
                    
                    NavigationLink {
                        ColorFromCamera()
                    } label: {
                        MenuItem(title: ColorFromCamera.name, creationDate: ColorFromCamera.date)
                    }
                    
                    NavigationLink {
                        AnimatedAcrossShapes()
                    } label: {
                        MenuItem(title: AnimatedAcrossShapes.name, creationDate: AnimatedAcrossShapes.date)
                    }

                }
            }
            .navigationBarTitle("My Sketches", displayMode: .inline)
        } else {
            Text("iOS 14 Fallback view")
        }
    }
}

struct MySketchesMenu_Previews: PreviewProvider {
    static var previews: some View {
        MySketchesMenu()
    }
}
