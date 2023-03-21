//
//  ActivityList.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-19.
//

import SwiftUI

struct ActivityList: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                NavigationView {
                    List {
                        ForEach(modelData.activities) { activity in
                            VStack {
                                NavigationLink {
                                    ActivityDetail(activity: activity)
                                } label: {
                                    Text(activity.date)
                                        .font(.custom("DIN Alternate Bold", size:22))
                                        .foregroundColor(CustomColors.White)
                                }
                                .frame(height:200)
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                }
                .navigationTitle("Recent Activities")
                .frame(minWidth: 500)
            }
        }
    }
}

extension NSTableView {
  open override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    backgroundColor = NSColor.black
    enclosingScrollView!.drawsBackground = false
  }
}
