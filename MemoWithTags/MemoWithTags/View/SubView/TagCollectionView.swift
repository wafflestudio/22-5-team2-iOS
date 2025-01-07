//
//  TagCollectionView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI
import UIKit

struct TagCollectionView: UIViewRepresentable {
    var tags: [Tag]
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    
    @Binding var collectionViewHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        // 커스텀 레이아웃 설정
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.minimumLineSpacing = verticalSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        uiView.reloadData()
        DispatchQueue.main.async {
            self.collectionViewHeight = uiView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        var parent: TagCollectionView
        
        init(parent: TagCollectionView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.tags.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else {
                return UICollectionViewCell()
            }
            let tag = parent.tags[indexPath.item]
            cell.configure(with: tag)
            return cell
        }
        
        // sizeForItemAt 구현하여 태그의 크기를 동적으로 계산
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let tag = parent.tags[indexPath.item]
            let maxWidth = collectionView.bounds.width // 셀의 최대 너비를 컬렉션 뷰의 너비로 설정
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = tag.name
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            let width = min(size.width + 14, maxWidth) // 좌우 패딩 7 + 7
            let height: CGFloat = 23 // 수직 패딩 1 + 1, 폰트 크기 15에 적합한 높이 설정
            return CGSize(width: width, height: height)
        }
    }
}

// 왼쪽 정렬을 위한 커스텀 레이아웃
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for attributes in attributesForElementsInRect {
            if attributes.representedElementCategory == .cell {
                if attributes.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                attributes.frame.origin.x = leftMargin
                
                leftMargin += attributes.frame.width + minimumInteritemSpacing
                maxY = max(attributes.frame.maxY , maxY)
            }
            newAttributesForElementsInRect.append(attributes)
        }
        
        return newAttributesForElementsInRect
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}