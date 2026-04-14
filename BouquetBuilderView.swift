//
//  BouquetBuilderView.swift
//  Companion_Plant_V2
//
//  Created by Lizard on 4/1/26.
//
import SwiftUI

struct BouquetBuilderView: View {
    let initialDraft: BouquetDraft?
    let hasExistingSavedDraft: Bool
    let onSaveDraft: (BouquetDraft) -> Void
    let onFinalize: (ArchivedBouquetArtifact) -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool

    @State private var draft: BouquetDraft
    @State private var hasFinalized = false
    @State private var showReplaceDraftAlert = false

    init(
        initialDraft: BouquetDraft? = nil,
        hasExistingSavedDraft: Bool = false,
        onSaveDraft: @escaping (BouquetDraft) -> Void,
        onFinalize: @escaping (ArchivedBouquetArtifact) -> Void
    ) {
        self.initialDraft = initialDraft
        self.hasExistingSavedDraft = hasExistingSavedDraft
        self.onSaveDraft = onSaveDraft
        self.onFinalize = onFinalize
        _draft = State(initialValue: initialDraft ?? BouquetDraft())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bouquet Title")
                        .font(.headline)

                    TextField("Untitled Bouquet", text: $draft.title)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .focused($isTitleFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            isTitleFieldFocused = false
                        }

                    if draft.isRenderable {
                        Text("Bouquet is ready to finalize")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else if let nextRole = draft.nextUnfilledRole {
                        Text("Next: \(nextRole.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.green.opacity(0.12))
                    .frame(height: 280)
                    .overlay {
                        GeometryReader { geo in
                            ZStack {
                                Text("Bouquet Canvas")
                                    .font(.headline)
                                    .position(x: geo.size.width * 0.5, y: 24)

                                if draft.elements.isEmpty {
                                    Text("No flowers added yet")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .position(
                                            x: geo.size.width * 0.5,
                                            y: geo.size.height * 0.5
                                        )
                                } else {
                                    ForEach(draft.elements) { element in
                                        if let flower = MockFlowerRegistry.flower(withID: element.flowerID) {
                                            BouquetCanvasItemView(
                                                element: element,
                                                flower: flower
                                            )
                                            .position(
                                                canvasPosition(
                                                    for: element.role,
                                                    in: geo.size
                                                )
                                            )
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .padding()
                    }

                if !draft.isRenderable, let nextRole = draft.nextUnfilledRole {
                    RoleFlowerPickerView(
                        role: nextRole,
                        flowers: MockFlowerRegistry.flowers(
                            for: nextRole,
                            excluding: draft.usedFlowerIDs
                        ),
                        onSelect: { flower in
                            hasFinalized = false
                            let element = BouquetElement(
                                flowerID: flower.id,
                                role: nextRole
                            )
                            draft.setElement(element)
                        }
                    )
                }

                if draft.isRenderable {
                    let refinementRoles = availableRefinementRoles()

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Optional Refinement")
                            .font(.headline)

                        if refinementRoles.isEmpty {
                            Text("Your bouquet is complete. You can finalize it now or keep refining later.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("You can finalize now, or add another element if you'd like.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            ForEach(refinementRoles) { role in
                                RoleFlowerPickerView(
                                    role: role,
                                    flowers: MockFlowerRegistry.flowers(
                                        for: role,
                                        excluding: draft.usedFlowerIDs
                                    ),
                                    onSelect: { flower in
                                        hasFinalized = false
                                        let element = BouquetElement(
                                            flowerID: flower.id,
                                            role: role
                                        )
                                        draft.setElement(element)
                                    }
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if draft.hasCommittedContent {
                    Button("Save Draft") {
                        let isEditingExistingDraft = initialDraft != nil

                        if hasExistingSavedDraft && !isEditingExistingDraft {
                            showReplaceDraftAlert = true
                        } else {
                            onSaveDraft(draft)
                            dismiss()
                        }
                    }
                    .buttonStyle(.bordered)
                }

                if draft.isRenderable {
                    Button("Finalize Bouquet") {
                        guard let artifact = draft.finalizedArtifact() else { return }
                        hasFinalized = true
                        onFinalize(artifact)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }

                Button("Undo Last Selection") {
                    hasFinalized = false
                    draft.undoLastSelection()
                }
                .disabled(draft.elements.isEmpty)
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Create Bouquet")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .simultaneousGesture(
            TapGesture().onEnded {
                isTitleFieldFocused = false
            }
        )
        .alert("Replace Existing Draft?", isPresented: $showReplaceDraftAlert) {
            Button("Replace Existing Draft", role: .destructive) {
                onSaveDraft(draft)
                dismiss()
            }

            Button("Return to Bouquet", role: .cancel) { }
        } message: {
            Text("There is already a saved draft. Replacing it will remove the previous draft.")
        }
    }

    private func canvasPosition(for role: BouquetRole, in size: CGSize) -> CGPoint {
        switch role {
        case .mainFlower:
            return CGPoint(x: size.width * 0.56, y: size.height * 0.50)

        case .companionFlower:
            return CGPoint(x: size.width * 0.24, y: size.height * 0.46)

        case .accentFlower:
            return CGPoint(x: size.width * 0.72, y: size.height * 0.30)

        case .supportingGreenery:
            return CGPoint(x: size.width * 0.50, y: size.height * 0.74)

        case .trailingElement:
            return CGPoint(x: size.width * 0.74, y: size.height * 0.84)
        }
    }

    private func availableRefinementRoles() -> [BouquetRole] {
        draft.unfilledOptionalRoles.filter { role in
            !MockFlowerRegistry.flowers(
                for: role,
                excluding: draft.usedFlowerIDs
            ).isEmpty
        }
    }
}
