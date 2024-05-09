//
//  BundleHelper.swift
//
//
//  Created by Lukas on 5/9/24.
//

import Foundation

#if SWIFT_PACKAGE
let bundle = Bundle.module
#else
class ReferenceClassForBundle {}
let bundle = Bundle(for: ReferenceClassForBundle.self)
#endif
