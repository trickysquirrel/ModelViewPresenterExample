//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import Foundation

public struct AsyncRunner<T>: Equatable {

    private let queue: DispatchQueue
    private let closure: (T) -> Void

    public init(on queue: DispatchQueue, run closure: @escaping (T) -> Void) {
        self.closure = closure
        self.queue = queue
    }

    public func run(_ t: T) {
        queue.asyncSafe {
            self.closure(t)
        }
    }

    static public func on<Q>(_ queue: DispatchQueue, run closure: @escaping (Q) -> Void) -> AsyncRunner<Q> {
        return AsyncRunner<Q>(on: queue, run: closure)
    }

    static public func == (lhs: AsyncRunner<T>, rhs: AsyncRunner<T>) -> Bool {
        return lhs.queue == rhs.queue
    }
}
