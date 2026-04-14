//
//  BouquetCanvasItemView.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//

import SwiftUI

struct BouquetCanvasItemView: View {
    let element: BouquetElement
    let flower: FlowerDefinition

    var body: some View {
        Text(flower.displayName)
            .font(font)
            .fontWeight(.medium)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var backgroundColor: Color {
        switch element.role {
        case .mainFlower:
            return .yellow.opacity(0.35)
        case .companionFlower:
            return .blue.opacity(0.22)
        case .accentFlower:
            return .purple.opacity(0.22)
        case .supportingGreenery:
            return .green.opacity(0.22)
        case .trailingElement:
            return .brown.opacity(0.18)
        }
    }

    private var font: Font {
        switch element.role {
        case .mainFlower:
            return .body
        case .companionFlower:
            return .body
        case .accentFlower:
            return .subheadline
        case .supportingGreenery:
            return .subheadline
        case .trailingElement:
            return .subheadline
        }
    }

    private var horizontalPadding: CGFloat {
        switch element.role {
        case .mainFlower:
            return 16
        case .companionFlower:
            return 14
        case .accentFlower:
            return 12
        case .supportingGreenery:
            return 16
        case .trailingElement:
            return 14
        }
    }

    private var verticalPadding: CGFloat {
        switch element.role {
        case .mainFlower:
            return 10
        case .companionFlower:
            return 9
        case .accentFlower:
            return 8
        case .supportingGreenery:
            return 8
        case .trailingElement:
            return 7
        }
    }

    private var cornerRadius: CGFloat {
        switch element.role {
        case .mainFlower:
            return 16
        case .companionFlower:
            return 15
        case .accentFlower:
            return 14
        case .supportingGreenery:
            return 16
        case .trailingElement:
            return 14
        }
    }
}
