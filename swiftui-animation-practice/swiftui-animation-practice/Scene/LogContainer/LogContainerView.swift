//
//  LogContainerView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogContainerView: View {
    var body: some View {
        HStack {
            LogView()
            LogView()
            LogView()
        }
    }
}

#Preview {
    LogContainerView()
}
