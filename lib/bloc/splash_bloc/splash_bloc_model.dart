enum SplashNavigationOption { signInOption, home, intro, noInfo }

class SplashBlocModel {
  SplashBlocModel({
    this.navigationOption = SplashNavigationOption.noInfo,
  });

  final SplashNavigationOption navigationOption;

  SplashBlocModel copyWith({
    SplashNavigationOption? navigationOption,
  }) {
    return SplashBlocModel(
      navigationOption: navigationOption ?? this.navigationOption,
    );
  }
}
