---
name: github-actions
description: Описує workflow GitHub Actions для release CI через локальні ci.sh і ci.bat на трьох ОС.
---

# github-actions

## Призначення

Підготувати кросплатформний workflow GitHub Actions, який делегує всі Cargo
операції локальним CI-скриптам і публікує каталог `dist/` як artifact.

## Коли застосовувати

Застосовувати після `build-and-test`, коли в корені існують працездатні
`ci.sh` і `ci.bat`. Skill потрібен для подій push, pull request і ручного
запуску workflow.

## Вхідні дані

- репозиторій із `ci.sh`, `ci.bat` і `.gitattributes`;
- цільові гілки `develop` і `master`;
- GitHub Actions із доступом до `actions/checkout@v4` та
  `actions/upload-artifact@v4`;
- відсутність секретів, які потрібно додати до workflow.

## Результати (точні файли та їх обов'язковий вміст)

Створити `.github/workflows/ci.yml` з таким контрактом:

- `name: CI`;
- `on` містить `push` і `pull_request` з гілками `develop` та `master`, а
  також `workflow_dispatch`;
- одна job `build` зі `strategy.matrix.os`:
  `[ubuntu-latest, windows-latest, macos-latest]` і `fail-fast: false`;
- кроки `actions/checkout@v4`, запуск `bash ./ci.sh` на Linux/macOS і
  `ci.bat` з `shell: cmd` на Windows;
- `actions/upload-artifact@v4` з
  `name: hello-${{ matrix.os }}` і `path: dist/`;
- workflow не містить прямих викликів `cargo` і не містить секретів.

## Кроки виконання

1. Перевірити наявність і line endings `ci.sh`, `ci.bat` та `.gitattributes`.
2. Створити відсутній каталог `.github/workflows/`.
3. Створити `ci.yml` з однією job і матрицею трьох ОС; не перезаписувати
   наявний несумісний workflow без явного дозволу.
4. Перевірити, що Cargo викликається тільки всередині локальних скриптів.
5. Валідовати YAML і обов'язкові текстові умови.

## Перевірки (конкретні команди)

```text
python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"
```

Додатково перевірити пошуком наявність `ubuntu-latest`,
`windows-latest`, `macos-latest`, `actions/checkout@v4`,
`actions/upload-artifact@v4` і відсутність рядків із прямим викликом `cargo` у
`.github/workflows/ci.yml`.

## Ідемпотентність (повторний запуск не перезаписує і не дублює)

Не перезаписувати сумісний `ci.yml` і не додавати дублікати trigger-ів,
операційних систем або кроків. Якщо наявний workflow має конфліктну структуру,
агент зупиняється та описує конфлікт замість прихованого об'єднання.

## Приклад входу

```text
ci_scripts=ci.sh,ci.bat
branches=develop,master
platforms=ubuntu-latest,windows-latest,macos-latest
```

## Очікуваний результат

`.github/workflows/ci.yml` запускає локальний CI на всіх трьох ОС для push,
pull request і `workflow_dispatch`, а після успіху завантажує відповідний
`dist/` як artifact `hello-${{ matrix.os }}`.

## Типовий сценарій помилки та дії агента

Якщо Linux повідомляє `bash\r: No such file`, агент зупиняється, перевіряє
line endings і виправляє їх через правило `.gitattributes` `*.sh text eol=lf`;
після цього повторює перевірку. Прямо додавати `cargo` до `ci.yml` не можна.
