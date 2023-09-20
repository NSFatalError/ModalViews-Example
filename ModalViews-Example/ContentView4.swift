//
//  ContentView.swift
//  ModalViews-Example
//
//  Created by Kamil Strzelecki on 20/09/2023.
//

import SwiftUI
import Observation

struct Banner4: View {
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

struct ContentView4: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 64)

            Section4()
            Color.red
        }
    }
}

// Additional problem - banners can overlap.
// We should have some queuing mechanism so they also don't get dismissed to early.
struct Section4: View {
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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(alignment: .bottom) {
            if showBanner1 {
                Banner4(isPresented: $showBanner1, label: "My Banner 1")
            }
            if showBanner2 {
                Banner4(isPresented: $showBanner2, label: "My Banner 2")
            }
        }
        .animation(.spring, value: showBanner1)
        .animation(.spring, value: showBanner2)
        .background(Color.green)
    }
}

#Preview {
    ContentView4()
}
