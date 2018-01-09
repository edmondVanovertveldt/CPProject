// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// Annuler
  static let cancel = L10n.tr("Localizable", "cancel")
  /// Service de géolocalisation désactivé.
  static let locationServiceDisable = L10n.tr("Localizable", "location_service_disable")
  /// Ouvrir les réglages
  static let openSettings = L10n.tr("Localizable", "open_settings")
  /// Pour vous indiquer votre position sur la carte, veuillez autoriser le service de géolocalisation
  static let requestLocationServiceSubtitle = L10n.tr("Localizable", "request_location_service_subtitle")
  /// Rechercher une adresse
  static let searchAddress = L10n.tr("Localizable", "search_address")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
