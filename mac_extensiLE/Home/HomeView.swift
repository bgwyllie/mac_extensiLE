//
//  HomeView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @EnvironmentObject var modelData: ModelData
    // use python GUI tkinter
    var body: some View {
        
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()
            ActivityList()
                        .frame(minWidth: 700, minHeight: 500)
            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)
            }
        }
    }
}
