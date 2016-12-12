//
//  FlickrPhotosCollection.swift
//  FlickrSearch
//
//  Created by Oscar Otero on 12/8/16.
//


import UIKit
import CoreLocation


final class FlickrPhotosCollection: UICollectionViewController {
    
    var loaded:Bool = false
    var detailViewController  = FlickrDetailViewcontroller()
    var location:CLLocation?
    var activityIndicatorView: ActivityIndicatorView!
    var granularity:Int8 = 11
    var lastPage:Int8 = -1
    var flickrPage:UInt8 = 1
    
    @IBOutlet var cityButton: UIBarButtonItem!
    @IBOutlet var neighborhoodButton: UIBarButtonItem!
    @IBOutlet var pageButton:UIBarButtonItem!
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "FlickrCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var searches = [FlickrResults]()
    fileprivate var termSearches = [FlickrSearchResults]()
    fileprivate let flickr = Flickr()
    fileprivate let itemsPerRow: CGFloat = 3
    
    
    override func viewDidLoad() {
        FlickrLocation.sharedInstance.circle = 2000
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! FlickrDetailViewcontroller
        self.activityIndicatorView = ActivityIndicatorView(title: "", center: self.view.center)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"LocationReady"),
                       object:nil, queue:nil,
                       using:catchNotification)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.searches.count == 0 && self.termSearches.count == 0) {
        self.showLoading(show: true)
        }
    }
    
    func reload(fade:Bool) {
        if fade == true {
            self.collectionView?.fadeOut()
        }
        self.collectionView?.reloadData()
        self.pageButton.title = "Page: \(flickrPage)"
        if fade == true {
            self.collectionView?.fadeIn()
        }
    }
    
    
    func catchNotification(notification:Notification) -> Void {
        
        self.searches.removeAll()
        self.termSearches.removeAll()
        self.reload(fade:false)
        location = FlickrLocation.sharedInstance.location
        self.title = (granularity == 11) ? FlickrLocation.sharedInstance.city : FlickrLocation.sharedInstance.country
        flickr.accuracy = granularity
        
        if granularity == 11 {
            flickr.searchFlickrForCoordinates(location!) {
                results, error in
                
                self.showLoading(show: false)
                if let error = error {
                    print("Error searching : \(error)")
                    return
                }
                
                if let results = results {
                    print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                    self.searches.insert(results, at: 0)
                    self.reload(fade:true)
                }
            }
        }
        else {
           
          flickr.searchFlickrForTerm(FlickrLocation.sharedInstance.country!) {
                results, error in
                
                self.showLoading(show: false)

                if let error = error {
                    print("Error searching : \(error)")
                    return
                }
                
                if let results = results {
                    self.termSearches.insert(results, at: 0)
                    self.reload(fade:true)
                }
            }
        }

    }
    
    @IBAction func citySelected(sender:UIBarButtonItem) {
        
        granularity =  11
        self.resetPageNumbers()
        FlickrLocation.sharedInstance.circle = 2000
        cityButton.tintColor = UIColor.white
        neighborhoodButton.tintColor = UIColor.blue
        self.showLoading(show: true)
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"LocationReady"),
                object: nil,
                userInfo:nil)

    }
    
    @IBAction func neighborhoodSelected(sender:UIBarButtonItem) {
        
        granularity = 3
        self.resetPageNumbers()
        FlickrLocation.sharedInstance.circle = 2000000
        cityButton.tintColor = UIColor.blue
        neighborhoodButton.tintColor = UIColor.white
        self.showLoading(show: true)

        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"LocationReady"),
                object: nil,
                userInfo:nil)

    }
   
// Flickr Photos paging

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var shouldReload:Bool = false
        let y = collectionView!.contentOffset.y
        let h = collectionView!.bounds.size.height
        let page = Int(ceil(y/h))
     
        if (page == 0 && lastPage == 0) {
            if flickr.page > 1 {
                flickr.page-=1
                shouldReload = true ;
            }
            else {
                return
            }
        }
        if (page == 1 && lastPage == 1) {
            flickr.page += 1
               shouldReload = true ;
        }
        lastPage = Int8(page)
        
        if shouldReload == true {
            flickrPage = flickr.page
            self.showLoading(show: true)
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"LocationReady"),
                    object: nil,
                    userInfo:nil)
            lastPage = 0
        }
    }
    
    func resetPageNumbers() {
        
        flickr.page = 1
        flickrPage = 1
        lastPage = 0
        
    }
    
    func showLoading (show:Bool) {
        
        switch show {
        case true:
            self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
            self.activityIndicatorView.startAnimating(page:flickrPage)
            break
        case false:
            self.activityIndicatorView.stopAnimating()
            break
        }
        
    }

}


// MARK: - Private
private extension FlickrPhotosCollection {
    func photoForIndexPath(_ indexPath: IndexPath) -> FlickrPhoto {
        return granularity == 11 ?searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]: termSearches[(indexPath as NSIndexPath).section].searchResultsTerm[(indexPath as NSIndexPath).row]

    }
}


// MARK: - UICollectionViewDataSource

extension FlickrPhotosCollection {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return granularity==11 ? searches.count : termSearches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return granularity == 11 ? searches[section].searchResults.count : termSearches[section].searchResultsTerm.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                                         for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photoForIndexPath(indexPath)
        cell.backgroundColor = UIColor.white
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flickrPhoto = photoForIndexPath(indexPath)
        self.navigationController?.show(self.detailViewController, sender: nil)

        flickrPhoto.loadLargeImage { (flickrPhoto, error) in
            self.showLargeImage(indexPath: indexPath)
        }
    }
    
    func showLargeImage(indexPath:IndexPath) -> Void {
        let flickrPhoto = photoForIndexPath(indexPath)
        self.detailViewController.setPhoto(image: flickrPhoto.largeImage!)
        
    }
}



extension FlickrPhotosCollection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
