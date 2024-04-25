//
//  ProductListViewController.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation
import UIKit



protocol ProductListViewControllerProtocol: AnyObject {
    func reloadData()
    func setupVerticalProductsCollectionView()
    func setupNavigationBar()
    func showLoadingView()
    func hideLoadingView()
    func showError(_ message: String)
    func updateProducts(_ products: [VerticalProduct], _ sugesstedProducts: [HorizontalProduct])
}


final class ProductListViewController: BaseViewController {
    enum Section: Int, CaseIterable {
        case horizontal, vertical
    }
    
    enum DataItem: Hashable{
        case products(VerticalProduct)
        case sugesstedProducts(HorizontalProduct)
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DataItem>! = nil
    var collectionView: UICollectionView!
    var productArr : [VerticalProduct] = []
    var suggestedProductArr : [HorizontalProduct] = []
    var presenter: ProductListPresenterProtocol!
    private var cartBarButtonItemView: CartBarButtonItemView?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        presenter.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
}

//TODO: modular yap
extension ProductListViewController: UICollectionViewDelegate {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(SuggestedProductCell.self, forCellWithReuseIdentifier: SuggestedProductCell.reuseIdentifier)
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.27),
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
            case .products(let product):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {fatalError("Couldn't Create New Cell")}
                cell.stepperValueChangedHandler = { [weak self] newValue in
                    
                    self?.productArr[indexPath.item].quantity = newValue
                    self?.updateQuantityInBasketManager(for: product, newQuantity: newValue)
                    self!.updateTotalPrice()
                }
                
                
                cell.cellPresenter = ProductCellPresenter(view: cell, product: product)
                return cell
            case .sugesstedProducts(let sugesstedProd):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedProductCell.reuseIdentifier, for: indexPath) as? SuggestedProductCell else {
                    fatalError("Couldn't Create New Cell")}
                cell.stepperValueChangedHandler = { [weak self] newValue in
                    
                    self?.suggestedProductArr[indexPath.item].quantity = newValue
                    self?.updateQuantityInBasketManager(for: sugesstedProd, newQuantity: newValue)
                    self!.updateTotalPrice()
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = productArr[indexPath.item]
        presenter.didSelectProduct(product: selectedProduct)
    }
}




extension ProductListViewController: ProductListViewControllerProtocol {
    func reloadData() {
        
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, DataItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>()
        snapshot.appendSections(Section.allCases)
        
        // Convert each VerticalProduct to DataItem.products
        let verticalDataItems = productArr.map { DataItem.products($0) }
        snapshot.appendItems(verticalDataItems, toSection: Section.vertical)
        
        // Convert each HorizontalProduct to DataItem.sugesstedProducts
        let horizontalDataItems = suggestedProductArr.map { DataItem.sugesstedProducts($0) }
        snapshot.appendItems(horizontalDataItems, toSection: Section.horizontal)
        
        return snapshot
    }
    
    
    
    func updateProducts(_ products: [VerticalProduct],_ sugesstedProducts: [HorizontalProduct]) {
        self.productArr = products
        self.suggestedProductArr = sugesstedProducts
        
        let snapshot = snapshotForCurrentState()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        updateTotalPrice()
        
    }
    
    private func updateTotalPrice() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("Calculating total price")
            
            let totalPrice = BasketManager.shared.getTotalPrice()
            
            
            
            self.cartBarButtonItemView?.updateTotalPriceLabel(with: totalPrice)
        }
    }
    
    
    
    func setupVerticalProductsCollectionView() {
        
    }
    
    func setupNavigationBar() {
        
        let customView = CartBarButtonItemView()
        self.cartBarButtonItemView = customView
        // custom cartBarButtonItem view in utils folder
        
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        cartBarButtonItemView?.isUserInteractionEnabled = true
        customBarButtonItem.target = self
        customBarButtonItem.action = #selector(rightBarButtonTapped)
        navigationItem.rightBarButtonItem = customBarButtonItem
        let shoppingButton = UIBarButtonItem(title: "Shopping", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.leftBarButtonItem = shoppingButton
        
        title = "Ürünler"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func rightBarButtonTapped() {
        presenter.tappedBasketButton()
        print("bar button tapped")
    }
    
    func showLoadingView() {
        // Implement loading view display if needed
    }
    
    func hideLoadingView() {
        // Implement hiding loading view if needed
    }
    
    func showError(_ message: String) {
        // Implement error display if needed
    }
}

