import Foundation
import SwiftUI

extension String {
    /// Returns the localized string for the **user-selected app language** (Settings),
    /// not the system language. Uses PreferencesService to get current Language and
    /// the corresponding .lproj bundle.
    var localizedByKey: String {
        let lang = PreferencesService.load().language.rawValue
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return bundle.localizedString(forKey: self, value: self, table: nil)
    }
}
