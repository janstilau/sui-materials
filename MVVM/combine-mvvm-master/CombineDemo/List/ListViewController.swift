//
//  ListViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<ListViewModel.Section, Player>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListViewModel.Section, Player>
    
    private lazy var contentView = ListView()
    private let viewModel: ListViewModel
    private var bindings = Set<AnyCancellable>()
    
    private var dataSource: DataSource!
    
    init(viewModel: ListViewModel = ListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        
        setUpTableView()
        configureDataSource()
        setUpBindings()
    }
    
    /*
     View 的构建操作, 移交完了 ListView 的内部, VC 里面, 仅仅做布局的处理.
     */
    private func setUpTableView() {
        contentView.collectionView.register(
            PlayerCollectionCell.self,
            forCellWithReuseIdentifier: PlayerCollectionCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrySearch()
    }
    
    private func setUpBindings() {
        /*
         ViewAction 的处理.
         ViewAction, 触发 ViewModel 的 IntentAction, 进行真正的业务逻辑的触发.
         在业务逻辑触发的最后, 是真正的 Model 的修改, 以及相关信号的发射.
         */
        func bindViewToViewModel() {
            contentView.searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak viewModel] in
                    viewModel?.search(query: $0)
                }
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            // 可以看到, 在 MVVM 的架构里面, View 的更新, 职责比较清晰.
            // 虽然没有总的 UpdateViews 这样的一个入口, 但是效率增加了. 减少了不需要更新的 View 的更新操作.
            // 虽然有点像是, ViewAction -> Model 特定数据的修改 -> 特定 View 的更新逻辑
            // 但是, 因为 ViewModel 里面, 会将信号进行聚合, 使得所有的对于 View 的修改, 合并成为一个信号源. 这要比上面的逻辑好追踪.
            /*
             数据源发生变化的 View 更新逻辑.
             */
            viewModel.$players
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    // Sink 是响应式的世界, 快速的达到指令式世界的入口.
                    // 这里没有很好的直接操作的 Operator. 直接到指令式的世界, 进行值的获取, Update 就好了.
                    self?.updateSections()
                })
                .store(in: &bindings)
            
            let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.contentView.startLoading()
                case .finishedLoading:
                    self?.contentView.finishLoading()
                case .error(let error):
                    self?.contentView.finishLoading()
                    self?.showError(error)
                }
            }
            /*
             数据源发生变化的 View 更新逻辑.
             */
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 进行 DataSource 相关逻辑的修改.
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.players])
        snapshot.appendItems(viewModel.players)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ListViewController {
    private func configureDataSource() {
        /*
         从这里来看, DataSource 的内部, 是将 Collection 的取值, DataSource 设置相关的逻辑, 放到了类的内部.
         */
        dataSource = DataSource(
            collectionView: contentView.collectionView,
            cellProvider: { (collectionView, indexPath, player) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlayerCollectionCell.identifier,
                    for: indexPath) as? PlayerCollectionCell
                cell?.viewModel = PlayerCellViewModel(player: player)
                return cell
            })
    }
}
