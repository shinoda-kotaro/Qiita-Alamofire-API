import UIKit

class ArticleListViewController: UIViewController {

    @IBOutlet weak var articleListTableView: UITableView!
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "記事一覧"
        
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        
        self.articleListTableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        articleListTableView.estimatedRowHeight = 10000
        
        fetchData()
    }
    
    func fetchData() {
        ArticleViewModel.fetchArticle(completion: { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.articleListTableView.reloadData()
            }
        })
    }
    
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleListTableViewCell
        let article = articles[indexPath.row]
        cell.articleTitle.text = article.title
        cell.createdAt.text = article.created_at
        cell.updatedAt.text = article.updated_at
        
        return cell
    }
    
}
