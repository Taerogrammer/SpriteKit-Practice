//
//  WrongView.swift
//  PledoTest
//
//  Created by 김태형 on 9/4/25.
//

import SwiftUI

import ComposableArchitecture

struct WrongView: View {
    let store: StoreOf<WrongStore>
    
    var scaleFactor: CGFloat {
        let original: CGFloat = 720 / UIScreen.main.scale
        let screen = UIScreen.main.bounds.height
        
        return screen / original
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
            ZStack {
                Image(uiImage: .resultRetry)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.resultRetry.size.width * scaleFactor,
                           height: UIImage.resultRetry.size.height * scaleFactor)
                    .offset(y: store.resultWrongOffset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)
                
                Image(uiImage: .berry08)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.berry08.size.width * scaleFactor,
                           height: UIImage.berry08.size.height * scaleFactor)
                    .offset(y: store.characterUPDownOffset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)
            
                Image(uiImage: .retryMent05)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.retryMent05.size.width * scaleFactor,
                           height: UIImage.retryMent05.size.height * scaleFactor)
                    .offset(y: UIScreen.main.bounds.height * 0.35 + store.wrongMentOffset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)

            }
        }
        .ignoresSafeArea()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    WrongView(store: Store(initialState: WrongStore.State()) {
        WrongStore()
    })
}
