

import Foundation

enum Router: Hashable {
    case main
    case account
    case settings
    case info
    case levelListing
    case game(Level)
    case customGame
}
