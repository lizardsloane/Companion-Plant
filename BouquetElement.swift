//
//  BouquetElement.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//


import Foundation

/// A single selected flower inside a specific bouquet draft.
///
/// `BouquetElement` is a runtime composition object, not a flower library entry.
/// It represents one confirmed user choice assigned to one bouquet role.
///
/// MVP note:
/// - One element per role is enforced at the `BouquetDraft` level.
/// - Bloom state and color variants will be added later.
struct BouquetElement: Identifiable, Codable, Equatable {
    let id: UUID

    /// References the stable `FlowerDefinition.id` from the flower registry.
    let flowerID: String

    /// The bouquet role this selected flower is currently filling.
    let role: BouquetRole

    init(
        id: UUID = UUID(),
        flowerID: String,
        role: BouquetRole
    ) {
        self.id = id
        self.flowerID = flowerID
        self.role = role
    }
}