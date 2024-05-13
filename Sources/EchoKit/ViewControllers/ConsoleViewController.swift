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
    private let bubbleView: BubbleView
    private let consoleView = ConsoleView()
    
    @Published private var isPresenting = false
    
    private let viewModel: ConsoleViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var interactiveViewHeightAnchor = interactiveView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var consoleViewHeightAnchor = consoleView.heightAnchor.constraint(equalToConstant: UIView.defaultConsoleHeight)
    
    internal init(viewModel: ConsoleViewModel, interactiveView: UIView, bubbleView: BubbleView) {
        self.viewModel = viewModel
        self.interactiveView = interactiveView
        self.bubbleView = bubbleView
        super.init(nibName: nil, bundle: nil)
        bubbleView.prepare(parentView: view)
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
    
    private func showActionSheet(actions: [HeaderViewModel.MoreAction], handler: @escaping (HeaderViewModel.MoreAction) -> Void) {
        isPresenting = true
        showActionSheet(actions: actions, handler: handler) { [weak self] in
            self?.isPresenting = false
        }
    }
    
    private func showOptionSheet(handler: @escaping (Filter) -> Void) {
        isPresenting = true
        showActionSheet(actions: Filter.allCases, handler: handler) { [weak self] in
            self?.isPresenting = false
        }
    }
    
    private func showClearFilterAlert() {
        guard !(presentedViewController is UIAlertController) else { return }
        isPresenting = true
        showAlert(title: "Clear Filters",
                  message: "Are you sure you want to clear all filters?",
                  handler: { [weak self] in self?.viewModel.send(.clearFilters) },
                  completion: { [weak self] in self?.isPresenting = false })
    }
}

// MARK: - Bindings
extension ConsoleViewController {
    
    private func bind() {
        $isPresenting
            .sink { [weak self] in
                let constant = $0 ? UIView.screenHeight : 0
                self?.interactiveViewHeightAnchor.constant = constant
            }
            .store(in: &cancellables)
        
        viewModel.$windowState
            .dropFirst()
            .sink { [weak self] state in
                UIView.animate(withDuration: 0.1) {
                    switch state {
                    case .fullscreen, .windowed:
                        self?.consoleView.controlWindow(.zoom)
                        self?.consoleViewHeightAnchor.constant = state == .windowed ? UIView.defaultConsoleHeight : UIView.safeScreenHeight
                    case .minimized:
                        self?.consoleView.controlWindow(.minimize)
                        self?.consoleViewHeightAnchor.constant = 30
                    case .closed:
                        break
                    }
                    self?.view.layoutIfNeeded()
                }
                self?.consoleView.isHidden = state == .closed
                self?.bubbleView.isHidden = state != .closed
            }
            .store(in: &cancellables)
        
        bubbleView.tap
            .sink { [weak self] in self?.viewModel.send(.activateWindow) }
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
        let headerViewModel = viewModel.headerViewModel
        consoleView.setupHeaderView(viewModel: headerViewModel)
        headerViewModel.result
            .sink { [weak self] in
                switch $0 {
                case .actions(let actions, let handler):
                    self?.showActionSheet(actions: actions, handler: handler)
                case .quit:
                    self?.viewModel.send(.quit)
                case .window(let action):
                    self?.viewModel.send(.adjustWindow(action))
                case .filter(let showOption):
                    if showOption {
                        self?.showOptionSheet {
                            self?.viewModel.send(.filter($0))
                        }
                    } else {
                        self?.viewModel.send(.filter(.system))
                    }
                case .clearFilter:
                    self?.showClearFilterAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupBodyView() {
        let bodyViewModel = viewModel.bodyViewModel
        consoleView.setupBodyView(viewModel: bodyViewModel)
    }
    
    private func setupFooterView() {
        let footerViewModel = viewModel.footerViewModel
        consoleView.setupFooterView(viewModel: footerViewModel)
    }
}
