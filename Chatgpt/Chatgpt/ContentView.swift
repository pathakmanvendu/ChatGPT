//
//  ContentView.swift
//  Chatgpt
//
//  Created by Manvendu Pathak on 04/02/24.
//
import OpenAISwift
import SwiftUI

//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
final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    
    func setup() {
        client = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: "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"))
            
    }
    
    func send(text: String , completion: @escaping (String) -> Void){
        client?.sendCompletion(with: text,maxTokens: 500, completionHandler: {  result  in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models,id: \.self){ string in
                Text(string)
            }
            Spacer()
            
            HStack{
                TextField("Type here...", text: $text)
                Button("Send"){
                    send()
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: "+response)
                print(response)
                self.text = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
