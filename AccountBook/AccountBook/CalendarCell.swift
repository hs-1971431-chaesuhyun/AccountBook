import UIKit

class CalendarCell: UICollectionViewCell {
    static let identifier = "CalendarCell"
    let dateLabel = UILabel()
    let incomeLabel = UILabel()
    let expenseLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateLabel.textAlignment = .center
        incomeLabel.textAlignment = .center
        expenseLabel.textAlignment = .center

        incomeLabel.font = UIFont.systemFont(ofSize: 12)
        expenseLabel.font = UIFont.systemFont(ofSize: 12)

        incomeLabel.textColor = .green
        expenseLabel.textColor = .red

        let stackView = UIStackView(arrangedSubviews: [dateLabel, incomeLabel, expenseLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        // 고정된 높이를 설정하여 일정한 레이아웃 유지
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            incomeLabel.heightAnchor.constraint(equalToConstant: 15),
            expenseLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateIncomeExpense(income: Double, expense: Double) {
        incomeLabel.text = income > 0 ? "\(Int(income))" : ""
        expenseLabel.text = expense > 0 ? "\(Int(expense))" : ""
    }
}

