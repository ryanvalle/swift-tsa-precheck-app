//
//  ViewController.swift
//  Unofficial TSA Pre-Check App
//
//  Created by Ryan Valle on 9/2/17.
//  Copyright © 2017 Ryan Valle. All rights reserved.
//

import UIKit

var tsaData: NSArray = NSArray()
var uicolor_red = UIColor.init(red: 0.47, green: 0, blue: 0, alpha: 1)
var uicolor_green = UIColor.init(red: 0.086, green: 0.458, blue: 0, alpha: 1)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var tsaDataFiltered: NSArray = NSArray()
    var selectedAirport: NSDictionary = NSDictionary()


    @IBAction func refreshAirportList(_ sender: Any) {
        getAirports()
        searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var airportTable: UITableView!
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "airportCell")
        let airport = ((self.tsaDataFiltered[indexPath.row] as? NSDictionary)?["airport"]) as! NSDictionary
        let name = airport["name"] as! String
        let city = airport["city"] as! String
        let state = stateAbbreviationToString(state: airport["state"] as! String)
        let shortcode = airport["shortcode"] as! String
        let isPrecheck = airport["precheck"] as? Bool
        var availability = false
        if let pc = isPrecheck {
            availability = pc
        }
        cell.textLabel?.text = name
        var subtext = " \(shortcode) -- \(city), \(state) -- "
        subtext += availability ? "TSA Available" : "TSA Unavailable"
        cell.detailTextLabel?.text = subtext
        if !availability {
            cell.detailTextLabel?.textColor = uicolor_red
            
        } else {
            cell.detailTextLabel?.textColor = uicolor_green
        }
        
    
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tsaDataFiltered.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAirportViewController" {
            let airportViewController = segue.destination as! AirportViewController
            airportViewController.selectedAirport = self.selectedAirport
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAirport = ((self.tsaDataFiltered[indexPath.row] as? NSDictionary)?["airport"]) as! NSDictionary
        performSegue(withIdentifier: "toAirportViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        airportTable.delegate = self
        if tsaData.count > 0 {
            self.tsaDataFiltered = tsaData
        } else {
            getAirports()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tsaDataFiltered = searchText.isEmpty ? tsaData : tsaData.filter { (item) -> Bool in
            let airport = ((item as! NSDictionary)["airport"]) as! NSDictionary
            let name = airport["name"] as! String
            let city = airport["city"] as! String
            let stateAbbr = airport["state"] as! String
            let state = stateAbbreviationToString(state: stateAbbr)
            let shortcode = airport["shortcode"] as! String
            
            let isAirportShortcode = shortcode.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let isNameRange = name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let isCityRange = city.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let isStateAbbrRange = stateAbbr.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let isStateRange = state.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            return isNameRange || isCityRange || isStateAbbrRange || isStateRange || isAirportShortcode
            } as NSArray
        self.airportTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getAirports() {
        let url = URL(string: "http://apps.tsa.dhs.gov/mytsawebservice/GetAirportCheckpoints.ashx?ap=all")!
        let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let content = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        DispatchQueue.main.sync {
                            tsaData = content
                            self.tsaDataFiltered = content
                            self.airportTable.reloadData()
                        }
                    } catch {
                        print("Error reading json...")
                    }
                }
            }
        }
        request.resume()
    }
    
    func stateAbbreviationToString(state: String!) -> String{
        return states[state]!
    }
    
    let states:[String:String] = [
        "AL": "Alabama",
        "AK": "Alaska",
        "AS": "American Samoa",
        "AZ": "Arizona",
        "AR": "Arkansas",
        "CA": "California",
        "CO": "Colorado",
        "CT": "Connecticut",
        "DE": "Delaware",
        "DC": "District Of Columbia",
        "FM": "Federated States Of Micronesia",
        "FL": "Florida",
        "GA": "Georgia",
        "GU": "Guam",
        "HI": "Hawaii",
        "ID": "Idaho",
        "IL": "Illinois",
        "IN": "Indiana",
        "IA": "Iowa",
        "KS": "Kansas",
        "KY": "Kentucky",
        "LA": "Louisiana",
        "ME": "Maine",
        "MH": "Marshall Islands",
        "MD": "Maryland",
        "MA": "Massachusetts",
        "MI": "Michigan",
        "MN": "Minnesota",
        "MS": "Mississippi",
        "MO": "Missouri",
        "MT": "Montana",
        "NE": "Nebraska",
        "NV": "Nevada",
        "NH": "New Hampshire",
        "NJ": "New Jersey",
        "NM": "New Mexico",
        "NY": "New York",
        "NC": "North Carolina",
        "ND": "North Dakota",
        "MP": "Northern Mariana Islands",
        "OH": "Ohio",
        "OK": "Oklahoma",
        "OR": "Oregon",
        "PW": "Palau",
        "PA": "Pennsylvania",
        "PR": "Puerto Rico",
        "RI": "Rhode Island",
        "SC": "South Carolina",
        "SD": "South Dakota",
        "TN": "Tennessee",
        "TX": "Texas",
        "UT": "Utah",
        "VT": "Vermont",
        "VI": "Virgin Islands",
        "VA": "Virginia",
        "WA": "Washington",
        "WV": "West Virginia",
        "WI": "Wisconsin",
        "WY": "Wyoming"
    ]
}

