//
//  AddDataView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI
import UniformTypeIdentifiers
import PythonKit

struct AddDataView: View {
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    var body: some View {
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)
                Text("Select the files of your hand and forearm sensors, make sure there are 2 Quaternion files and 1 Gyroscope file")
                    .font(.custom("DIN Alternate Bold", size:22))
                    .frame(width: 600)
                    .foregroundColor(Color(red: 0.67, green: 0.88, blue: 1))
                    .multilineTextAlignment(.center)
                    .padding(30)
                Divider()
                Divider()
                Divider()
                Divider()
                Divider()
                Divider()
                Button(action: {isImporting.toggle()},
                       label: {
                    Text("UPLOAD DATA")
                })
                .frame(width: 320, height: 70, alignment: .center)
                .background(CustomColors.White)
                .foregroundColor(.black)
                .cornerRadius(10)
                .font(.custom("DIN Alternate Bold", size:22))
                .buttonStyle(.plain)
                .padding()
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [UTType.plainText],
                    allowsMultipleSelection: true
                ) { selectedFiles in
                    do {
                        let fileURLs = try selectedFiles.get()
                        
                        if fileURLs[0].absoluteString.range(of: "Osaka") != nil {
                            // forearm
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("forearm_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[0])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[0].absoluteString.range(of: "Williams") != nil {
                            // hand
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("hand_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[0])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[0].absoluteString.range(of: "King") != nil {
                            //underarm
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("stroke_data_Gyroscope.csv")
                            let fileData = try Data(contentsOf: fileURLs[0])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[1].absoluteString.range(of: "Osaka") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("forearm_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[1])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[1].absoluteString.range(of: "Williams") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("hand_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[1])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[1].absoluteString.range(of: "King") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("stroke_data_Gyroscope.csv")
                            let fileData = try Data(contentsOf: fileURLs[1])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[2].absoluteString.range(of: "Osaka") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("forearm_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[2])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[2].absoluteString.range(of: "Williams") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("hand_data_Quaternion.csv")
                            let fileData = try Data(contentsOf: fileURLs[2])
                            try fileData.write(to: newFilePath)
                        }
                        if fileURLs[2].absoluteString.range(of: "King") != nil {
                            let newFilePath = getDocumentsDirectory().appendingPathComponent("stroke_data_Gyroscope.csv")
                            let fileData = try Data(contentsOf: fileURLs[2])
                            try fileData.write(to: newFilePath)
                        }
                    } catch {
                        print("Error reading docs")
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .background(Color(red: 0, green: 0, blue: 0))
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("symposium_data")
        return paths
    }
}

struct AddDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddDataView()
    }
}
