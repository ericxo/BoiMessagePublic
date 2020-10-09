//
//  ContentView.swift
//  boiMessage
//
//  Created by Eric Chianti on 10/7/20.
//

import SwiftUI

struct ContentView: View {
    
    let cvWindow:NSWindow?
    
    
    @ObservedObject var msgView : RandomViewModel = RandomViewModel()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Image("heart")
//                Text().fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.system(size: 60))
                Text(msgView.msgToDisplay).lineLimit(nil).fixedSize(horizontal: false, vertical: true)
            }.padding()
            HStack {
                Spacer()
                Button(action: {
                    self.msgView.newRand()
                }, label: {
                    Text("Show me another")
                })
                Button(action: {
                    self.cvWindow!.close()
                }, label: {
                    Text("I appreciate my boyfriend (close)")
                })
            }.padding()
        }.padding().frame(minWidth: 600, idealWidth: 600, maxWidth: 600, minHeight: 150, idealHeight: 150, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

class RandomViewModel : ObservableObject {
    var msgs : [String]
    @Published var msgToDisplay : String
    init() {
        let url = Bundle.main.url(forResource: "msgs", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let strings = try? JSONDecoder().decode([String].self, from: data)
        self.msgs = strings!
        self.msgToDisplay = msgs.randomElement()!
        webJSONTry()
    }
    
    func newRand() -> Void {
        self.msgToDisplay = msgs.randomElement()!
    }

    func webJSONTry() -> Void {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationDirectory, in: .userDomainMask).first!
        let directoryURL = appSupportURL.appendingPathComponent("BoiMessage")
        
        let documentURL = directoryURL.appendingPathComponent ("msgs.json")
        print(documentURL.path)
        let urlString = "https://Your/remote/json/here"
        let url = URL(string: urlString)
        guard url != nil else {
            return
        }
        let session = URLSession.shared
        let dataTaskVar = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    
                    self.msgs = try decoder.decode([String].self, from: data!)
                    self.msgToDisplay = self.msgs.randomElement()!
                    try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                    try? JSONSerialization.data(withJSONObject: self.msgs).write(to: documentURL)
                }
                catch {
                    print("Error in JSON retrieval / writing")
                    let data = try! Data(contentsOf: documentURL)
                    self.msgs = try! JSONDecoder().decode([String].self, from: data)
                    self.msgToDisplay = self.msgs.randomElement()!
                }
            }
            else {
                print("something strange happened")
            }
        }
        dataTaskVar.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cvWindow: nil)
    }
}

