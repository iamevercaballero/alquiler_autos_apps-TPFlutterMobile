import 'package:intl/intl.dart';

final _df = DateFormat('dd/MM/yyyy');
String fmtDate(DateTime d) => _df.format(d);
