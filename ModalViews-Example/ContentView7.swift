//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

@Observable
final class BannerPresenter7 {
    private(set) var items = [BannerItem7]()

    func dismiss() {
        guard !items.isEmpty else { return }
        items.removeFirst()
    }

    // Added ability to show item.
    func showBanner(withLabel label: LocalizedStringKey) {
        items.append(.init(label: label))
    }
}

struct BannerItem7: Equatable {
    let label: LocalizedStringKey
}

struct BannerContainer7: ViewModifier {
    @State private var presenter = BannerPresenter7()

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay(alignment: .bottom) {
                if let item = presenter.items.first {
                    Banner7(
                        label: item.label,
                        onDismiss: {
                            presenter.dismiss()
                        }
                    )
                }
            }
            .animation(.spring, value: presenter.items)
            .environment(presenter)
    }
}

// Modifier accesses presenter from the environment
// and shows the banner in the fire-and-forget fashion.
struct ShowBannerModifier7<Trigger: Equatable>: ViewModifier {
    let label: LocalizedStringKey
    let trigger: Trigger

    @Environment(BannerPresenter7.self) 
    private var presenter: BannerPresenter7

    func body(content: Content) -> some View {
        content.onChange(of: trigger) {
            presenter.showBanner(withLabel: label)
        }
    }
}

extension View {
    // Convenience method.
    func banner7(label: LocalizedStringKey, trigger: some Equatable) -> some View {
        modifier(ShowBannerModifier7(label: label, trigger: trigger))
    }
}

struct Banner7: View {
    let label: LocalizedStringKey
    let onDismiss: () -> Void

    var body: some View {
        Text(label)
            .padding()
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .transition(
                AnyTransition.move(edge: .bottom)
                    .combined(with: .opacity)
            )
            .task {
                try? await Task.sleep(for: .seconds(5))
                onDismiss()
            }
    }
}

// MARK: - ContentView

struct ContentView7: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section7()
        }
        .modifier(BannerContainer7())
    }
}

struct Section7: View {
    @State private var showBanner1 = false
    @State private var showBanner2 = false

    var body: some View {
        VStack {
            Button("Show banner") {
                guard !showBanner1 else { return }
                showBanner1 = true
            }
            Button("Show banner 2") {
                guard !showBanner2 else { return }
                showBanner2 = true
            }
        }
        .buttonStyle(
            .borderedProminent
        )
    }
}
