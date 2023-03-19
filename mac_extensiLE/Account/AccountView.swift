//
//  AccountView.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-13.
//

import SwiftUI

struct SettingOptions: Identifiable {
    let label: String
    let icon: Image
    let id = UUID()
}

private var settingOptions = [
    SettingOptions(label: "Change password", icon: Image(systemName: "lock")),
    SettingOptions(label: "Help", icon: Image(systemName: "questionmark.circle"))
]


struct AccountView: View {
   
    var body: some View {
        ZStack (alignment: .top){
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Image("extensiLE Logo V4")
                    .resizable()
                    .frame(width: 400, height: 160, alignment: .center)
                    .padding(10)
                Divider()
                Divider()
                Divider()
                Text("Serena Williams")
                    .foregroundColor(CustomColors.BlueText)
                    .font(.custom("DIN Alternate Bold", size:22))
                    .padding(5)
                Text("swilliams@gmail.com")
                    .foregroundColor(CustomColors.BlueText)
                    .font(.custom("DIN Alternate Bold", size:22))
                
                Divider()
                
                VStack(alignment: .leading){
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.system(size: 55, weight: .thin))

                        Text("Change Password")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName: "chevron.right")
                            .foregroundColor(CustomColors.Grey)
                            .font(.system(size: 55, weight: .thin))
                            .frame(maxWidth: 145, alignment: .trailing)
                    }
                    .padding(7.5)
                    
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1) // / UIScreen.main.scale)
                    }
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.system(size: 55, weight: .thin))

                        Text("Help")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName: "chevron.right")
                            .foregroundColor(CustomColors.Grey)
                            .font(.system(size: 55, weight: .thin))
                            .frame(maxWidth: 252.5, alignment: .trailing)
                    }
                    .padding(7.5)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1) // / UIScreen.main.scale)
                    }
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.system(size: 55, weight: .thin))
                        Text("Privacy And Data Sharing")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.custom("DIN Alternate Bold", size:20))
//                            .font(.system(size:20))
                        Image(systemName: "chevron.right")
                            .foregroundColor(CustomColors.Grey)
                            .font(.system(size: 55, weight: .thin))
                            .frame(maxWidth: 80, alignment: .trailing)
                    }
                    .padding(7.5)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1) // / UIScreen.main.scale)
                    }
                    HStack {
                        Image(systemName: "tennisball")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.system(size: 55, weight: .thin))

                        Text("About")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName: "chevron.right")
                            .foregroundColor(CustomColors.Grey)
                            .font(.system(size: 55, weight: .thin))
                            .frame(maxWidth: 240, alignment: .trailing)
                    }
                    .padding(7.5)
                    VStack {
                        CustomColors.MenuColor.frame(width:400, height: 1) // / UIScreen.main.scale)
                    }
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.system(size: 55, weight: .thin))

                        Text("Logout")
                            .foregroundColor(CustomColors.MenuColor)
                            .font(.custom("DIN Alternate Bold", size:20))
                        Image(systemName: "chevron.right")
                            .foregroundColor(CustomColors.Grey)
                            .font(.system(size: 55, weight: .thin))
                            .frame(maxWidth: 220, alignment: .trailing)
                    }
                    .padding(7.5)
                    
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
