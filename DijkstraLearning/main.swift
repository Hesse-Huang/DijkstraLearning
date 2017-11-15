//
//  main.swift
//  DijkstraLearning
//
//  Created by Hesse Huang on 2017/11/15.
//  Copyright © 2017年 Hesse. All rights reserved.
//

import Foundation

typealias Nb = (Vertex, Int)

class Vertex: NSObject {
    let name: String
    var neighbours: [Nb]
    init(name: String, neighbours: [Nb]) {
        self.name = name
        self.neighbours = neighbours
    }
    
    override var debugDescription: String {
        return name
    }
    
}

var a = Vertex(name: "A", neighbours: [])
var b = Vertex(name: "B", neighbours: [])
var c = Vertex(name: "C", neighbours: [])
var d = Vertex(name: "D", neighbours: [])
var e = Vertex(name: "E", neighbours: [])

a.neighbours = [(b, 6), (d, 1)]
b.neighbours = [(a, 1), (c, 5), (d, 2), (e, 2)]
c.neighbours = [(b, 5), (e, 5)]
d.neighbours = [(a, 1), (b, 2), (e, 1)]
e.neighbours = [(b, 2), (c, 5), (d, 1)]

let graph = [a, b, c, d, e]

typealias ResultTable = Array<ResultItem>
class ResultItem: NSObject {
    let vertex: Vertex
    var shortestDistance: Int
    var previousVertex: Vertex?
    init(vertex: Vertex, shortestDistance: Int, previousVertex: Vertex?) {
        self.vertex = vertex
        self.shortestDistance = shortestDistance
        self.previousVertex = previousVertex
    }
    
    override var debugDescription: String {
        return "\(vertex.debugDescription), \(shortestDistance), \(String(describing: previousVertex))"
    }
    
}

func runDijkstra(from origin: Vertex, in graph: [Vertex]) -> ResultTable {
    var result = ResultTable()
    for v in graph {
        let item = ResultItem(vertex: v, shortestDistance: v == origin ? 0 : .max, previousVertex: nil)
        result.append(item)
    }
    
    var start: Vertex
    var unvisiteds = graph
    var visiteds = [Vertex]()
    while !unvisiteds.isEmpty {
        if let v = result.filter({ unvisiteds.contains($0.vertex) }).min(by: { $0.shortestDistance < $1.shortestDistance })?.vertex {
            start = v
            
            // examine unvisited neighbours
            let unvisitedNbs = start.neighbours.filter({ !visiteds.contains($0.0) })
            let item_c = result.first(where: { $0.vertex == v })!
            for (u, d) in unvisitedNbs {
                let item_u = result.first(where: { $0.vertex == u })!
                if item_u.shortestDistance > item_c.shortestDistance + d {
                    item_u.shortestDistance = item_c.shortestDistance + d
                    item_u.previousVertex = v
                }
            }
            
            let i = unvisiteds.index(where: { $0 == v })!
            visiteds.append(unvisiteds[i])
            unvisiteds.remove(at: i)
        }
    }
    return result
}

let r = runDijkstra(from: a, in: graph)
for i in r {
    debugPrint(i)
}
