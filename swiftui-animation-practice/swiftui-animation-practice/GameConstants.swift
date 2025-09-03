//
//  GameConstants.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//
    
import Foundation

// MARK: - Game Constants
struct GameConstants {
    static let logCount: Int = 4
    static let leadingPaddingRatio: CGFloat = 0.24
    static let logSizeRatio: CGFloat = 0.18
    static let logSpacing: CGFloat = 120
    static let containerSpacing: CGFloat = 40
    static let logImageAspectRatio: CGFloat = 293.0 / 215.0
    static let endingImageAspectRatio: CGFloat = 343.0 / 721.0
    
    static func calculateTotalContentWidth(for screenSize: CGSize) -> CGFloat {
        let leadingPadding = screenSize.width * leadingPaddingRatio
        let logHeight = screenSize.height * logSizeRatio
        let logWidth = logHeight * logImageAspectRatio
        let endingImageWidth = screenSize.height * endingImageAspectRatio
        
        let logContainerWidth = (CGFloat(logCount) * logWidth) + (CGFloat(logCount - 1) * logSpacing)
        
        return leadingPadding + logContainerWidth + containerSpacing + endingImageWidth
    }
}
