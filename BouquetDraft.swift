//
//  BouquetDraft.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 3/31/26.
//
import Foundation

/// A mutable bouquet-in-progress.
///
/// `BouquetDraft` is the live composition object used while the user is building
/// a bouquet. It is intentionally separate from finalized archived artifacts.
///
/// A draft is allowed to be:
/// - incomplete
/// - editable
/// - saveable only after it has real confirmed content
///
/// A finalized artifact is handled elsewhere and is non-mutable in MVP.
struct BouquetDraft: Identifiable, Codable, Equatable {
    /// Unique identifier for this specific bouquet draft.
    let id: UUID

    /// User-editable bouquet title.
    ///
    /// This may remain empty during early composition and be refined later.
    var title: String

    /// All confirmed bouquet elements currently in the draft.
    ///
    /// These are runtime composition choices, not flower registry entries.
    var elements: [BouquetElement]

    init(
        id: UUID = UUID(),
        title: String = "",
        elements: [BouquetElement] = []
    ) {
        self.id = id
        self.title = title
        self.elements = elements
    }

    /// A draft only counts as having real saveable content once at least one
    /// flower has been confirmed into the bouquet draft canvas.
    ///
    /// Browsing or previewing flowers alone should not create a saveable draft.
    var hasCommittedContent: Bool {
        !elements.isEmpty
    }

    /// The set of bouquet roles currently filled by confirmed elements.
    ///
    /// Useful for:
    /// - guided next-step logic
    /// - renderability checks
    /// - UI state (filled vs unfilled roles)
    var filledRoles: Set<BouquetRole> {
        Set(elements.map(\.role))
    }

    /// All flower IDs currently used in this bouquet draft.
    ///
    /// MVP rule:
    /// - each flower type may appear only once per bouquet
    /// - later role pickers should exclude flowers already used in the draft
    /// 
    var usedFlowerIDs: Set<String> {
        Set(elements.map(\.flowerID))
    }

    /// Returns the first unfilled bouquet role in guided selection order.
    ///
    /// This supports the step-by-step bouquet creation flow.
    var nextUnfilledRole: BouquetRole? {
        BouquetRole.ordered.first { !containsElement(for: $0) }
    }
    /// Optional bouquet roles that are still unfilled.
    var unfilledOptionalRoles: [BouquetRole] {
        BouquetRole.ordered.filter { role in
            !role.isRequiredForMinimumRenderableBouquet &&
            !containsElement(for: role)
        }
    }

    /// The most recently filled role in guided selection order.
    ///
    /// Since MVP only allows one element per role, the "last" role is simply the
    /// filled role with the highest selection order.
    var lastFilledRole: BouquetRole? {
        filledRoles.max(by: { $0.selectionOrder < $1.selectionOrder })
    }

    /// MVP renderability rule:
    /// - Main Flower required
    /// - Companion Flower required
    /// - At least one additional supporting role required
    ///
    /// This is kept here for now because the logic is still small.
    /// If render rules become more complex later, this can move into a dedicated evaluator.
    var isRenderable: Bool {
        let hasMain = containsElement(for: .mainFlower)
        let hasCompanion = containsElement(for: .companionFlower)
        let hasSupportingRole =
            containsElement(for: .accentFlower) ||
            containsElement(for: .supportingGreenery) ||
            containsElement(for: .trailingElement)

        return hasMain && hasCompanion && hasSupportingRole
    }

    /// Returns whether the draft already contains a confirmed element for a given role.
    func containsElement(for role: BouquetRole) -> Bool {
        elements.contains { $0.role == role }
    }

    /// Returns whether the draft already contains a given flower type.
    func containsFlower(withID flowerID: String) -> Bool {
        usedFlowerIDs.contains(flowerID)
    }

    /// Returns the currently assigned element for a given role, if one exists.
    func element(for role: BouquetRole) -> BouquetElement? {
        elements.first { $0.role == role }
    }
    /// Converts this mutable draft into a preserved archived artifact.
    ///
    /// This should only be called when the bouquet is renderable.
    func finalizedArtifact() -> ArchivedBouquetArtifact? {
        guard isRenderable else { return nil }

        return ArchivedBouquetArtifact(
            sourceDraftID: id,
            title: title.isEmpty ? "Untitled Bouquet" : title,
            elements: elements
        )
    }

    /// Sets or replaces the element for a given bouquet role.
    ///
    /// MVP rule:
    /// - only one confirmed flower may occupy a given role at a time
    /// - assigning a new element to an already-filled role replaces the old one
    ///
    /// Elements are kept sorted by `BouquetRole.selectionOrder` so the draft remains
    /// predictable and easier to inspect/debug.
    mutating func setElement(_ element: BouquetElement) {
        elements.removeAll { $0.role == element.role }
        elements.append(element)
        elements.sort { $0.role.selectionOrder < $1.role.selectionOrder }
    }

    /// Removes the currently assigned element for a given role, if one exists.
    ///
    /// This supports revision/backtracking during bouquet composition.
    mutating func removeElement(for role: BouquetRole) {
        elements.removeAll { $0.role == role }
    }

    /// Removes the most recently filled role, if one exists.
    ///
    /// This supports a simple MVP undo flow for guided bouquet composition.
    mutating func undoLastSelection() {
        guard let lastRole = lastFilledRole else { return }
        removeElement(for: lastRole)
    }
}
