---
name: build-and-test
description: Готує локальні команди build-config і unit-test, CI-скрипти та перевіряє release-збірку Rust.
---

# build-and-test

## Призначення

Стандартизувати локальну release-збірку, модульний тест і кросплатформні
скрипти CI для Cargo-проєкту `hello`.

## Коли застосовувати

Застосовувати після `project-scaffold`, коли доступні `Cargo.toml`, бібліотека
`hello` та Cargo. Підкоманди цього skill: `build-config` і `unit-test`.

## Вхідні дані

- готовий Cargo-проєкт із package `hello`;
- `cargo` у `PATH`;
- оболонка Bash для `ci.sh` або Windows `cmd` для `ci.bat`;
- кореневий каталог репозиторію.

## Результати (точні файли та їх обов'язковий вміст)

Створити або перевірити:

- `tests/basic_addition.rs` з тестом, який має містити дослівно:
  ```rust
  use hello::add;

  #[test]
  #[allow(non_snake_case)]
  fn BasicAddition() {
      assert_eq!(add(2, 3), 5);
  }
  ```
- `ci.sh` з `#!/usr/bin/env bash`, `set -euo pipefail` і чотирма етапами у
  виводі: `== Configure ==`, `== Build ==`, `== Test ==`, `== Package ==`;
- `ci.bat`, який у Windows `cmd` виконує ті самі чотири етапи, кожен із
  відповідним заголовком у виводі;
- етап `Configure` виконує `rustc --version`, `cargo --version`, `cargo fetch`;
- етап `Build` виконує `cargo build --release`;
- етап `Test` виконує `cargo test --release`;
- етап `Package` створює `dist/`, копіює `hello`/`hello.exe` у `dist/` і
  запускає скопійований виконуваний файл;
- після кожної команди скрипт завершується з помилкою при збої; у `ci.bat`
  для цього використовується `if errorlevel 1 exit /b %errorlevel%`.
- каталог `dist/` і release-бінарний файл після успішного запуску скрипта.

## Кроки виконання

1. Перевірити, що існує package `hello` і функція `hello::add`.
2. Підкомандою `build-config` перевірити release-конфігурацію та підготувати
   `ci.sh` і `ci.bat` без зміни Cargo-коду.
3. Підкомандою `unit-test` створити `tests/basic_addition.rs`, якщо його ще
   немає; конфліктний наявний тест не перезаписувати.
4. Запустити release-збірку, тест і відповідний платформний скрипт.
5. Перевірити артефакт у `dist/` та повідомити точний код помилки при збої.

Скрипти мають виконувати етапи саме в порядку Configure, Build, Test,
Package; конфігураційним етапом не можна нехтувати.

## Перевірки (конкретні команди)

```text
cargo test --release
bash ./ci.sh
```

У Windows виконати:

```text
ci.bat
```

Очікувати `test BasicAddition ... ok`, існування `dist/hello` або
`dist/hello.exe`, а також:

```text
git check-ignore target dist
```

## Ідемпотентність (повторний запуск не перезаписує і не дублює)

Не перезаписувати сумісні `tests/basic_addition.rs`, `ci.sh` або `ci.bat`.
Каталог `dist` можна використовувати повторно, але скрипт має замінювати
лише власний release-артефакт після успішної збірки. Не додавати дублікати
рядків до конфігурацій.

## Приклад входу

```text
project_name=hello
subcommands=build-config,unit-test
platform=windows
```

## Очікуваний результат

`cargo test --release` завершується успішно з тестом `BasicAddition`, а
`ci.sh` або `ci.bat` збирає, тестує, копіює та запускає release-бінарний файл
у `dist/`.

## Типовий сценарій помилки та дії агента

Якщо у Windows повідомлено `link.exe not found`, агент зупиняється та
повідомляє встановити компонент Visual Studio **Desktop development with
C++** (разом із потрібним Windows SDK), після чого повторити команду. Не
маскувати помилку альтернативною збіркою.
