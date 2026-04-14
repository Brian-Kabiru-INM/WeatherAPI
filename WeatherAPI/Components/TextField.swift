import UIKit

final class TextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        borderStyle = .none
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        autocapitalizationType = .words
        returnKeyType = .search
        clearButtonMode = .whileEditing

        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        leftView = padding
        leftViewMode = .always
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
