import UIKit
import RxSwift
import RxRelay

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    var articles = [Article]()
    
    let viewModel: ArticleViewModel = ArticleViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "記事一覧"
        
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        
        self.articleListTableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        articleListTableView.estimatedRowHeight = 10000
        
        setBinding()
        
        viewModel.getArticle()
    }
    
    // バインディングをセット
    private func setBinding() {
        viewModel.articles.subscribe { event in
            guard let articles = event.element else { return }
            self.articles = articles
            DispatchQueue.main.async {
                self.articleListTableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleListTableViewCell
        let article = articles[indexPath.row]
        cell.articleTitle.text = article.title
        cell.createdAt.text = article.created_at
        cell.updatedAt.text = article.updated_at
        cell.number.text = String(indexPath.row)
        
        return cell
    }
    
    // 記事取得
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.articles.count >= 30 && indexPath.row == (self.articles.count - 5) {
            self.viewModel.getArticle()
        }
    }
    
}
