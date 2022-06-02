//
//  BookDetailViewController.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import UIKit
import SafariServices

class BookDetailViewController: BaseViewController {

    var book: Item?
    
    @IBOutlet weak var bookThumb: UIImageView!
    
    @IBOutlet weak var favButton: UIButton! {
        didSet {
            favButton.layer.cornerRadius = 20
            favButton.setImage(UIImage(named: "notFavBook"), for: .normal)
        }
    }
    
    @IBOutlet weak var bookDetailTitleLabel: UILabel! {
        didSet {
            bookDetailTitleLabel.text = "Título"
        }
    }
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookDetailAuthorLabel: UILabel! {
        didSet {
            bookDetailAuthorLabel.text = "Autor"
        }
    }
    
    @IBOutlet weak var bookAuthor: UILabel!
    
    @IBOutlet weak var bookDetailDescriptionLabel: UILabel! {
        didSet {
            bookDetailDescriptionLabel.text = "Descrição"
        }
    }
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var buyButton: UIButton! {
        didSet {
            buyButton.backgroundColor = .white
            buyButton.layer.cornerRadius = 6
            buyButton.setTitleColor(.black, for: .normal)
            buyButton.isHidden = true
            buyButton.setTitle("Comprar", for: .normal)
            buyButton.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        guard let nav = self.navigationController else { return }
        setupNavBar(title: "Detalhes", navBar: nav.navigationBar, navBarItem: nil)
    }
    
    override func setupNavBar(title: String, navBar: UINavigationBar, navBarItem: UIBarButtonItem?) {
        self.navigationItem.title = title
    }
    
    private func setup() {
        guard let book = book, let volumeInfo = book.volumeInfo, let authors = volumeInfo.authors, let imageLinks = volumeInfo.imageLinks, let thumb = imageLinks.thumbnail else { return }
        self.bookTitle.text = volumeInfo.title
        self.bookAuthor.text = authors[0]
        self.bookDescription.text = volumeInfo.volumeInfoDescription
        self.bookThumb.downloaded(from: thumb)
        if let salesInfo = book.saleInfo, let _ = salesInfo.buyLink {
            self.buyButton.isHidden = false
        }
        changeHeartIcon()
    }
    
    @IBAction func buyBook(_ sender: Any) {
        guard let book = book, let salesInfo = book.saleInfo, let buyLink = salesInfo.buyLink, let url = URL(string: buyLink) else {
            return
        }
        let configuration = SFSafariViewController.Configuration()
        let safariController = SFSafariViewController(url: url, configuration: configuration)
        present(safariController, animated: true, completion: nil)
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        guard let book = book, let id = book.id else { return }
        let defaults = UserDefaults.standard
        var favorites = getFavorites()
        if favorites.contains(id) {
            let newFavorites = favorites.filter { $0 != id }
            defaults.set(newFavorites, forKey: "FavoritesBooks")
        } else {
            favorites.append(id)
            defaults.set(favorites, forKey: "FavoritesBooks")
            
        }
        defaults.synchronize()
        changeHeartIcon()
    }
    
    private func getFavorites() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "FavoritesBooks")  as? [String] ?? [String]()
    }
    
    private func changeHeartIcon() {
        guard let book = book, let id = book.id else { return }
        let favorites = getFavorites()
        if favorites.contains(id) {
            favButton.setImage(UIImage(named: "favBook"), for: .normal)
        } else {
            favButton.setImage(UIImage(named: "notFavBook"), for: .normal)
        }
    }
}
