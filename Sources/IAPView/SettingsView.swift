//
//  SettingsView.swift
//
//
//  Created by shimastripe on 2024/02/03.
//

import IAPCore
import IAPInterface
import IAPModel
import SwiftUI

@MainActor
public struct SettingsView: View {

    @Environment(IAPModel.self)
    private var model
    @Environment(\.openURL)
    private var openURL

    @State private var bundleID = ""
    @State private var keyID = ""
    @State private var issuerID = ""
    @State private var appAppleID = 0

    @State private var importerPresented = false
    @State private var importedFileURL: URL?

    public init() {}

    var canRegister: Bool {
        guard let importedFileURL else { return false }
        return !bundleID.isEmpty && !keyID.isEmpty && !issuerID.isEmpty && importedFileURL.isFileURL
    }

    var overview: some View {
        GroupBox {
            Text("NOTE: Credentials are stored in Keychain. 2 steps are required.").font(.headline)
            Text("1. Download Apple Root Certificate.")
            Text("2. Configure App Store Server API")
        }
        .padding()
    }

    var serverCredential: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            Divider()

            GridRow {
                Text("Root Certificate").font(.headline)

                switch model.rootCertificateState {
                case .waiting:
                    Button {
                        Task {
                            await model.execute(action: .fetchRootCertificate)
                        }
                    } label: {
                        Label("Download AppleRootCA-G3.cer", systemImage: "arrow.down.circle")
                    }
                case .success:
                    Text("Save AppleRootCA-G3.cer ✅").bold()
                case .failed(let error):
                    Text(error.localizedDescription)
                case .loading:
                    ProgressView().controlSize(.small)
                case .appendLoading:
                    fatalError("Should not call")
                }
            }

            Divider()

            HStack {
                Spacer()
                Button {
                    openURL(URL(string: "https://appstoreconnect.apple.com/access/api/subs")!)
                } label: {
                    Label(
                        "Generate an in-app purchase key via browser",
                        systemImage: "link.badge.plus")
                }
                .buttonStyle(.borderedProminent)
            }

            // Use ZStack for keeping textField and text height
            switch model.credentialState {
            case .waiting, .success, .loading:
                GridRow {
                    Text("Bundle ID").font(.headline)
                    ZStack {
                        TextField("com.shimastripe.XXXXXX", text: $bundleID).opacity(
                            !model.isCredentialEditing ? 0 : 1)
                        Text(model.credentialState.value?.bundleID ?? "").opacity(
                            model.isCredentialEditing ? 0 : 1)
                    }
                }
                GridRow {
                    Text("Issuer ID").font(.headline)
                    ZStack {
                        TextField("XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX", text: $issuerID).opacity(
                            !model.isCredentialEditing ? 0 : 1)
                        Text(model.credentialState.value?.issuerID ?? "").opacity(
                            model.isCredentialEditing ? 0 : 1)
                    }
                }
                GridRow {
                    Text("Key ID").font(.headline)
                    ZStack {
                        TextField("YYYYYYYYYY", text: $keyID).opacity(
                            !model.isCredentialEditing ? 0 : 1)
                        Text(model.credentialState.value?.keyID ?? "").opacity(
                            model.isCredentialEditing ? 0 : 1)
                    }
                }
                GridRow {
                    Text("App Apple ID").font(.headline)
                    ZStack {
                        TextField("YYYYYYYYYY", value: $appAppleID, format: .number).opacity(
                            !model.isCredentialEditing ? 0 : 1)
                        Text(model.credentialState.value.map(\.appAppleID).map(\.description) ?? "")
                            .opacity(
                                model.isCredentialEditing ? 0 : 1)
                    }
                }
                GridRow {
                    Text("SubscriptionKey.p8").font(.headline)

                    ZStack {
                        Button("") {}.opacity(0)  // for keeping height

                        switch importedFileURL {
                        case .some(let url):
                            Text("\(url)")
                                .opacity(!model.isCredentialEditing ? 0 : 1)
                        case .none:
                            Button("Choose") {
                                importerPresented = true
                            }
                            .opacity(!model.isCredentialEditing ? 0 : 1)
                        }

                        Text("-----BEGIN PRIVATE KEY-----XXXXXX-----END PRIVATE KEY-----")
                            .opacity(model.isCredentialEditing ? 0 : 1)
                    }
                }

                GridRow {
                    Text("")

                    ZStack {
                        Button("Authenticate") {
                            Task {
                                guard let importedFileURL else { return }
                                await model.execute(
                                    action: .saveCredential(
                                        bundleID: bundleID, issuerID: issuerID, keyID: keyID,
                                        appAppleID: appAppleID, privateKeyFileURL: importedFileURL))
                                await model.execute(action: .getCredential)
                            }
                        }
                        .disabled(!canRegister)
                        .opacity(!model.isCredentialEditing ? 0 : 1)
                        Text("Authenticated ✅")
                            .opacity(model.isCredentialEditing ? 0 : 1)
                    }
                }
                .padding()
            case .failed(let error):
                GridRow {
                    Text("\(error.localizedDescription)")
                }
            case .appendLoading:
                fatalError("Should not call")
            }

            Divider()
        }
        .textFieldStyle(.roundedBorder)
        .fileImporter(
            isPresented: $importerPresented, allowedContentTypes: [.privateKey],
            onCompletion: { result in
                Task {
                    switch result {
                    case .success(let success):
                        importedFileURL = success
                    case .failure(let failure):
                        print(failure)
                    }
                }
            })
    }

    var reset: some View {
        VStack {
            HStack {
                ProgressView(value: model.isSetupLevel, total: 1)
                Text(model.isSetupLevel == 1 ? "Done✨" : "Set up please🙏")
            }
            .animation(.default, value: model.isSetupLevel)

            Button("Remove all settings") {
                Task {
                    await model.execute(action: .removeAll)
                    importedFileURL = nil
                }
            }
        }
        .padding()
    }

    public var body: some View {
        TabView {
            VStack {
                overview
                serverCredential
                reset
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle.fill")
            }
            .tag(0)

            LicensesView()
                .tabItem {
                    Label("License", systemImage: "quote.opening")
                }
                .tag(1)
        }
        .padding(20)
        .overlay {
            if model.credentialState.isLoading {
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            }
        }
    }
}
