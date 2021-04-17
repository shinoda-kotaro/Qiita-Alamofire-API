import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SafariServices

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    var articles = [Article]()
    
    let viewModel: ArticleViewModel = ArticleViewModel()
    
    let disposeBag = DisposeBag()
    
    let scrollToTopButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "記事一覧"
        
        setTableView()
        
        articleListTableView.estimatedRowHeight = 10000
        
        setButton()
        
        setBinding()
        
        viewModel.getArticles()
    }
    
    // setting table view
    private func setTableView() {
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        self.articleListTableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        articleListTableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            openSafari(url: articles[indexPath.row].url)
        }).disposed(by: disposeBag)
    }
    
    // 記事をsafariで開く
    private func openSafari(url: String) {
        let webPage = url
        let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
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
    
    // ページトップまでスクロールするボタンの設定
    private func setButton() {
        scrollToTopButton.frame = CGRect(x: self.view.bounds.width - 50, y: self.view.bounds.height - 100, width: 30, height: 30)
        scrollToTopButton.backgroundColor = .lightGray
        scrollToTopButton.layer.cornerRadius = 5
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        scrollToTopButton.rx.tap.subscribe {[unowned self] _ in
            self.articleListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }.disposed(by: disposeBag)
        view.addSubview(scrollToTopButton)
    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleListTableViewCell
        let article = articles[indexPath.row]
        cell.articleTitle.text = article.title
        cell.createdAt.text = article.created_at
        cell.updatedAt.text = article.updated_at
        cell.number.text = String(indexPath.row)
        cell.number.lineBreakMode = .byClipping
        
        return cell
    }
    
    // 記事取得
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.articles.count >= 30 && indexPath.row == (self.articles.count - 5) {
            self.viewModel.getArticles()
        }
    }
    
    // スクロールボタンを隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollToTopButton.isHidden = true
    }
    
    // スクロールボタンを表示
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToTopButton.isHidden = false
    }
    
}
