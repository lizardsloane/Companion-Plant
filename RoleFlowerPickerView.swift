//
//  RoleFlowerPickerView.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//

import SwiftUI

struct RoleFlowerPickerView: View {
    let role: BouquetRole
    let flowers: [FlowerDefinition]
    let onSelect: (FlowerDefinition) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(role.displayName)
                .font(.headline)

            if flowers.isEmpty {
                Text("No flowers available for this role yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(flowers) { flower in
                    Button {
                        onSelect(flower)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(flower.displayName)
                                    .font(.body)
                                    .foregroundStyle(.primary)

                                Text(flower.meaningTags.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
