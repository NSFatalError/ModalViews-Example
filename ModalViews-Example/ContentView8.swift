//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

@Observable
final class BannerPresenter8 {
    private(set) var items = [BannerItem8]()

    func dismiss() {
        guard !items.isEmpty else { return }
        items.removeFirst()
    }

    func showBanner(withLabel label: LocalizedStringKey) {
        items.append(.init(label: label))
    }
}

struct BannerItem8: Equatable {
    let label: LocalizedStringKey
}

struct BannerContainer8: ViewModifier {
    @State private var presenter = BannerPresenter8()

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay(alignment: .bottom) {
                if let item = presenter.items.first {
                    Banner8(
                        label: item.label,
                        onDismiss: {
                            presenter.dismiss()
                            print("dismissed")
                            // The 'task' modifier fires only once, so if there is more than one banner,
                            // only the first one will be dismissed. SwiftUI treats item change as underling model change,
                            // but identity of the view remains the same.
                        }
                    )
                }
            }
            .animation(.spring, value: presenter.items)
            .environment(presenter)
    }
}

struct ShowBannerModifier8<Trigger: Equatable>: ViewModifier {
    let label: LocalizedStringKey
    let trigger: Trigger

    @Environment(BannerPresenter8.self)
    private var presenter: BannerPresenter8

    func body(content: Content) -> some View {
        content.onChange(of: trigger) {
            presenter.showBanner(withLabel: label)
        }
    }
}

extension View {
    func banner8(label: LocalizedStringKey, trigger: some Equatable) -> some View {
        modifier(ShowBannerModifier8(label: label, trigger: trigger))
    }
}

struct Banner8: View {
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

struct ContentView8: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section8()
        }
        .modifier(BannerContainer8())
    }
}

struct Section8: View {
    // Changed type.
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
        // Applied the modifier.
        .banner8(label: "My Banner 1", trigger: showBanner1Trigger)
        .banner8(label: "My Banner 2", trigger: showBanner2Trigger)
    }
}

#Preview {
    ContentView8()
}
