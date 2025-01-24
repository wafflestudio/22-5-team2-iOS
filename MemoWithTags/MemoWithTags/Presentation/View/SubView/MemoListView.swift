import SwiftUI

struct MemoListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ScrollView {
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.memos.reversed()) { memo in
                    MemoView(memo: memo, viewModel: viewModel)
                        .id(memo.id)
                        .padding(.horizontal, 12)
                }
            }
            .padding(.bottom, 20)

        }
        .padding(.top, 1)
        .defaultScrollAnchor(.bottom)
        
    }
}
