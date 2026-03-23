//
//  TransactionStatusView.swift
//  MySampleTEsts
//
//  Created by Vic on 18/12/2025.
//

import SwiftUI


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



#Preview {
    Group {
        TransactionStatusView(status:  .success);
        TransactionStatusView(status:  .pending);
        TransactionStatusView(status: .reversed);
    }
}
