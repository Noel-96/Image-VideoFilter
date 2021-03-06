//
//  VideoLogsViewController.swift
//  Filter-Video
//
//  Created by Noel Obaseki on 04/03/2020.
//  Copyright © 2020 NoelObaseki. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreData

class VideoLogsViewController: UIViewController {
    
    var videoArray = [NSManagedObject]()
    
    @IBOutlet weak var VideoLogsTableview: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUiTableData()
        VideoLogsTableview.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoLogsTableview.reloadData()
        VideoLogsTableview.dataSource = self
        VideoLogsTableview.delegate = self
    }
    
    
    
    // function to get the video data from core data
    func getUiTableData(){
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Video")
        do {
        videoArray = try managedContext.fetch(fetchRequest)
           } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
       }
    }
}



// extension of the view controller to handle the code to load the uitableview  data
extension VideoLogsViewController:  UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoLogsTableViewCellID") as? VideoLogsTableViewCell{
            let videoItem = videoArray[indexPath.row]
            
            //extract the url from the core data database
            let urlHolder  = (videoItem.value(forKeyPath: "videoAsset") as? URL)!
            let text_title   = "Video Clip \(indexPath.row + 1) "
            let  videoAsset = AVURLAsset(url: urlHolder as URL)
            let image_thumbnail  = videoAsset.videoToUIImage()
                
            // update the tableviewCell with data
            cell.updateViews(title: text_title, thumbnail: image_thumbnail)
            return cell
            }else {
            return  VideoLogsTableViewCell()
            }
        }
    
    
    //functions to send the video to the VideoDetailsViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoItem = videoArray[indexPath.row]
        let urlHolder  = (videoItem.value(forKeyPath: "videoAsset") as? URL)!
        performSegue(withIdentifier: "DetailedSegue", sender: urlHolder)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if  let TestVc = segue.destination as? VideoDetailsViewController {
           assert(sender as? URL != nil)
           TestVc.getVideoDetails(videoDataUrl: sender as! URL)
        }
    }
}
    
    
    
    


