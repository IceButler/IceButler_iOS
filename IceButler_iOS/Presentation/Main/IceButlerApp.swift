//
//  IceButlerApp.swift
//  IceButler_iOS
//
//  Created by 유상 on 7/7/24.
//

import SwiftUI
import ComposableArchitecture
import KakaoSDKCommon

@main
struct IceButlerApp: App {
    init() {
        guard let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KakaoAppKey") as? String else {return}
        KakaoSDK.initSDK(appKey: kakaoKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(store: Store(initialState: LoginStore.State(), reducer: {
                LoginStore()
            }))
        }
    }
}

