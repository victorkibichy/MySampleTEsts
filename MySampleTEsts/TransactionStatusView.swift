struct TransactionStatusView: View {
    let status: TransactionStatus

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: status.icon)
                .foregroundColor(status.color)

            Text(status.title)
                .font(.headline)
                .foregroundColor(status.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            status.color.opacity(0.15)
        )
        .cornerRadius(12)
    }
}
