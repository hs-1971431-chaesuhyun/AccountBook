import UIKit
import CoreData

protocol AddExpenseViewControllerDelegate: AnyObject {
    func didAddExpense()
}

class AddExpenseViewController: UIViewController, IncomeExpenseSelectionDelegate {

    weak var delegate: AddExpenseViewControllerDelegate?
    var selectedDate: Date?
    var expenseToEdit: Expense?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "카테고리를 골라주세요"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false // 텍스트 필드 직접 입력 불가
        return textField
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비용을 적어주세요"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()

    private var isIncome: Bool = true

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    private let selectCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카테고리 고르기", for: .normal)
        button.addTarget(self, action: #selector(selectCategoryButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        if let expense = expenseToEdit {
            categoryTextField.text = expense.category
            amountTextField.text = "\(expense.amount)"
            isIncome = expense.isIncome
        }
    }

    private func setupViews() {
        view.addSubview(categoryTextField)
        view.addSubview(amountTextField)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        view.addSubview(selectCategoryButton)
    }

    private func setupConstraints() {
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        selectCategoryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            selectCategoryButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 10),
            selectCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            amountTextField.topAnchor.constraint(equalTo: selectCategoryButton.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func saveButtonTapped() {
        guard let category = categoryTextField.text, !category.isEmpty,
              let amountText = amountTextField.text, let amount = Double(amountText),
              let date = selectedDate else { return }

        if let expense = expenseToEdit {
            expense.category = category
            expense.amount = amount
            expense.isIncome = isIncome
        } else {
            let newExpense = Expense(context: context)
            newExpense.category = category
            newExpense.amount = amount
            newExpense.isIncome = isIncome
            newExpense.date = date
        }

        do {
            try context.save()
            delegate?.didAddExpense()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save expense: \(error)")
        }
    }

    @objc private func deleteButtonTapped() {
        if let expense = expenseToEdit {
            context.delete(expense)
            do {
                try context.save()
                delegate?.didAddExpense()
                navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to delete expense: \(error)")
            }
        }
    }

    @objc private func selectCategoryButtonTapped() {
        let incomeExpenseSelectionVC = IncomeExpenseSelectionViewController()
        incomeExpenseSelectionVC.delegate = self
        navigationController?.pushViewController(incomeExpenseSelectionVC, animated: true)
    }

    func didSelectIncomeExpense(isIncome: Bool) {
        self.isIncome = isIncome
    }
}

extension AddExpenseViewController: IncomeCategorySelectionViewControllerDelegate, ExpenseCategorySelectionViewControllerDelegate {
    func didSelectIncomeCategory(_ category: String) {
        categoryTextField.text = category
        navigationController?.popViewController(animated: true)
    }

    func didSelectExpenseCategory(_ category: String) {
        categoryTextField.text = category
        navigationController?.popViewController(animated: true)
    }
}

