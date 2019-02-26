# CarloudyiOS

上传SDK代码 并上传到cocoapods 步骤：
1. 把代码上传到github, 并release 一个version ex：v1.03
2. 修改CarloudyiOS.podspec里边的s.version = "1.03"
3. pod lib lint CarloudyiOS.podspec --allow-warnings
4. pod trunk push CarloudyiOS.podspec --allow-warnings
