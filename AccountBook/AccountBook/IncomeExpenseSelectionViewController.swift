import UIKit

protocol IncomeExpenseSelectionDelegate: AnyObject {
    func didSelectIncomeExpense(isIncome: Bool)
}

class IncomeExpenseSelectionViewController: UIViewController {

    weak var delegate: IncomeExpenseSelectionDelegate?

    private let incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수입", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let expenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지출", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(expenseButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        view.addSubview(incomeButton)
        view.addSubview(expenseButton)

        NSLayoutConstraint.activate([
            incomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incomeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            incomeButton.widthAnchor.constraint(equalToConstant: 200),
            incomeButton.heightAnchor.constraint(equalToConstant: 50),

            expenseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expenseButton.topAnchor.constraint(equalTo: incomeButton.bottomAnchor, constant: 20),
            expenseButton.widthAnchor.constraint(equalToConstant: 200),
            expenseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func incomeButtonTapped() {
        delegate?.didSelectIncomeExpense(isIncome: true)
        let incomeCategoryVC = IncomeCategorySelectionViewController()
        incomeCategoryVC.delegate = delegate as? IncomeCategorySelectionViewControllerDelegate
        navigationController?.pushViewController(incomeCategoryVC, animated: true)
    }

    @objc private func expenseButtonTapped() {
        delegate?.didSelectIncomeExpense(isIncome: false)
        let expenseCategoryVC = ExpenseCategorySelectionViewController()
        expenseCategoryVC.delegate = delegate as? ExpenseCategorySelectionViewControllerDelegate
        navigationController?.pushViewController(expenseCategoryVC, animated: true)
    }
}

