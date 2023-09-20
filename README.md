# ModalViews-Example

This sample project contains 9 steps (named `ContentView1` to `ContentView9`), that show the reasoning behind a robust modal view presentation mechanism implemented in SwiftUI.

Implementation in `ContentView9` achieves two goals:
1. It allows to invoke the presentation of a modal over the root view, similar to how `UIViewController` would be shown on top of the entire underlying view hierarchy.
2. It provides a queuing mechanism, so modals do not appear at the same time and overlap.
