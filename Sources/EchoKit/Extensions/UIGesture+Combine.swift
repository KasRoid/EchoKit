//
//  UIGesture+Combine.swift
//
//
//  Created by Lukas on 4/26/24.
//

import Combine
import UIKit

internal enum GestureType {
    case tap
    case longPress
    case pan
    case pinch
    case swipe
    case edge
    
    func getType() -> UIGestureRecognizer {
        switch self {
        case.tap:
            return UITapGestureRecognizer()
        case.longPress:
            return UILongPressGestureRecognizer()
        case.pan:
            return UIPanGestureRecognizer()
        case.pinch:
            return UIPinchGestureRecognizer()
        case.swipe:
            return UISwipeGestureRecognizer()
        case.edge:
            return UIScreenEdgePanGestureRecognizer()
        }
    }
}

internal struct GesturePublisher: Publisher {
    
    public typealias Output = GestureType
    public typealias Failure = Never
    
    private let view: UIView
    private let gestureType: GestureType
    
    internal init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }
    
    internal func receive<S>(subscriber: S) where S: Subscriber, GesturePublisher.Failure == S.Failure, GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber, view: view, gestureType: gestureType)
        subscriber.receive(subscription: subscription)
    }
}

internal final class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {
    
    private var subscriber: S?
    private var gestureType: GestureType
    private var view: UIView
    
    internal init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        configure (gestureType: gestureType)
    }
    
    private func configure(gestureType: GestureType) {
        let gesture = gestureType.getType()
        gesture.addTarget(self, action: #selector(gestureHandler))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    internal func request(_ demand: Subscribers.Demand) {}
    
    internal func cancel() {
        subscriber = nil
    }
    
    @objc private func gestureHandler() {
        _ = subscriber?.receive(gestureType)
    }
}

extension UIView {
    
    internal func gesturePublisher(_ type: GestureType) -> GesturePublisher {
        GesturePublisher(view: self, gestureType: type)
    }
}
