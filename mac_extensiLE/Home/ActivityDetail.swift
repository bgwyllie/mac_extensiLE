//
//  ActivityDetail.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-19.
//

import SwiftUI
import PythonKit

struct ActivityDetail: View {
    @EnvironmentObject var modelData: ModelData
    var activity: Activity
    
    var body: some View {
        ScrollView {
            Image(activity.imageName)
                .resizable()
                .frame(width: 400, height: 400, alignment: .center)
            VStack(alignment: .leading) {
                HStack {
                    Text(activity.date)
                        .foregroundColor(CustomColors.White)
                        .font(.custom("Avenir Next Bold", size: 28))
                }
                Divider()
                Text("Total Duration: \(activity.total_duration)")
                    .foregroundColor(CustomColors.MenuColor)
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Total Backhand Time: \((Int(activity.backhand_duration) ?? 0) / 1000) seconds")
                    .foregroundColor(CustomColors.MenuColor)
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Total Number of Backhands: \(activity.number_of_backhands)")
                    .foregroundColor(CustomColors.MenuColor)
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Number of Risky Backhands: \(activity.number_of_bad_backhands)")
                    .foregroundColor(CustomColors.MenuColor)
                    .font(.custom("DIN Alternate Bold", size:22))
            }
            .padding()
            .frame(maxWidth: 700)
        }
        .padding(.top, 175)
    }
}
