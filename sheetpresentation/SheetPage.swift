//
//  SheetPage.swift
//  sheetpresentation
//
//  Created by Muhamed Ezaden Seraj on 8/6/21.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
        controller.prefersScrollingExpandsWhenScrolledToEdge = true
        controller.detents = [.large(), .medium()]
        controller.prefersGrabberVisible = true
        return controller
    }
}

class SheetPage: UITableViewController {

    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        APIService().getPosts { result in
            do {
                self.posts = try result.get()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("error")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
