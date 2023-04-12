//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import UIKit
import Common

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appController = AppController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        disableAnimations()
        appController.start()
        return true
    }
    
    func disableAnimations() {
        let arguments = ProcessInfo.processInfo.arguments
        UIView.setAnimationsEnabled(!arguments.contains("UITesting"))
    }
}

//public extension UIViewController {
//    @objc
//    private func custom_viewWillAppear(_ animated: Bool) {
//        let name = self.view.accessibilityIdentifier
//        logger.info("Scene: \(name)")
//    }
//
//    static func registerAccessibilityUITest() {
//        #if !DEBUG
//        return
//        #endif
//
//        DispatchQueue.once(token: "UIViewController.accessibilityTesting.swizzle") {
//            UIAccessibilityUtil.swizzle(
//                selector: #selector(UIViewController.viewWillAppear(_:)),
//                with: #selector(UIViewController.custom_viewWillAppear(_:)),
//                inClass: UIViewController.self,
//                usingClass: UIViewController.self
//            )
//        }
//    }
//}
//
//struct UIAccessibilityUtil {
//    static func forceSwizzle(selector originalSelector: Selector, with swizzledSelector: Selector, inClass: AnyClass, usingClass: AnyClass) {
//        let hasBaseImplementation = class_respondsToSelector(inClass, originalSelector)
//        if !hasBaseImplementation {
//            addDefaultImplementation(selector: originalSelector, inClass: inClass)
//        }
//
//        swizzle(
//            selector: originalSelector,
//            with: swizzledSelector,
//            inClass: inClass,
//            usingClass: usingClass
//        )
//    }
//
//    static func swizzle(selector originalSelector: Selector, with swizzledSelector: Selector, inClass: AnyClass, usingClass: AnyClass) {
//        guard
//            let originalMethod = class_getInstanceMethod(inClass, originalSelector),
//            let swizzledMethod = class_getInstanceMethod(usingClass, swizzledSelector) else { return }
//
//        if class_addMethod(inClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)) {
//            class_replaceMethod(inClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//    }
//
//    static func addDefaultImplementation(selector originalSelector: Selector, inClass: AnyClass) {
//        let dummyMethod = class_getInstanceMethod(UIView.self, #selector(UIView.dummyMethod))!
//
//        _ = class_addMethod(
//            inClass,
//            originalSelector,
//            method_getImplementation(dummyMethod),
//            method_getTypeEncoding(dummyMethod)
//        )
//    }
//}
