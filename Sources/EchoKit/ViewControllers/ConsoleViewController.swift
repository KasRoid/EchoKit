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
    
    @Published private(set) var isPresenting = false
    @Published private(set) var isQuitable = false
    
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
    
    private func handleMoreActions(actions: [HeaderViewModel.MoreAction]) {
        isPresenting = true
        showActionSheet(actions: actions) { [weak self] in
            switch $0 {
            case .share:
                self?.showActivity()
            case .buidInfo:
                self?.viewModel.send(.showBuildInfo)
            case .systemInfo:
                self?.viewModel.send(.showSystemInfo)
            case .divider:
                self?.viewModel.send(.divider)
            case .clear:
                self?.viewModel.send(.clear)
            case .copy:
                self?.viewModel.send(.copy)
            case .quit:
                self?.isQuitable = false
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
        let isQuitablePublisher = $isQuitable
            .dropFirst()
            .eraseToAnyPublisher()
        let headerViewModel = HeaderViewModel(isQuitablePublisher: isQuitablePublisher)
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
        let quitPublisher = $isQuitable
            .dropFirst()
            .filter { !$0 }
            .map { _ in Void() }
            .eraseToAnyPublisher()
        let bodyViewModel = BodyViewModel(environment: .production, quitPublisher: quitPublisher)
        bodyViewModel.logSelected
            .sink { [weak self] in self?.isQuitable = true }
            .store(in: &cancellables)
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
