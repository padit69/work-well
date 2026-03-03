//
//  UpdateAvailableView.swift
//  WorkWell
//

import SwiftUI
import AppKit

/// Shown when a new version is available: release info + button to open GitHub releases page to download manually.
struct UpdateAvailableView: View {
    let release: GitHubRelease
    let onDismiss: () -> Void

    @State private var isDownloading: Bool = false
    @State private var downloadError: String?

    private var releaseNotes: String {
        release.body ?? "Bug fixes and improvements."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Update Available".localizedByKey)
                        .font(.headline)
                    Text("Version \(release.version) is available. You have \(UpdateCheckService.currentVersion).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if !releaseNotes.isEmpty {
                Text(releaseNotes)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let error = downloadError {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundStyle(.red)
            }

            HStack(spacing: 10) {
                Button("Later".localizedByKey) {
                    onDismiss()
                }
                .keyboardShortcut(.escape, modifiers: [])

                Button(isDownloading ? "Downloading…".localizedByKey : "Download & Install".localizedByKey) {
                    startDownloadAndInstall()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isDownloading)

                Button("Open on GitHub".localizedByKey) {
                    if let url = URL(string: release.htmlUrl) {
                        NSWorkspace.shared.open(url)
                    }
                }
                .disabled(isDownloading)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        .frame(minWidth: 420, maxWidth: 420, alignment: .leading)
    }

    private func startDownloadAndInstall() {
        downloadError = nil
        isDownloading = true
        UpdateInstallService.downloadRelease(release) { result in
            isDownloading = false
            switch result {
            case let .success(url):
                UpdateInstallService.installFromDMG(url)
            case let .failure(error):
                switch error {
                case .missingDownloadURL:
                    downloadError = "Unable to find a download for this update.".localizedByKey
                case let .downloadFailed(message):
                    downloadError = "Download failed: \(message)".localizedByKey
                case .fileMoveFailed:
                    downloadError = "Could not save downloaded file.".localizedByKey
                }
            }
        }
    }
}
