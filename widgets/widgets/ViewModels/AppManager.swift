import UIKit

protocol AppManagerDelegate {
    func didUpdateApp(_ appManager: AppManager, dataItems: [DataItem])
    func didFailWithError(error: Error)
}

struct AppManager {
    let appURL = "https://www.blibli.com/backend/content/widgets/_grouped?device=ios"
    
    var delegate: AppManagerDelegate?
    var widgets: [Widget] = [] // Add a widgets property
    
    func get() {
        request(urlString: appURL)
    }
    
    func request(urlString: String) {
        if let urlNetwork = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlNetwork, completionHandler: {
                (data, response, error) in
                if(error != nil) {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let dataItems = self.parseJSON(apiData: safeData) {
                        self.delegate?.didUpdateApp(self, dataItems: dataItems)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    func parseJSON(apiData: Data) -> [DataItem]? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(APIResponse.self, from: apiData)
            let data = response.data
            return data
        } catch {
            print("Error decoding API response: \(error)")
            return nil
        }
    }
}
