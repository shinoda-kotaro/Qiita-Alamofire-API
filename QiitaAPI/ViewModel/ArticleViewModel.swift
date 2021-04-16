import Foundation
import Alamofire
import RxRelay

class ArticleViewModel  {
    
    public var articles = BehaviorRelay<[Article]>(value: [Article]())
    
    func getArticle() {
        ArticleModel.getArticles { articles in
            guard articles.count > 0 else { return }
            var oldArticles = self.articles.value
            oldArticles.append(contentsOf: articles)
            self.articles.accept(oldArticles)
        }
    }
}
