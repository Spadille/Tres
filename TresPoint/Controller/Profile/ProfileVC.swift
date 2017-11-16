//
//  ProfileVC.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

protocol SubScrollDelegate {
    func subScrollViewDidScroll(scrollView: UIScrollView)
}

class ProfileUpdate {
    var name: String
    var body: String
    
    init(name: String, body: String) {
        self.name = name
        self.body = body
    }
    
}

class ProfileVC: UITableViewController {

    var delegate: SubScrollDelegate!
    var items: [ProfileUpdate] = [
        ProfileUpdate(name: "@iamusername", body: "omg i just got a papercut while reading the bible"),
        ProfileUpdate(name: "@iamusername", body: "hey is anyone up or down for a quick ride around the city coppin bricks in my new 2005 Chevy Ultra?"),
        ProfileUpdate(name: "@iamusername", body: "hvae you ever seen a cat that looks like it has a transparent ear because its standing in front of something the same color as one of its ears"),
        ProfileUpdate(name: "@iamusername", body: "totally gettin gangrene today with all the moldes outside"),
        ProfileUpdate(name: "@iamusername", body: "lol look at this http://google.com/"),
        ProfileUpdate(name: "@iamusername", body: "WHAT is going ON with the lights in this BaseMENT?  ? ? it looks liek a phantom opera"),
        ProfileUpdate(name: "@iamusername", body: "just got back from Coleston valley. Sucks but they have chep vidoe games"),
        ]
    
    @IBAction func addRow() {
        let new_item = ProfileUpdate(name: "@iamusername", body: "it's about time I had a new update here")
        self.items.insert(new_item, at: 0)
        self.tableView.insertRows(at: [IndexPath(row:0,section:0)] , with: .none)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate.subScrollViewDidScroll(scrollView: scrollView)
    }
    
    func getUpdate(indexPath: NSIndexPath) -> ProfileUpdate {
        return self.items[indexPath.row]
    }
    
    // Table methods
    
    func heightOfLabel(withString: String, ofSize: CGFloat, inWidth: CGFloat) -> CGFloat {
        //let labelFont = UIFont.systemFontOfSize(ofSize)
        let labelFont = UIFont(name: "HelveticaNeue-Light", size: ofSize)!
        let labelSize = (withString as NSString).boundingRect(with: CGSize(width: inWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: labelFont], context: nil)
        return ceil(labelSize.height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 15 + 18 + 8 + heightOfLabel(getUpdate(indexPath).body, ofSize: 20, inWidth: self.tableView.frame.width - 30) + 15
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15 + 18 + 8 + heightOfLabel(withString: getUpdate(indexPath: indexPath as NSIndexPath).body, ofSize: 20, inWidth: self.tableView.frame.width - 30) + 15
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileUpdateCell") as! ProfileUpdateCell
        cell.renderWithUpdate(update: getUpdate(indexPath: indexPath as NSIndexPath))
        return cell
    }
}

class ProfileUpdateCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    func renderWithUpdate(update: ProfileUpdate) {
        nameLabel.text = update.name
        bodyLabel.text = update.body
    }
    
}
