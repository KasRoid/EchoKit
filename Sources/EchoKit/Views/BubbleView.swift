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
    private let locationKey = "EchoKit-Bubble-Location"
    
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
            guard let originalCenter, let safeLayoutGuide = parentView?.safeAreaLayoutGuide else { return }
            let translation = gesture.translation(in: parentView)
            let center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            guard safeLayoutGuide.layoutFrame.contains(center) else { return }
            self.center = center
            updatePosition()
        case .ended, .cancelled:
            updatePosition(isEnd: true)
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
        let location = if let location = UserDefaults.standard.cgPoint(forKey: locationKey) {
            location
        } else {
            CGPoint(x: 0, y: 0)
        }
        centerXConstraint = centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: location.x)
        centerYConstraint = centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: location.y)
        centerXConstraint?.isActive = true
        centerYConstraint?.isActive = true
        widthAnchor.constraint(equalToConstant: 30).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        guard #unavailable(iOS 17.0) else { return }
        let image = UIImage(systemName: "terminal.fill")
        button.setImage(image, for: .normal)
    }
    
    private func updatePosition(isEnd: Bool = false) {
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
        guard isEnd else { return }
        let point = CGPoint(x: newCenterX, y: newCenterY)
        UserDefaults.standard.set(point, forKey: locationKey)
    }
}
