//
//  UIControl.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/15.
//

import Combine
import UIKit

extension UIControl: CombineCompatible {}

extension UIControl {
    final class Subscription<SubscriberType: Subscriber, Control: UIControl>: Combine.Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let input: Control
        
        public init(subscriber: SubscriberType, input: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.input = input
            input.addTarget(self, action: #selector(eventHandler), for: event)
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {
            subscriber = nil
        }
        
        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }
    
    struct Publisher<Output: UIControl>: Combine.Publisher {
        public typealias Output = Output
        public typealias Failure = Never
        
        let output: Output
        let event: UIControl.Event
        
        public init(output: Output, event: UIControl.Event) {
            self.output = output
            self.event = event
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
}
