# Learning Systems & Functional Languages — notes + practical

> **Audience:** someone comfortable with Python/Go who wants to learn **Rust, Zig, and Swift** — the modern systems/
> functional languages — end to end, with side-by-side comparisons.
>
> **Goal:** understand the *mental models* (ownership, memory, types, concurrency) that make these languages different
> from Python/Go, and be able to read/write small programs in each.

---

## 0. Why these languages (vs Python/Go)

| | Python | Go | Rust | Zig | Swift |
|---|---|---|---|---|---|
| Paradigm | OOP/dynamic | imperative/concurrent | systems/functional | systems/imperative | OOP/functional |
| Memory | GC | GC | ownership (no GC) | manual (allocators) | ARC (ref counting) |
| Speed | slow | fast | fastest | fastest | fast |
| Safety | runtime | runtime (race det) | compile-time (borrow checker) | explicit (no hidden alloc) | compile-time (optionals) |
| Concurrency | GIL | goroutines | async/await, threads | threads | async/await, actors |
| Use cases | ML, scripting | services, infra | kernels, perf, crypto | kernels, embedded | Apple, servers |

**Mental-model shift:** in Python/Go you *trust the runtime*. In Rust/Zig/Swift you *own the memory and the types*.

---

## 1. The three mental models

### 1.1 Rust — ownership & borrowing (the "borrow checker")

- Every value has **one owner**.
- When the owner goes out of scope, the value is **dropped** (freed).
- You can **borrow** (`&T` immutable, `&mut T` mutable) but rules: many immutable OR one mutable, never both.
- **No null, no data races, no use-after-free** — enforced at compile time.

### 1.2 Zig — explicit allocators + comptime

- **No hidden allocations**: every allocation takes an `Allocator` argument.
- **No GC, no runtime**; you manage memory explicitly (defer/errdefer).
- **comptime**: code runs at compile time (generics, reflection).
- **C interop**: seamless; Zig can compile C.

### 1.3 Swift — ARC + value types + protocols

- **ARC** (automatic reference counting) for classes; structs are **value types** (copied).
- **Optionals** (`T?`) replace null.
- **Protocols** (interfaces) + generics.
- **async/await** + actors for concurrency.

---

## 2. Side-by-side language tour

### 2.1 Variables & types

**Python:**
```python
x = 5
y = 3.14
name = "swift"
```

**Rust:**
```rust
let x: i32 = 5;          // immutable
let mut y: f64 = 3.14;   // mutable
let name: &str = "rust";
```

**Zig:**
```zig
const x: i32 = 5;
var y: f64 = 3.14;
const name: []const u8 = "zig";
```

**Swift:**
```swift
let x: Int = 5            // immutable
var y: Double = 3.14      // mutable
let name: String = "swift"
```

### 2.2 Functions

**Rust:**
```rust
fn add(a: i32, b: i32) -> i32 { a + b }
fn main() { println!("{}", add(2, 3)); }
```

**Zig:**
```zig
fn add(a: i32, b: i32) i32 { return a + b; }
pub fn main() void { std.debug.print("{d}\n", .{add(2,3)}); }
```

**Swift:**
```swift
func add(_ a: Int, _ b: Int) -> Int { a + b }
print(add(2, 3))
```

### 2.3 Structs / enums

**Rust:**
```rust
struct Point { x: f64, y: f64 }
enum Shape { Circle(f64), Rect(f64, f64) }
```

**Zig:**
```zig
const Point = struct { x: f64, y: f64 };
const Shape = union(enum) { circle: f64, rect: struct { w: f64, h: f64 } };
```

**Swift:**
```swift
struct Point { var x: Double; var y: Double }
enum Shape { case circle(Double); case rect(Double, Double) }
```

### 2.4 Pattern matching

**Rust:**
```rust
match shape {
    Shape::Circle(r) => println!("circle r={}", r),
    Shape::Rect(w, h) => println!("rect {}x{}", w, h),
}
```

**Zig:**
```zig
switch (shape) {
    .circle => |r| std.debug.print("circle {d}\n", .{r}),
    .rect => |r| std.debug.print("rect {d}x{d}\n", .{r.w, r.h}),
}
```

**Swift:**
```swift
switch shape {
case .circle(let r): print("circle \(r)")
case .rect(let w, let h): print("rect \(w)x\(h)")
}
```

### 2.5 Error handling

**Rust:** `Result<T, E>` + `?` operator.
```rust
fn parse(s: &str) -> Result<i32, ParseIntError> { s.parse() }
fn main() { let n = parse("42").unwrap(); }
```

**Zig:** error unions `!T` + `try`.
```zig
fn parse(s: []const u8) !i32 { return std.fmt.parseInt(i32, s, 10); }
pub fn main() void { const n = parse("42") catch 0; }
```

**Swift:** `throws` + `try`/`catch`.
```swift
func parse(_ s: String) throws -> Int { Int(s)! }
do { let n = try parse("42") } catch { print("err") }
```

### 2.6 Generics

**Rust:**
```rust
fn max<T: Ord>(a: T, b: T) -> T { if a > b { a } else { b } }
```

**Zig (comptime):**
```zig
fn max(comptime T: type, a: T, b: T) T { return if (a > b) a else b; }
```

**Swift:**
```swift
func max<T: Comparable>(_ a: T, _ b: T) -> T { a > b ? a : b }
```

### 2.7 Concurrency

**Rust:** threads + `async/await` (Tokio).
```rust
let handle = tokio::spawn(async { do_work().await });
```

**Zig:** threads via `std.Thread`.
```zig
const t = try std.Thread.spawn(.{}, worker, .{});
t.join();
```

**Swift:** `async/await` + actors.
```swift
actor Counter { var n = 0; func inc() { n += 1 } }
let c = Counter(); await c.inc()
```

### 2.8 Memory management

**Rust:** ownership; `Box`, `Rc`, `Arc`; drop on scope exit.
```rust
let v = vec![1,2,3];  // owned; freed when v goes out of scope
```

**Zig:** explicit allocator; `defer`/`errdefer`.
```zig
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alloc = gpa.allocator();
const buf = try alloc.alloc(u8, 100);
defer alloc.free(buf);
```

**Swift:** ARC for classes; structs copied by value.
```swift
class Foo { var x = 0 }   // ARC-managed
struct Bar { var x = 0 }   // value type, copied
```

---

## 3. Common gotchas (from Python/Go)

### Rust
- **Borrow checker fights**: "cannot borrow as mutable because also borrowed as immutable" — split borrows, use indices.
- **Lifetimes**: `&'a T` — often inferred; explicit only in structs.
- **`String` vs `&str`**: owned vs borrowed string.
- **No null**: use `Option<T>`; pattern-match with `if let Some(x) = ...`.
- **`unwrap()` panics** — prefer `?` or `match`.

### Zig
- **No hidden alloc**: every `alloc` needs an allocator; pass it down.
- **`errdefer`** for cleanup on error paths.
- **comptime** is powerful but errors are cryptic.
- **No operator overloading** (mostly); explicit.

### Swift
- **Value vs reference**: structs copy, classes share — choose deliberately.
- **Optionals**: `T?` and `guard let`/`if let`.
- **ARC cycles**: use `weak`/`unowned` to break.
- **async/await** requires runtime (Swift concurrency).

---

## 4. Learning path

### Rust
1. Read "The Rust Book" (ch. 1–10: ownership, structs, enums, pattern matching).
2. Do Rustlings (exercises).
3. Build a small CLI (clap) and a small async server (axum/tokio).
4. Read "Rust for Rustaceans" for advanced.

### Zig
1. Read Zig docs + "Zig Learn" (ziglearn.org).
2. Build a small CLI; interop with a C library.
3. Study Zig's std (std.mem, std.fmt, std.Thread).

### Swift
1. Swift.org "A Swift Tour" + "The Swift Programming Language".
2. Build a small CLI with ArgumentParser; then a small server (Vapor).
3. Explore async/await + actors.

---

## 5. Practice exercises

1. **Rust:** implement a stack (Vec-backed) with push/pop; write a unit test.
2. **Zig:** implement a dynamic array using an allocator; free on scope exit.
3. **Swift:** implement a generic `Stack<T>` struct with push/pop; use it with Int and String.
4. **All three:** write a tiny HTTP server (or use a library) and benchmark.
5. **Rust vs Zig vs Swift:** port a small algorithm (e.g., binary search) to all three; compare.

---

## 6. Resources

- Rust Book: https://doc.rust-lang.org/book/
- Rustlings: https://github.com/rust-lang/rustlings
- Zig Learn: https://ziglearn.org/
- Zig docs: https://ziglang.org/documentation/
- Swift Tour: https://docs.swift.org/swift-book/GuidedTour/GuidedTour.html
- Swift book: https://docs.swift.org/swift-book/

---

**End of tutorial.** Pair with the `max-go/` and `kernel-go/` projects for the Go-side systems view.
EOF
echo "written"