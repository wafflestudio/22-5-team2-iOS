//
//  KeyboardState.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/13/25.
//

import SwiftUI
import Combine

@MainActor
final class KeyboardState: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        // Use keyboardWillChangeFrameNotification to handle
        // all frame changes (including show/hide and 3rd-party keyboards).
        let willChangeFrame = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification -> CGFloat? in
                guard
                    let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first
                else {
                    return nil
                }
                
                // Convert the frame from screen coords to the window's coords
                let convertedFrame = window.convert(frame, from: nil)
                
                // If the keyboard's top is below (or at) the bottom of the screen, it’s hidden.
                // This can happen if the keyboard is being dismissed.
                if convertedFrame.minY >= window.bounds.height {
                    return 0
                } else {
                    // Subtract the safe area inset if you want the actual space the keyboard covers.
                    // If you prefer the raw keyboard height, just return `convertedFrame.height`.
                    return convertedFrame.height - window.safeAreaInsets.bottom
                }
            }
        
        // Subscribe and assign to currentHeight
        willChangeFrame
            .receive(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }
    
    func isKeyboardUp() -> Bool {
        return currentHeight > 0
    }
}
