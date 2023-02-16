import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as?UIWindowScene)?.windows ?? [] }
            .forEach { $0.endEditing(force) }
    }
}
