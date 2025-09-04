//
//  AnswerView.swift
//  PledoTest
//
//  Created by 김태형 on 9/4/25.
//

import SwiftUI

import ComposableArchitecture

struct AnswerView: View {
    let store: StoreOf<AnswerStore>
    
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
                Image(uiImage: .resultAnswer)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.resultAnswer.size.width * scaleFactor,
                           height: UIImage.resultAnswer.size.height * scaleFactor)
                    .offset(y: store.resultAnswerOffset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)
                
                Image(uiImage: .berry03)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.berry03.size.width * scaleFactor,
                           height: UIImage.berry03.size.height * scaleFactor)
                    .offset(y: store.berry03Offset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)
                
                Image(uiImage: .answerMent09)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIImage.answerMent09.size.width * scaleFactor,
                           height: UIImage.answerMent09.size.height * scaleFactor)
                    .offset(y: UIScreen.main.bounds.height * 0.35 + store.answerMent09Offset)
                    .animation(.linear(duration: 0.2).delay(0.1), value: store.isAnimated)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

//#Preview(traits: .landscapeLeft) {
//    AnswerView()
//}
