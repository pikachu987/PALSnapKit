//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit
import SnapKit

public extension ConstraintMakerFinalizable {
    enum LabelType: String {
    case top
    case leading
    case trailing
    case bottom
    case width
    case height
    case centerX
    case centerY
    }

    @discardableResult
    func labeled(_ type: LabelType) -> ConstraintMakerFinalizable {
        return self.labeled(type.rawValue)
    }
}

public extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return self.snp
        #else
            return self.snp
        #endif
    }
}

public extension UIViewController {
    var safeArea: ConstraintBasicAttributesDSL {
        return self.view.safeArea
    }
}

public extension NSLayoutConstraint {
    enum Identifier: String {
    case top
    case bottom
    case leading
    case trailing
    case centerX
    case centerY
    case left
    case right
    case width
    case height
    }

    @discardableResult
    func priority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }

    @discardableResult
    func identifier(_ identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }

    @discardableResult
    func identifier(_ identifier: Identifier) -> NSLayoutConstraint {
        self.identifier = identifier.rawValue
        return self
    }

    func equalIdentifier(_ identifier: String) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier
    }

    func equalIdentifier(_ identifier: Identifier) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier.rawValue
    }
}

public extension UIView {
    func make(_ callback: (ConstraintMaker) -> Void) {
        self.snp.makeConstraints { (make) in
            callback(make)
        }
    }

    func removeConstraints() {
        self.snp.removeConstraints()
    }

    @discardableResult
    func removeConstraint(_ identifier: String) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
            return nil
        }
    }

    @discardableResult
    func removeConstraint(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
           return nil
       }
    }

    func constraints(to item: UIView) -> [NSLayoutConstraint] {
        return self.constraints.filter({ ($0.secondItem as? UIView) == item || ($0.firstItem as? UIView) == item })
    }

    func constraints(to item: UIView, attributed: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        let constraint = self.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
            guard let constraint = constraint as? LayoutConstraint else { return nil }
            guard let firstItem = constraint.firstItem as? UIView, firstItem == item, constraint.firstAttribute == attributed else { return nil }
            return constraint
        }
        return constraint
    }

    func constraints(labelType: ConstraintMakerFinalizable.LabelType, to targetView: UIView?) -> [NSLayoutConstraint] {
        if let targetView = targetView {
            return self.constraints(labelType: labelType).filter({ ($0.firstItem as? UIView) == targetView })
        } else {
            return self.constraints(labelType: labelType)
        }
    }

    func constraints(labelType: ConstraintMakerFinalizable.LabelType) -> [NSLayoutConstraint] {
        return self.constraints(label: labelType.rawValue)
    }

    func constraints(label: String) -> [NSLayoutConstraint] {
        let constraint = self.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
            guard let constraint = constraint as? LayoutConstraint else { return nil }
            guard let constraintLabel = constraint.label, constraintLabel == label else { return nil }
            return constraint
        }
        return constraint
    }
}

public extension Array where Element == NSLayoutConstraint {
    @discardableResult
    func addSuperview(_ view: UIView) -> [NSLayoutConstraint] {
        view.addConstraints(self)
        return self
    }

    @discardableResult
    func priority(_ priority: Float) -> [NSLayoutConstraint] {
        self.forEach({ $0.priority = UILayoutPriority(priority) })
        return self
    }

    func identifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }

    func identifier(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }
}
