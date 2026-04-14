# Companion Plant

Companion Plant is a symbolic emotional communication app that helps users build floral artifacts and preserve them in a personal archive without forcing direct language or interpretation.

## Overview

Companion Plant was designed around a simple question: how can someone express something meaningful when direct language is difficult, exhausting, or too exposing?

Instead of requiring full written disclosure, the app lets users compose bouquets step by step using symbolic floral elements. Those bouquets can then be preserved as personal artifacts in an archive. The goal is not to interpret the user for them, but to give them a structured, non-coercive way to build and keep meaning on their own terms.

The app prioritizes:

- user agency
- low cognitive load
- guided but non-coercive interaction
- symbolic expression without forced explanation
- clean, disciplined implementation

## Current MVP Features

- Guided bouquet creation using role-based composition
- One active draft saved locally
- Resume Draft flow from the home screen
- Finalize a bouquet into an archived artifact
- Local JSON persistence for:
  - one active draft
  - many archived artifacts
- Archive list view
- Archive detail view for finalized bouquets
- Undo support during bouquet building
- Duplicate flower filtering within a bouquet

## Technical Approach

Companion Plant uses a constrained composition system rather than freeform drag-and-drop.

Flowers are selected into bouquet roles such as:

- Main Flower
- Companion Flower
- Accent Flower
- Supporting Greenery
- Trailing Element

This structure is used to reduce overwhelm, preserve clarity, and keep bouquet rendering stable.

Core implementation ideas include:

- Separate mutable `BouquetDraft` and immutable `ArchivedBouquetArtifact` models
- A flower registry backed by structured asset families
- Role-based bouquet composition rules
- Guided progression before renderability, optional refinement afterward
- Local JSON persistence for archived artifacts and one active draft
- SwiftUI-based state-driven UI

## Architecture Notes

The current MVP separates concerns into a few core concepts:

- `FlowerDefinition`  
  Registry entry describing what a flower is, what it means, what roles it can fill, and which assets belong to it

- `BouquetElement`  
  A selected flower instance inside one bouquet draft

- `BouquetDraft`  
  A mutable bouquet-in-progress

- `ArchivedBouquetArtifact`  
  A finalized, preserved bouquet record

- Persistence Services  
  Local JSON save/load services for archive artifacts and one active draft

This structure is meant to keep the app understandable, extensible, and easy to reason about during development.

## Status

This project is currently in active MVP development.

### Implemented

- Home placeholder flow
- Bouquet builder core logic
- Guided role progression
- Optional refinement after renderability
- Save Draft flow
- Resume Draft flow
- Replace Existing Draft confirmation
- Finalize flow
- Archive list and detail views
- Local JSON persistence

### In Progress

- Builder layout refinement
- Archive visual refinement
- Asset integration
- Title field interaction polish
- Error handling expansion

## Running the App

1. Open the project in Xcode
2. Select an iPhone simulator
3. Build and run

Current development target:

- SwiftUI
- iOS simulator

## Persistence

The MVP uses local JSON serialization instead of cloud storage.

Current persisted data:

- one active draft
- archived bouquet artifacts

This was chosen intentionally to keep the system simple, inspectable, and easy to debug while the data model is still evolving.

## Design Principles

Companion Plant is guided by a few core design rules:

- preserve user agency
- reduce overwhelm through sequencing
- avoid forced interpretation
- separate draft state from preserved artifact state
- prefer clean, understandable systems over unnecessary complexity

## Planned Improvements

- Refined visual asset integration
- Bloom-state support
- Expanded flower registry
- More polished archive presentation
- Improved keyboard/title interaction
- Shared bouquet canvas rendering helpers
- Cloud sync in a later version

## Screenshots

Screenshots will be added as the UI stabilizes.

## Project Focus

This project is part product design, part interaction design, and part application architecture. The goal is not just to build a working app, but to build one that respects the user’s pace, intent, and ownership of meaning.
