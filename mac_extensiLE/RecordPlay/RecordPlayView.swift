//
//  RecordPlayView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI

struct RecordPlayView: View {
    var body: some View {
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)
                
                Text("Select Device")
                    .foregroundColor(CustomColors.BlueText)
                    .font(.custom("DIN Alternate Bold", size:22))
                    .padding(5)
                Text("Make sure your Bluetooth is turn on and the device is in range")
                    .font(.custom("DIN Alternate Bold", size:22))
                    .foregroundColor(CustomColors.BlueText)
                    .frame(width: 370)
                    .multilineTextAlignment(.center)
                    .padding(5)
                VStack{
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1)
                    }
                    HStack {
                        Text("Cedric's extensiLE")
                            .foregroundColor(CustomColors.White)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName:"battery.75")
                            .foregroundColor(CustomColors.White)
                            .font(.system(size: 30, weight: .thin))
                            .frame(maxWidth: 225, alignment: .trailing)
                    }
                    .padding(10)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1)
                    }
                    HStack {
                        Text("Milena's extensiLE")
                            .foregroundColor(CustomColors.White)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName:"battery.50")
                            .foregroundColor(CustomColors.White)
                            .font(.system(size: 30, weight: .thin))
                            .frame(maxWidth: 225, alignment: .trailing)
                    }
                    .padding(10)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1)
                    }
                    HStack {
                        Text("Teresa's extensiLE")
                            .foregroundColor(CustomColors.White)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName:"battery.100")
                            .foregroundColor(CustomColors.White)
                            .font(.system(size: 30, weight: .thin))
                            .frame(maxWidth: 225, alignment: .trailing)
                    }
                    .padding(10)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1)
                    }
                }
                .padding(10)
                Button("PAIR DEVICE", action: {})
                    .frame(width: 320, height: 70, alignment: .center)
                    .background(CustomColors.logoBlue)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .font(.custom("DIN Alternate Bold", size:22))
                    .buttonStyle(.plain)
                    .padding()
                Text("Not seeing your device?")
                    .foregroundColor(Color(.white))
                    .underline()
                    .padding(10)
                    .font(.custom("DIN Alternate Bold", size:18))
            }
        }
    }
}
