//
//  LoadingViewState.swift
//
//
//  Created by shimastripe on 2024/02/05.
//

import Foundation

public enum LoadingViewState<Element: Equatable>: Equatable {
    case waiting
    case loading
    case appendLoading(Element)
    case success(Element)
    case failed(IAPError)

    public var value: Element? {
        switch self {
        case .success(let element), .appendLoading(let element):
            element
        case .waiting, .loading, .failed:
            nil
        }
    }

    public var isLoading: Bool {
        guard case .loading = self else {
            return false
        }
        return true
    }

    public var isAppendLoading: Bool {
        guard case .appendLoading = self else {
            return false
        }
        return true
    }

    public var presentsError: IAPError? {
        get {
            guard case .failed(let error) = self else { return nil }
            return error
        }
        set { clear() }
    }

    public mutating func startLoading() {
        switch self {
        case .waiting, .success:
            self = .loading
        case .loading, .appendLoading, .failed:
            assertionFailure()
            return
        }
    }

    public mutating func finishLoading(_ element: Element) {
        guard case .loading = self else {
            assertionFailure()
            return
        }
        self = .success(element)
    }

    public mutating func failLoading(with error: IAPError) {
        guard case .loading = self else {
            assertionFailure()
            return
        }
        self = .failed(error)
    }

    public mutating func clear() {
        self = .waiting
    }

    public mutating func startAppendLoading() {
        switch self {
        case .success(let element):
            self = .appendLoading(element)
        case .waiting, .loading, .appendLoading, .failed:
            assertionFailure()
            return
        }
    }

    public mutating func finishAppendLoading(_ element: Element) {
        guard case .appendLoading = self else {
            assertionFailure()
            return
        }
        self = .success(element)
    }

    public mutating func failAppendLoading(with error: IAPError) {
        guard case .appendLoading = self else {
            assertionFailure()
            return
        }
        self = .failed(error)
    }
}
