//
//  Activity.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-19.
//

import Foundation
import SwiftUI

struct Activity: Hashable, Codable, Identifiable {
    var id: Int
    var date: String
    var number_of_backhands: String
    var number_of_bad_backhands: String
    var total_duration: String
    var backhand_duration: String
    
    var imageName: String
//    var image: Image? {
//        Image(imageName ?? "")
//    }
}
