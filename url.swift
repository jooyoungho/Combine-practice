import Combine
import SwiftUI

enum HTTPError: LocalizedError {
    case statusCode
    case post
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//  
//  let task = URLSession.shared.dataTask(with: url) { data, response, error in 
//      if let error = error {
//          fatalError("error: \(error.localizedDescription)")
//      }
//      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//          fatalError()
//      }
//      
//      guard let data = data else {
//          fatalError()
//      }
//      
//      do {
//          let decoder = JSONDecoder()
//          let posts = try decoder.decode([Post].self, from: data)
//          print(posts.map { $0.title })
//      } catch {
//          print("error")
//      }
//  }
//  task.resume()
//  

let cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .replaceError(with: [])
    .eraseToAnyPublisher()
    .sink(receiveValue: {print("data count: \($0.count)")})
