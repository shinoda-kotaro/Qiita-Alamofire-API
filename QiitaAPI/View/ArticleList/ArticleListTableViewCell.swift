import UIKit

protocol ArticleListTableViewCellDelegate {
    func onTapped()
}

class ArticleListTableViewCell: UITableViewCell, ArticleListTableViewCellDelegate {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var number: UILabel!
    
    func onTapped() {
        // タップイベント
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let nib = UINib(nibName: "ArticleListTableViewCell", bundle: .main)
//        let cell = nib.instantiate(withOwner: self, options: nil).first as! ArticleListTableViewCell
//        cell.frame = self.bounds
//        self.addSubview(cell)
        
        articleTitle.numberOfLines = 0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
