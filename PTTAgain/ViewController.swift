//
//  ViewController.swift
//  PTTAgain
//
//  Created by Rishi Masand on 10/3/15.
//  Copyright (c) 2015 Rishi Masand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: "http://c32d5eb2.ngrok.io")

    @IBOutlet var xLabel: UILabel!
    @IBOutlet var yLabel: UILabel!
    @IBOutlet var zLabel: UILabel!
    
    @IBOutlet var myEmail: UITextField!
    @IBOutlet var coachEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        socket.connect()
        
        socket.on("display data") {[weak self] data, ack in
            
            println("fdssdkvn")
            self!.xLabel.text = String(stringInterpolationSegment: data![0] as! Int)
            self!.yLabel.text = String(stringInterpolationSegment: data![1] as! Int)
            self!.zLabel.text = String(stringInterpolationSegment: data![2] as! Int)
            
        }

    }
    @IBAction func start(sender: AnyObject) {
        let url = NSURL(string: "http://c32d5eb2.ngrok.io/startgame")
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    }
    @IBAction func end(sender: AnyObject) {
        let url = NSURL(string: "http://c32d5eb2.ngrok.io/endgame")
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    }

    @IBAction func setEmails(sender: AnyObject) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://c32d5eb2.ngrok.io/set")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        var jsonString = "{\"me\":\""
        jsonString = jsonString.stringByAppendingString(myEmail.text)
        jsonString = jsonString.stringByAppendingString("\"")
        jsonString = jsonString.stringByAppendingString(",\"coach\":\"")
        jsonString = jsonString.stringByAppendingString(coachEmail.text)
        jsonString = jsonString.stringByAppendingString("\"}")
        
        
        // create some JSON data and configure the request
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

