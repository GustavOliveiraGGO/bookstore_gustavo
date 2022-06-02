//
//  BookListViewController.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import UIKit

class BookListViewController: UIViewController {

    private var bookStore: BookStore?
    private var books: [Item]?
    private let viewModel = BookStoreViewModel()
    private var currentMax = 20
    private var currentStart = 0
    private var canLoadMore = true
    private lazy var load = LoadingView()
    private var coodinator: BookCoordinator?
    private var supportBookList = [Item]()
    private var isFavSelected: Bool = false
        
    @IBOutlet weak var bookCollectionView: UICollectionView! {
        didSet {
            bookCollectionView.delegate = self
            bookCollectionView.dataSource = self
            bookCollectionView.register(UINib(nibName: String(describing: BookCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: BookCollectionViewCell.self))
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 5.0
            flowLayout.scrollDirection = .vertical
            bookCollectionView.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar! {
        didSet {
            navBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        setup()
        DispatchQueue.main.async {
            self.fetchBookStore()
        }
    }

    private func setup() {
        self.setupNavBar()
        self.load.setup()
        load.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(load)
        NSLayoutConstraint.activate([
            load.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            load.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            load.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            load.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.coodinator = BookCoordinator(navigationController: self.navigationController ?? UINavigationController())
    }
    
    private func setupNavBar() {
        let navItem = UINavigationItem(title: "Book Store - iOS")
        let favItem = UIBarButtonItem(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(self.favBooks)
        )
        navItem.rightBarButtonItem = favItem

        navBar.setItems([navItem], animated: false)
    }
    
    private func fetchBookStore() {
        startLoad()
        viewModel.fetchBooks(maxResults: "20", startIndex: currentStart.description)
    }
    
    private func startLoad() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.load)
            self.load.onStartAnimating()
        }
    }
    
    private func stopLoad() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.load)
            self.load.onStopAnimating()
        }
    }
    
    @objc func favBooks() {
        let defaults = UserDefaults.standard
        let favorites = defaults.array(forKey: "FavoritesBooks")  as? [String] ?? [String]()
        self.books?.removeAll()
        if self.isFavSelected {
            self.books = supportBookList
        } else {
            for currentBook in supportBookList {
                guard let id = currentBook.id else { return }
                if favorites.contains(id) {
                    self.books?.append(currentBook)
                }
            }
        }
        self.isFavSelected = !isFavSelected
        DispatchQueue.main.async {
            self.bookCollectionView.reloadData()
        }
    }
}

extension BookListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
      
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}

extension BookListViewController: UICollectionViewDelegate {
    
}

extension BookListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let books = self.books else { return 0 }
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCollectionViewCell.self), for: indexPath) as! BookCollectionViewCell
        
        if let books = self.books, let volumeItens = books[indexPath.row].volumeInfo, let imageLinks = volumeItens.imageLinks, let thumb = imageLinks.smallThumbnail {
            cell.bookThumb.downloaded(from: thumb)
        }
        if indexPath.row == self.currentMax - 1 && canLoadMore {
            self.canLoadMore = false
            self.currentStart = self.currentMax - 1
            self.currentMax = self.currentMax + 20
            fetchBookStore()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let books = self.books else { return }
        DispatchQueue.main.async {
            self.coodinator?.startBookDetail(book: books[indexPath.row])
        }
    }
}

extension BookListViewController: FetchBookStore {
    func didFetch(bookStore: BookStore, books: [Item]) {
        self.stopLoad()
        self.canLoadMore = true
        if let _ = self.bookStore {
            self.books?.append(contentsOf: books)
        } else {
            self.bookStore = bookStore
            self.books = bookStore.items
        }
        self.supportBookList = self.books ?? [Item]()
        DispatchQueue.main.async {
            self.bookCollectionView.reloadData()
        }
    }
    
    func didntFetch(error: Error?) {
        stopLoad()
        self.canLoadMore = true
    }
}

extension BookListViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
}
