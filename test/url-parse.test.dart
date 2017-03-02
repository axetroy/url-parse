import 'package:test/test.dart';

import '../lib/url-parse.dart' show urlParser;

@TestOn('linux || mac-os || posix || content-shell || window')
void main() {
  group('test http url > ', () {
    test("Parse an https url.", () {
      String url = 'https://www.google.com';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('https'));
      expect(result["protocols"], equals(['https']));
      expect(result["port"], equals(443));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('https://www.google.com'));
      expect(result["path"], equals(''));
      expect(result["query"], equals(''));
      expect(result["hash"], equals(''));
    });

    test("Parse an http url with query.", () {
      String url = 'http://www.google.com?a=b&b=c';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('http'));
      expect(result["protocols"], equals(['http']));
      expect(result["port"], equals(80));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('http://www.google.com'));
      expect(result["path"], equals(''));
      expect(result["query"], equals('a=b&b=c'));
      expect(result["hash"], equals(''));
    });

    test("Parse an https url with query and hash.", () {
      String url = 'http://www.google.com?a=b&b=c#readme';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('http'));
      expect(result["protocols"], equals(['http']));
      expect(result["port"], equals(80));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('http://www.google.com'));
      expect(result["path"], equals(''));
      expect(result["query"], equals('a=b&b=c'));
      expect(result["hash"], equals('readme'));
    });

    test("Parse an https url with hash and query.", () {
      String url = 'http://www.google.com#readme?a=b&b=c';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('http'));
      expect(result["protocols"], equals(['http']));
      expect(result["port"], equals(80));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('http://www.google.com'));
      expect(result["path"], equals(''));
      expect(result["query"], equals('a=b&b=c'));
      expect(result["hash"], equals('readme'));
    });

    test("Parse an https url with user info.", () {
      String url = 'http://axetroy:1111@www.google.com?a=b&b=c#readme';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('http'));
      expect(result["protocols"], equals(['http']));
      expect(result["port"], equals(80));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('http://www.google.com'));
      expect(result["path"], equals(''));
      expect(result["query"], equals('a=b&b=c'));
      expect(result["hash"], equals('readme'));
      expect(result["user"], equals('axetroy'));
      expect(result["pass"], equals('1111'));
    });

    test("Parse an https url with specify port.", () {
      String url = 'http://axetroy:1111@www.google.com:8080?a=b&b=c#readme';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('http'));
      expect(result["protocols"], equals(['http']));
      expect(result["port"], equals(8080));
      expect(result["host"], equals('www.google.com'));
      expect(result["origin"], equals('http://www.google.com:8080'));
      expect(result["path"], equals(''));
      expect(result["query"], equals('a=b&b=c'));
      expect(result["hash"], equals('readme'));
      expect(result["user"], equals('axetroy'));
      expect(result["pass"], equals('1111'));
    });
  });

  group('test git url > ', () {
    test("Parse an git url.", () {
      String url = 'git@github.com:axetroy/protocols.git';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('git'));
      expect(result["protocols"], equals(['git']));
      expect(result["port"], equals(443));
      expect(result["host"], equals('github.com'));
      expect(result["origin"], equals('git@github.com'));
      expect(result["path"], equals('/protocols.git'));
      expect(result["query"], equals(''));
      expect(result["hash"], equals(''));
    });

    test("Parse an git url with http+git proto.", () {
      String url = 'git+https@github.com:axetroy/protocols.git';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('git'));
      expect(result["protocols"], equals(['git', 'https']));
      expect(result["port"], equals(443));
      expect(result["host"], equals('github.com'));
      expect(result["origin"], equals('git+https@github.com'));
      expect(result["path"], equals('/protocols.git'));
      expect(result["query"], equals(''));
      expect(result["hash"], equals(''));
      expect(result["user"], equals('axetroy'));
    });

    test("Parse an gitlab url .", () {
      String url = 'git@gitlab.com:kadu/kadu.git';
      final Map<String, dynamic> result = urlParser(url);
      expect(result["protocol"], equals('git'));
      expect(result["protocols"], equals(['git']));
      expect(result["port"], equals(443));
      expect(result["host"], equals('gitlab.com'));
      expect(result["origin"], equals('git@gitlab.com'));
      expect(result["path"], equals('/kadu.git'));
      expect(result["query"], equals(''));
      expect(result["hash"], equals(''));
      expect(result["user"], equals('kadu'));
    });
  });

  group('2 way parser away return the same field', () {
    test("thier key's length are same", () {
      String url1 = 'git@gitlab.com:kadu/kadu.git';
      String url2 = 'http://www.google.com?a=b&b=c';
      final Map<String, dynamic> result1 = urlParser(url1);
      final Map<String, dynamic> result2 = urlParser(url2);
      expect(result1.keys.length, result2.keys.length);
    });
  });
}