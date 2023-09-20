//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

// Solution:

// 1. Global object, that stores and queues the modals' view models.
@Observable
final class BannerPresenter5 {
    var items = [BannerItem5]()
}

// 2. Representation of the modal we want to display.
struct BannerItem5: Equatable {
    let label: LocalizedStringKey
}

// 3. Global view modifier, that coordinates the dispaly of the modals
//    and adjusts the root view of the app.
struct BannerContainer5: ViewModifier {
    @State private var presenter = BannerPresenter5()

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay(alignment: .bottom) {
                // Banners go here
            }
            .environment(presenter)
    }
}

struct Banner5: View {
    @Binding var isPresented: Bool
    let label: LocalizedStringKey

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
                isPresented = false
            }
    }
}

// MARK: - ContentView

struct ContentView5: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section5()
        }
        // Applying the container to the root view.
        .modifier(BannerContainer5())
    }
}

struct Section5: View {
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
