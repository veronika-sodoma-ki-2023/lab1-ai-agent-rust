use hello::add;

#[test]
#[allow(non_snake_case)]
fn BasicAddition() {
    assert_eq!(add(2, 3), 5);
}
