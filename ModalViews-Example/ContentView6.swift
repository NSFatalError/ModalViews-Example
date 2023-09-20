//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

@Observable
final class BannerPresenter6 {
    private(set) var items = [BannerItem6]()

    // Added ability to dismiss item.
    func dismiss() {
        guard !items.isEmpty else { return }
        items.removeFirst()
    }
}

struct BannerItem6: Equatable {
    let label: LocalizedStringKey
}

struct BannerContainer6: ViewModifier {
    @State private var presenter = BannerPresenter6()

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay(alignment: .bottom) {
                // Only one banner at a time allowed.
                if let item = presenter.items.first {
                    Banner6(
                        label: item.label,
                        onDismiss: {
                            presenter.dismiss()
                        }
                    )
                }
            }
            // Container now handles the animation as well.
            .animation(.spring, value: presenter.items)
            .environment(presenter)
    }
}

struct Banner6: View {
    let label: LocalizedStringKey

    // Presentation condition has now stopped being tied to the view that invoked the modal.
    // The condition to appear is never triggered by the modal, we only need ability to dismiss it.
    // Communication about the presentation state between modal and the invoking view can be achieved,
    // but BannerItem would need to be a reference type and store the binding.
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

struct ContentView6: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section6()
        }
        .modifier(BannerContainer6())
    }
}

struct Section6: View {
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
