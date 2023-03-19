//
//  HomeView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    // use python GUI tkinter
    var body: some View {
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)

            }
                .background(Color(red: 0, green: 0, blue: 0))

            VStack {

            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
