import UIKit

protocol ExpenseCategorySelectionViewControllerDelegate: AnyObject {
    func didSelectExpenseCategory(_ category: String)
}

class ExpenseCategorySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: ExpenseCategorySelectionViewControllerDelegate?

    private let categories = ["음식", "여행", "쇼핑", "운동", "여가","교통비","뷰티","병원","핸드폰","적금", "그 외 지출"]
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        delegate?.didSelectExpenseCategory(selectedCategory)
        navigationController?.popViewController(animated: true)
    }
}

