---
name: create-build
description: Підготувати release-збірку, BasicAddition і локальні CI-скрипти
disable-model-invocation: true
---
# create-build

## Призначення

Виконати skill `build-and-test` з підкомандами `build-config` і `unit-test`
для Rust-проєкту `hello`.

## Передумови

- Успішно виконано `create-project`.
- Існують `Cargo.toml`, `src/lib.rs` і функція `hello::add`.
- Доступний `cargo`; для поточної ОС доступна потрібна оболонка.

## Дії (покроково)

1. Прочитати та виконати `.github/skills/build-and-test/SKILL.md`.
2. Виконати підкоманду `build-config`: підготувати `ci.sh` і `ci.bat` за
   контрактом skill, не змінюючи Rust-код.
3. Виконати підкоманду `unit-test`: створити
   `tests/basic_addition.rs` з тестом `BasicAddition`, якщо його немає.
4. ????????? `cargo test --release` ? ?????????? `test BasicAddition ... ok` ?
   ????????????, ?? ????? ?? ??????? `warning:`.
5. Запустити `ci.bat` у Windows або `bash ./ci.sh` у Linux/macOS.
6. Перевірити наявність `dist/hello.exe` у Windows або `dist/hello` на
   Linux/macOS.

## Очікувані файли

- `tests/basic_addition.rs` з тестом `BasicAddition`, який містить дослівно:
  ```rust
  use hello::add;

  #[test]
  #[allow(non_snake_case)]
  fn BasicAddition() {
      assert_eq!(add(2, 3), 5);
  }
  ```
- `ci.sh` і `ci.bat` із чотирма етапами `== Configure ==`,
  `== Build ==`, `== Test ==`, `== Package ==`.
- `Configure`: `rustc --version`, `cargo --version`, `cargo fetch`.
- `Build`: `cargo build --release`.
- `Test`: `cargo test --release`.
- `Package`: створення `dist/`, копіювання `hello`/`hello.exe` у `dist/` і
  запуск скопійованого артефакту.
- Після кожної команди має бути вихід із помилкою при збої; `ci.bat`
  перевіряє кожну команду через `if errorlevel 1 exit /b %errorlevel%`.
- `dist/hello` або `dist/hello.exe` після успішного запуску.

## Команди перевірки

```text
cargo test --release
```

Windows:

```text
ci.bat
```

Linux/macOS:

```text
bash ./ci.sh
```

Перевірити також `git check-ignore target dist` і вивід скрипта
`Hello, World!`.

## Повідомлення про помилку (точний текст і що робити)

- `ПОМИЛКА: cargo test --release не пройшов. Перевірте BasicAddition і повідомлення компілятора, виправте причину та повторіть команду.`
- `ПОМИЛКА: у Windows не знайдено link.exe. Встановіть Visual Studio Desktop development with C++ і Windows SDK, потім повторіть команду.`
- `ПОМИЛКА: CI-скрипт не створив очікуваний dist/hello або dist/hello.exe. Перевірте код завершення, шляхи копіювання та повторіть команду.`

Зупинитися на першій помилці й не маскувати її альтернативною збіркою.

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Сумісні `tests/basic_addition.rs`, `ci.sh` і `ci.bat` не перезаписувати.
Каталог `dist/` можна повторно використовувати; замінювати лише власний
успішно зібраний release-артефакт і не дублювати конфігураційні рядки.
