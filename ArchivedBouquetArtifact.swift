//
//  ArchivedBouquetArtifact.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//


import Foundation

/// A finalized, preserved bouquet artifact.
///
/// Unlike `BouquetDraft`, an archived artifact is no longer mutable in MVP.
/// It represents the kept version of a bouquet after the user chooses to finalize it.
struct ArchivedBouquetArtifact: Identifiable, Codable, Equatable {
    /// Unique identifier for this preserved artifact.
    let id: UUID

    /// The original draft ID this artifact came from.
    ///
    /// Useful for traceability during development, even if draft editing is not supported.
    let sourceDraftID: UUID

    /// Final preserved title.
    let title: String

    /// The finalized bouquet elements kept with the artifact.
    let elements: [BouquetElement]

    /// When the artifact was created.
    let createdAt: Date

    init(
        id: UUID = UUID(),
        sourceDraftID: UUID,
        title: String,
        elements: [BouquetElement],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sourceDraftID = sourceDraftID
        self.title = title
        self.elements = elements
        self.createdAt = createdAt
    }
}