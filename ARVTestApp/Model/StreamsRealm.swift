//
//  StreamsRealm.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 22.12.22.
//

import Foundation
import RealmSwift

class StreamsRealm: Object {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var data: List<StreamRealm> = List<StreamRealm>()
    
    override init() {
        super.init()
    }
    
    convenience init(streams: Streams, id: String) {
        self.init()
        self.id = id
        self.data.append(objectsIn: streams.data.map { StreamRealm(stream: $0)})
    }
    
    func getStreams() -> [Stream] {
        return data.map { $0.getStream() }
    }
}

class StreamRealm: Object {
    @Persisted var title: String = ""
    @Persisted var thumbnailUrl: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(stream: Stream) {
        self.init()
        self.title = stream.title
        self.thumbnailUrl = stream.thumbnailUrl
    }
    
    func getStream() -> Stream {
        return Stream(title: title, thumbnailUrl: thumbnailUrl)
    }
}
