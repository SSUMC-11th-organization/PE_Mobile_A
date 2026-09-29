import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movielog/main.dart';

void main() {
  ElevatedButton signUpButton(WidgetTester tester) => tester
      .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, '가입하기'));

  testWidgets('모든 입력이 유효하고 약관에 동의해야 가입 버튼이 활성화된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    expect(signUpButton(tester).onPressed, isNull);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '무비러버');
    await tester.enterText(fields.at(1), 'movie@movielog.com');
    await tester.enterText(fields.at(2), 'password1');
    await tester.pump();

    expect(signUpButton(tester).onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(signUpButton(tester).onPressed, isNotNull);
  });

  testWidgets('잘못된 입력은 한국어 오류 메시지를 표시한다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '무');
    await tester.enterText(fields.at(1), 'movie');
    await tester.enterText(fields.at(2), '1234');
    await tester.pump();

    expect(find.text('닉네임은 두 글자 이상 입력해주세요.'), findsOneWidget);
    expect(find.text('올바른 이메일 형식이 아닙니다.'), findsOneWidget);
    expect(find.text('비밀번호는 8자 이상 입력해주세요.'), findsOneWidget);
  });
}
