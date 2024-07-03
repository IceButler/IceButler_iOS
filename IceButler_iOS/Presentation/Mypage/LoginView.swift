//
//  LoginView.swift
//  IceButler_iOS
//
//  Created by 유상 on 7/1/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("iceButlerMainIcon")
                .padding(.top, 141)
            
            Text("냉장고를 지켜주는 나만의 집사")
            Text("냉집사")
            
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color("Blue2"))
    }
}

#Preview {
    LoginView()
}
