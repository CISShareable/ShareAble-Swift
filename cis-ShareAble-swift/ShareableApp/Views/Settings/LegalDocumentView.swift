import SwiftUI

/// Shared layout for the static text screens (About, Privacy Policy, Terms).
/// in aboutUs.html, privacyPolicy.html, and termsConditions.html.
struct LegalSection: Identifiable {
    let id = UUID()
    var heading: String?
    var body: String
}

struct LegalDocumentView: View {
    let title: String
    var lastUpdated: String?
    let sections: [LegalSection]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let lastUpdated {
                    Text("Last Updated: \(lastUpdated)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 6) {
                        if let heading = section.heading {
                            Text(heading)
                                .font(.headline)
                        }
                        Text(section.body)
                            .font(.subheadline)
                    }
                }

                Text("Citations: content drafted with the assistance of ChatGPT (OpenAI), Apr. 27, 2024.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
