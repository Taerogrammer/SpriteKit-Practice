//
//  QuestionView.swift
//  PledoTest
//
//  Created by 이중엽 on 9/2/25.
//

import SwiftUI

import ComposableArchitecture
struct QuestionView: View {

    // View는 Store를 소유하고, 모든 상태와 로직은 Store가 관리합니다.
    let store: StoreOf<QuestionStore>

    private let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    ZStack(alignment: .leading) {
                        Image(uiImage: .bg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: store.totalWidth, // State의 계산 프로퍼티 사용
                                alignment: .leading
                            )
                            .ignoresSafeArea()
                            .id("backgroundImage")

                        Image(uiImage: store.isOn ? .berryIdle : .berrySmile)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIImage.berryIdle.size.width * store.scaleFactor,
                                   height: UIImage.berryIdle.size.height * store.scaleFactor)
                            .offset(
                                x: store.initialCharacterOffsetX + (store.isJumping ? store.parabolicOffsetX : store.characterOffsetX),
                                y: -UIScreen.main.bounds.height * 0.2 + (store.isJumping ? store.parabolicOffsetY : store.characterOffsetY)
                            )
                            .zIndex(1.0)
                            .animation(.linear(duration: 0.016), value: store.animationProgress)

                        HStack(spacing: 20) { // bridgeSpacing
                            Color.clear
                                .frame(width: UIScreen.main.bounds.width * 0.2) // leftPaddingScale

                            ForEach(store.tokenQuestionText, id: \.self) { word in
                                switch word {
                                case .normal(let text):
                                    Image(uiImage: .log)
                                        .resizable()
                                        .frame(
                                            width: UIImage.log.size.width * store.scaleFactor,
                                            height: UIImage.log.size.height * store.scaleFactor
                                        )
                                        .overlay(
                                            Text(text)
                                                .shadow(color: .black, radius: 0, x: 1, y: 1)
                                                .shadow(color: .black, radius: 0, x: -1, y: 1)
                                                .shadow(color: .black, radius: 0, x: 1, y: -1)
                                                .shadow(color: .black, radius: 0, x: -1, y: -1)
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .bold()
                                                .padding(.top, 60)
                                        )
                                        .padding(.top, 40)

                                case .question(let strings):
                                    VStack(spacing: 20) {
                                        ForEach(strings, id: \.self) { text in
                                            Image(uiImage: store.isOn ? .blankOn : .blankOff)
                                                .resizable()
                                                .frame(
                                                    width: UIImage.blankOn.size.width * store.scaleFactor,
                                                    height: UIImage.blankOn.size.height * store.scaleFactor
                                                )
                                                .overlay(
                                                    Text(text)
                                                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                                                        .shadow(color: .black, radius: 0, x: -1, y: 1)
                                                        .shadow(color: .black, radius: 0, x: 1, y: -1)
                                                        .shadow(color: .black, radius: 0, x: -1, y: -1)
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                        .bold()
                                                        .padding(.top, 60)
                                                )
                                        }
                                    }
                                }
                            }

                            Image(uiImage: .bgEnd)
                                .resizable()
                                .frame(
                                    width: UIImage.bgEnd.size.width * store.scaleFactor,
                                    height: UIImage.bgEnd.size.height * store.scaleFactor
                                )
                                .id("backgroundEndImage")
                        }
                        .frame(
                            width: store.totalWidth,
                            alignment: .leading
                        )
                    }
                }
                .scrollIndicators(.never)
                .allowsHitTesting(store.isTouchable)
                .onChange(of: store.question) {
                    scrollAnimation(proxy)
                }
            }

            // MARK: - UI Controls
            VStack {
                HStack {
                    Button {
                        // TODO: 듣기 액션
                    } label: {
                        Image(uiImage: .btnListening)
                            .resizable()
                            .frame(width: UIImage.btnListening.size.width * store.scaleFactor, height: UIImage.btnListening.size.height * store.scaleFactor)
                    }

                    Spacer()

                    HStack(alignment: .center, spacing: 5) {
                        ForEach(1 ..< 11) { index in
                            let prefix = "0"
                            let number = index < 10 ? prefix + String(index) : String(index)

                            Button {
                                store.send(.levelButtonClicked(index))
                            } label: {
                                Image((store.quizID == index) ? "stage_color_\(number)" : "stage_bw_\(number)")
                                    .resizable()
                                    .frame(width: UIImage.stageBw01.size.width * store.scaleFactor, height: UIImage.stageBw01.size.height * store.scaleFactor)
                            }
                            .disabled(!store.isTouchable)
                        }
                    }

                    Spacer()

                    Button {
                        // TODO: 닫기 액션
                    } label: {
                        Image(uiImage: .btnExit)
                            .resizable()
                            .frame(width: UIImage.btnExit.size.width * store.scaleFactor, height: UIImage.btnExit.size.height * store.scaleFactor)
                    }
                }
                .padding()

                Spacer()

                HStack {
                    Button { store.send(.showCorrectAnswer) } label: {
                        Image(uiImage: .btnCorrect)
                            .resizable()
                            .frame(width: UIImage.btnCorrect.size.width * store.scaleFactor, height: UIImage.btnCorrect.size.height * store.scaleFactor)
                    }
                    Button { store.send(.showWrongAnswer) } label: {
                        Image(uiImage: .btnWrong)
                            .resizable()
                            .frame(width: UIImage.btnWrong.size.width * store.scaleFactor, height: UIImage.btnWrong.size.height * store.scaleFactor)
                    }
                    Spacer()
                    Button {
                        store.send(.passButtonClicked)
                    } label: {
                        Image(uiImage: .buttonPass)
                            .resizable()
                            .frame(width: UIImage.buttonPass.size.width * store.scaleFactor, height: UIImage.buttonPass.size.height * store.scaleFactor)
                    }
                    .disabled(!store.isTouchable)
                }
                .overlay {
                    VStack(spacing: 5) {
                        HStack(spacing: 15) {
                            ForEach(store.sentenceQuestionText, id: \.self) { textType in
                                switch textType {
                                case .normal(let text):
                                    Text(text)
                                        .font(.system(size: 24 * store.scaleFactor, weight: .bold))
                                case .question(_):
                                    Image(uiImage: .smallBlank)
                                        .resizable()
                                        .frame(width: UIImage.smallBlank.size.width * store.scaleFactor, height: UIImage.smallBlank.size.height * store.scaleFactor)
                                }
                            }
                        }

                        Text(store.question?.fullTextKorean ?? "")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                            .shadow(color: .black, radius: 0, x: -1, y: 1)
                            .shadow(color: .black, radius: 0, x: 1, y: -1)
                            .shadow(color: .black, radius: 0, x: -1, y: -1)
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            store.send(.onAppear)
        }
        .onReceive(timer) { _ in
            store.send(.timerTick)
        }
        .overlay {
            if store.isShowingAnswer {
                AnswerView(store: Store(initialState: AnswerStore.State()) {
                    AnswerStore()
                })
            }
            if store.isShowingWrong {
                WrongView(store: Store(initialState: WrongStore.State()) {
                    WrongStore()
                })
            }
        }
    }

    /// View에 종속적인 스크롤 애니메이션은 View에 남겨둡니다.
    func scrollAnimation(_ proxy: ScrollViewProxy) {
        store.send(.animationStarted)
        Task {
            withAnimation(.easeOut(duration: 1.5)) {
                proxy.scrollTo("backgroundEndImage", anchor: .trailing)
            }
            try await Task.sleep(for: .seconds(1.5))

            withAnimation(.easeInOut(duration: 1.5)) {
                proxy.scrollTo("backgroundImage", anchor: .leading)
            }
            try await Task.sleep(for: .seconds(1.5))

            store.send(.animationEnded)
        }
    }
}

//#Preview {
//    QuestionView(store: Store(initialState: QuestionStore.State()) {
//        QuestionStore()
//    })
//    .onAppear { UIScrollView.appearance().bounces = false }
//}
