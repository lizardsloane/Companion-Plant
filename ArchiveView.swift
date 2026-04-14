//
//  ArchiveView.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//

import SwiftUI

struct ArchiveView: View {
    let artifacts: [ArchivedBouquetArtifact]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if artifacts.isEmpty {
                    Text("No archived bouquets yet.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 12)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(artifacts.enumerated()), id: \.element.id) { index, artifact in
                            NavigationLink {
                                ArchiveDetailView(artifact: artifact)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue.opacity(0.08))

                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(artifact.title)
                                                .font(.headline)
                                                .foregroundStyle(.primary)

                                            Text(formattedDate(artifact.createdAt))
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 20)
                                }
                                .contentShape(Rectangle())
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            if index < artifacts.count - 1 {
                                Divider()
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.green.opacity(0.18))
                            .background(Color.orange.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.green.opacity(0.35), lineWidth: 1)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Archive")
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
