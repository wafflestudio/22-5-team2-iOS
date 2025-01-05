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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            let tag = parent.tags[indexPath.item]
            cell.configure(with: tag)
            return cell
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
