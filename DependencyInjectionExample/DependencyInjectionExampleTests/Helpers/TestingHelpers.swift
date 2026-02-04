//
//  TestingHelpers.swift
//  DependencyInjectionExampleTests
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation

import SnapshotTesting
import SwiftUI
import UIKit

let traitsList = [
    ("light", UITraitCollection(userInterfaceStyle: .light)),
    ("dark", UITraitCollection(userInterfaceStyle: .dark)),
]

func testImageSnapshot<Value: View>(
    _ value: Value,
    layout: SwiftUISnapshotLayout = .sizeThatFits,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    for (traitType, traits) in traitsList {
        let file = filePath.description
            .components(separatedBy: "/")
            .last?
            .replacingOccurrences(of: ".swift", with: "") ?? ""
        assertSnapshot(
            of: value,
            as: .image(layout: layout, traits: traits),
            named: traitType + "." + file,
            fileID: fileID,
            file: filePath,
            testName: testName,
            line: line,
            column: column
        )
    }
}

struct EmbedInNavigationStack: ViewModifier {
    func body(content: Content) -> some View {
        NavigationStack {
            content
        }
    }
}

extension View {
    func navigationStack() -> some View {
        modifier(EmbedInNavigationStack())
    }
}
