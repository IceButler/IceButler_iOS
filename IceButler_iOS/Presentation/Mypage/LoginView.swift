//
//  LoginView.swift
//  IceButler_iOS
//
//  Created by 유상 on 7/1/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("iceButlerMainIcon")
                .padding(.top, 141)
            
            Text("냉장고를 지켜주는 나만의 집사")
                .font(.custom("NanumSquareOTFB", size: 16))
                .foregroundStyle(.white)
                .padding(.top, 32)
            
            Text("냉집사")
                .font(.custom("NanumSquareOTFB", size: 22))
                .foregroundStyle(.white)
                .padding(.top, 12)
            
            Image("kakaoLoginIcon")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 48)
                .padding(.top, 76)
            
            SignInWithAppleButton { _ in
                
            } onCompletion: { _ in
                
            }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 48)
                .padding(.top, 5)

            
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
