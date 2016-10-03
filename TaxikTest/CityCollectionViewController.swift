//
//  CityCollectionViewController.swift
//  TaxikTest
//
//  Created by Артем on 30/09/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "CityCell"
private let segueIdentifier = "ShowMap"

class CityCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let url = "http://beta.taxistock.ru/taxik/api/client/query_cities"
    
    // MARK: Model
    private var cities = [City]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: Subscription
    private var applicationObserver: NSObjectProtocol?

    // MARK: Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        subscribeToActvieApp()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            if let mvc = segue.destinationViewController as? MapViewController,
                let cell = sender as? CityCollectionViewCell,
                let indexPath = collectionView!.indexPathForCell(cell) {
                mvc.coordinatePin = cities[indexPath.row].cityCoordinates
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cities.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        if let cityCell = cell as? CityCollectionViewCell {
            cityCell.cityLabel.text = cities[indexPath.row].cityName
        }
        return cell
    }

    private func fetchData() {
        cities.removeAll()
        spinner.startAnimating()
        if let url = NSURL(string: url) {
            let utilityQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            Alamofire.request(.GET, url).validate().responseJSON(queue: utilityQueue) { response in
                switch response.result {
                case .Success(let value):
                    if let json = value as? [String: AnyObject] {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateCities(json)
                    })
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateCities(json: [String: AnyObject]) {
        if cities.count == 0 {
            for case let result in json["cities"] as! [[String: AnyObject]] {
                do {
                    let city = try City(json: result)
                    cities.append(city)
                } catch let error {
                    print("Error = \(error)")
                }
            }
        }
        spinner.stopAnimating()
        collectionView?.reloadData()
    }
    
    private func subscribeToActvieApp() {
        applicationObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationDidBecomeActiveNotification,
            object: UIApplication.sharedApplication(),
            queue: NSOperationQueue.mainQueue()) { (notification) in
                self.fetchData()
        }    }
}


