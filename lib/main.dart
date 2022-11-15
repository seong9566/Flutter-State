import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// provider는 공급자
// provider는 창고(repository)에 데이터를 공급
// final numProvider = Provider((_) => 2);
//final helloWorldProvider = Provider((ref) => 1);
final numProvider = StateProvider((_) => 2);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // provider스코프로 바꾸어준다.
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: AComponent()),
          Expanded(child: BComponent()),
        ],
      ),
    );
  }
}

//소비자 : 소비자는 공급자(provider)에게 데이터를 요청한다(read).
//공급자 : 공급자는 창고에서 데이터를 찾아서 돌려준다.
class AComponent extends ConsumerWidget {
  // 1. 리빌드 하고싶은 곳만 ConsumerWidget를 넣어준다.
  const AComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. WidgetRef를 넣는다. 얘를 넣으면 provider에 접근이 가능해진다.
    // 소비를 한번만 할 때 read옵션을 사용한다.
    // watch는 numprovider의 값이 변경될 때마다 rebuild가된다
    //int num = ref.read(numProvider); // 2. watch, read가 있지만 read를 읽는다.

    int num = ref.watch(numProvider);
    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          Text("ACompoent"),
          Expanded(
            child: Align(
              child: Text(
                "${num}",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 서플라이어 공급자
class BComponent extends ConsumerWidget {
  const BComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          Text("BCompoent"),
          Expanded(
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  final result = ref
                      .read(numProvider.notifier); // stateProvider이면 notifier사용
                  result.state = result.state + 5;
                },
                child: Text(
                  "숫자증가",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
