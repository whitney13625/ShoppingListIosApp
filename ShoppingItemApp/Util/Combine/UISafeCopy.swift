
import Combine
import Foundation

extension Publisher where Failure == Never {
    public func uiSafeCopy(to published: inout Published<Self.Output>.Publisher) {
        self.receive(on: DispatchQueue.main).assign(to: &published)
    }
}

func uiSafeCopy<P: Publisher>(_ p: P, to published: inout Published<P.Output>.Publisher) where P.Failure == Never {
    p.uiSafeCopy(to: &published)
}
