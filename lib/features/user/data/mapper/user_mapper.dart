import 'package:alt__wally/features/user/data/remote/user_dto.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';

// User userEntityToUser(UserEntity user) {
//   return User(
//       name: user.name,
//       id: user.id,
//       email: user.email,
//       password: user.password,
//       profileUrl: user.profileUrl);
// }

// UserEntity userToUserEntity(User user) {
//   return UserEntity(
//       name: user.name,
//       id: user.id,
//       email: user.email,
//       password: user.password,
//       profileUrl: user.profileUrl);
// }

UserEntity userDtoToUserEntity(UserDTO userDto) {
  return UserEntity(
    id: userDto.user.id,
    name: userDto.user.name,
    email: userDto.user.email,
    emailVerifiedAt: userDto.user.emailVerifiedAt,
    role: userDto.user.role,
    createdAt: userDto.user.createdAt,
    updatedAt: userDto.user.updatedAt,
    profileImageUrl: userDto.user.profileImageUrl,
    bannerImageUrl: userDto.user.bannerImageUrl,
    token: userDto.token,
  );
}
