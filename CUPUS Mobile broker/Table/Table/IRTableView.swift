//
//  BasicTable.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

protocol BasicTableEventHandler{
    func didSelectCell(indexPath:NSIndexPath)
}

/**
 Base table view implementation for IRTableViewCell
 
 Handles presentation and event delegation of IRTableViewCell
*/
class IRTableView: UITableView, UITableViewDataSource, UITableViewDelegate{

    /// Stores CellViews in CellViewSections
    var cellViewModelSections:[IRCellViewModelSection]
    var eventHandler:BasicTableEventHandler?
    
    /// Label that show message when no data is present
    var noDataLabel:UILabel!
    
    init(frame:CGRect, sections:[IRCellViewModelSection] = []){
        self.cellViewModelSections = sections
        
        super.init(frame: frame, style: .Grouped)
        
        addSubview(refreshControl)
        
        postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cellViewModelSections = []

        super.init(coder: aDecoder)
        
        postInit()
    }
    
    func postInit(){
        delegate = self
        dataSource = self
        
        initRefreshControl()
        
        noDataLabelInit()
        
        noDataShow = {(sections:AnyObject) -> Bool in
            return (sections as! [IRCellViewModelSection]).count == 0 && !self.refreshControl.refreshing
        }
    }
    
    /// Refresh indicator
    var refreshControl = UIRefreshControl()
    
    /// Refresh state
    var isRefreshing = false
    
    /// Refresh controll update funcion. Set to enable pull to refresh
    var refreshControllUpdateFunction: (() -> ())?
    
    /// Prepeares UIRefreshControll. Call from init
    func initRefreshControl(){
        addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(IRTableView.refreshControllTarget), forControlEvents: .ValueChanged)
        refreshControl.beginRefreshing()
    
        isRefreshing = true
    }
    
    /// Gets called on swipe down if refreshControllUpdateFunction is set
    func refreshControllTarget(){
        if let update = refreshControllUpdateFunction{
            update()
        }
    }
    
    func noDataLabelInit(){
        noDataLabel = UILabel(frame: CGRectMake(0, 0, bounds.size.width, bounds.size.height))
        
        noDataLabel.text = "No data currently available"
        noDataLabel.textColor = UIColor.darkGrayColor()
        noDataLabel.numberOfLines = 0;
        noDataLabel.textAlignment = NSTextAlignment.Center
        noDataLabel.font = UIFont(name:"HelveticaNeue", size:14)
        noDataLabel.sizeToFit()
    }
    
    /// Sets table data and check for animation
    func setData(sections: [IRCellViewModelSection]){
        let wasEmpty = self.cellViewModelSections.count == 0
        
        self.cellViewModelSections = sections
        
        reloadData()
    
        endRefreshAnimation(wasEmpty, dataFetched: true)
        
        if refreshControllUpdateFunction == nil{
            refreshControl.removeFromSuperview()
        }else{
            addSubview(refreshControl)
        }
       
    }
    
    /// Call on viewWillApper
    func superviewWillApper(){
        if isRefreshing && !refreshControl.refreshing{
            startRefreshAnimation()
        }
    }
    
    /// Call on viewDidDisapper
    func superviewDidDisappear(){
        endRefreshAnimation(false, dataFetched: !isRefreshing)
    }
    
    /// Presents animating UIRefreshControll
    func startRefreshAnimation(){
        refreshControl.beginRefreshing()
        contentOffset = CGPointMake(0, -refreshControl.bounds.size.height)
        
        isRefreshing = true
    }
    
    /// Hides UIRefreshControll and saves state of refresh
    func endRefreshAnimation(wasEmpty: Bool, dataFetched: Bool){
        refreshControl.endRefreshing()
        
        isRefreshing = !dataFetched
        
        if !wasEmpty{
            setContentOffset(CGPointZero, animated: true)
        }else{
            setContentOffset(CGPointZero, animated: false)
        }
    }
    
    
    // Events
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let eventHandler = eventHandler{
            eventHandler.didSelectCell(indexPath)
        }
        
        if let modelsDidSelect = cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].didSelectCellFunc{
            modelsDidSelect()
        }
        
        deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].implementationIdentifier.rawValue
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil{
            tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        }
        
        cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].cellUpdateFunc = (cell as! IRGenericCellImplementation).setData
        
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.accessoryType = cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].accessoryType
        (cell as! IRGenericCellImplementation).setData(cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].data)
        
        if let postInit = cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].postInit{
            postInit(cell)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModelSections[section].cellViewModels.count
    }
    
    
    var noDataShow:((AnyObject)->Bool)!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if noDataShow(cellViewModelSections){
            backgroundView = noDataLabel
        }else{
            backgroundView = nil
        }
        
        return cellViewModelSections.count
    }
    
    // Section style
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cellViewModelSections[section].sectionTitle == nil{
            return 0.001
        }else{
            return 34
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellViewModelSections[section].sectionTitle
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellViewModelSections[indexPath.section].cellViewModels[indexPath.row].height
        
    }
    

}