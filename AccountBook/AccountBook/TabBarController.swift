import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMiddleButton()
        print("viewDidLoad called") // viewDidLoad가 호출되었는지 확인
    }

    func setupMiddleButton() {
        addButton = UIButton(type: .custom)
        
        addButton.frame.size = CGSize(width: 60, height: 60)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 30
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowRadius = 10
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        self.tabBar.addSubview(addButton)
        print("Add button added to tabBar: \(addButton.superview == self.tabBar)")  // 버튼이 tabBar에 추가되었는지 확인
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        print("Button Constraints Set")  // 제약 조건이 설정되었는지 확인
    }

    @objc private func addButtonTapped() {
        print("Add button tapped") // 버튼 탭이 호출되었는지 확인
        if let mainViewController = viewControllers?.first(where: { $0 is UINavigationController && ($0 as! UINavigationController).viewControllers.first is MainViewController }) {
            (mainViewController as! UINavigationController).popToRootViewController(animated: false)
            (mainViewController as! UINavigationController).viewControllers.first?.perform(Selector(("addButtonTapped")))
        }
    }
}

