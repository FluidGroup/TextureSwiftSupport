func modify<Value>(_ value: inout Value, _ modifier: (inout Value) throws -> Void) rethrows {
  try modifier(&value)
}

@discardableResult
func with<Value>(_ value: Value, _ modifier: (Value) throws -> Void) rethrows -> Value {
  try modifier(value)
  return value
}
