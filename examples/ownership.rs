// ownership.rs — ownership & borrowing in Rust
fn main() {
    let s = String::from("hello");
    let s2 = s;          // move: s is no longer valid
    // println!("{}", s); // ERROR: use of moved value
    println!("{}", s2);

    let v = vec![1, 2, 3];
    let r = &v;          // immutable borrow
    println!("{:?}", r);
    // v.push(4);        // ERROR: cannot mutate while borrowed
}