//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

struct Banner3: View {
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

struct ContentView3: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section3()

            // New sibling
            Color.red
        }
    }
}

// Logic moved inside.
// With this setup we do not have access to the "superview", so modal is restricted to local container.
struct Section3: View {
    @State private var showBanner = false

    var body: some View {
        Button("Show banner") {
            guard !showBanner else { return }
            showBanner = true
        }
        .buttonStyle(
            .borderedProminent
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(alignment: .bottom) {
            if showBanner {
                Banner3(isPresented: $showBanner, label: "My Banner!")
            }
        }
        .background(Color.green)
        .animation(.spring, value: showBanner)
    }
}

#Preview {
    ContentView3()
}
