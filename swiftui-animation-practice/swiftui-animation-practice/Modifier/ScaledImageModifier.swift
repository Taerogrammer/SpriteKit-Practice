//
//  ScaledImageModifier.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct ScaledImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        let scaledSize = 720 / UIScreen.main.scale
        return content
            .frame(width: scaledSize, height: scaledSize)
    }
}

extension View {
    func scaledToScreen() -> some View {
        self.modifier(ScaledImageModifier())
    }
}
