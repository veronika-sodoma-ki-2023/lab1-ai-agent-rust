---
description: "Послідовно виконати повну ініціалізацію Rust-проєкту та завершити лише після CHECK PASSED"
agent: "build-engineer"
---

# init

## Призначення

Оркеструвати повний процес варіанта 4: `git-init` → `create-project` →
`create-build` → `create-actions` → `check`.

## Передумови

- Доступні `git`, `cargo` і `python` у `PATH`.
- Виконання відбувається з кореня репозиторію.
- Доступні prompt-файли `.github/prompts/git-init.prompt.md`,
  `.github/prompts/create-project.prompt.md`,
  `.github/prompts/create-build.prompt.md`,
  `.github/prompts/create-actions.prompt.md` і
  `.github/prompts/check.prompt.md`.

## Дії (покроково)

1. Послідовно прочитати й виконати `git-init.prompt.md`,
   `create-project.prompt.md`, `create-build.prompt.md`,
   `create-actions.prompt.md`, `check.prompt.md`.
2. Після кожного з перших чотирьох кроків перевірити його очікувані файли;
   після `check` вимагати саме `CHECK PASSED`.
3. При першій помилці зупинитися, вивести назву кроку, точну причину та код
   завершення, не переходити далі.
4. Після завершення вивести таблицю `Крок | Команда | Статус | Деталі`.
5. Оголосити успіх лише після повного звіту `check` зі статусом
   `CHECK PASSED`.

## Очікувані файли

Після успіху існують і перевірені: `.gitignore`, `Cargo.toml`, `src/lib.rs`,
`src/main.rs`, `.gitattributes`, `tests/basic_addition.rs`, `ci.sh`,
`ci.bat`, `.github/workflows/ci.yml` та release-артефакт `dist/hello` або
`dist/hello.exe`. Команда `check` не повинна змінювати файли проєкту.

## Команди перевірки

```text
git --version
cargo --version
python --version
```

Після кожного кроку перевірити відповідний розділ «Очікувані файли» його
prompt-файла. Фінальна перевірка — виконання `.github/prompts/check.prompt.md`
і отримання `CHECK PASSED`.

## Повідомлення про помилку (точний текст і що робити)

- `INIT FAILED: крок "<назва>" завершився помилкою: <причина>. Виправте причину окремою командою та повторіть init. Наступні кроки не виконувалися.`
- `ПОМИЛКА: недоступна обов'язкова команда <git|cargo|python>. Встановіть її, додайте до PATH і повторіть init.`
- `INIT FAILED: фінальний check не повернув CHECK PASSED. Перегляньте таблицю check, усуньте помилки відповідними prompt-командами й повторіть init.`

Не приховувати помилку, не пропускати кроки та не переходити до наступного
prompt після невдачі.

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Повторний запуск виконує ті самі перевірки та не перезаписує правильні файли.
Кожен дочірній prompt зберігає власні правила ідемпотентності, не дублює
рядки конфігурації, а `check` лише читає проєкт.

