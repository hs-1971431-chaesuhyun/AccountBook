import UIKit

class CalendarHeaderView: UICollectionReusableView {
    static let identifier = "CalendarHeaderView"

    let incomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.green
        return label
    }()

    let expenseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.red
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()

    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()

    private let daysOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        for day in days {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textColor = UIColor.white
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBlue
        
        addSubview(incomeLabel)
        addSubview(expenseLabel)
        addSubview(balanceLabel)
        addSubview(monthLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        addSubview(daysOfWeekStackView)
        
        // Add constraints
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        daysOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            incomeLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 5),
            incomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            expenseLabel.topAnchor.constraint(equalTo: incomeLabel.bottomAnchor, constant: 5),
            expenseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            balanceLabel.topAnchor.constraint(equalTo: expenseLabel.bottomAnchor, constant: 5),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            previousButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            nextButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            daysOfWeekStackView.topAnchor.constraint(equalTo: expenseLabel.bottomAnchor, constant: 30),
            daysOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            daysOfWeekStackView.heightAnchor.constraint(equalToConstant: 35),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(month: String, previousAction: Selector, nextAction: Selector, target: Any?) {
        monthLabel.text = month
        previousButton.addTarget(target, action: previousAction, for: .touchUpInside)
        nextButton.addTarget(target, action: nextAction, for: .touchUpInside)
    }
}

