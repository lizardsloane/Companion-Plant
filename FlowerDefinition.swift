//
//  FlowerDefinition.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//

import Foundation

/// A flower registry entry.
///
/// `FlowerDefinition` describes what a flower *is* inside Companion Plant:
/// - how it is named
/// - what meanings it carries
/// - which bouquet roles it can fill
/// - which companion suggestions it can surface
/// - which asset family belongs to it
///
/// Important:
/// This is registry data, not runtime bouquet state.
/// User-specific choices like selected role occupancy, bloom state, or draft placement
/// belong in bouquet models such as `BouquetElement` and `BouquetDraft`.
struct FlowerDefinition: Identifiable, Codable, Equatable {
    /// Stable internal identifier used for lookup, linking, and asset references.
    ///
    /// This should remain boring and stable over time.
    /// Example: "sunflower", "chamomile", "fern"
    let id: String

    /// Human-readable flower name shown in the UI.
    let displayName: String

    /// Core symbolic meanings associated with this flower.
    ///
    /// These support:
    /// - search
    /// - lightweight symbolic guidance
    /// - future filtering if needed
    ///
    /// Keep these curated and concise.
    let meaningTags: [String]

    /// The bouquet roles this flower can legally occupy.
    ///
    /// This is one of the main safeguards against render jank.
    /// A flower should only be allowed in roles where it works visually and symbolically.
    let compatibleRoles: [BouquetRole]

    /// IDs of flowers that may be surfaced as companion suggestions.
    ///
    /// This supports the companion-plant guidance layer, but does not restrict the user
    /// to those flowers only.
    let companionPlantIDs: [String]

    /// The asset family used for picker sketches and rendered bouquet states.
    let assets: FlowerAssets

    /// Controls whether this flower is currently enabled for the MVP experience.
    ///
    /// This allows the registry to contain future flowers without surfacing them yet.
    let isMVPEnabled: Bool

    init(
        id: String,
        displayName: String,
        meaningTags: [String],
        compatibleRoles: [BouquetRole],
        companionPlantIDs: [String] = [],
        assets: FlowerAssets,
        isMVPEnabled: Bool = true
    ) {
        self.id = id
        self.displayName = displayName
        self.meaningTags = meaningTags
        self.compatibleRoles = compatibleRoles
        self.companionPlantIDs = companionPlantIDs
        self.assets = assets
        self.isMVPEnabled = isMVPEnabled
    }
}
