import Foundation
import Alamofire

final class ArticleModel {
    
    private init() {}
    static let shared = ArticleModel()
    
    var page = 1
    let baseURL = "https://qiita.com/api/v2/items"
    var fetchParameter = FetchParameter()
    
    func getArticles(completion: @escaping ([Article]) -> Void) {
        
        let parameters = ["per_page": 30, "page": page]
        
        guard fetchParameter == .complete || fetchParameter == .initial else {
            switch fetchParameter {
            case .error:    print("エラーがあります"); break
            case .full:     print("記事がいっぱいです"); break
            case .loading:  print("記事を取得中です"); break
            case .initial:  break
            case .complete: break
            }
            return
        }
        
        // フェッチ開始
        fetchParameter = .loading
        AF.request(baseURL, parameters: parameters).response { response in
            switch response.result {
            case .success(let jsonData): do {
                guard let jsonData = jsonData else {
                    self.fetchParameter = .error
                    print("データがありません")
                    return
                }
                
//                print(String(data: jsonData, encoding: .utf8)!)
                
                let articles = try JSONDecoder().decode([Article].self, from: jsonData)
                print(articles.count, self.page, parameters, self.fetchParameter)
                
                // ある程度のところで打ち止め
                if self.page > 5 {
                    self.fetchParameter = .full
                    return
                }
                
                // 次にロードするページを増やす
                self.page += 1
                completion(articles)
                self.fetchParameter = .complete // ロード完了！！！
            } catch {
                self.fetchParameter = .error
                print("デコードに失敗しました: \(error)")
            }
            
            case .failure(let error): do{
                self.fetchParameter = .error
                print(error.localizedDescription)
            }
            }
        }
    }
    
}


enum FetchParameter {
    case loading
    case initial
    case complete
    case full
    case error
    
    init() {
        self = .initial
    }
}
