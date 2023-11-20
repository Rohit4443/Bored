//
//  MapVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    @IBOutlet weak var mapUserCollectionView: UICollectionView!
    
    //MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapVisibiltyLabel: UILabel!
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapAnnotation()
        setCollectionViewDelegate()
    }
    
    //MARK: - CustomFunction -
    func setMapAnnotation(){
        
        mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(latitude: 30.7046,longitude: 76.7179)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
    }
    
    func setCollectionViewDelegate(){
        mapUserCollectionView.delegate = self
        mapUserCollectionView.dataSource = self
        mapUserCollectionView.register(UINib(nibName : "MapCVCell" , bundle: nil), forCellWithReuseIdentifier: "MapCVCell")
    }
    
    //MARK: - IBAction -
    @IBAction func toggleAction(_ sender: UISwitch) {
        if sender.isOn {
            
            mapView.isHidden = false
            mapUserCollectionView.isHidden = false
        } else {
            
            mapView.isHidden = true
            mapUserCollectionView.isHidden = true
            
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    
}

extension MapVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCVCell", for: indexPath) as! MapCVCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 1.1
                      ,height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlaceDetailVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        }
    }


