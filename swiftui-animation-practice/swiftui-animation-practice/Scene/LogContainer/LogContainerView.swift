//
//  LogContainerView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogContainerView: View {
    let dummyData: [LogEntity]
    let size: CGSize // 상위 뷰로부터 크기를 전달받음

    var body: some View {
        HStack {
            ForEach(dummyData, id: \.self) { entity in
                // VStack/LogView 그룹의 크기를 명확하게 지정
                Group {
                    if entity.type == .question {
                        VStack {
                            LogView(entity: entity)
                        }
                    } else {
                        LogView(entity: entity)
                    }
                }
                // 모든 LogView가 동일한 크기를 갖도록 설정 (정사각형)
                .frame(width: size.height, height: size.height)
            }
        }
    }
}

//#Preview {
//    LogContainerView()
//}
