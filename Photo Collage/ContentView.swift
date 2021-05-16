//
//  ContentView.swift
//  Photo Collage
//
//  Created by Женя on 16.05.2021.
//

import SwiftUI
import Photos

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var selected : [UIImage] = []
    @State var data : [Images] = []
    @State var show = false
    
    var body: some View {
        
        ZStack{
            Color.black.opacity(0.07).edgesIgnoringSafeArea(.all)
            
            VStack{
                Button(action: {
                    self.selected.removeAll()
                    self.show.toggle()
                }, label: {
                    Text("Image Picker")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width / 2)
                })
                .background(Color.red)
                .clipShape(Capsule())
            }
            if self.show {
                CustomPicker(selected: self.$selected, data: self.$data, show: self.$show)
            }
        }
    }
}

struct CustomPicker: View {
    @Binding var selected: [UIImage]
    @Binding var data: [Images]
    @State var grid: [Int] = []
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader {_ in
            VStack{
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
            .background(Color.white)
            .cornerRadius(12)
        }
        .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            self.show.toggle()
        }
        .onAppear {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.getAllImages()
                } else {
                    print("Not authorized")
                }
            }
        }
    }
    
    func getAllImages() {
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            req.enumerateObjects { (asset, _, _) in
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHCachingImageManager.default().requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                    
                    let dataItem = Images(image: image!, selected: false)
                    data.append(dataItem)
                }
            }
            
            if req.count == self.data.count {
                self.getGrid()
            }
        }
    }
    
    func getGrid() {
        for row in stride(from: 0, to: self.data.count, by: 3) {
            self.grid.append(row)
        }
    }
}

struct Images {
    var image: UIImage
    var selected: Bool
}
