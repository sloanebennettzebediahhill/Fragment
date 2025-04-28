
import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
}
