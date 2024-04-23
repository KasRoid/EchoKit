//
//  BubbleView.swift
//
//
//  Created by Lukas on 4/23/24.
//

import Combine
import UIKit

internal final class BubbleView: UIView {
    
    @IBOutlet private weak var button: UIButton!
    
    private var parentView: UIView?
    private var originalCenter: CGPoint?
    private var cancellable = Set<AnyCancellable>()
    
    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWithXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}

// MARK: - Methods
extension BubbleView {
    
    internal var tap: AnyPublisher<Void, Never> {
        button.publisher(for: .touchUpInside)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
    internal func prepare(parentView: UIView) {
        self.parentView = parentView
        setupUI()
        addPanGesture()
    }
}

// MARK: - Gestures
extension BubbleView {
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            originalCenter = center
            centerXConstraint?.priority = UILayoutPriority(1)
            centerYConstraint?.priority = UILayoutPriority(1)
        case .changed:
            guard let originalCenter else { return }
            let translation = gesture.translation(in: parentView)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            updatePosition()
        case .ended, .cancelled:
            updatePosition()
        default:
            break
        }
    }
}

// MARK: - UI
extension BubbleView {
    
    private func setupUI() {
        isHidden = true
        guard let parentView else { return }
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerXConstraint = centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
        centerYConstraint = centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        centerXConstraint?.isActive = true
        centerYConstraint?.isActive = true
        widthAnchor.constraint(equalToConstant: 30).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func updatePosition() {
        guard let parentView else { return }
        centerXConstraint?.isActive = false
        centerYConstraint?.isActive = false
        let newCenterX = center.x - parentView.bounds.midX
        let newCenterY = center.y - parentView.bounds.midY
        centerXConstraint = centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: newCenterX)
        centerYConstraint = centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: newCenterY)
        centerXConstraint?.priority = .required
        centerYConstraint?.priority = .required
        centerXConstraint?.isActive = true
        centerYConstraint?.isActive = true
        parentView.layoutIfNeeded()
    }
}
