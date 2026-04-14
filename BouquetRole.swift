//
//  BouquetRole.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//

import Foundation

/// The user-facing composition roles available in a bouquet.
///
/// `BouquetRole` defines:
/// - which parts a bouquet is made from
/// - the order those parts are introduced during guided composition
/// - which roles are required for a minimally renderable bouquet in MVP
///
/// Important:
/// This enum describes *composition meaning*, not renderer coordinates.
/// Placement, scale, layering, and slot behavior belong in render logic elsewhere.
enum BouquetRole: String, CaseIterable, Codable, Identifiable {
    case mainFlower
    case companionFlower
    case accentFlower
    case supportingGreenery
    case trailingElement

    var id: String { rawValue }

    /// Human-readable role name shown in the UI.
    ///
    /// These names should stay bouquet-based and understandable to the user.
    /// Avoid exposing internal renderer terminology like "slot" or "zone."
    var displayName: String {
        switch self {
        case .mainFlower:
            return "Main Flower"
        case .companionFlower:
            return "Companion Flower"
        case .accentFlower:
            return "Accent Flower"
        case .supportingGreenery:
            return "Supporting Greenery"
        case .trailingElement:
            return "Trailing Element"
        }
    }

    /// The guided selection order used during bouquet creation.
    ///
    /// MVP flow:
    /// 1. Main Flower
    /// 2. Companion Flower
    /// 3. Remaining supporting roles
    ///
    /// This order helps reduce overwhelm without removing agency.
    var selectionOrder: Int {
        switch self {
        case .mainFlower:
            return 0
        case .companionFlower:
            return 1
        case .accentFlower:
            return 2
        case .supportingGreenery:
            return 3
        case .trailingElement:
            return 4
        }
    }

    /// Whether this role is required for the minimum renderable bouquet in MVP.
    ///
    /// Current MVP renderability rule:
    /// - Main Flower required
    /// - Companion Flower required
    /// - At least one additional supporting role required
    ///
    /// So this property only marks the always-required roles.
    /// Full renderability is still evaluated elsewhere.
    var isRequiredForMinimumRenderableBouquet: Bool {
        switch self {
        case .mainFlower, .companionFlower:
            return true
        case .accentFlower, .supportingGreenery, .trailingElement:
            return false
        }
    }

    /// All roles sorted by their guided composition order.
    static var ordered: [BouquetRole] {
        allCases.sorted { $0.selectionOrder < $1.selectionOrder }
    }
}
