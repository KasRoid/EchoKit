//
//  ConsoleViewController.swift
//
//
//  Created by Doyoung Song on 4/22/24.
//

import Combine
import UIKit

internal final class ConsoleViewController: UIViewController, Echoable {
    
    private let interactiveView: UIView
    private var console: ConsoleView?
    private let viewModel: ConsoleViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ConsoleViewModel, interactiveView: UIView) {
        self.interactiveView = interactiveView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Functions
extension ConsoleViewController {
    
    private func handleMoreActions(actions: [HeaderViewModel.MoreAction]) {
        showActionSheet(actions: actions) { [weak self] action in
            self?.print(action)
        }
    }
}

// MARK: - UI
extension ConsoleViewController: ActionProvider {
    
    private func setupUI() {
        setupInteractiveView()
        setupConsole()
        setupHeaderView()
        setupBodyView()
        setupFooterView()
    }
    
    private func setupInteractiveView() {
        interactiveView.width = UIView.screenWidth
        interactiveView.height = UIView.screenHeight / 3
        interactiveView.frame.origin = .init(x: 0, y: UIView.screenHeight - interactiveView.height)
        view.addSubview(interactiveView)
    }
    
    private func setupConsole() {
        let console = ConsoleView()
        interactiveView.addSubview(console)
        console.frame = interactiveView.bounds
        self.console = console
    }
    
    private func setupHeaderView() {
        let headerViewModel = HeaderViewModel()
        console?.setupHeaderView(viewModel: headerViewModel)
        headerViewModel.publisher
            .sink { [weak self] _ in self?.handleMoreActions(actions: headerViewModel.moreActions) }
            .store(in: &cancellables)
    }
    
    private func setupBodyView() {
        let bodyViewModel = BodyViewModel()
        console?.setupBodyView(viewModel: bodyViewModel)
    }
    
    private func setupFooterView() {
        let footerViewModel = FooterViewModel()
        console?.setupFooterView(viewModel: footerViewModel)
    }
}
