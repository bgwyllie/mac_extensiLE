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
                .frame(width: 525, height: 525, alignment: .center)
            VStack(alignment: .leading) {
                HStack {
                    Text(activity.date)
                        .font(.custom("Avenir Next", size: 30))
                }
                .foregroundColor(CustomColors.Grey)
                    
                Divider()
                Text("Total Duration: \(activity.total_duration)")
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Total Backhand Time: \((Int(activity.backhand_duration) ?? 0) / 1000) seconds")
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Total Number of Backhands: \(activity.number_of_backhands)")
                    .font(.custom("DIN Alternate Bold", size:22))
                Text("Number of Risky Backhands: \(activity.number_of_bad_backhands)")
                    .font(.custom("DIN Alternate Bold", size:22))
                
            }
            .padding()
            .frame(maxWidth: 700)
        }
        .padding(.top, 175)
    }
}
