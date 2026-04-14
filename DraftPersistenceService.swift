//
//  DraftPersistenceService.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//


import Foundation

struct DraftPersistenceService {
    private let fileName = "active_draft.json"

    /// Loads the active bouquet draft from local JSON storage.
    func loadDraft() -> BouquetDraft? {
        let url = fileURL()

        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(BouquetDraft.self, from: data)
        } catch {
            print("Failed to load active draft: \(error)")
            return nil
        }
    }

    /// Saves the active bouquet draft to local JSON storage.
    func saveDraft(_ draft: BouquetDraft) {
        do {
            let data = try JSONEncoder().encode(draft)
            try data.write(to: fileURL(), options: [.atomic])
        } catch {
            print("Failed to save active draft: \(error)")
        }
    }

    /// Removes the active draft from local JSON storage.
    func clearDraft() {
        let url = fileURL()

        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to clear active draft: \(error)")
        }
    }

    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
}