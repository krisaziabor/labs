import SwiftUI

extension Font {
  static func inter(size: CGFloat, weight: Font.Weight = .regular) -> Font {
    let fontName: String
    switch weight {
    case .semibold:
      fontName = "Inter-SemiBold"
    case .bold:
      fontName = "Inter-Bold"
    default:
      fontName = "Inter-Regular"
    }
    return Font.custom(fontName, size: size)
  }
}
