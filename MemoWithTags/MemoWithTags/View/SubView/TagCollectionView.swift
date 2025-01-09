//
//  TagCollectionView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI
import UIKit

struct TagCollectionView: UIViewRepresentable {
    @Binding var tags: [Tag]
    @Binding var collectionViewHeight: CGFloat
    
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.minimumLineSpacing = verticalSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HostingTagCell.self, forCellWithReuseIdentifier: HostingTagCell.reuseIdentifier)
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
            uiView.layoutIfNeeded() // 레이아웃 강제 업데이트
            let newHeight = uiView.collectionViewLayout.collectionViewContentSize.height
            if self.collectionViewHeight != newHeight {
                self.collectionViewHeight = newHeight
                print("Updated collectionViewHeight: \(newHeight)") // 디버깅
            }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostingTagCell.reuseIdentifier, for: indexPath) as? HostingTagCell else {
                return UICollectionViewCell()
            }
            let tag = parent.tags[indexPath.item]
            cell.configure(with: tag)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let tag = parent.tags[indexPath.item]
            let maxWidth = collectionView.bounds.width
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = tag.name
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            let width = min(size.width + 14, maxWidth) // 좌우 패딩 7 + 7
            let height: CGFloat = 25 // TagView와 일치하도록 높이 조정
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
                
                let frame = attributes.frame
                attributes.frame.origin.x = leftMargin
                leftMargin += frame.width + minimumInteritemSpacing
                maxY = max(frame.maxY, maxY)
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

class HostingTagCell: UICollectionViewCell {
    static let reuseIdentifier = "HostingTagCell"
    private var hostController: UIHostingController<TagView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tag: Tag) {
        let tagView = TagView(tag: tag)
        
        if hostController == nil {
            let controller = UIHostingController(rootView: tagView)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            hostController = controller
            contentView.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            hostController?.rootView = tagView
        }
    }
}
