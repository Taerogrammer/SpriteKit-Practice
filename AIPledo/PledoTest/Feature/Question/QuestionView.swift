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

    // 애니메이션을 위한 상태 추가
    @State private var characterOffsetX: CGFloat = 0
    @State private var currentLogIndex: Int = 0
    @State private var isAnimating: Bool = false

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
                            .background(.red)
                            .offset(x: getInitialCharacterOffsetX() + characterOffsetX,
                                    y: -UIScreen.main.bounds.height * 0.2)
                            .zIndex(1.0)

                        // MARK: - 통나무 + 나뭇잎 + 배경 끝단
                        HStack(spacing: bridgeSpacing) { // 통나무 사이의 간격
                            // MARK: - 왼쪽 여백
                            Color.black.opacity(0.7)
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
        .onChange(of: store.state.tokenQuestionText) { newValue in
            if !newValue.isEmpty {
                printCharacterAndLogPositions()
            }
        }
        .onChange(of: store.state.isShowingAnswer) { oldValue, newValue in
            if oldValue && !newValue {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    startCharacterAnimation()
                }
            }
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

    // MARK: - 애니메이션 관련 함수들

    /// 캐릭터의 초기 X 오프셋 계산
    func getInitialCharacterOffsetX() -> CGFloat {
        let characterWidth = UIImage.berryIdle.size.width * scaleFactor
        return -characterWidth * 0.5 + UIScreen.main.bounds.width * leftPaddingScale * 0.33
    }

    /// 캐릭터가 각 통나무로 순차적으로 이동하는 애니메이션 시작
    func startCharacterAnimation() {
        guard !store.state.tokenQuestionText.isEmpty else { return }

        isAnimating = true
        currentLogIndex = 0

        animateToNextLog()
    }

    /// 다음 통나무로 이동하는 애니메이션
    func animateToNextLog() {
        let logPositions = calculateLogPositions()

        guard currentLogIndex < logPositions.count else {
            // 모든 통나무를 방문했으면 화면 밖으로 나가는 애니메이션
            animateCharacterOffScreen()
            return
        }

        let targetLog = logPositions[currentLogIndex]
        let characterCurrentCenterX = getCharacterCenterX() + characterOffsetX
        let moveDistance = targetLog.centerX - characterCurrentCenterX

        // 캐릭터를 현재 통나무 중앙으로 이동
        withAnimation(.easeInOut(duration: 0.8)) {
            characterOffsetX += moveDistance
        }

        // 0.8초 후에 다음 통나무로 이동 (약간의 대기 시간 포함)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentLogIndex += 1
            animateToNextLog()
        }
    }

    /// 캐릭터를 화면 밖으로 나가게 하는 애니메이션
    func animateCharacterOffScreen() {
        let screenWidth = UIScreen.main.bounds.width
        let characterCurrentCenterX = getCharacterCenterX() + characterOffsetX

        // 화면 오른쪽 끝으로부터 캐릭터 너비만큼 더 나가도록 계산
        let characterWidth = UIImage.berryIdle.size.width * 2 * scaleFactor
        let offScreenDistance = screenWidth - characterCurrentCenterX + characterWidth

        // 화면 밖으로 나가는 애니메이션 (조금 더 빠르게)
        withAnimation(.easeIn(duration: 1.2)) {
            characterOffsetX += offScreenDistance
        }
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
    
    /// 캐릭터의 중앙 X좌표 계산
    func getCharacterCenterX() -> CGFloat {
        let characterWidth = UIImage.berryIdle.size.width * scaleFactor
        let characterOffsetX = -characterWidth * 0.5 + UIScreen.main.bounds.width * leftPaddingScale * 0.33
        let characterCenterX = characterOffsetX + characterWidth / 2
        
        return characterCenterX
    }

    /// 모든 통나무들의 X좌표 (시작점, 중앙점, 끝점) 계산
    func calculateLogPositions() -> [(index: Int, text: String, startX: CGFloat, centerX: CGFloat, endX: CGFloat)] {
        var results: [(index: Int, text: String, startX: CGFloat, centerX: CGFloat, endX: CGFloat)] = []
        
        let leftPadding = UIScreen.main.bounds.width * leftPaddingScale
        let logWidth = UIImage.log.size.width * scaleFactor
        let blankWidth = UIImage.blankOn.size.width * scaleFactor
        let spacing = bridgeSpacing
        
        var currentXOffset = leftPadding
        
        for (index, token) in store.state.tokenQuestionText.enumerated() {
            switch token {
            case .normal(let text):
                let startX = currentXOffset
                let centerX = currentXOffset + logWidth / 2
                let endX = currentXOffset + logWidth
                
                results.append((
                    index: index,
                    text: text,
                    startX: startX,
                    centerX: centerX,
                    endX: endX
                ))
                
                currentXOffset += logWidth + spacing
                
            case .question(let strings):
                let questionText = "빈칸(\(strings.joined(separator: ", ")))"
                let startX = currentXOffset
                let centerX = currentXOffset + blankWidth / 2
                let endX = currentXOffset + blankWidth
                
                results.append((
                    index: index,
                    text: questionText,
                    startX: startX,
                    centerX: centerX,
                    endX: endX
                ))
                
                currentXOffset += blankWidth + spacing
            }
        }
        
        return results
    }

    /// 캐릭터와 통나무 위치 정보를 콘솔에 출력
    func printCharacterAndLogPositions() {
        let characterCenterX = getCharacterCenterX()
        let logPositions = calculateLogPositions()
        
        print("===== 캐릭터 & 통나무 위치 정보 =====")
        print("화면 너비: \(UIScreen.main.bounds.width)")
        print("Scale Factor: \(scaleFactor)")
        print("왼쪽 여백 비율: \(leftPaddingScale)")
        print("통나무 간격: \(bridgeSpacing)")
        print("")
        
        // 캐릭터 정보
        let characterWidth = UIImage.berryIdle.size.width * scaleFactor
        let characterOffsetX = -characterWidth * 0.5 + UIScreen.main.bounds.width * leftPaddingScale * 0.33
        
        print("🐻 캐릭터 위치:")
        print("  너비: \(characterWidth)")
        print("  offset X: \(characterOffsetX)")
        print("  시작점: \(characterOffsetX)")
        print("  중앙점: \(characterCenterX)")
        print("  끝점: \(characterOffsetX + characterWidth)")
        print("")
        
        // 통나무 정보
        print("🪵 통나무 위치들:")
        for logInfo in logPositions {
            print("  통나무 \(logInfo.index + 1) [\(logInfo.text)]:")
            print("    시작점: \(logInfo.startX)")
            print("    중앙점: \(logInfo.centerX)")
            print("    끝점: \(logInfo.endX)")
            print("    캐릭터 중앙과의 거리: \(abs(logInfo.centerX - characterCenterX))")
        }
        
        // 가장 가까운 통나무 찾기
        if let closestLog = logPositions.min(by: { abs($0.centerX - characterCenterX) < abs($1.centerX - characterCenterX) }) {
            let distance = abs(closestLog.centerX - characterCenterX)
            print("")
            print("🎯 캐릭터와 가장 가까운 통나무:")
            print("  통나무 \(closestLog.index + 1) [\(closestLog.text)]")
            print("  거리: \(distance)")
        }
        
        print("=====================================")
    }
}

//#Preview {
//    QuestionView(store: Store(initialState: QuestionStore.State()) {
//        QuestionStore()
//    })
//    .onAppear { UIScrollView.appearance().bounces = false }
//}
