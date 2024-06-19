import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        // MainViewController 설정
        let mainViewController = MainViewController()
        let mainNavController = UINavigationController(rootViewController: mainViewController)
        mainNavController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)

        // AnalysisViewController 설정
        let analysisViewController = AnalysisViewController()
        let analysisNavController = UINavigationController(rootViewController: analysisViewController)
        analysisNavController.tabBarItem = UITabBarItem(title: "Analysis", image: UIImage(systemName: "chart.bar"), tag: 1)

        // TabBarController 설정
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNavController, analysisNavController]
        tabBarController.delegate = self

        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

