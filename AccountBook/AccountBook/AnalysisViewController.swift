import UIKit
import CoreData

class AnalysisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    private var expenses: [Expense] = []
    private var monthlyExpenses: [String: Double] = [:]
    private var totalExpense: Double = 0.0
    private var isIncomeAnalysis: Bool = false

    private let segmentControl: UISegmentedControl = {
        let items = ["수입 분석", "지출 분석"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    
    private let yearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("연도 선택", for: .normal)
        button.addTarget(self, action: #selector(selectYear), for: .touchUpInside)
        return button
    }()
    
    private let monthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("월 선택", for: .normal)
        button.addTarget(self, action: #selector(selectMonth), for: .touchUpInside)
        return button
    }()
    
    private var selectedYear: Int?
    private var selectedMonth: Int?
    
    private let years: [Int] = Array(2000...Calendar.current.component(.year, from: Date()))
    private let months: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.monthSymbols
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSegmentControl()
        setupYearMonthButtons()
        setupTableView()
        loadExpenses()
    }

    private func setupNavigationBar() {
        let titleView = UIView()
        let imageView = UIImageView(image: UIImage(named: "sunny.jpeg"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40), // 원하는 너비로 설정
            imageView.heightAnchor.constraint(equalToConstant: 40) // 원하는 높이로 설정
        ])
        
        navigationItem.titleView = titleView
    }


    private func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupYearMonthButtons() {
        let stackView = UIStackView(arrangedSubviews: [yearButton, monthButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: yearButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadExpenses() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }

    private func calculateMonthlyExpenses() {
        guard let selectedYear = selectedYear, let selectedMonth = selectedMonth else {
            monthlyExpenses.removeAll()
            totalExpense = 0.0
            tableView.reloadData()
            return
        }
        
        let calendar = Calendar.current
        monthlyExpenses.removeAll()
        totalExpense = 0.0
        
        for expense in expenses {
            guard let date = expense.date else { continue }
            let components = calendar.dateComponents([.year, .month], from: date)
            if components.year == selectedYear && components.month == selectedMonth && expense.isIncome == isIncomeAnalysis {
                let category = expense.category ?? "기타"
                monthlyExpenses[category, default: 0.0] += expense.amount
                totalExpense += expense.amount
            }
        }
        tableView.reloadData()
    }

    @objc private func segmentChanged() {
        isIncomeAnalysis = segmentControl.selectedSegmentIndex == 0
        calculateMonthlyExpenses()
    }

    @objc private func selectYear() {
        let alert = UIAlertController(title: "연도 선택", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: alert.view.bounds.width - 20, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 0
        
        alert.view.addSubview(pickerView)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "선택", style: .default, handler: { _ in
            self.selectedYear = self.years[pickerView.selectedRow(inComponent: 0)]
            self.yearButton.setTitle("\(self.selectedYear!)년", for: .normal)
            self.calculateMonthlyExpenses()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectMonth() {
        let alert = UIAlertController(title: "월 선택", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: alert.view.bounds.width - 20, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        
        alert.view.addSubview(pickerView)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "선택", style: .default, handler: { _ in
            self.selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
            self.monthButton.setTitle("\(self.selectedMonth!)월", for: .normal)
            self.calculateMonthlyExpenses()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .none
    }


    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyExpenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let category = Array(monthlyExpenses.keys)[indexPath.row]
        let amount = monthlyExpenses[category]!
        let percentage = (amount / totalExpense) * 100
        cell.textLabel?.text = "\(category): \(Int(amount))원 (\(String(format: "%.2f", percentage))%)"
        return cell
    }
}

extension AnalysisViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? years.count : months.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? "\(years[row])" : months[row]
    }
}

