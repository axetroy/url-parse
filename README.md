# url-parse

[![Build Status](https://travis-ci.org/axetroy/url-parse.svg?branch=master)](https://travis-ci.org/axetroy/url-parse)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Dart](https://img.shields.io/badge/dart-%3E=1.2.0-blue.svg?style=flat-square)

An advanced url parser supporting git urls too.

## Usage

```dart
import 'package:url_parse/url-parse.dart' show urlParse;

void main(){
  Map<String,dynamic> httpUrlInfo = urlParse('https://www.google.com');
  Map<String,dynamic> gitUrlInfo = urlParse('git+https@github.com:axetroy/protocols.git');
  
  print(httpUrlInfo);
  print(urlInfo);
}
```

## Test

```bash
./TEST
```

## Contribute

```bash
git clone https://github.com/axetroy/url-parse.git && cd ./url-parse
pub get
./TEST
```

## LICENSE

The [MIT License](https://github.com/axetroy/url-parse/blob/master/LICENSE)