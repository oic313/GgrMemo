public extension String {
    var trimming: String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
    var isEmptyByTrimming: Bool { self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
