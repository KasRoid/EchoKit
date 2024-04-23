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
    private let consoleView = ConsoleView()
    
    private let viewModel: ConsoleViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var isPresenting = false
    private lazy var interactiveViewHeightAnchor = interactiveView.heightAnchor.constraint(equalToConstant: UIView.defaultConsoleHeight)
    private lazy var consoleViewHeightAnchor = consoleView.heightAnchor.constraint(equalToConstant: UIView.defaultConsoleHeight)
    
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
        bind()
    }
}

// MARK: - Private Functions
extension ConsoleViewController {
    
    private func handleMoreActions(actions: [HeaderViewModel.MoreAction]) {
        isPresenting = true
        showActionSheet(actions: actions) { [weak self] in
            switch $0 {
            case .share:
                self?.showActivity()
            case .divider:
                self?.viewModel.send(.divider)
            case .clear:
                self?.viewModel.send(.clear)
            case .copy:
                self?.viewModel.send(.copy)
            }
        } completion: { [weak self] in
            self?.isPresenting = false
        }
    }
}

// MARK: - Bindings
extension ConsoleViewController {
    
    private func bind() {
        $isPresenting
            .sink { [weak self] in
                let constant = $0 ? UIView.screenHeight : UIView.defaultConsoleHeight
                self?.interactiveViewHeightAnchor.constant = constant
            }
            .store(in: &cancellables)
        
        viewModel.$windowState
            .dropFirst()
            .sink { [weak self] state in
                UIView.animate(withDuration: 0.1) {
                    switch state {
                    case .closed:
                        self?.consoleView.isHidden = true
                    case .fullscreen:
                        self?.consoleView.controlWindow(.fullscreen)
                        self?.consoleViewHeightAnchor.constant = UIView.safeScreenHeight
                    case .minimized:
                        self?.consoleView.controlWindow(.minimize)
                        self?.consoleViewHeightAnchor.constant = 30
                    case .windowed:
                        self?.consoleView.controlWindow(.fullscreen)
                        self?.consoleViewHeightAnchor.constant = UIView.defaultConsoleHeight
                    }
                    self?.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension ConsoleViewController: ActionProvider {
    
    private func setupUI() {
        addSubviews()
        setupInteractiveView()
        setupConsole()
        setupHeaderView()
        setupBodyView()
        setupFooterView()
    }
    
    private func addSubviews() {
        view.addSubview(interactiveView)
        interactiveView.addSubview(consoleView)
        interactiveView.translatesAutoresizingMaskIntoConstraints = false
        consoleView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupInteractiveView() {
        let maximumHeightAnchorConstraint = interactiveView.heightAnchor.constraint(greaterThanOrEqualTo: consoleView.heightAnchor)
        maximumHeightAnchorConstraint.priority = .defaultHigh
        interactiveViewHeightAnchor.priority = UILayoutPriority(749)
        
        NSLayoutConstraint.activate([
            interactiveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            interactiveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            interactiveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maximumHeightAnchorConstraint,
            interactiveViewHeightAnchor
        ])
    }
    
    private func setupConsole() {
        consoleViewHeightAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            consoleView.leadingAnchor.constraint(equalTo: interactiveView.leadingAnchor),
            consoleView.trailingAnchor.constraint(equalTo: interactiveView.trailingAnchor),
            consoleView.bottomAnchor.constraint(equalTo: interactiveView.bottomAnchor),
            consoleViewHeightAnchor
        ])
    }
    
    private func setupHeaderView() {
        let headerViewModel = HeaderViewModel()
        consoleView.setupHeaderView(viewModel: headerViewModel)
        headerViewModel.publisher
            .sink { [weak self] in
                switch $0 {
                case .adjustWindow(let action):
                    self?.viewModel.send(.adjustWindow(action))
                case .showActions:
                    self?.handleMoreActions(actions: headerViewModel.moreActions) }
            }
            .store(in: &cancellables)
    }
    
    private func setupBodyView() {
        let bodyViewModel = BodyViewModel()
        consoleView.setupBodyView(viewModel: bodyViewModel)
    }
    
    private func setupFooterView() {
        let footerViewModel = FooterViewModel()
        consoleView.setupFooterView(viewModel: footerViewModel)
    }
    
    private func showActivity() {
        isPresenting = true
        let items = [viewModel.fullLogs]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.completionWithItemsHandler = { [weak self] _, _, _, _ in self?.isPresenting = false }
        present(controller, animated: true)
    }
}
