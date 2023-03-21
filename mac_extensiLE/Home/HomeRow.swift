//
//  HomeRow.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-19.
//

import SwiftUI

struct HomeRow: View {
    var activity: Activity
//    var activity_date: String//Date
//    var items: []
    var body: some View {
//        Color.black
//            .ignoresSafeArea()
        VStack(alignment: .leading) {
            Color.black
                .ignoresSafeArea()
            Text(activity.date)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
                .foregroundColor(CustomColors.White)
//                .background(Color.black)
//                .foregroundColor(Color.pink)
//                .listRowBackground(Color.black)
//            ScrollView(.horizontal, showsIndicators: false) {
////                HStack(alignment: .top, spacing: 0) {
////                    ForEach(items) {landmark in
////                        Text(landmark.name)
////                    }
////                }
//                
        }
        .foregroundColor(Color.black)
        .background(Color.black)
        .frame(height: 100)
    }
}
