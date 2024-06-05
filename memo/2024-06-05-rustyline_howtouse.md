title: rustyline_HowToUse
==========
date: 2024-06-05 16:08:46
tags: ["rust", "rustyline"]
categories: []
==========
# simple
```rust
use rustyline::{DefaultEditor, Result};
use rustyline::error::RustylineError;
fn main() -> Result<()> {
    env_logger::init();
    let mut rl = DefaultEditor::new()?;
    loop {
        let line = rl.readline("> ")?; // read
        println!("Line: {line}"); // eval / print
    }
}
```
# external-print

readlineのプロンプトと並行して外部の出力をスレッドで制御できる。
他コマンドとの連携に使えそう。

__requirements__
* rand
* rustyline
```rust
use std::thread;
use std::time::Duration;
use rand::{thread_rng, Rng};
use rustyline::{DefaultEditor, ExternalPrinter, Result};
fn main() -> Result<()> {
    let mut rl = DefaultEditor::new()?;
    let mut printer = rl.create_external_printer()?;
    thread::spawn(move || {
        let mut rng = thread_rng();
        let mut i = 0usize;
        loop {
            printer
                .print(format!("External message #{i}"))
                .expect("External print failure");
            let wait_ms = rng.gen_range(1000..10000);
            thread::sleep(Duration::from_millis(wait_ms));
            i += 1;
        }
    });

    loop {
        let line = rl.readline("> ")?;
        rl.add_history_entry(line.as_str())?;
        println!("Line: {line}");
    }
}
```

