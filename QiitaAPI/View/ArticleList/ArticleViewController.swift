//
//  ArticleViewController.swift
//  QiitaAPI
//
//  Created by 信田　虎太郎 on 2021/04/13.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleTableView.delegate = self
        articleTableView.dataSource = self
    }

}


extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}
