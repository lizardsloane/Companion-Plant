import SwiftUI

struct AppView: View {
    @State private var archivedArtifacts: [ArchivedBouquetArtifact] = []
    @State private var activeDraft: BouquetDraft?
    @State private var persistenceErrorMessage: String?

    private let archivePersistence = ArchivePersistenceService()
    private let draftPersistence = DraftPersistenceService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Home Placeholder")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text(homeStatusText)
                    .foregroundStyle(.secondary)

                NavigationLink("Create Bouquet") {
                    BouquetBuilderView(
                        initialDraft: nil,
                        hasExistingSavedDraft: activeDraft != nil,
                        onSaveDraft: { draft in
                            activeDraft = draft
                            draftPersistence.saveDraft(draft)
                        },
                        onFinalize: { artifact in
                            archivedArtifacts.insert(artifact, at: 0)

                            switch archivePersistence.saveArtifacts(archivedArtifacts) {
                            case .success:
                                break
                            case .failure(let error):
                                persistenceErrorMessage = error.localizedDescription
                            }

                            activeDraft = nil
                            draftPersistence.clearDraft()
                        }
                    )
                }
                .buttonStyle(.borderedProminent)

                if let activeDraft {
                    NavigationLink("Resume Draft") {
                        BouquetBuilderView(
                            initialDraft: activeDraft,
                            hasExistingSavedDraft: true,
                            onSaveDraft: { draft in
                                self.activeDraft = draft
                                draftPersistence.saveDraft(draft)
                            },
                            onFinalize: { artifact in
                                archivedArtifacts.insert(artifact, at: 0)

                                switch archivePersistence.saveArtifacts(archivedArtifacts) {
                                case .success:
                                    break
                                case .failure(let error):
                                    persistenceErrorMessage = error.localizedDescription
                                }

                                self.activeDraft = nil
                                draftPersistence.clearDraft()
                            }
                        )
                    }
                    .buttonStyle(.bordered)
                }

                NavigationLink("Archive") {
                    ArchiveView(artifacts: archivedArtifacts)
                }
                .buttonStyle(.bordered)

                if !archivedArtifacts.isEmpty {
                    VStack(spacing: 8) {
                        Text("Artifacts saved: \(archivedArtifacts.count)")
                            .font(.headline)

                        Text("Most recent: \(archivedArtifacts[0].title)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
            .onAppear {
                switch archivePersistence.loadArtifacts() {
                case .success(let artifacts):
                    archivedArtifacts = artifacts
                case .failure(let error):
                    archivedArtifacts = []
                    persistenceErrorMessage = error.localizedDescription
                }

                activeDraft = draftPersistence.loadDraft()
            }
        }
        .alert("Persistence Error", isPresented: Binding(
            get: { persistenceErrorMessage != nil },
            set: { if !$0 { persistenceErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(persistenceErrorMessage ?? "An unknown persistence error occurred.")
        }
    }

    private var homeStatusText: String {
        if let activeDraft {
            return "Active draft: \(activeDraft.title.isEmpty ? "Untitled Bouquet" : activeDraft.title)"
        }

        guard let mostRecent = archivedArtifacts.first else {
            return "No bouquet finalized yet"
        }

        return "Finalized: \(mostRecent.title)"
    }
}
