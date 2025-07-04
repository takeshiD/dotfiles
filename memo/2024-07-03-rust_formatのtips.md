title: Rust_formatのtips
====================================
date: 2024-07-03 10:07:43
tags: []
category: []
====================================

# format関連
println, print, formatマクロのフォーマットパラメータの動的な指定の仕方を記述する。

とはいえ公式が一番詳しいので2番煎じです。

[RustDocument - std::fmt - format string](https://doc.rust-lang.org/std/fmt/index.html)

# 項目整理
* Positional Parameter
* Named Parameter
* Formatting Parameter
    * Width
    * Fill/Alignment
    * Sign/#/0
    * Precision
* Escape

## 基本の使い方
```rust
let value = 12;
let label = String::from("Hello");
println("{value} {}", label);
>> 12 Hello
```

## 揃え
* `{:<n}` : n桁で左揃え
* `{:>n}` : n桁で右揃え
* `{:^n}` : n桁で中央揃え

## 基数、指数
* `{:b}`: 2進数
* `{:o}`: 8進数
* `{:x}`: 16進数(小文字)
* `{:X}`: 16進数(大文字)
* `{:e}`: 指数表現(小文字)
* `{:E}`: 指数表現(大文字)

## 0埋め
`{:0n}`などと指定すると8桁で0埋めしてくれる。揃え,基数,小数点と併用可能です。

* `{:<}`
