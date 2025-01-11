// MemoListView.swift
// MemoWithTags

import SwiftUI

struct MemoListView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    private var reversedMemos: [Memo] {
        return Array(mainViewModel.memos.reversed())
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEachIndexed(reversedMemos) { index, memo in
                        // 날짜 헤더 표시
                        if shouldShowDateHeader(at: index) {
                            Text(dateFormatter.string(from: memo.createdAt))
                                .font(Font.custom("Pretendard Variable", size: 12).weight(.medium))
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // MemoView with unique id and context menu
                        MemoView(memo: memo)
                            .id(memo.id)
                            .contextMenu {
                                Button(role: .destructive) {
                                    mainViewModel.deleteMemo(memoId: memo.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onAppear {
                                if index == reversedMemos.count - 1 {
                                    Task {
                                        mainViewModel.fetchMemos()
                                    }
                                }
                            }
                    }
                    
                    if mainViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // 100픽셀 높이의 빈 공간 추가
                    Color.clear
                        .frame(height: 100)
                        .id("bottomSpace")
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .onAppear {
                    // Delay the scroll to ensure the view has rendered
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo("bottomSpace", anchor: .bottom)
                        }
                    }
                }
                .onChange(of: mainViewModel.memos) { _, _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo("bottomSpace", anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
    
    // 날짜 헤더 표시 여부를 판단하는 함수 분리
    private func shouldShowDateHeader(at index: Int) -> Bool {
        if index == 0 { return true }
        else { return isDifferentDay(current: reversedMemos[index], previous: reversedMemos[index - 1]) }
    }
    
    // 현재 메모와 이전 메모가 다른 날에 생성되었는지 확인
    private func isDifferentDay(current: Memo, previous: Memo) -> Bool {
        let currentDay = Calendar.current.startOfDay(for: current.createdAt)
        let previousDay = Calendar.current.startOfDay(for: previous.createdAt)
        return currentDay != previousDay
    }
}

struct ForEachIndexed<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable, Data.Element.ID: Hashable {
    let data: Data
    let content: (Int, Data.Element) -> Content
    
    init(_ data: Data, @ViewBuilder content: @escaping (Int, Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(data.enumerated()), id: \.element.id) { index, element in
            content(index, element)
        }
    }
}

