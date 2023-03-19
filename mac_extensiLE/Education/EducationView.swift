//
//  EducationView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI

struct EducationView: View {
    var body: some View {
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)
                Image("LE_Labelled_Diagram")
                    .resizable()
                    .frame(width: 325, height: 325, alignment: .center)
                Text("About Lateral Epicondylitis")
                    .font(.custom("DIN Alternate Bold", size:16))
                    .foregroundColor(CustomColors.BlueText)
                    .padding(5)
                Text("""
                    Lateral epicondylitis (LE), commonly referred to as tennis elbow, is a painful condition of the elbow caused by damage to the forearm muscles and tendons that are damaged from overuse. LE causes pain and tenderness due to the inflammation or the microtearing of the tendons that join the forearm musles on the outside of the elbow. If left untreated, pain in the forearm can increase and may even result in the loss of function of the affected area. Your elbow joint is a joint made up of three bones: the upper arm bone (humerus) and the two bones in the forearm (radius and ulna). There are bony bumps at the bottom of the humerus called epicondyles, where several muscles of the forearm begin their course. The bony bump on the outside (lateral side) of the elbow is called the lateral epicondyle.Muscles, ligaments, and tendons hold the elbow joint together. Lateral epicondylitis, or tennis elbow, involves the muscles and tendons of your forearm that are responsible for the extension of your wrist and fingers. Your forearm muscles extend your wrist and fingers. Your forearm tendons — often called extensors — attach the muscles to bone.  The tendon usually involved in tennis elbow is called the extensor carpi radialis brevis (ECRB).
                    """)
                    .font(.custom("DIN Alternate Bold", size:14))
                    .frame(width: 650)
                    .foregroundColor(Color(red: 0.67, green: 0.88, blue: 1))
                
                Link("Click For More Information About LE", destination: URL(string: "https://orthoinfo.aaos.org/en/diseases--conditions/tennis-elbow-lateral-epicondylitis/")!)
            }
        }
    }
}

struct EducationView_Previews: PreviewProvider {
    static var previews: some View {
        EducationView()
    }
}
