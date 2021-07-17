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
                    
                    NavigationLink {
                        ColorSpectrumGrid()
                    } label: {
                        MenuItem(title: ColorSpectrumGrid.name, creationDate: ColorSpectrumGrid.date)
                    }
                    
                    NavigationLink {
                        ColorSpectrumCircle()
                    } label: {
                        MenuItem(title: ColorSpectrumCircle.name, creationDate: ColorSpectrumCircle.date)
                    }
                    
                    NavigationLink {
                        ColorPaletteInterpolation()
                    } label: {
                        MenuItem(title: ColorPaletteInterpolation.name, creationDate: ColorPaletteInterpolation.date)
                    }

                    NavigationLink {
                        RGBInterpolation()
                    } label: {
                        MenuItem(title: RGBInterpolation.name, creationDate: RGBInterpolation.date)
                    }
                    
                    NavigationLink {
                        ColorFromImages()
                    } label: {
                        MenuItem(title: ColorFromImages.name, creationDate: ColorFromImages.date)
                    }

                    NavigationLink {
                        ColorFromCamera()
                    } label: {
                        MenuItem(title: ColorFromCamera.name, creationDate: ColorFromCamera.date)
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
