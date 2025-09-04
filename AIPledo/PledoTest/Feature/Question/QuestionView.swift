//
//  QuestionView.swift
//  PledoTest
//
//  Created by 이중엽 on 9/2/25.
//

import SwiftUI

import ComposableArchitecture

struct QuestionView: View {
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    private let rightOffset: CGFloat = 80
    private let bridgeSpacing: CGFloat = 20
    private let leftPaddingScale: CGFloat = 0.2
    
    let store: StoreOf<QuestionStore>
    
    var body: some View {
        ZStack {
            
            ScrollViewReader { proxy in
                // MARK: - 배경, 통나무, 나뭇잎, 배경 끝단
                ScrollView(.horizontal) {
                    ZStack(alignment: .leading) {
                        // MARK: - 배경
                        Image(uiImage: .bg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: calculateTotalWidth(),
                                alignment: .leading
                            )
                            .ignoresSafeArea()
                            .id("backgroundImage")
                        
                        Image(uiImage: store.isOn ? .berryIdle : .berrySmile)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIImage.berryIdle.size.width * scaleFactor,
                                   height: UIImage.berryIdle.size.height * scaleFactor,
                                   alignment: .leading)
                            .offset(x: -UIScreen.main.bounds.width * leftPaddingScale + 30/*UIImage.berryIdle.size.width * 0.25*/,
                                    y: -UIScreen.main.bounds.height * 0.2)
                        
                        // MARK: - 통나무 + 나뭇잎 + 배경 끝단
                        HStack(spacing: bridgeSpacing) { // 통나무 사이의 간격
                            // MARK: - 왼쪽 여백
                            Color.clear
                                .frame(width: UIScreen.main.bounds.width * leftPaddingScale)
                            
                            // MARK: - 통나무 + 나뭇잎
                            ForEach(store.state.tokenQuestionText, id: \.self) { word in
                                
                                switch word {
                                case .normal(let text):
                                    Image(uiImage: .log)
                                        .resizable()
                                        .frame(
                                            width: UIImage.log.size.width * scaleFactor,
                                            height: UIImage.log.size.height * scaleFactor
                                        )
                                        .overlay(
                                            // 단어를 통나무 위에 표시 (테스트용)
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
                                                    width: UIImage.blankOn.size.width * scaleFactor,
                                                    height: UIImage.blankOn.size.height * scaleFactor
                                                )
                                                .overlay(
                                                    // 단어를 통나무 위에 표시 (테스트용)
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
                                    .onReceive(timer) { _ in
                                        store.send(.timerTick)
                                    }
                                }
                            }
                            
                            // MARK: - 배경 끝단
                            Image(uiImage: .bgEnd)
                                .resizable()
                                .frame(
                                    width: UIImage.bgEnd.size.width * scaleFactor,
                                    height: UIImage.bgEnd.size.height * scaleFactor
                                )
                                .id("backgroundEndImage")
                        }
                        .frame(
                            width: calculateTotalWidth(),
                            alignment: .leading
                        )
                    }
                }
                .scrollIndicators(.never)
                .allowsHitTesting(store.state.isTouchable)
                .onChange(of: store.state.question) {
                    scrollAnimation(proxy)
                }
            }
            
            // MARK: - 문제듣기, 레벨 선택, 닫기, 정답, 오답, 텍스트, 패스
            VStack {
                HStack {
                    // MARK: - 문제듣기
                    Button {
                        
                    } label: {
                        Image(uiImage: .btnListening)
                            .resizable()
                            .frame(
                                width: UIImage.btnListening.size.width * scaleFactor,
                                height: UIImage.btnListening.size.height * scaleFactor
                            )
                    }
                    
                    Spacer()
                    
                    // MARK: - 레벨 선택
                    HStack(alignment: .center, spacing: 5) {
                        
                        ForEach(1 ..< 11) { index in
                            let prefix = "0"
                            let number = index < 10 ? prefix + String(index) : String(index)
                            
                            Button {
                                store.send(.levelButtonClicked(index))
                            } label: {
                                Image((store.state.quizID == index) ? "stage_color_\(number)" : "stage_bw_\(number)")
                                    .resizable()
                                    .frame(
                                        width: UIImage.stageBw01.size.width * scaleFactor,
                                        height: UIImage.stageBw01.size.height * scaleFactor
                                    )
                            }
                            .disabled(!store.state.isTouchable)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: - 닫기
                    Button {
                        
                    } label: {
                        Image(uiImage: .btnExit)
                            .resizable()
                            .frame(
                                width: UIImage.btnExit.size.width * scaleFactor,
                                height: UIImage.btnExit.size.height * scaleFactor
                            )
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    // MARK: - 정답
                    Button {
                        store.send(.showCorrectAnswer)
                    } label: {
                        Image(uiImage: .btnCorrect)
                            .resizable()
                            .frame(width: UIImage.btnCorrect.size.width * scaleFactor,
                                   height: UIImage.btnCorrect.size.height * scaleFactor)
                    }
                    
                    // MARK: - 오답
                    Button {
                        store.send(.showWrongAnswer)
                    } label: {
                        Image(uiImage: .btnWrong)
                            .resizable()
                            .frame(width: UIImage.btnWrong.size.width * scaleFactor,
                                   height: UIImage.btnWrong.size.height * scaleFactor)
                    }
                    
                    Spacer()
                    
                    // MARK: - 패스
                    Button {
                        store.send(.passButtonClicked)
                    } label: {
                        Image(uiImage: .buttonPass)
                            .resizable()
                            .frame(width: UIImage.buttonPass.size.width * scaleFactor,
                                   height: UIImage.buttonPass.size.height * scaleFactor)
                    }
                    .disabled(!store.state.isTouchable)
                }
                .overlay {
                    VStack(spacing: 5) {
                        HStack(spacing: 15) {
                            // MARK: - 단어, 퀴즈 이미지
                            ForEach(store.state.sentenceQuestionText) { textType in
                                switch textType {
                                case .normal(let text):
                                    Text(text)
                                        .font(.system(size: 24 * scaleFactor, weight: .bold))
                                case .question(_):
                                    Image(uiImage: .smallBlank)
                                        .resizable()
                                        .frame(width: UIImage.smallBlank.size.width * scaleFactor,
                                               height: UIImage.smallBlank.size.height * scaleFactor)
                                }
                            }
                        }
                        
                        // MARK: - 한국어
                        Text(store.state.question?.fullTextKorean ?? "")
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
        .overlay {
            if store.state.isShowingAnswer {
                AnswerView(store: Store(initialState: AnswerStore.State()) {
                  AnswerStore()
                })
            }
            if store.state.isShowingWrong {
                WrongView(store: Store(initialState: WrongStore.State()) {
                    WrongStore()
                })
            }
        }
    }
    
    /// 화면 크기에 따른 이미지 스케일 팩터
    var scaleFactor: CGFloat {
        let original: CGFloat = 720 / UIScreen.main.scale
        let screen = UIScreen.main.bounds.height
        
        return screen / original
    }
    
    /// ScrollView 내부 콘텐츠의 전체 너비를 계산하는 함수
    func calculateTotalWidth() -> CGFloat {
        let logWidth = UIImage.log.size.width * scaleFactor
        let logSpacing: CGFloat = bridgeSpacing
        let numberOfLogs = store.sentenceQuestionText.count
        let numberOfHorizontalItems = store.sentenceQuestionText.count + 2 // 왼쪽 여백 + bgEnd
        let sidePadding = UIScreen.main.bounds.width * leftPaddingScale
        let totalLogsWidth = logWidth * CGFloat(numberOfLogs)
        let totalSpacingWidth = logSpacing * CGFloat(numberOfHorizontalItems - 1)
        let bgEndWidth = UIImage.bgEnd.size.width * scaleFactor
        let totalWidth = sidePadding + totalLogsWidth + totalSpacingWidth + bgEndWidth
        
        return totalWidth
    }
    
    func scrollAnimation(_ proxy: ScrollViewProxy) {
        Task {
            store.send(.animationStarted)
            
            withAnimation(.easeOut(duration: 1.5)) {
                proxy.scrollTo("backgroundEndImage", anchor: .trailing)
            }
            
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            withAnimation(.easeInOut(duration: 1.5)) {
                proxy.scrollTo("backgroundImage", anchor: .leading)
            }
            
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
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
