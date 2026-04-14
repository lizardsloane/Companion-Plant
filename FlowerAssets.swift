//
//  FlowerAssets.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//


import Foundation

/// The reusable asset family for a single flower.
///
/// `FlowerAssets` holds the visual references for:
/// - the simplified sketch shown in picker/bucket view
/// - each supported bloom-state render used in refinement, draft display,
///   and final artifact rendering
///
/// Important:
/// This type only stores asset references.
/// It does not load images, apply rendering rules, or contain any UI-specific logic.
struct FlowerAssets: Codable, Equatable {
    /// Simplified sketch used in flower picker / bucket view.
    ///
    /// This keeps browsing visually calm and readable.
    let sketch: String

    /// Asset used when the flower is shown in its bud state.
    let bud: String

    /// Asset used when the flower is shown in its bloom state.
    let bloom: String

    /// Asset used when the flower is shown in its wilted state.
    let wilted: String

    /// Asset used when the flower is shown in its pressed / preserved state.
    let pressed: String

    init(
        sketch: String,
        bud: String,
        bloom: String,
        wilted: String,
        pressed: String
    ) {
        self.sketch = sketch
        self.bud = bud
        self.bloom = bloom
        self.wilted = wilted
        self.pressed = pressed
    }
}
