//
//  KeyboardAdaptive.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI
import Combine

/// Note that the `KeyboardAdaptive` modifier wraps your view in a `GeometryReader`,
/// which attempts to fill all the available space, potentially increasing content view size.
struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    @State private var bottomPaddingValue: CGFloat = 0
    static var isAdjustingPaddingView: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    let padding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    
                    // Hanlde for keyboard show, ignore case Keyboard is closing.
                    if padding > 0 && bottomPaddingValue == 0 {
                        KeyboardAdaptive.isAdjustingPaddingView = true
                        
                        // ipX.
                        var minHeight: CGFloat = 180
                        self.bottomPaddingValue = min(padding, minHeight)
                        
                        if #available(iOS 14.0, *) {
                            // From iOS14 auto handle scroll view when keyboard show.
                        } else {
                            self.bottomPadding = self.bottomPaddingValue
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            KeyboardAdaptive.isAdjustingPaddingView = false
                        }
                    } else if padding == 0 {
                        // Handle for keyboard hide.
                        self.bottomPaddingValue = 0
                        self.bottomPadding = 0
                        KeyboardAdaptive.isAdjustingPaddingView = false
                    }
                }
                .onReceive(Publishers.keyboardHide, perform: { _ in
                    self.bottomPaddingValue = 0
                    self.bottomPadding = 0
                    KeyboardAdaptive.isAdjustingPaddingView = false
                })
                .animation(.easeInOut, value: 0.16)
        }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
            .eraseToAnyPublisher()
    }
    
    static var keyboardHide: AnyPublisher<CGFloat, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
