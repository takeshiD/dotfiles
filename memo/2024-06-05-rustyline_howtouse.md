title: rustyline_HowToUse
==========
date: 2024-06-05 16:08:46
tags: ["rust", "rustyline"]
categories: []
==========
# reference
* SourceCode: https://github.com/kkawakam/rustyline.git
* Document: https://docs.rs/rustyline/14.0.0/rustyline/index.html

# trait

* completion
    * Candidate
    * Completer
* config
    * Builder
    * Config
* error
    * ReadlineError::Io(Error)
    * ReadlineError::Eof
    * ReadlineError::Interrupterd
    * ReadlineError::Errno(Error)
    * ReadlineError::WindowResized
* highlight
    * Highliter
* hint
    * Hint
    * Hinter
* history
    * History
* line_buffer
    * ChangeListener
    * DeleteListener
* validate
    * Validator

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

# Hints

```rust
use std::collections::HashSet;
use rustyline::hint::{Hint, Hinter};
use rustyline::history::DefaultHistory;
use rustyline::Context;
use rustyline::{Completer, Helper, Highlighter, Validator};
use rustyline::{Editor, Result};

#[derive(Completer, Helper, Validator, Highlighter)]
struct DIYHinter {
    // It's simple example of rustyline, for more efficient, please use ** radix trie **
    hints: HashSet<CommandHint>,
}

#[derive(Hash, Debug, PartialEq, Eq)]
struct CommandHint {
    display: String,
    complete_up_to: usize,
}

impl Hint for CommandHint {
    fn display(&self) -> &str {
        &self.display
    }

    fn completion(&self) -> Option<&str> {
        if self.complete_up_to > 0 {
            Some(&self.display[..self.complete_up_to])
        } else {
            None
        }
    }
}

impl CommandHint {
    fn new(text: &str, complete_up_to: &str) -> CommandHint {
        assert!(text.starts_with(complete_up_to));
        CommandHint {
            display: text.into(),
            complete_up_to: complete_up_to.len(),
        }
    }

    fn suffix(&self, strip_chars: usize) -> CommandHint {
        CommandHint {
            display: self.display[strip_chars..].to_owned(),
            complete_up_to: self.complete_up_to.saturating_sub(strip_chars),
        }
    }
}

impl Hinter for DIYHinter {
    type Hint = CommandHint;

    fn hint(&self, line: &str, pos: usize, _ctx: &Context<'_>) -> Option<CommandHint> {
        if line.is_empty() || pos < line.len() {
            return None;
        }

        self.hints
            .iter()
            .filter_map(|hint| {
                // expect hint after word complete, like redis cli, add condition:
                // line.ends_with(" ")
                if hint.display.starts_with(line) {
                    Some(hint.suffix(pos))
                } else {
                    None
                }
            })
            .next()
    }
}

fn diy_hints() -> HashSet<CommandHint> {
    let mut set = HashSet::new();
    set.insert(CommandHint::new("help", "help"));
    set.insert(CommandHint::new("get key", "get "));
    set.insert(CommandHint::new("set key value", "set "));
    set.insert(CommandHint::new("hget key field", "hget "));
    set.insert(CommandHint::new("hset key field value", "hset "));
    set
}

fn main() -> Result<()> {
    println!("This is a DIY hint hack of rustyline");
    let h = DIYHinter { hints: diy_hints() };

    let mut rl: Editor<DIYHinter, DefaultHistory> = Editor::new()?;
    rl.set_helper(Some(h));

    loop {
        let input = rl.readline("> ")?;
        println!("input: {input}");
    }
}
```


ヒント機能の利用。Rustのworkspaceをよくわかっておらず若干はまる。
RustのライブラリはCargo.tomlの`[features]`で機能の有効化/無効化をするらしい。
rootのCargo.tomlは以下


```toml:Cargo.toml
[package]
name = "ex_rustyline"
version = "0.1.0"
edition = "2021"

[dependencies]
rand = "0.8.5"
rustyline = {version = "14.0.0", features = ["derive"]}
```


このページが参考になった。
* Rust フィーチャーフラグの使い方 : https://qiita.com/osanshouo/items/43271813b5d62e89d598


rustylineのCargo.tomlは以下リンク

https://github.com/kkawakam/rustyline/blob/master/Cargo.toml

## 解説
大きく`Hinter`と`Hint`に分けられる。
```rust
pub trait Hint {
    // Hintsがアクティブな時に表示される文字列
    fn display(&self) -> &str;
    // デフォルトでは右矢印キーで補完する文字列
    fn completion(&self) -> Option<&str>;
}

pub trait Hinter {
    type Hint: Hint + 'static;
    // 補完のたびに呼ばれるメイン関数
    fn hint(
        &self,
        line: &str,
        pos: usize,
        ctx: &Context<'_>
    ) -> Option<Self::Hint> { ... }
}
```

### 実装部
実装部だけ抜きだすと以下。`CommandHint`と`DIYHinter`が自身の実装struct

```rust
// Hintは表示と補完だけなのでノー解説
impl Hint for CommandHint {
    fn display(&self) -> &str {
        &self.display
    }

    fn completion(&self) -> Option<&str> {
        if self.complete_up_to > 0 {
            Some(&self.display[..self.complete_up_to])
        } else {
            None
        }
    }
}

impl Hinter for DIYHinter {
    type Hint = CommandHint;
    fn hint(&self, line: &str, pos: usize, _ctx: &Context<'_>) -> Option<CommandHint> {
        if line.is_empty() || pos < line.len() {
            return None;
        }
        // self.hints: HashSet<CommandHint>
        self.hints
            .iter()
            .filter_map(|hint| {
                if hint.display.starts_with(line) {
                    Some(hint.suffix(pos))
                } else {
                    None
                }
            })
            .next()
    }
}
```

# EventHandler
```rust
use rustyline::{
    Cmd, ConditionalEventHandler, DefaultEditor, Event, EventContext, EventHandler, KeyCode,
    KeyEvent, Modifiers, RepeatCount, Result,
};

struct FilteringEventHandler;
impl ConditionalEventHandler for FilteringEventHandler {
    fn handle(&self, evt: &Event, _: RepeatCount, _: bool, _: &EventContext) -> Option<Cmd> {
        if let Some(KeyEvent(KeyCode::Char(c), m)) = evt.get(0) {
            if m.contains(Modifiers::CTRL) || m.contains(Modifiers::ALT) || c.is_ascii_digit() {
                None
            } else {
                Some(Cmd::Noop) // filter out invalid input
            }
        } else {
            None
        }
    }
}

fn main() -> Result<()> {
    let mut rl = DefaultEditor::new()?;

    rl.bind_sequence(
        Event::Any,
        EventHandler::Conditional(Box::new(FilteringEventHandler)),
    );

    loop {
        let line = rl.readline("> ")?;
        println!("Num: {line}");
    }
}
```


# Editor
エントリーポイントとなるstruct
```rust
pub struct Editor<H: Helper, I: History> {
    term: Terminal,
    buffer: Option<Buffer>,
    history: I,
    helper: Option<H>,
    kill_ring: KillRing,
    config: Config,
    custom_bindings: Bindings,
}
```
よく例題に現れる`DefaultEditor`はHistoryがDefaultHistoryとなっている構造体。
