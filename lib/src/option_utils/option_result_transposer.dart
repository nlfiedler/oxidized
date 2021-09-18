part of 'option_utils.dart';

extension OptionResultTransposer<T extends Object, E extends Object>
    on Option<Result<T, E>> {
  /// Transposes the result of an option.
  ///
  /// See also https://doc.rust-lang.org/std/option/enum.Option.html#method.transpose
  Result<Option<T>, E> transpose() {
    return match(
      (result) => result.match(
        (value) => Ok(Some(value)),
        (err) => Err(err),
      ),
      () => Ok(None()),
    );
  }
}
