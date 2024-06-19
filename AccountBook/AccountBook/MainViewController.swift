import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, AddExpenseViewControllerDelegate {

    private var collectionView: UICollectionView!
    private var expenses: [Expense] = []
    private var dailyIncomeExpenses: [Date: (income: Double, expense: Double)] = [:]
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var selectedDate = Date()
    private var selectedIndexPath: IndexPath?
    private var daysInMonth: [String] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupDaysInMonth()
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
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
            navigationItem.rightBarButtonItem = addButton
        }


    private func setupViews() {
        setupCollectionView()
        setupTableView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let itemSize = (view.frame.size.width - 6) / 7
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 150)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        collectionView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 480),

            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupDaysInMonth() {
        daysInMonth.removeAll()

        let numberOfDays = CalendarHelper.shared.numberOfDaysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper.shared.firstDayOfMonth(date: selectedDate)

        for _ in 0..<firstDayOfMonth {
            daysInMonth.append("")
        }

        for day in 1...numberOfDays {
            daysInMonth.append("\(day)")
        }

        collectionView.reloadData()
    }

    func loadExpenses() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            expenses = try context.fetch(request)
            aggregateDailyIncomeExpenses()
            collectionView.reloadData()
            tableView.reloadData()
            updateSummaryView()
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }

    private func aggregateDailyIncomeExpenses() {
        dailyIncomeExpenses.removeAll()

        for expense in expenses {
            guard let date = expense.date else { continue }
            let startOfDay = Calendar.current.startOfDay(for: date)
            if dailyIncomeExpenses[startOfDay] == nil {
                dailyIncomeExpenses[startOfDay] = (income: 0, expense: 0)
            }
            if expense.isIncome {
                dailyIncomeExpenses[startOfDay]?.income += expense.amount
            } else {
                dailyIncomeExpenses[startOfDay]?.expense += expense.amount
            }
        }
    }

    private func updateSummaryView() {
        let monthExpenses = expenses.filter { Calendar.current.isDate($0.date!, equalTo: selectedDate, toGranularity: .month) }
        let totalIncome = monthExpenses.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let totalExpense = monthExpenses.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        let balance = totalIncome - totalExpense

        // 여기에 요약 정보 업데이트 코드를 추가하세요.
    }

    @objc func addButtonTapped() {
        addExpense(for: selectedDate)
    }

    private func addExpense(for date: Date) {
        let addExpenseVC = AddExpenseViewController()
        addExpenseVC.selectedDate = date
        addExpenseVC.delegate = self
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }

    func didAddExpense() {
        loadExpenses()
        updateDetailsView(for: selectedDate)
    }

    private func updateDetailsView(for date: Date) {
        tableView.reloadData()
    }

    @objc private func showPreviousMonth() {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) else { return }
        selectedDate = previousMonth
        setupDaysInMonth()
        loadExpenses()
    }

    @objc private func showNextMonth() {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) else { return }
        selectedDate = nextMonth
        setupDaysInMonth()
        loadExpenses()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let day = daysInMonth[indexPath.item]
        cell.dateLabel.text = day

        if day != "", let dayInt = Int(day), Calendar.current.isDate(selectedDate, equalTo: selectedDate, toGranularity: .month) {
            var dateComponents = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            dateComponents.day = dayInt
            if let cellDate = Calendar.current.date(from: dateComponents) {
                if let dailyIncomeExpense = dailyIncomeExpenses[cellDate] {
                    cell.updateIncomeExpense(income: dailyIncomeExpense.income, expense: dailyIncomeExpense.expense)
                } else {
                    cell.updateIncomeExpense(income: 0, expense: 0)
                }

                if Calendar.current.isDateInToday(cellDate) {
                    cell.dateLabel.backgroundColor = .systemBlue
                    cell.dateLabel.textColor = .white
                    cell.dateLabel.layer.cornerRadius = cell.dateLabel.frame.size.width / 2
                    cell.dateLabel.layer.masksToBounds = true
                } else {
                    cell.dateLabel.backgroundColor = .clear
                    cell.dateLabel.textColor = .black
                    cell.dateLabel.layer.cornerRadius = 0
                    cell.dateLabel.layer.masksToBounds = false
                }
            }
        } else {
            cell.dateLabel.backgroundColor = .clear
            cell.dateLabel.textColor = .black
            cell.dateLabel.layer.cornerRadius = 0
            cell.dateLabel.layer.masksToBounds = false
        }

        // 선택된 날짜 강조
        if indexPath == selectedIndexPath {
            cell.contentView.backgroundColor = UIColor.systemGray4
        } else {
            cell.contentView.backgroundColor = UIColor.clear
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath, let previousSelectedCell = collectionView.cellForItem(at: selectedIndexPath) {
            previousSelectedCell.contentView.backgroundColor = UIColor.clear
        }

        selectedIndexPath = indexPath
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.contentView.backgroundColor = UIColor.systemGray4

        guard let day = Int(daysInMonth[indexPath.item]) else { return }
        var dateComponents = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        dateComponents.day = day
        if let selectedDate = Calendar.current.date(from: dateComponents) {
            self.selectedDate = selectedDate
            updateDetailsView(for: selectedDate)
        }
    }

    // Header 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarHeaderView.identifier, for: indexPath) as! CalendarHeaderView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        headerView.configure(month: dateFormatter.string(from: selectedDate), previousAction: #selector(showPreviousMonth), nextAction: #selector(showNextMonth), target: self)
        
        // 요약 정보 업데이트
        let monthExpenses = expenses.filter { Calendar.current.isDate($0.date!, equalTo: selectedDate, toGranularity: .month) }
        let totalIncome = monthExpenses.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let totalExpense = monthExpenses.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        let balance = totalIncome - totalExpense
        
        headerView.incomeLabel.text = "수입: \(Int(totalIncome))원"
        headerView.expenseLabel.text = "지출: \(Int(totalExpense))원"
        headerView.balanceLabel.text = "잔액: \(Int(balance))원"

        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 원하는 간격을 설정
    }
}

// UITableViewDataSource, UITableViewDelegate 구현
extension MainViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        return expenses.filter { Calendar.current.startOfDay(for: $0.date!) == startOfDay }.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let dailyExpenses = expenses.filter { Calendar.current.startOfDay(for: $0.date!) == startOfDay }
        let expense = dailyExpenses[indexPath.row]

        cell.textLabel?.text = "\(expense.category ?? ""): \(expense.amount)"
        cell.textLabel?.textColor = expense.isIncome ? .green : .red

        return cell
    }

    // 편집 스타일 설정 (삭제 기능)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let startOfDay = Calendar.current.startOfDay(for: selectedDate)
            let dailyExpenses = expenses.filter { Calendar.current.startOfDay(for: $0.date!) == startOfDay }
            let expenseToDelete = dailyExpenses[indexPath.row]
            context.delete(expenseToDelete)
            do {
                try context.save()
                loadExpenses()
            } catch {
                print("Failed to delete expense: \(error)")
            }
        }
    }

    // 액세서리 버튼 (수정 기능) 설정
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let dailyExpenses = expenses.filter { Calendar.current.startOfDay(for: $0.date!) == startOfDay }
        let expenseToEdit = dailyExpenses[indexPath.row]
        let addExpenseVC = AddExpenseViewController()
        addExpenseVC.selectedDate = selectedDate
        addExpenseVC.expenseToEdit = expenseToEdit // 수정할 항목을 설정
        addExpenseVC.delegate = self
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }

    // 셀에 액세서리 타입 추가
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .detailDisclosureButton
    }
}

extension UIView {
    func addBorder(edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        if edges.contains(.top) || edges.contains(.all) {
            let border = UIView()
            border.backgroundColor = color
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            self.addSubview(border)
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            let border = UIView()
            border.backgroundColor = color
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            self.addSubview(border)
        }

        if edges.contains(.left) || edges.contains(.all) {
            let border = UIView()
            border.backgroundColor = color
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            self.addSubview(border)
        }

        if edges.contains(.right) || edges.contains(.all) {
            let border = UIView()
            border.backgroundColor = color
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            self.addSubview(border)
        }
    }
}

