import UIKit

extension UIView {
    func addBorder(edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        func addBorderHelper(to edge: UIRectEdge) -> UIView {
            let border = UIView()
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(border)

            switch edge {
            case .top:
                border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            case .bottom:
                border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            case .left:
                border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            case .right:
                border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            default:
                break
            }

            return border
        }

        if edges.contains(.top) || edges == .all { _ = addBorderHelper(to: .top) }
        if edges.contains(.bottom) || edges == .all { _ = addBorderHelper(to: .bottom) }
        if edges.contains(.left) || edges == .all { _ = addBorderHelper(to: .left) }
        if edges.contains(.right) || edges == .all { _ = addBorderHelper(to: .right) }
    }
}

