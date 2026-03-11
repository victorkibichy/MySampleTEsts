import SwiftUI

enum TransactionStatus: Int {
    case pending = 0
    case success = 1
    case failed = 2
    case reversed = 3

    var title: String {
        switch self {
        case .pending:
            return "Pending"
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        case .reversed:
            return "Reversed"
        }
    }

    var color: Color {
        switch self {
        case .pending:
            return .orange
        case .success:
            return .green
        case .failed:
            return .red
        case .reversed:
            return .gray
        }
    }

    var icon: String {
        switch self {
        case .pending:
            return "clock"
        case .success:
            return "checkmark.circle.fill"
        case .failed:
            return "xmark.circle.fill"
        case .reversed:
            return "arrow.uturn.backward.circle.fill"
        }
    }
}
