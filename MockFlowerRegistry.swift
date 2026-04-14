//
//  MockFlowerRegistry.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//


import Foundation

/// Temporary in-memory flower registry used during early development.
///
/// `MockFlowerRegistry` exists to:
/// - prove the model structure
/// - test role bucket filtering
/// - test companion suggestions
/// - let the bouquet flow work before the full flower dictionary is built
///
/// This is intentionally small and incomplete.
/// It should be replaced later by a real registry source or loader.
enum MockFlowerRegistry {
    /// A tiny starter flower set used to prove the bouquet system.
    ///
    /// Current goals:
    /// - at least one strong focal flower
    /// - at least one companion / accent-capable flower
    /// - at least one greenery/support plant
    static let flowers: [FlowerDefinition] = [
        FlowerDefinition(
            id: "Sunflower",
            displayName: "Sunflower",
            meaningTags: ["hope", "warmth", "steadiness"],
            compatibleRoles: [.mainFlower],
            companionPlantIDs: ["chamomile"],
            assets: FlowerAssets(
                sketch: "flowers/sunflower/sketch",
                bud: "flowers/sunflower/bud",
                bloom: "flowers/sunflower/bloom",
                wilted: "flowers/sunflower/wilted",
                pressed: "flowers/sunflower/pressed"
            )
        ),
        FlowerDefinition(
            id: "Chamomile",
            displayName: "Chamomile",
            meaningTags: ["comfort", "rest", "gentleness"],
            compatibleRoles: [.companionFlower, .accentFlower],
            companionPlantIDs: ["sunflower"],
            assets: FlowerAssets(
                sketch: "flowers/chamomile/sketch",
                bud: "flowers/chamomile/bud",
                bloom: "flowers/chamomile/bloom",
                wilted: "flowers/chamomile/wilted",
                pressed: "flowers/chamomile/pressed"
            )
        ),
        FlowerDefinition(
            id: "Fern",
            displayName: "Fern",
            meaningTags: ["shelter", "protection", "quiet growth"],
            compatibleRoles: [.supportingGreenery],
            companionPlantIDs: [],
            assets: FlowerAssets(
                sketch: "flowers/fern/sketch",
                bud: "flowers/fern/bud",
                bloom: "flowers/fern/bloom",
                wilted: "flowers/fern/wilted",
                pressed: "flowers/fern/pressed"
            )
        ),
        
        FlowerDefinition(
            id: "Lavender",
            displayName: "Lavender",
            meaningTags: ["calm", "devotion", "quiet strength"],
            compatibleRoles: [.companionFlower, .accentFlower],
            companionPlantIDs: ["sunflower", "chamomile"],
            assets: FlowerAssets(
                sketch: "flowers/lavender/sketch",
                bud: "flowers/lavender/bud",
                bloom: "flowers/lavender/bloom",
                wilted: "flowers/lavender/wilted",
                pressed: "flowers/lavender/pressed"
            )
        )
    ]

    /// Returns all currently enabled flowers that can occupy the requested bouquet role.
    ///
    /// This is the simplest possible role-bucket filter for early development.
    /// Later, the real registry may add:
    /// - search
    /// - sorting
    /// - more nuanced companion suggestion layering
    /// - phased content enablement
    static func flowers(for role: BouquetRole) -> [FlowerDefinition] {
        flowers.filter { $0.isMVPEnabled && $0.compatibleRoles.contains(role) }
    }

    /// Returns one flower by its stable registry ID.
    ///
    /// Useful when turning a `BouquetElement.flowerID` back into a full registry definition.
    static func flower(withID id: String) -> FlowerDefinition? {
        flowers.first { $0.id == id }
    }
    
    static func flowers(for role: BouquetRole, excluding usedFlowerIDs: Set<String>) -> [FlowerDefinition] {
        flowers.filter {
            $0.isMVPEnabled &&
            $0.compatibleRoles.contains(role) &&
            !usedFlowerIDs.contains($0.id)
        }
    }
}
