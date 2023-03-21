//
//  ContentView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-11.
//

import SwiftUI
import PythonKit

struct CustomColors {
    static let logoBlue = Color("LogoBlue")
    static let BlueText = Color("BlueText")
    static let MenuColor = Color("MenuColor")
    static let Grey = Color("Grey")
    static let SelectedMenu = Color("SelectedMenu")
    static let White = Color("White")
}

public struct CustomTabView: View {
    public enum TabBarPosition {
        case top
        case bottom
    }
    private let tabBarPosition: TabBarPosition
    private let tabText: [String]
    private let tabViews: [AnyView]
    
    @State private var selection = 0
    
    public init(tabBarPosition: TabBarPosition, content: [(tabText: String, view: AnyView)]) {
        self.tabBarPosition = tabBarPosition
        self.tabText = content.map{$0.tabText}
        self.tabViews = content.map{$0.view}
        
    }
    public var tabBar: some View {
        HStack {
            Spacer()
            ForEach(0..<tabText.count) { index in
                HStack {
                    Text(self.tabText[index])
                }
                .padding()
                .foregroundColor(self.selection == index ? CustomColors.MenuColor : CustomColors.SelectedMenu)
                .background(Color.black)
                .font(.custom("DIN Condensed Bold", size:24))
                .onTapGesture {
                    self.selection = index
                }
            }
            Spacer()
        }
        .padding(0)
        .background(Color.black)
        .shadow(color: Color.clear, radius: 0, x: 0, y: 0)
        .background(Color.black)
        .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: tabBarPosition == .top ? 1: -1)
        .zIndex(99)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if (self.tabBarPosition == .top) {
                tabBar
            }
            tabViews[selection]
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if (self.tabBarPosition == .bottom) {
                tabBar
            }
        }
        .padding(0)
    }
}

struct ContentView: View {
    var body: some View {
        CustomTabView(
            tabBarPosition: .bottom,
            content: [
                (
                    tabText: "Home",
//                    view: AnyView(ActivityList()) //
                    view: AnyView(HomeView())
                ),
                (
                    tabText: "Record",
                    view: AnyView(RecordPlayView())
                ),
                (
                    tabText: "Add Data",
                    view: AnyView(AddDataView())
                ),
                (
                    tabText: "Education",
                    view: AnyView(EducationView())
                ),
                (
                    tabText: "Account",
                    view: AnyView(AccountView())
                ),
            ])
    }
}
