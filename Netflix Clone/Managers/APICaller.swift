//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import Foundation
struct Constants {
    static let APIKey = "a9274e6e8833241baccf0b2cb25d864d"
    static let YoutubeAPI_Key = "AIzaSyA0Ga_S6cMYm4nX6SaFCZPti9IkfjOUb9U"
}
enum APIError:Error {
case failedTogetData
}
class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title],Error>) -> Void){
        let urlString = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(Constants.APIKey)"
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            guard let data = data , error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
                
            }catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(competion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/trending/tv/day?api_key=\(Constants.APIKey)"
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }
            catch {
                competion(.failure(APIError.failedTogetData))
                
            }
   
        }
        task.resume()
   
    }
    
    func upcoming(competion: @escaping (Result<[Title],Error>) -> Void){
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.APIKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }catch{
                competion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
            
        
    }
    
    func getpopular(competion: @escaping (Result<[Title],Error>) -> Void){
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.APIKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }catch{
                competion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    func getTopRated(competion: @escaping (Result<[Title],Error>) -> Void){
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(Constants.APIKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }catch{
                competion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    func getDiscoveryMovies(competion: @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constants.APIKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }catch{
                competion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String,competion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        // ifadesi, query stringindeki karakterleri .urlHostAllowed karakter setine göre yüzde kodlama yap
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&api_key=\(Constants.APIKey)") else{return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                competion(.success(result.results))
            }catch{
                competion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
     
    }
    
    func getMovieTrailer(with query: String,competion: @escaping (Result<VideoElement,Error>) -> Void){
        // Burada bir ağ isteği yapılır ve sonuç asenkron olarak döner. Başarılıysa sonuç error yada YoutubeSearchResponse olacaktır.
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&key=\(Constants.YoutubeAPI_Key)"
        guard let url = URL(string: urlString) else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                competion(.success(results.items[0]))
                
              
            } catch {
                competion(.failure(error))
                print(error.localizedDescription)
            }
            
        }
        task.resume()

    }
     
}
// https://www.googleapis.com/youtube/v3/search
// https://www.googleapis.com/youtube/v3/search?part=snippet&q=Harry%20Potter%20trailer&type=video&key=YOUR_API_KEY
