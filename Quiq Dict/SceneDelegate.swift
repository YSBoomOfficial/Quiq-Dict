//
//  SceneDelegate.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let dataManager = DataManager(phoneticsLoader: RemotePhoneticsAudioLoader())

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
	// MARK: Root TabBarController
	private func makeRootVC() -> UITabBarController {
        let wordListVCLoadsRemoteData = makeWordListVCLoadsRemoteData()
		wordListVCLoadsRemoteData.tabBarItem = .init(title: "Search", image: .init(systemName: "magnifyingglass"), tag: 0)

        let wordListVCLoadsLocalData = makeWordListVCLoadsLocalData()
		wordListVCLoadsLocalData.tabBarItem = .init(title: "Saved", image: .init(systemName: "archivebox"), tag: 1)

		let tabBarVC = UITabBarController()
		tabBarVC.viewControllers = [
			UINavigationController(rootViewController: wordListVCLoadsRemoteData),
            UINavigationController(rootViewController: wordListVCLoadsLocalData)
		]
		return tabBarVC
	}

    private func makeWordListVCLoadsRemoteData() -> WordListViewController {
		let remoteWordLoader = RemoteWordsLoader()

		let remoteWordListDataSource = WordListDataSource()
		let remoteWordListDelegate = WordListDelegate(
			onSave: { [weak self] index in
				guard let self else { return }
				let word = remoteWordListDataSource.word(at: index)
				self.dataManager.add(word: word)
			}
		)

        let wordListVCLoadsRemoteData = WordListViewController(
            dataSource: remoteWordListDataSource,
			delegate: remoteWordListDelegate,
            searchAction: remoteWordLoader.fetchDefinitions
        )

		remoteWordListDelegate.didSelectWord = { [weak self, weak wordListVCLoadsRemoteData] index in
			let word = remoteWordListDataSource.word(at: index)
			let vc = WordDetailViewController(word: word, audioService: RemotePhoneticsAudioLoader())
			wordListVCLoadsRemoteData?.show(vc, sender: self)
		}

		return wordListVCLoadsRemoteData
    }

    private func makeWordListVCLoadsLocalData() -> WordListViewController {
        let localWordsLoader = LocalWordsLoader(dataManager: dataManager)
        let localPhoneticsLoader = LocalPhoneticsAudioLoader(dataManager: dataManager)

		let localWordListDataSource = WordListDataSource(words: dataManager.words)
		let localWordListDelegate = WordListDelegate(
			onDelete: { [weak self] index in
				guard let self else { return }
				let word = localWordListDataSource.word(at: index)
				self.dataManager.remove(word: word)
				localWordListDataSource.removeWord(at: index)
			}
		)

        let wordListVCLoadsLocalData = WordListViewController(
            dataSource: localWordListDataSource,
			delegate: localWordListDelegate,
            searchAction: localWordsLoader.fetchDefinitions
        )

		localWordListDelegate.didSelectWord = { [weak self, weak wordListVCLoadsLocalData] index in
			let word = localWordListDataSource.word(at: index)
			let vc = WordDetailViewController(word: word, audioService: localPhoneticsLoader)
			wordListVCLoadsLocalData?.show(vc, sender: self)
		}

        return wordListVCLoadsLocalData
    }

}
