//
//  GraphStructure.swift
//  Graph
//
//  Created by youngjun goo on 02/01/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation


//MARK: -Vertex(정점)
public struct Vertex<T: Equatable & Hashable>: Equatable {
    public var data: T
    public let index: Int
}
// 두 정점을 비교하는 연산자 함수를 클로저로 구현
public func ==<T: Equatable>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    guard lhs.data == rhs.data else {
        return false
    }
    return true
}

extension Vertex: Hashable {
    public var hashValue: Int {
        get {
            return "\(index)".hashValue
        }
    }
}

//MARK: -Edge(엣지)
public struct Edge<T: Equatable & Hashable>: Equatable {
    public let from: Vertex<T>
    public let to: Vertex<T>
}

public func ==<T: Equatable>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    guard lhs.from == rhs.from else {
        return false
    }
    guard lhs.to == rhs.to else {
        return false
    }
    return true
}

extension Edge: Hashable {
    public var hashValue: Int {
        get {
            let stringHash = "\(from.index) -> \(to.index)"
            return stringHash.hashValue
        }
    }
}


public struct VertexEdgeList<T: Equatable & Hashable> {
    public let vertex: Vertex<T>
    public var edges = [Edge<T>]()
    public init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    //구조체 내부의 값을 수정하는 함수 addEdge(엣지 추가)
    public mutating func addEdge(edge: Edge<T>) {
        if edges.count > 0 {
            //해당 조건을 만족 시카는 엣지 찾기
            let equalEdges = edges.filter { existingEdge -> Bool in
                return existingEdge == edge
            }
            if equalEdges.count > 0 {
                return
            }
        }
        edges.append(edge)
    }
}

public struct AdjacencyListGraph<T: Equatable & Hashable> {
    public var adjacencyLists = [VertexEdgeList<T>]()
    
    public var vertices: [Vertex<T>] {
        get {
            var vertices = [Vertex<T>]()
            for list in adjacencyLists {
                vertices.append(list.vertex)
            }
            return vertices
        }
    }
    
    public var edges: [Edge<T>] {
        get {
            var edges = Set<Edge<T>>()
            for list in adjacencyLists {
                for edge in list.edges {
                    edges.insert(edge)
                }
            }
            return Array(edges)
        }
    }
    
    //그래프에 정점 추가
    public mutating func addVertex(data: T) -> Vertex<T> {
        for list in adjacencyLists {
            if list.vertex.data == data {
                return list.vertex
            }
        }
        let vertex = Vertex(data: data, index: adjacencyLists.count)
        let additionalList = VertexEdgeList(vertex: vertex)
        adjacencyLists.append(additionalList)
        return vertex
    }
    
    public mutating func addEdge(from: Vertex<T>, to: Vertex<T>) -> Edge<T> {
        let edge = Edge(from: from, to: to)
        let list = adjacencyLists[from.index]
        
        if list.edges.count > 0 {
            for existingEdge in  list.edges {
                if existingEdge == edge {
                    return existingEdge
                }
            }
            adjacencyLists[from.index].edges.append(edge)
        } else {
            adjacencyLists[from.index].edges = [edge]
        }
        return edge
    }
    
    
}

