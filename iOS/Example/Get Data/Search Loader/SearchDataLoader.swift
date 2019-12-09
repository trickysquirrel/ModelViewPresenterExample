//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct SearchDataModel {
    let id: Int
    let title: String
    let imageUrl: URL
}


enum SearchDataLoaderResponse {
    case success([SearchDataModel])
    case error(Error)
}


protocol SearchDataLoading {
    func load(searchString: String, completionQueue: DispatchQueue, completion:@escaping (SearchDataLoaderResponse)->())
    func cancel()
}


struct SearchDataLoader: SearchDataLoading {

    let dataLoader: DataLoading

    func load(searchString: String, completionQueue: DispatchQueue, completion:@escaping (SearchDataLoaderResponse)->()) {
        guard let assetJson = dataLoader.load() else {
            completionQueue.async {
                let tempError = NSError(domain: "", code: 0, userInfo: nil)
                completion(.error(tempError))
            }
            return
        }
        let assetDataModelList = assetJson.compactMap { makeSearchData(json: $0) }

        // adding in a delay before responding
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionQueue.async {
                completion(.success(assetDataModelList))
            }
        }

    }

    func cancel() {
        // do nothing for now
    }
}

// MARK: Utils

extension SearchDataLoader {

    private func makeSearchData(json: [String:Any]) -> SearchDataModel? {
        guard
            let id = json["id"] as? Int,
            let endpoint = json["imageUrl"],
            let url = URL(string: "https:\(endpoint)"),
            let title = json["title"] as? [String:Any],
            let usTitle = title["en_US"] as? String
            else {
                return nil
        }

        return SearchDataModel(id: id, title: usTitle, imageUrl: url)
    }

}


/*
https://cinema.iflix.com/my/catalogue/adults/search?query=Bob
GET /my/catalogue/adults/search?query=Bob HTTP/1.1
Host: cinema.iflix.com
Accept: application/json
Cookie: JSESSIONID=c0914c4b2cce6d6c506cc8b5484cb47c2e47421f~DC6F3922BD531127BF27BF055A0F0BCD; api-authorization=Bearer%206e3db0c4-ce1f-4000-a1ea-f35ee3819ced; vimond-playout-access-token=ndefine; platformAndMe=%7B%22platform%22%3A%22my-web%22%2C%22lastUpdated%22%3A1508457482944%2C%22region%22%3A%22my%22%2C%22locales%22%3A%5B%22en_US%22%2C%22ms_MY%22%5D%2C%22redirect%22%3Afalse%7D; _u=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgxMjc1MzgsImEiOjE3OTIxMTY3LCJwIjoxNzc5NzM3NCwiZSI6MjU4NTUwMTksImk0YSI6dHJ1ZSwiYXV0aG9yaXphdGlvbiI6IkJlYXJlciA2ZTNkYjBjNC1jZTFmLTQwMDAtYTFlYS1mMzVlZTM4MTljZWQiLCJzaWQiOiJjMDkxNGM0YjJjY2U2ZDZjNTA2Y2M4YjU0ODRjYjQ3YzJlNDc0MjFmfkRDNkYzOTIyQkQ1MzExMjdCRjI3QkYwNTVBMEYwQkNEIiwibmFtZSI6IlJpY2hhcmQiLCJ2aWQiOjE4MTI3NTM4LCJzdGFmZiI6ZmFsc2UsInVuaXF1ZUlEIjoiN0Y1QTMwMkMtNzA2Ni00RUQyLUJBNTItOTVFRUJDQUYwMzY4IiwiaWF0IjoxNTA4NDU3NDgyLCJleHAiOjE1MTA4NzY2ODJ9.BnuyGhUxg4MCg-rF1j22PtNt4FTAvX1tv2GSMplMaYA; JSESSIONID=c0914c4b2cce6d6c506cc8b5484cb47c2e47421f~62D364189AF72FF24A61116E22831F9A; __cfduid=de36c809ccfb80d4360ce8bf158b561551508824493
User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Mobile/15A372 x86_64 iflixApp/8 native ios/2.36.0 build/1
Accept-Language: en-us
Accept-Encoding: br, gzip, deflate
Connection: keep-alive
*/

