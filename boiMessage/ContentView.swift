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
                Text("􀊼").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.system(size: 60))
                Text(msgView.msgToDisplay).lineLimit(nil)
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
    }
    
    func newRand() -> Void {
        self.msgToDisplay = msgs.randomElement()!
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cvWindow: nil)
    }
}
