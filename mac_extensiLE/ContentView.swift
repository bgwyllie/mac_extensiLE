//
//  ContentView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-11.
//

import SwiftUI
import PythonKit


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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action: {
                self.runPythonCode()
            }, label: {
                Text("Run script")
            })
            Text("\(result)")
            
            Button(action: {
                self.swapNumbersInPython()
            }, label: {
                Text("Swap Numbers")
            })
            HStack {
                Text("\(swapA)")
                Text("\(swapB)")
            }
            
        }
        .padding()
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
