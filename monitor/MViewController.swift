//
//  MViewController.swift
//  monitor
//
//  Created by cc on 1/23/20.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import SwifterSwift
import SwiftyJSON

class MViewController: UIViewController {

    var collectionView: UICollectionView!
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "交易风控"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.sizeToFit()
        return label
    }()
    var socket: JFRWebSocket!
    var host: String!
    var datas: [OverseeModel] = []
    var accounts: [String] = []
    
    let tests: [String] = ["{\"company\":\"Tickmill Ltd\", \"account\": \"123456\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.1\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.2\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.3\"}]}","{\"company\":\"Tickmill Ltd\", \"account\": \"123457\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.2\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.3\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.1\"}]}","{\"company\":\"Tickmill Ltd\", \"account\": \"123456\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.5\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.6\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.7\"}]}\n{\"company\":\"Tickmill Ltd\", \"account\": \"123457\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.8\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.9\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"1.0\"}]}","{\"company\":\"Tickmill Ltd\", \"account\": \"123457\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"2.00\"}]}","{\"company\":\"Tickmill Ltd\", \"account\": \"123456\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.1\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"100.2\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.23\"}]}","{\"company\":\"Tickmill Ltd\", \"account\": \"123456\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.5\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.6\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.7\"}]}\n{\"company\":\"Tickmill Ltd\", \"account\": \"123457\", \"host\": \"liudaolu\", \"balance\": \"100000.00\", \"equity\": \"1021312\", \"freeMargin\": \"11231\", \"marginLevel\": \"123123\", \"margin\": \"123123\", \"orders\":[{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.8\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"0.9\"},{\"symbol\":\"EURUSD\", \"type\": \"BUY\", \"lots\": \"0.1\", \"profit\": \"1.0\"}]}"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = statusLabel
        navigationController?.navigationBar.barStyle = .black
        
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout:ListCollectionViewLayout(stickyHeaders: false, topContentInset: 10, stretchToEdge: false))
        
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.websocket(JFRWebSocket(), didReceiveMessage: self.tests[0])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.websocket(JFRWebSocket(), didReceiveMessage: self.tests[3])
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.websocket(JFRWebSocket(), didReceiveMessage: self.tests[2])
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.websocket(JFRWebSocket(), didReceiveMessage: self.tests[1])
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.websocket(JFRWebSocket(), didReceiveMessage: self.tests[4])
                        }
                    }
                }
            }
        }

    }
    
    func initSocket() {
        socket = JFRWebSocket.init(url: URL(string: "ws://" + "108.61.196.9:8089" + "/echo")!, protocols: nil)
        socket.delegate = self
        socket.connect()
    }
    
//    override func viewDidLayoutSubviews() {
//       super.viewDidLayoutSubviews()
//       collectionView.bounds = view.bounds
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MViewController: JFRWebSocketDelegate {
    func websocketDidConnect(_ socket: JFRWebSocket) {
        print("websocket is connected")
        statusLabel.textColor = .white
    }
    
    func websocketDidDisconnect(_ socket: JFRWebSocket, error: Error?) {
        print("websocket is disconnected")
        statusLabel.textColor = .gray
    }
    
    func websocket(_ socket: JFRWebSocket, didReceiveMessage string: String) {
        if string == "" {
            return
        }
        
        let strs = string.nsString.components(separatedBy: "}\n{")
        
        if strs.count == 1 {
            processResponseString(str: string)
        } else {
            for i in 0..<strs.count {
                var str = strs[i]
                if i == 0 {
                    str = str + "}"
                } else if i == strs.count - 1 {
                    str = "{" + str
                } else {
                    str = "{" + str + "}"
                }
                processResponseString(str: str)
            }
        }
    }
    
    func processResponseString(str: String) {
        let om = OverseeModel(json: JSON(parseJSON: str))
        print(str)
        if datas.isEmpty {
            datas.append(om)
            if !accounts.contains(om.account) {
                accounts.append(om.account)
            }
            adapter.performUpdates(animated: false, completion: nil)
            
        } else {
            
            for (idx, obj) in datas.enumerated() {
                if accounts.contains(om.account) {
                    if obj.account == om.account {
                        datas[idx] = om
                        adapter.performUpdates(animated: false, completion: nil)
                    }
                } else {
                    datas.append(om)
                    accounts.append(om.account)
                    adapter.performUpdates(animated: false, completion: nil)
                }
            }
        }
        
    }
}

extension MViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return datas
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return OverseeSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension MViewController: MOCollectionViewLayoutDelegate {
    func itemSize(for indexPath: IndexPath) -> CGSize {
        let status = UIApplication.shared.statusBarOrientation
        let om = datas[indexPath.row]
        if UIDevice.current.userInterfaceIdiom == .phone {
            var height = OverseeInfoCell.cellSize().height
            height += OverseeOrdersCell.cellSize().height * om.orders.count.cgFloat
            var width: CGFloat = 375
            if status == .portrait || status == .portraitUpsideDown {
                width = SCREEN_WIDTH
            }
            return CGSize(width: width, height: height)
        } else {
            var height = OverseeInfoCell.cellSize().height
            height += OverseeOrdersCell.cellSize().height * om.orders.count.cgFloat
            var width: CGFloat = 0
            if status == .portrait || status == .portraitUpsideDown {
                width = (SCREEN_WIDTH - 10) / 2
            } else {
                width = (SCREEN_WIDTH - 20) / 3
            }
            return CGSize(width: width, height: height)
        }
    }
    
    
    
}
