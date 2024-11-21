import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  final String contactNumber = '+7 (929) 594-57-66';
  final String facebookUrl = 'https://facebook.com';
  final String twitterUrl = 'https://twitter.com';
  final String instagramUrl = 'https://instagram.com';

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('О нас')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Над проектом работал Жаныбеков Байэл Жаркынбекович 4исп9-28вб, '
              'стремялся создавать полезное и удобное приложение для пользователей. '
              'Моя цель - сделать технологии доступными и понятными каждому. '
              'Мы верим в силу инноваций и постоянно ищем новые пути для улучшения '
              'вашего опыта использования наших продуктов.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Привычки:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '• Эффективные. Помогают сделать жизнь такой, как хочется, и добиться целей. Примеры: готовить полезный завтрак, планировать приёмы пищи на неделю, делать зарядку, составлять список задач на день, чистить зубы.\n'
              '• Нейтральные. Не влияют на жизнь. Примеры: ездить на работу одним и тем же маршрутом, покупать шампунь одного и того же бренда.\n'
              '• Неэффективные. Отдаляют от того, как хочется жить. Примеры: сидеть в телефоне перед сном, курить, употреблять алкоголь, есть шоколадки во время перекуса. ',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Column(
                children: [
                  Text(
                    'Свяжитесь с нами:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    contactNumber,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        onPressed: () => _launchURL(facebookUrl),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitter),
                        onPressed: () => _launchURL(twitterUrl),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.instagram),
                        onPressed: () => _launchURL(instagramUrl),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}