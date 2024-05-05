//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import UIKit

class SearchViewController: UIViewController{
 
    private var titles: [Title] = [Title]()

    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleUpcomingTableViewCell.self, forCellReuseIdentifier: TitleUpcomingTableViewCell.identifier)
        return table
   
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(discoverTable)
        discoverTable.delegate=self
        discoverTable.dataSource=self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater=self
        fetchDiscoverMovies()
 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    func fetchDiscoverMovies(){
        APICaller.shared.getDiscoveryMovies { result in
            switch result {
            case .success(let titles):
                self.titles=titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleUpcomingTableViewCell.identifier, for: indexPath) as? TitleUpcomingTableViewCell else{
            return UITableViewCell()
        }
        let titleName = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title
        let posterUrl = titles[indexPath.row].poster_path
        
        cell.configure(with: TitleViewModel(titleName: titleName ?? "Unknown", posterUrl: posterUrl ?? ""))
        return cell
                
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title  else {
            return
        }
        guard let overview = title.overview else {
            return
        }
        APICaller.shared.getMovieTrailer(with: titleName+" trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: 0, y: -50)
        cell.transform = initialTransform
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }

}
extension SearchViewController: UISearchResultsUpdating ,SearchResultsViewControllerDelegate{
 
    func updateSearchResults(for searchController: UISearchController) {
        // arama çubuğundaki içerik her değiştiğinde otomatik olarak çağrılır.
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count>=3,
        let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.delegate=self
    
        APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results{
                case .success(let titles):
                    resultsController.titles=titles
                    resultsController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        }
 
    }
    
    func searchResultsViewControllerDidSelectItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
}
