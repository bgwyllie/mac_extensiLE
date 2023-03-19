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
    private let tabIcon: [Image]
    private let tabViews: [AnyView]
    
    @State private var selection = 0
    
    public init(tabBarPosition: TabBarPosition, content: [(tabText: String, tabIcon: Image, view: AnyView)]) {
        self.tabBarPosition = tabBarPosition
        self.tabText = content.map{$0.tabText}
        self.tabIcon = [Image(systemName: "house")] //content.map{$0.tabIcon}
        self.tabViews = content.map{$0.view}
        
    }
    public var tabBar: some View {
        HStack {
            Spacer()
            ForEach(0..<tabText.count) { index in
                HStack {
//                    Image(self.tabIcon)
                    Text(self.tabText[index])
                }
                .padding()
                .foregroundColor(self.selection == index ? CustomColors.MenuColor : CustomColors.SelectedMenu)
                .background(Color.black)
                .font(.custom("DIN Condensed Bold", size:20))
//                .font(.system(size:16))
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
   
    @State var result: String = ""
    @State var swapA: Int = 13
    @State var swapB: Int = 6
    
    func runPythonCode() {
        let sys = Python.import("sys")
        sys.path.append("/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/PythonTests")
        let example = Python.import("hello")
        let response = example.hello()
        result = response.description
//        
//        let str = String(pythonString)!
//        let arr = Array(pythonArray)!
    }
    func swapNumbersInPython(){
            let sys = Python.import("sys")
            sys.path.append("/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/PythonTests")
            let example = Python.import("hello")
            let response = example.swap(swapA, swapB)
            let a : [Int] = Array(response)!
            swapA = a[0]
            swapB = a[1]
    }
    
    var body: some View {
        CustomTabView(
            tabBarPosition: .bottom,
            content: [
                (
                    tabText: "Home",
                    tabIcon: Image(systemName: "house"),
                    view: AnyView(HomeView())
                ),
                (
                    tabText: "Record",
                    tabIcon:  Image(systemName: "house"),
                    view: AnyView(RecordPlayView())
                ),
                (
                    tabText: "Add Data",
                    tabIcon:  Image(systemName: "house"),
                    view: AnyView(AddDataView())
                ),
                (
                    tabText: "Education",
                    tabIcon:  Image(systemName: "house"),
                    view: AnyView(EducationView())
                ),
                (
                    tabText: "Account",
                    tabIcon: Image(systemName: "house"),
                    view: AnyView(AccountView())
                ),
            ])
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//            Button(action: {
//                self.runPythonCode()
//            }, label: {
//                Text("Run script")
//            })
//            Text("\(result)")
//
//            Button(action: {
//                self.swapNumbersInPython()
//            }, label: {
//                Text("Swap Numbers")
//            })
//            HStack {
//                Text("\(swapA)")
//                Text("\(swapB)")
//            }
//            TabView {
//                HomeView()
//                    .tabItem {
//                        Label("Home", systemImage: "house")
//                    }
//                RecordPlayView()
//                    .tabItem {
//                        Label("Record", systemImage: "plus.circle")
//                    }
//                EducationView()
//                    .tabItem {
//                        Label("Education", systemImage: "tennisball")
//                    }
//                AccountView()
//                    .tabItem {
//                        Label("Account", systemImage: "person")
//                    }
//            }
//            .accentColor(CustomColors.SelectedMenu)
            
//        }
//        .padding()
    }
}
//print("Python Encoding: \(sys.getdefaultencoding().upper())")
//print("Python Path: \(sys.path)")
//
//_ = Python.import("math") // verifies `lib-dynload` is found and signed successfully
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
