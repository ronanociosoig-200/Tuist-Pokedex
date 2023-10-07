//
//  Coordinator.swift
//  Catch
//
//  Created by Ronan on 01/07/21.
//  Copyright © 2021 Sonomos. All rights reserved.
//
// swiftlint:disable force_try force_unwrapping

import Foundation
import JGProgressHUD
import Catch
import Common
import NetworkKit

public struct TestCasePokemonIdentifiers {
    static let fixedCase = 5
    static let leaveItCase = 0
    static let errorCase = 950
}

class Coordinator: Coordinating {
    let window: UIWindow
    var dataProvider: DataProvider?
    var hud: JGProgressHUD?
    lazy var actions = Actions(coordinator: self)
    var presenter: Updatable?
    var currentViewController: UIViewController?
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }
    
    func start() {
        actions.dataProvider = dataProvider
        
        showHomeScene()
    }
    
    func showHomeScene() {
        guard let dataProvider = dataProvider else { return }
        let viewController = HomeWireframe.makeViewController()
        HomeWireframe.prepare(viewController, actions: actions as HomeActions, dataProvider: dataProvider as HomeDataProvider)
        
        window.rootViewController = viewController
    }
    
    func showCatchScene(identifier: Int?) {
        guard let dataProvider = dataProvider else { return }
        let viewController = CatchWireframe.makeViewController()
        
        CatchWireframe.prepare(viewController, actions: actions as CatchActions, dataProvider: dataProvider as CatchDataProvider)
        
        guard let topViewController = window.rootViewController else { return }
        
        topViewController.present(viewController, animated: true, completion: nil)
        
        presenter = viewController.presenter as? Updatable
        
        currentViewController = viewController
        
        searchNextPokemon(identifier: identifier)
        
        showLoading()
    }
    
    func searchNextPokemon(identifier: Int?) {
        guard let dataProvider = dataProvider else { return }
        let searchService: SearchService
        let arguments = ProcessInfo.processInfo.arguments
        var pokemonIdentifier: Int
        let externalIdentifier = identifier ?? 0
        
        dataProvider.clean()
        
        if arguments.contains(LaunchArguments.uiTesting)
            || externalIdentifier == TestCasePokemonIdentifiers.fixedCase {
            let session = URLSessionFactory.makeSession()
            searchService = PokemonSearchService(session: session)
            pokemonIdentifier = TestCasePokemonIdentifiers.fixedCase
        } else if arguments.contains(LaunchArguments.error401)
                    || externalIdentifier == TestCasePokemonIdentifiers.errorCase {
            let session = URLSessionFactory.makeError401Session()
            searchService = PokemonSearchService(session: session)
            pokemonIdentifier = TestCasePokemonIdentifiers.errorCase
        } else if arguments.contains(LaunchArguments.leaveIt)
                    || externalIdentifier == TestCasePokemonIdentifiers.leaveItCase {
            let session = URLSessionFactory.makeSession()
            searchService = PokemonSearchService(session: session)
            pokemonIdentifier = TestCasePokemonIdentifiers.fixedCase
            dataProvider.addMockPokemon()
        } else {
            if let identifier = identifier {
                pokemonIdentifier = identifier
            } else {
                pokemonIdentifier = Generator.nextIdentifier()
            }
            searchService = PokemonSearchService()
        }
        
        dataProvider.search(identifier: pokemonIdentifier, networkService: searchService)
    }
    
    func showBackpackScene() {
        
    }
    
    func showPokemonDetailScene(pokemon: LocalPokemon) {
        
    }
    
    func showLoading() {
        showHud(with: Constants.Translations.loading)
    }
    
    private func showHud(with message: String) {
        guard let viewController = currentViewController else { return }
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = message
        hud?.show(in: viewController.view)
    }
    
    func dismissLoading() {
        hud?.dismiss(animated: true)
        hud = nil
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: Constants.Translations.ok,
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(okButton)
        
        guard let viewController = currentViewController else { return }
        
        viewController.present(alertController,
                               animated: true,
                               completion: nil)
    }
}

extension Coordinator: Notifier {
    func dataReceived(errorMessage: String?, on queue: DispatchQueue?) {
        
        var localQueue = queue
        
        if localQueue == nil {
            localQueue = .global(qos: .userInteractive)
        }
        
        localQueue?.async {
            self.dismissLoading()
            
            if let errorMessage = errorMessage {
                if errorMessage == Constants.Translations.Error.statusCode404 {
                    self.presenter?.update()
                    return
                }
                self.presenter?.showError(message: errorMessage)
            } else {
                self.presenter?.update()
            }
        }
    }
}

struct URLSessionFactory {
    static func makeError401Session() -> URLSession {
        let identifier = TestCasePokemonIdentifiers.errorCase
        let endpoint = PokemonSearchEndpoint.search(identifier: identifier)
        let url = endpoint.makeURL()
        return MockSessionFactory.make(url: url,
                                              data: Data("".utf8),
                                              statusCode: 401)
    }
    
    static func makeSession() -> URLSession {
        let identifier = TestCasePokemonIdentifiers.fixedCase
        let endpoint = PokemonSearchEndpoint.search(identifier: identifier)
        let url = endpoint.makeURL()
        let data = try! MockData.loadResponse()
        
        return MockSessionFactory.make(url: url,
                                              data: data!,
                                              statusCode: 200)
    }
}

struct MockSessionFactory {
    static func make(url: URL, data: Data, statusCode: Int) -> URLSession {
        
        guard let response = HTTPURLResponse(url: url,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil) else {
            return URLSession.shared
        }
        
        let mockResponse = MockResponse(response: response, url: url, data: data)

        URLProtocolMock.testResponses = [url: mockResponse]
        
        // now setup a configuration to use our mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        // and create the URLSession form that
        return URLSession(configuration: config)
    }
}

struct MockResponse {
    let response: URLResponse
    let url: URL
    let data: Data?
}

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to mock responses containing data
    static var testResponses = [URL: MockResponse]()
    static var error: Error?

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            
            // if we have a valid URL with a response…
            if let response = URLProtocolMock.testResponses[url] {
                
                // …and if we have test data for that URL…
                if url.absoluteString == response.url.absoluteString, let data = response.data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                // …and we return our response if defined…
                self.client?.urlProtocol(self,
                                         didReceive: response.response,
                                         cacheStoragePolicy: .notAllowed)
            } else {
                print("Error: No response found for URL: \(url.absoluteString)")
            }
        }

        // …and we return our error if defined…
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() {
        
    }
}
