//
//  FlickrResults.swift
//  FlickrSearch
//
//  Created by Oscar Otero on 12/8/16.
//




import Foundation
import CoreLocation

struct FlickrResults {
    let searchTerm : CLLocation
    let searchResults : [FlickrPhoto]
}

struct FlickrSearchResults {
    let searchTerm : String
    let searchResultsTerm : [FlickrPhoto]
}
