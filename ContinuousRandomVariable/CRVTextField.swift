//
//  CRVTextField.swift
//  ContinuousRandomVariable
//
//  Created by Steven Wijaya on 12.05.2023.
//

import SwiftUI

struct CRVTextField: View {
    
    var text: String
    @Binding var data: String
    
    var body: some View {
        HStack {
            Text(text)
            TextField(text, text: $data)
        }
    }
}

struct CRVTextField_Previews: PreviewProvider {
    static var previews: some View {
        CRVTextField(text: "Mean", data: .constant("0.0"))
    }
}
