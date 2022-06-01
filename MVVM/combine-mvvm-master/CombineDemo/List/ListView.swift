//
//  ListView.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import UIKit

/*
 将 View 的构建, 完全的交给了 View 组件内部. 
 */
final class ListView: UIView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var searchTextField = UITextField()
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let subviews = [searchTextField, collectionView, activityIndicationView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.backgroundColor = .background
        searchTextField.autocorrectionType = .no
        searchTextField.backgroundColor = .background
        searchTextField.placeholder = "NBA Player"
    }
    
    func startLoading() {
        collectionView.isUserInteractionEnabled = false
        searchTextField.isUserInteractionEnabled = false
        
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        collectionView.isUserInteractionEnabled = true
        searchTextField.isUserInteractionEnabled = true
        
        activityIndicationView.stopAnimating()
    }
    
    private func setUpConstraints() {
        let defaultMargin: CGFloat = 4.0
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: defaultMargin),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultMargin),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
            searchTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: defaultMargin),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}

extension ListView {
    private func createLayout() -> UICollectionViewLayout {
        // 这种方式的函数调用, 在 Swfit 推崇的方式.
        // 我个人很不习惯. 但是, 标准的写法就是这样.
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 5
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
