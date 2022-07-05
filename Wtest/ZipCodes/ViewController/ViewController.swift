//
//  ViewController.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    
    // MARK: - Declarations
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIView!
    
    weak var coordinator: ViewCoordinator?
    var viewModel: ViewModelProtocol?
    
    // MARK: - lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDelegate()
        getCSV()
    }
}

// MARK: - Private Extension
private extension ViewController {
    func setDelegate() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// this function check if it downloaded all zip codes to call the API or not
    func getCSV() {
        if !UserDefaults.standard.bool(forKey: "hasFinished") {
            getCSVFromApi()
        }
    }
        
    /// It downloads a CSV file, decodes to ZipCode object and adds to CoreData
    func getCSVFromApi() {
        viewModel?.getCSVFromApi(completion: { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.indicatorView.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.indicatorView.removeFromSuperview()
                }
            }
        })
    }
    
    /// This function get all data from CoreData
    @discardableResult
    func getZipCodes(by text: String = "") -> [ZipCodeEntity] {
        var zipCodes = viewModel?.zipCodes ?? []
        
        viewModel?.getZipCodes(by: text, completion: { result in
            switch result {
            case .success(let response):
                zipCodes = response
            case .failure(let error):
                print(error)
            }
        })
        
        return zipCodes
    }
}


// MARK: - Extensions UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let text = searchBar.text, text.isEmpty {
            return 0
        }
        let zipCodes = viewModel?.zipCodes ?? []
        return zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let zipCodes = viewModel?.zipCodes ?? []
        cell.textLabel?.text = zipCodes[indexPath.row].zipCode
        return cell
    }
}

// MARK: - Extensions UISearchBar
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText = searchBar.text ?? ""
        getZipCodes(by: searchedText)
        tableView.reloadData()
    }
}
