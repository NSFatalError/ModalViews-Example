//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

struct Banner2: View {
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

struct ContentView2: View {
    @State private var showBanner = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section2(showBanner: $showBanner)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(alignment: .bottom) {
            if showBanner {
                Banner2(isPresented: $showBanner, label: "My Banner!")
            }
        }
        .animation(.spring, value: showBanner)
    }
}

// Extracting a section with binding to the root view.
// Currently logic must go through the entire hierarchy.
// Not ideal - SwiftUI alert(...) modifier allows to present alert from deeply nested views.
struct Section2: View {
    @Binding var showBanner: Bool

    var body: some View {
        Button("Show banner") {
            guard !showBanner else { return }
            showBanner = true
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContentView2()
}
