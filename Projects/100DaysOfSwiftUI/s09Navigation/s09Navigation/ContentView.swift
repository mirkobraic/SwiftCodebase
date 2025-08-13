//
//  ContentView.swift
//  s09Navigation
//
//  Created by Mirko Braic on 10.02.2024..
//

import SwiftUI

// MARK: ContentView
struct ContentView: View {
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Show 32") {
                    path = [32]
                }
                Button("Show 64") {
                    path.append(64)
                }
                Button("Show 32 then 64") {
                    path = [32, 64]
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

// MARK: NavigationPathContentView
struct NavigationPathContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }

                ForEach(0..<5) { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
            .toolbar {
                Button("Push 556") {
                    path.append(556)
                }

                Button("Push Hello") {
                    path.append("Hello")
                }
            }
        }
    }
}

// MARK: PathInDetailView
struct PathInDetailView: View {
    struct DetailView: View {
        var number: Int
        @Binding var path: NavigationPath

        var body: some View {
            NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
                .navigationTitle("Number: \(number)")
                .toolbar {
                    Button("Home") {
                        path = NavigationPath()
                    }
                }
        }
    }

    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            DetailView(number: 0, path: $path)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i, path: $path)
                }
        }
    }
}

// MARK: PathStore
@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePathUrl = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePathUrl) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePathUrl)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct PathStoreView: View {
    struct DetailView: View {
        var number: Int

        var body: some View {
            NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
                .navigationTitle("Number: \(number)")
        }
    }

    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}


#Preview {
    ContentView()
}
#Preview {
    NavigationPathContentView()
}
#Preview {
    PathInDetailView()
}
#Preview {
    PathStoreView()
}
