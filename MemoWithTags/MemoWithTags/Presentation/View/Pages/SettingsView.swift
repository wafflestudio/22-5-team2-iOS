//
//  SettingsView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Button {
            //action
            Task {
                await viewModel.logout()
            }
        } label: {
            Text("로그아웃")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(12)

        }
        .background(Color.titleTextBlack)
        .cornerRadius(22)
    }
}
