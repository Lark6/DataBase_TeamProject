import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Twitter Clone'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 기능 추가
            },
          ),
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              // 메시지 기능 추가
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    // 여기에 사용자 프로필 이미지를 가져오는 코드 추가
                  ),
                  SizedBox(height: 8),
                  Text(
                    // 여기에 사용자 이름을 가져오는 코드 추가
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    // 여기에 사용자 아이디 또는 추가 정보를 가져오는 코드 추가
                    '@username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('프로필'),
              onTap: () {
                // 프로필 화면으로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('리스트'),
              onTap: () {
                // 리스트 화면으로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('설정'),
              onTap: () {
                // 설정 화면으로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('로그아웃'),
              onTap: () {
                // 로그아웃 기능 추가
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildTweetCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTweetDialog(context);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildTweetCard(BuildContext context, int index) {
    // 여기에 트윗 카드를 생성하는 코드 추가
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 트윗 내용, 작성자 정보, 이미지 등을 표시하는 코드 추가
            Text(
              '트윗 내용 $index',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '작성자 $index',
                  style: TextStyle(color: Colors.grey),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // 좋아요 기능 추가
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _showTweetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새로운 트윗 작성'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '트윗 내용'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // 여기에 트윗 작성 로직 추가
                  final content = '입력한 내용'; // 실제로는 사용자 입력 내용을 가져와야 함

                  // 여기에 SQLite 데이터베이스에 트윗을 저장하는 로직 추가
                  // 저장 후 화면을 갱신할 수 있도록 추가한 트윗을 리스트에 추가하거나 다시 불러옴

                  Navigator.pop(context); // 다이얼로그 닫기
                },
                child: Text('작성'),
              ),
            ],
          ),
        );
      },
    );
  }
}



