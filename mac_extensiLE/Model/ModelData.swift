//
//  ModelData.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-19.
//

import Foundation
import Combine
import PythonKit

final class ModelData: ObservableObject {
    @Published var activities: [Activity] = load("activityData.json")
    
    func addActivity(_ activity: Activity) {
        activities.insert(activity, at: 0)
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't find \(filename) from main bundle: \n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
