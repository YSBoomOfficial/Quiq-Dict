//
//  WordListDataSource.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/10/2022.
//

import UIKit

final class WordListDataSource: NSObject {
    private var words = [Word]()

    init(words: [Word] = []) {
        self.words = words
    }

    func word(at index: Int) -> Word {
        words[index]
    }

    func addWord(_ word: Word) {
        words.append(word)
    }

    func removeWord(at index: Int) {
        words.remove(at: index)
    }

}

// MARK: UITableViewDataSource Methods
extension WordListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseID, for: indexPath) as? WordCell else {
            fatalError("Could not dequeue WordCell")
        }
        cell.configure(with: words[indexPath.row])
        return cell
    }
}

