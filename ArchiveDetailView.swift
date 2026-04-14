//
//  ArchiveDetailView.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//


import SwiftUI

struct ArchiveDetailView: View {
    let artifact: ArchivedBouquetArtifact

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(artifact.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(formattedDate(artifact.createdAt))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.green.opacity(0.12))
                .frame(height: 280)
                .overlay {
                    GeometryReader { geo in
                        ZStack {
                            Text("Archived Bouquet")
                                .font(.headline)
                                .position(x: geo.size.width * 0.5, y: 24)

                            ForEach(artifact.elements) { element in
                                if let flower = MockFlowerRegistry.flower(withID: element.flowerID) {
                                    BouquetCanvasItemView(
                                        element: element,
                                        flower: flower
                                    )
                                    .position(
                                        canvasPosition(
                                            for: element.role,
                                            in: geo.size
                                        )
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                }

            Spacer()
        }
        .padding()
        .navigationTitle("Bouquet")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    private func canvasPosition(for role: BouquetRole, in size: CGSize) -> CGPoint {
        switch role {
        case .mainFlower:
            return CGPoint(x: size.width * 0.56, y: size.height * 0.50)

        case .companionFlower:
            return CGPoint(x: size.width * 0.24, y: size.height * 0.46)

        case .accentFlower:
            return CGPoint(x: size.width * 0.72, y: size.height * 0.30)

        case .supportingGreenery:
            return CGPoint(x: size.width * 0.50, y: size.height * 0.74)

        case .trailingElement:
            return CGPoint(x: size.width * 0.74, y: size.height * 0.84)
        }
    }
}