//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

@Observable
final class BannerPresenter9 {
    private(set) var items = [BannerItem9]()
    private var counter = 0

    func dismiss() {
        guard !items.isEmpty else { return }
        items.removeFirst()
    }

    func showBanner(withLabel label: LocalizedStringKey) {
        // Creating a stable identity.
        counter += 1
        items.append(.init(label: label, id: counter))
    }
}

struct BannerItem9: Equatable, Identifiable {
    let label: LocalizedStringKey
    let id: Int
}

struct BannerContainer9: ViewModifier {
    @State private var presenter = BannerPresenter9()
    @State private var index = 0

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay(alignment: .bottom) {
                if let item = presenter.items.first {
                    Banner9(
                        label: item.label,
                        onDismiss: {
                            presenter.dismiss()
                            print("dismissed \(item.id)")
                        }
                    )
                    // With unique ids SwiftUI knows how to transition views in and out.
                    .id(item.id)
                }
            }
            .animation(.spring, value: presenter.items)
            .environment(presenter)
    }
}

struct ShowBannerModifier9<Trigger: Equatable>: ViewModifier {
    let label: LocalizedStringKey
    let trigger: Trigger

    @Environment(BannerPresenter9.self)
    private var presenter: BannerPresenter9

    func body(content: Content) -> some View {
        content.onChange(of: trigger) {
            presenter.showBanner(withLabel: label)
        }
    }
}

extension View {
    func banner9(label: LocalizedStringKey, trigger: some Equatable) -> some View {
        modifier(ShowBannerModifier9(label: label, trigger: trigger))
    }
}

struct Banner9: View {
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

struct ContentView9: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section9()
        }
        .modifier(BannerContainer9())
    }
}

struct Section9: View {
    @State private var showBanner1Trigger = 0
    @State private var showBanner2Trigger = 0

    var body: some View {
        VStack {
            Button("Show banner") {
                showBanner1Trigger += 1
            }
            Button("Show banner 2") {
                showBanner2Trigger += 1
            }
        }
        .buttonStyle(
            .borderedProminent
        )
        .banner9(label: "My Banner 1", trigger: showBanner1Trigger)
        .banner9(label: "My Banner 2", trigger: showBanner2Trigger)
    }
}

#Preview {
    ContentView9()
}
