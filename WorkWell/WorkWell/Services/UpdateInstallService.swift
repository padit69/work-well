//
//  UpdateInstallService.swift
//  WorkWell
//

import AppKit
import Foundation

enum UpdateInstallService {
    enum InstallError: Error {
        case missingDownloadURL
        case downloadFailed(String)
        case fileMoveFailed
    }

    /// Download the DMG/ZIP for a given release into the user's caches directory.
    /// Calls completion on the main queue.
    static func downloadRelease(
        _ release: GitHubRelease,
        completion: @escaping (Result<URL, InstallError>) -> Void
    ) {
        guard let url = release.downloadURL else {
            DispatchQueue.main.async {
                completion(.failure(.missingDownloadURL))
            }
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.downloadFailed(error.localizedDescription)))
                }
                return
            }

            guard let tempURL else {
                DispatchQueue.main.async {
                    completion(.failure(.downloadFailed("Empty download response")))
                }
                return
            }

            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileName = "WorkWell-update.\(url.pathExtension.isEmpty ? "dmg" : url.pathExtension)"
            let destinationURL = cachesURL.appendingPathComponent(fileName)

            do {
                try? FileManager.default.removeItem(at: destinationURL)
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                DispatchQueue.main.async {
                    completion(.success(destinationURL))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.fileMoveFailed))
                }
            }
        }
        task.resume()
    }

    /// Mount a DMG and replace the current app bundle, then relaunch.
    /// This function writes and runs a helper shell script and then terminates the app.
    static func installFromDMG(_ dmgURL: URL) {
        let appName = AppConstants.App.name
        let appBundlePath = Bundle.main.bundlePath
        let pid = ProcessInfo.processInfo.processIdentifier

        let script = """
        #!/bin/bash
        DMG="\(dmgURL.path)"
        MOUNT=$(hdiutil attach "$DMG" -nobrowse -noverify -noautoopen 2>/dev/null | grep '/Volumes/' | awk -F'\\t' '{print $NF}')
        if [ -z "$MOUNT" ]; then exit 1; fi
        APP="$MOUNT/\(appName).app"
        if [ ! -d "$APP" ]; then hdiutil detach "$MOUNT" -quiet; exit 1; fi
        # Wait for app to quit
        while kill -0 \(pid) 2>/dev/null; do sleep 0.2; done
        # Copy new app
        DEST="\(appBundlePath)"
        rm -rf "$DEST"
        cp -R "$APP" "$DEST"
        # Unmount & cleanup
        hdiutil detach "$MOUNT" -quiet
        rm -f "$DMG"
        # Relaunch
        open "$DEST"
        """

        let tmpScript = FileManager.default.temporaryDirectory.appendingPathComponent("workwell-update.sh")
        try? script.write(to: tmpScript, atomically: true, encoding: .utf8)
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tmpScript.path)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [tmpScript.path]
        try? process.run()

        NSApp.terminate(nil)
    }
}

