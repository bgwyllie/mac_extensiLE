//
//  AddDataView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI
import UniformTypeIdentifiers
import PythonKit

struct WhiteButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 320, height: 70, alignment: .center)
            .background(CustomColors.White)
            .foregroundColor(.black)
            .cornerRadius(10)
            .font(.custom("DIN Alternate Bold", size:22))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct AddDataView: View {
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    @State private var isUploaded: Bool = false
    @State private var uploadedFiles = [URL]()
    @EnvironmentObject var modelData: ModelData
    
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
                    .padding(100)
                Button(action: {isImporting.toggle()},
                       label: {
                    Text("UPLOAD DATA")
                })
                .buttonStyle(WhiteButtonStyle())
                .padding()
                .onChange(of: isImporting) { _ in
                    isUploaded = true
                }
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [UTType.plainText],
                    allowsMultipleSelection: true
                ) { selectedFiles in
                    do {
                        let urls = try selectedFiles.get()
//                        let urls = try.selectedFiles.get()
                        importFiles(urls: urls)
                        uploadedFiles = urls
                    } catch {
                        print("Error reading docs")
                        print(error.localizedDescription)
                    }
                }
                .disabled(uploadedFiles.count == 3)
                
                if isUploaded {
                    Button(action:{
                        self.getAlgorithmData()
                    }, label:{
                        Text("ANALYZE DATA")
                    })
                    .buttonStyle(WhiteButtonStyle())
                    .padding()
                    .disabled(uploadedFiles.count != 3)
                }
            }
        }
        .background(Color(red: 0, green: 0, blue: 0))
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("symposium_data")
        return paths
    }
    
    func importFiles(urls: [URL]) {
        lazy var types: [(String, String)] = [("McEnroe", "forearm_data_Quaternion.csv"), ("Ashe", "hand_data_Quaternion.csv"), ("Williams", "stroke_data_Gyroscope.csv")]
            for url in urls {
                for type in types {
                    if url.absoluteString.range(of: type.0) != nil {
                        let newFilePath = getDocumentsDirectory().appendingPathComponent(type.1)
                        do {
                            let fileData = try Data(contentsOf: url)
                            try fileData.write(to: newFilePath)
                        } catch {
                            print("Error reading docs")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
    }
    
    func getAlgorithmData() {
        let sys = Python.import("sys")
        sys.path.append("/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/PythonFiles")
        let classificationAlgorithms = Python.import("ClassificationAlgorithms")
        let response = classificationAlgorithms.getDisplayInformation()
        print("RES", response)
        let arrayResponse: [String] = Array(response)!
        let play_duration = arrayResponse[0]
        let bad_backhands = arrayResponse[1]
        let duration_of_backhands = arrayResponse[2]
        let number_of_backhands = arrayResponse[3]
        let data_date = arrayResponse[4]
        let image_url = arrayResponse[5]
        let new_activity = Activity(id: 1006, date: data_date, number_of_backhands: number_of_backhands, number_of_bad_backhands: bad_backhands, total_duration: play_duration, backhand_duration: duration_of_backhands, imageName: "example_graph")// image_url)
        modelData.addActivity(new_activity)
        print("DISPLAY INFO", play_duration, bad_backhands, duration_of_backhands, number_of_backhands, data_date, image_url)
    }
}


//        var activityDataArray: [Activity] = {
//            do {
//                let fileURL = URL(fileURLWithPath: "/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/Model/activityData.json")
//
//                let data = try Data(contentsOf: fileURL)
//                let decoder = JSONDecoder()
//                let items = try decoder.decode([Activity].self, from: data)
//                return items
//            } catch {
//                print(error.localizedDescription)
//                return []
//            }
//        }()

//        func writeJSON(activities: [Activity]) {
//            do {
//                let fileURL = URL(fileURLWithPath: "/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/Model/activityData.json")
//
//                let encoder = JSONEncoder()
//                try encoder.encode(activityDataArray).write(to: fileURL)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }

//        activityDataArray.insert(Activity(id: 1005, date: "March 11, 2023", number_of_backhands: number_of_backhands, number_of_bad_backhands: bad_backhands, total_duration: play_duration, backhand_duration: duration_of_backhands), at: 0)


//        writeJSON(activities: activityDataArray)

