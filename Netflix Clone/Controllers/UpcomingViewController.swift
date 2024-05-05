//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    private var titles: [Title] = [Title]()

    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleUpcomingTableViewCell.self, forCellReuseIdentifier: TitleUpcomingTableViewCell.identifier)
        return table
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(upcomingTable)
        fetchUpcoming()
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    private func fetchUpcoming(){
        APICaller.shared.upcoming { result in
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension UpcomingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:TitleUpcomingTableViewCell.identifier, for: indexPath) as? TitleUpcomingTableViewCell else {
            return UITableViewCell()
        }
        let titleName = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown"
        let posterUrl = titles[indexPath.row].poster_path
        cell.configure(with: TitleViewModel(titleName: titleName, posterUrl: posterUrl ?? ""))
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
        let initialTransform = CGAffineTransform(translationX: 0, y: -50) // Yukarıdan 50 birim yüksekte başla
        cell.transform = initialTransform
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }

    

    
}
