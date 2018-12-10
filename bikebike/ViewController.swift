//
//  ViewController.swift
//  bikebike
//
//  Created by D7703_23 on 2018. 12. 10..
//  Copyright © 2018년 D7703_23. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, XMLParserDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation: BusanData?
    var annotations: Array = [BusanData]()
    
    var item: [String:String] = [:]
    var items: [[String:String]] = []
    var currentElement = ""
    
    var address: String?
    var lat: String?
    var long: String?
    var spot: String?
    var spotGubun: String?
    var dLat: Double?
    var dLong: Double?
    var type: String?
    var company: String?
    var startTime: String?
    var endTime: String?
    var holiday: String?
    var phoneNum: String?
    
    // 광복동, 초량동
    let addrs:[String:[String]] = [
        "20" : ["35.1189595", "128.8896589"], 
        "19" : ["35.1189544", "128.8568282"],
        "18" : ["35.1189444", "128.8568282"],
        "17" : ["35.217591", "128.962399"],
        "16" : ["35.1584479", "128.9512923"],
        "14" : ["35.21505", "128.967361"],
        "13" : ["35.0887364", "128.8447801"],
        "12" : ["35.0920886", "128.8513093"],
        "265" : ["35.1343821", "129.0522686"],
        "264" : ["35.127741", "129.0456643"],
        "262" : ["35.114512", "129.0371673"]
    ]
    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.url(forResource: "bike", withExtension: "xml"){
            if let myParser = XMLParser(contentsOf: path) {
                myParser.delegate = self
                if myParser.parse() {
                    print("파싱 성공")
                    for item in items {
                        //print("item \(item["소재지지번주소"]!)")
                    }
                } else {
                    print("파싱 실패")
                }
            } else {
                print("파싱 오류1")
            }
        } else {
            print("XML 파일 없음")
        }
        
        mapView.delegate = self
        
        //초기맵 설정
        zoomToRegion()
        mapDisplay()
        
    }
    
    func mapDisplay() {
        for item in items {
            let dSite = item["idx"]
            print("dSite = \(items.count) \(String(describing: dSite))")
            
            // 추가 데이터 처리
            for (key, value) in addrs {
                if key == dSite {
                    lat = value[0]
                    long = value[1]
                    dLat = Double(lat!)
                    dLong = Double(long!)
                }
            }
            
            // 파싱 데이터 처리
            let spot = item["spot"]
            let spotGubun = item["spotGubun"]
            let setCnt = item["setCnt"]
            print(dLat!)
            
            annotation = BusanData(coordinate: CLLocationCoordinate2D(latitude: dLat!, longitude: dLong!), title: spot!, subtitle: setCnt!)
            
            annotations.append(annotation!)
        }
        mapView.showAnnotations(annotations, animated: true)
        //        myMapView.addAnnotations(annotations)
    }
    
    func zoomToRegion() {
        let location = CLLocationCoordinate2D(latitude: 35.180100, longitude: 129.081017)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // XMLParser Delegete 메소드
    //mkpinannotationview image
    
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // 공백제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        // 공백체크 후 데이터 뽑기
        if !data.isEmpty {
            item[currentElement] = data
        }
        
    }


}

