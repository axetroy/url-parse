library urlParse;

/**
 * parse an input url and return a Map
 */
Map<String, dynamic> urlParse(String url) {
  final output = new Map();

  // git@xxx.com
  if (new RegExp(r'^\s?[\w\+]+\@').hasMatch(url)) {
    List<List<String>> listOfMatches = new RegExp(r'^(([\w\+]+)\@([^\:\/]+))\:(\w+)(\/[^\?]+)')
      .allMatches(url)
      .map((Match match) {
      // 0 => source href
      // 1 => origin
      // 2 => proto
      // 3 => host
      // 4 => username
      // 5 => path
      return match.groups([0, 1, 2, 3, 4, 5]);
    }).toList();

    final List urlInfo = listOfMatches[0];

    final String origin = urlInfo[1] ?? '';
    final String proto = urlInfo[2] ?? '';
    final String host = urlInfo[3] ?? '';
    final String username = urlInfo[4] ?? '';
    final String path = urlInfo[5] ?? '';

    // port
    final List<String> protos = proto.split('+').toList();
    final inlinePortMatch = new RegExp(r'(?=\:)\d+').stringMatch(url);
    final protoPort = protos.contains('https') || protos.contains('wss') || protos.contains('git') ? 443 : 80;

    output["href"] = url;
    output["protocols"] = protos;
    output["protocol"] = protos[0];
    output["port"] = inlinePortMatch ?? protoPort;
    output["host"] = host;
    output["user"] = username;
    output["password"] = '';
    output["origin"] = origin;
    output["path"] = path;
  }
  // https://xxxx.com
  else {
    List<List<String>> listOfMatches = new RegExp(
      r'^(\w+):\/\/(([\w\_]+):([\w\_]+)\@)?([\w\_\-\.]+)(:(\d+))?(\/[^\?\#]+)?'
    ).allMatches(url)
      .map((Match match) {
      // 0 => source href
      // 1 => proto
      // 3 => username
      // 4 => pass
      // 5 => host
      // 7 => port
      // 8 => path
      return match.groups([1, 2, 3, 4, 5, 6, 7, 8]);
    }).toList();

    Uri uri = Uri.parse(url);
    output["href"] = url;
    output["protocols"] = [uri.scheme];
    output["protocol"] = uri.scheme;
    output["hash"] = uri.fragment;
    output["port"] = uri.port;
    output["path"] = uri.path;
    output["query"] = uri.query;
    output["origin"] = uri.origin;
    output["host"] = uri.host;

    List<String> userInfo = uri.userInfo.split(new RegExp(r'\:|\='));

    output["user"] = userInfo.first ?? '';
    output["pass"] = userInfo.last ?? '';
  }

  // query
  final int queryIndex = url.indexOf('?');
  final int hashIndex = url.indexOf('#');
  String query = '';
  String hash = '';

  if (queryIndex > hashIndex) {
    query = queryIndex >= 0 ? url.substring(queryIndex) : '';
    hash = hashIndex >= 0 ? url.substring(hashIndex, queryIndex) : '';
  } else {
    query = queryIndex >= 0 ? url.substring(queryIndex, hashIndex) : '';
    hash = hashIndex >= 0 ? url.substring(hashIndex) : '';
  }

  output["query"] = query.replaceFirst(new RegExp(r'^\??'), '');
  output["hash"] = hash.replaceFirst(new RegExp(r'^\#?'), '');

  return output;
}