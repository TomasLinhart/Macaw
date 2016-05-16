import Foundation
import RxSwift

public class Group: Node {

	public let contentsVar: Variable<[Node]>
	public var contents: [Node] {
		get { return contentsVar.value }
		set(val) { contentsVar.value = val }
	}

	public init(contents: [Node] = [], pos: Transform = Transform(), opaque: NSObject = true, visible: NSObject = true, clip: Locus? = nil, tag: [String] = []) {
		self.contentsVar = Variable<[Node]>(contents)
		super.init(
			pos: pos,
			opaque: opaque,
			visible: visible,
			clip: clip,
			tag: tag
		)
	}

	override public func bounds() -> Rect? {
		guard let firstPos = contents.first?.pos else {
			return .None
		}

		guard var union = contents.first?.bounds()?.applyTransform(firstPos) else {
			return .None
		}

		contents.forEach { node in
			guard let nodeBounds = node.bounds() else {
				return
			}

			union = union.union(nodeBounds.applyTransform(node.pos))
		}

		return union // .applyTransform(pos)
	}
}
