//
//  SearchView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI
import UIKit

struct SearchView: UIViewRepresentable{
    func makeUIView(context: Context) -> UIViewType {
        SerchBleView(frame: .zero)
    }
    
    func updateUIView(_ view: SerchBleView, context: Context) {
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


class SerchBleView :UIView{
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "background")
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
}
