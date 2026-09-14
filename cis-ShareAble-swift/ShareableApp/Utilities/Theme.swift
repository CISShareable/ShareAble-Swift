import SwiftUI

/// Colors for app CSS
extension Color {
    /// Primary brand green (#62931B) — used throughout the original app for
    /// primary buttons, "Back" labels, and links (login, signup, upload,
    /// settings, product_info, etc).
    static let brandGreen = Color(red: 0x62 / 255, green: 0x93 / 255, blue: 0x1B / 255)

    /// Darker green (#235507) — used for the name/email/rating text on
    /// profile.html and another_profile.html headers.
    static let brandGreenDark = Color(red: 0x23 / 255, green: 0x55 / 255, blue: 0x07 / 255)

    /// Lighter green accent (#94BF1A) — the hero banner on setting.html and
    /// the owner-username link color on product_info.html.
    static let brandGreenLight = Color(red: 0x94 / 255, green: 0xBF / 255, blue: 0x1A / 255)

    /// Light gray app background (#F6F6F6), used across nearly every screen.
    static let brandBackground = Color(red: 0xF6 / 255, green: 0xF6 / 255, blue: 0xF6 / 255)
}
