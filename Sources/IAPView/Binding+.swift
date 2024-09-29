//
//  Binding+.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/09/29.
//

import SwiftUI

extension Binding
where
    Value: MutableCollection, Value: RangeReplaceableCollection, Value: Sendable,
    Value.Element: Identifiable
{
    func filter(_ isIncluded: @Sendable @escaping (Value.Element) -> Bool) -> Binding<
        [Value.Element]
    > {
        Binding<[Value.Element]>(
            get: {
                wrappedValue.filter(isIncluded)
            },
            set: { newValue in
                newValue.forEach { newItem in
                    guard let i = wrappedValue.firstIndex(where: { $0.id == newItem.id })
                    else {
                        self.wrappedValue.append(newItem)
                        return
                    }
                    self.wrappedValue[i] = newItem
                }
            }
        )
    }
}
