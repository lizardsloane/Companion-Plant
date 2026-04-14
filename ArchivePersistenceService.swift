//
//  ArchivePersistenceService.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//


import Foundation

struct ArchivePersistenceService {
    private let fileName = "archived_artifacts.json"

    /// Loads archived bouquet artifacts from local JSON storage.
    func loadArtifacts() -> [ArchivedBouquetArtifact] {
        let url = fileURL()

        guard FileManager.default.fileExists(atPath: url.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([ArchivedBouquetArtifact].self, from: data)
        } catch {
            print("Failed to load archived artifacts: \(error)")
            return []
        }
    }

    /// Saves archived bouquet artifacts to local JSON storage.
    func saveArtifacts(_ artifacts: [ArchivedBouquetArtifact]) {
        do {
            let data = try JSONEncoder().encode(artifacts)
            try data.write(to: fileURL(), options: [.atomic])
        } catch {
            print("Failed to save archived artifacts: \(error)")
        }
    }

    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
}