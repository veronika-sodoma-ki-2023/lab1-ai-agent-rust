---
name: create-project
description: Створити мінімальний Rust Cargo-проєкт hello через skill project-scaffold
disable-model-invocation: true
---
# create-project

## Призначення

Виконати skill `project-scaffold` з параметрами `language=rust` та
`project_name=hello`, щоб підготувати мінімальний Cargo-проєкт Hello World.

## Передумови

- Успішно виконано `git-init`.
- Доступний `cargo`.
- Поточний каталог є коренем репозиторію.
- Не перезаписувати наявний сумісний код; конфлікти повідомляти явно.

## Дії (покроково)

1. Прочитати та виконати `.github/skills/project-scaffold/SKILL.md`.
2. Перед створенням перевірити `Cargo.toml`, `src/lib.rs` і `src/main.rs`.
3. Передати skill точні входи `language=rust` і `project_name=hello`.
4. Створити лише відсутні файли та каталоги; для наявних порівняти
   обов’язковий вміст і зупинитися при конфлікті.
5. Перевірити структуру та виконати `cargo run`.

## Очікувані файли

- `Cargo.toml` з package `hello`, версією `0.1.0`, edition `2021` і без
  залежностей.
- `src/lib.rs` з `hello::add` та `hello::greeting()`, що повертає
  `Hello, World!`.
- `src/main.rs`, який друкує `hello::greeting()`.
- `.gitignore` з `/target/` і `/dist/`, без дублікатів.
- `.gitattributes` з правилами `*.sh text eol=lf` і `*.bat text eol=crlf`.

## Команди перевірки

```text
Test-Path Cargo.toml
Test-Path src/lib.rs
Test-Path src/main.rs
cargo run
```

Вивід `cargo run` має містити точний текст `Hello, World!`.

## Повідомлення про помилку (точний текст і що робити)

- `ПОМИЛКА: skill project-scaffold виявив конфлікт у наявному файлі. Збережіть файл, узгодьте обов'язковий вміст і повторіть команду.`
- `ПОМИЛКА: cargo не знайдено в PATH. Встановіть Rust через rustup, додайте Cargo до PATH і повторіть команду.`
- `ПОМИЛКА: cargo run не вивів Hello, World!. Перевірте greeting(), main.rs і помилку компіляції, виправте конфлікт і повторіть команду.`

Не імітувати успіх і не переходити до наступної команди після помилки.

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Повторний запуск не перезаписує сумісні `Cargo.toml`, `src/lib.rs`,
`src/main.rs` або `.gitattributes`, не дублює рядки в конфігураціях і лише
перевіряє їх або повідомляє про конфлікт.

