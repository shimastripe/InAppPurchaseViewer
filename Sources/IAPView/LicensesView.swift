//
//  LicensesView.swift
//
//
//  Created by shimastripe on 2024/02/05.
//

import SwiftUI

struct LicensesView: View {
    @State private var selectedLicense: LicensesPlugin.License?

    var body: some View {
        List {
            ForEach(LicensesPlugin.licenses) { license in
                LabeledContent(license.name) {
                    Button {
                        selectedLicense = license
                    } label: {
                        Image(systemName: "info.circle").padding(4)
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Assets") {
                Link(
                    "Space icons created by Freepik - Flaticon",
                    destination: .init(string: "https://www.flaticon.com/free-icons/space")!)
            }
        }
        .sheet(item: $selectedLicense, content: { license in
            NavigationStack {
                Group {
                    if let licenseText = license.licenseText {
                        ScrollView {
                            Text(licenseText)
                                .padding()
                        }
                    } else {
                        Text("No License Found")
                    }
                }
                .navigationTitle(license.name)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            selectedLicense = nil
                        } label: {
                            Label("Close", systemImage: "xmark")
                        }
                    }
                }
            }
            .frame(idealWidth: 600)
        })
        .navigationTitle("Licenses")
        .scrollContentBackground(.hidden)
    }
}
