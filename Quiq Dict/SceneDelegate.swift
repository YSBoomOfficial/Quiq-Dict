//
//  SceneDelegate.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		window?.rootViewController = makeRootVC()
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}
}

fileprivate extension SceneDelegate {

	// MARK: Make WordListViewController that loads remote data
	private func makeWordListVCLoadsRemoteData() -> WordListViewController {
		WordListViewController(
			words: [],
			searchAction: RemoteWordsLoader.shared.fetchDefinitions,
			didSelectWord: { word in
				WordDetailViewController(word: word, audioService: RemotePhoneticsAudioLoader.shared)
			},
			onSave: DataManager.shared.add,
			onDelete: { _ in
				// No Delete action for Remote Loaders
			}
		)

	}

	// MARK: Make WordListViewController that loads local data
	private func makeWordListVCLoadsLocalData() -> WordListViewController {
		WordListViewController(
			words: DataManager.shared.words,
			searchAction: LocalWordsLoader.shared.fetchDefinitions,
			didSelectWord: { word in
				WordDetailViewController(word: word, audioService: LocalPhoneticsAudioLoader.shared)
			},
			onSave: { _ in
				// No Save action for Local Loaders
			},
			onDelete: DataManager.shared.remove
		)
	}

	// MARK: Root TabBarController
	private func makeRootVC() -> UITabBarController {
		let wordListVCLoadsRemoteData = makeWordListVCLoadsRemoteData()
		wordListVCLoadsRemoteData.tabBarItem = .init(title: "Search", image: .init(systemName: "magnifyingglass"), tag: 0)

		let wordListVCLoadsLocalData = makeWordListVCLoadsLocalData()
		wordListVCLoadsLocalData.tabBarItem = .init(title: "Saved", image: .init(systemName: "archivebox"), tag: 1)


		let tabBarVC = UITabBarController()
		tabBarVC.viewControllers = [
			UINavigationController(rootViewController: wordListVCLoadsRemoteData),
			UINavigationController(rootViewController: wordListVCLoadsLocalData),
		]
		return tabBarVC
	}
}
