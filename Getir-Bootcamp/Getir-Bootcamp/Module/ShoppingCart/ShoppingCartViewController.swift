
//  ShoppingCartViewController.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

import UIKit



protocol ShoppingCartViewControllerProtocol: AnyObject {
    func displayCartItems(_ items: [Product])
    func displaySuccessMessage(_ message: String)
    func setupNavBar()
    func displaySuggestedProducts(_ items: [HorizontalProduct])
}

final class ShoppingCartViewController: BaseViewController {
    enum Section: Int, CaseIterable {
        case horizontal, vertical
    }

    enum DataItem: Hashable{
        case basketProducts(Product)
        case sugesstedProducts(HorizontalProduct)
    }

    var presenter: ShoppingCartPresenterProtocol!
    var dataSource: UICollectionViewDiffableDataSource<Section, DataItem>! = nil


    var collectionView: UICollectionView!
    var productArr : [Product] = []
    var suggestedProductArr : [HorizontalProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupNavBar()
        configureCollectionView()
        configureDataSource()
    }
    

    
}

extension ShoppingCartViewController : UICollectionViewDelegate {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(SuggestedProductCell.self, forCellWithReuseIdentifier: SuggestedProductCell.reuseIdentifier) // Add this line
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.createSuggestedSectionLayout()
            case 1:
                return self.createMainSectionLayout()
             default:
                return self.createSuggestedSectionLayout()
            }
        }
        return layout
    }
    
    private func createMainSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, 
                                                     leading: 5,
                                                     bottom: 5,
                                                     trailing: 5)
        let spacing: CGFloat = 10
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(spacing), 
                                                         top: .fixed(spacing),
                                                         trailing: .fixed(spacing),
                                                         bottom: .fixed(spacing))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createSuggestedSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), 
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, 
                                                     leading: 8,
                                                     bottom: 0,
                                                     trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), 
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, 
                                      leading: 0,
                                      bottom: 15,
                                      trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }


    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource
        <Section, DataItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, dataItem: DataItem) -> UICollectionViewCell in
            
            switch dataItem {
            case .basketProducts(let product):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else {fatalError("Couldn't Create New Cell")}
                cell.stepperValueChangedHandler = { [weak self] newValue in
                    // Update the corresponding product's quantity
                    self?.productArr[indexPath.item].quantity = newValue
                    self?.updateQuantityInBasketManager(for: product, newQuantity: newValue)
//                    self!.updateTotalPrice()
                }
               
                // Set product name
                cell.cellPresenter = ListCellPresenter(view: cell, product: product)
                return cell
            case .sugesstedProducts(let sugesstedProd):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedProductCell.reuseIdentifier, for: indexPath) as? SuggestedProductCell else {
                    fatalError("Couldn't Create New Cell")}
                cell.stepperValueChangedHandler = { [weak self] newValue in
                    // Update the corresponding product's quantity
                    self?.suggestedProductArr[indexPath.item].quantity = newValue
                    self?.updateQuantityInBasketManager(for: sugesstedProd, newQuantity: newValue)
//                    self!.updateTotalPrice()
                }
                cell.suggestedProductCellPresenter = SuggestedProductCellPresenter(view: cell, product: sugesstedProd)
                return cell
            }
        }
        dataSource.apply(snapshotForCurrentState(), animatingDifferences: false)
    }
    func updateQuantityInBasketManager(for product: Product, newQuantity: Int) {
            BasketManager.shared.updateQuantity(for: product.id!, newQuantity: newQuantity)
    }
}

extension ShoppingCartViewController : ShoppingCartViewControllerProtocol{
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, DataItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>()
        snapshot.appendSections(Section.allCases)

        // Convert each VerticalProduct to DataItem.products
        let verticalDataItems = productArr.map { DataItem.basketProducts($0) }
        snapshot.appendItems(verticalDataItems, toSection: Section.vertical)

        // Convert each HorizontalProduct to DataItem.sugesstedProducts
        let horizontalDataItems = suggestedProductArr.map { DataItem.sugesstedProducts($0) }
        snapshot.appendItems(horizontalDataItems, toSection: Section.horizontal)

        return snapshot
    }
    func displaySuggestedProducts(_ items: [HorizontalProduct]) {
        self.suggestedProductArr = items
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupNavBar() {
        
    }
    
    func displayCartItems(_ items: [Product]) {
        self.productArr = items
      
    }
    
    func displaySuccessMessage(_ message: String) {
        
    }
    
    
}
