//
//  SearchView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @StateObject private var keyboard = KeyboardManager()
    
    @State private var selectedTags: [Tag] = []
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200) // 너비 조정
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
