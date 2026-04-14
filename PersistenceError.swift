//
//  PersistenceError.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/2/26.
//


import Foundation

enum PersistenceError: LocalizedError {
    case fileNotFound
    case failedToLoad(underlying: Error)
    case failedToDecode(underlying: Error)
    case failedToEncode(underlying: Error)
    case failedToSave(underlying: Error)
    case failedToDelete(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "No saved file was found."

        case .failedToLoad:
            return "The saved data could not be loaded."

        case .failedToDecode:
            return "The saved data could not be read."

        case .failedToEncode:
            return "The data could not be prepared for saving."

        case .failedToSave:
            return "The data could not be saved."

        case .failedToDelete:
            return "The saved data could not be deleted."
        }
    }
}