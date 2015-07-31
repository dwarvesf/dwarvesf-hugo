
---

title: Giới thiệu Unit Test trong Android
draft: false
description: "Introduce Android Unit Test"
date: "2015-01-28T23:49:15+07:00"
categories: intro, go, hugo

coverimage: 2015-07-31-android-unitest-tutorial-1.jpg

excerpt: "Bài viết giới thiệu về Unit Test trong Android và cách thực hiện"

authorname: Nam Bùi Vũ
authorlink: https://www.facebook.com/namvu.bui 
authortwitter: 
authorgithub: nambv
authorbio: Scouting Unit
authorimage: inhel.png

---

## Tổng quan

Kiểm thử là một bước cần thiết để đảm bảo chất lượng khi xây dựng ứng dụng trên môi trường Android. Có nhiều loại kiểm thử có thể được tiến hành trên môi trường Android như:
+ Unit Testing ( Kiểm thử đơn vị )
+ Functional Testing ( Kiểm thử chức năng )
+ Integration Testing ( Kiểm thử tích hợp )
Trong bài viết này, tui sẽ giới thiệu tới các bạn cách tiến hành triển khai unit test trên Android bằng cách sử dụng Robolectric.

## Các bước chuẩn bị

IDE: Android Studio version 1.2.
Kiến thức nhất định về JUnit.

## Nhắc lại về JUnit

JUnit là một framework đơn giản thường được dùng để viết Unit Test trên môi trường Java.
Các bạn có thể xem lại về JUnit ở:
https://github.com/junit-team/junit/wiki
Ở đây, tui chỉ nhắc những kiến thức có liên sẽ sử dụng trong unit testing trên Android để các bạn tiện theo dõi, gồm:
-	Aggregating test in suites -  https://github.com/junit-team/junit/wiki/Aggregating-tests-in-suites 
-	Test Fixtures - https://github.com/junit-team/junit/wiki/Test-fixtures 
-	Assertions - https://github.com/junit-team/junit/wiki/Assertions 

## Giới thiệu về Robolectric

Robolectric là một framework cho phép bạn viết unit test và chạy chúng trên môi trường JVM mà không cần chạy ứng dụng Android một cách trực tiếp trên thiết bị.
URL trang chủ: http://robolectric.org 
Robolectric được viết dựa trên framework JUnit 4.

## Sử dụng Robolectric trong Android Studio

Bây giờ, tui sẽ tạo và viết một ứng dụng Android đơn giản có sử dụng unit test bằng IDE Android Studio.
Tui tạo một project android có tên là robolectric-example
Cấu trúc project sau khi tạo xong:

{{% img src="/images/2015-07-31-android-unitest-tutorial-2.png" class="third right" %}}

Để sử dụng robolectric, trước tiên cần mở file build.gradle và chỉnh sửa dependencies vào như sau:

```
dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile 'com.android.support:appcompat-v7:22.2.0'
    testCompile 'junit:junit:4.12'
    testCompile 'org.easytesting:fest:1.0.16'
    testCompile 'com.squareup:fest-android:1.0.8'
    testCompile('org.robolectric:robolectric:3.0-rc2') {
        exclude group: 'commons-logging', module: 'commons-logging'
        exclude group: 'org.apache.httpcomponents', module: 'httpclient'
    }
}
```

Sau khi chỉnh sửa file build.gradle, tiến hành sync project để get các package liên quan về:

{{% img src="/images/2015-07-31-android-unitest-tutorial-3.png" class="third right" %}}

Các file java dùng cho viết unit test thường được lưu trong thư mục src/test/java/package_name như hình sau:

{{% img src="/images/2015-07-31-android-unitest-tutorial-4.png" class="third right" %}}

Các file Test nên có đuôi “Test” ở cuối tên ( ví dụ: MainActivityTest.java)

Để chạy được unit test sử dụng Robolectric, với mỗi file java tạo ra để chạy kiểm thử, bạn cần thêm annotation @RunWith(RobolectricGradleTestRunner.class). Một việc nữa cần làm là cấu hình môi trường chạy kiểm thử thong qua annotation @Config()

Ví dụ, tôi cấu hình cho file MainActivityTest.java chạy unit test sử dụng Robolectric:

```
package com.example.nambv.robolectric_example;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricGradleTestRunner;
import org.robolectric.annotation.Config;

import static org.fest.assertions.api.ANDROID.assertThat;

@RunWith(RobolectricGradleTestRunner.class)
@Config(constants = BuildConfig.class, emulateSdk = 21)
public class MainActivityTest {

    private MainActivity mActivity;

    @Before
    public void setUp() throws Exception {
        // setup
        mActivity = Robolectric.buildActivity(MainActivity.class).create().get();
    }

    @Test
    public void myActivityAppearsAsExpectedInitially() throws Exception {
        // test
        assertThat(mActivity.mClickMeButton).hasText("Click Me!");
        assertThat(mActivity.mHelloWorldTextView).hasText("Hello world!");
    }

    @Test
    public void clickingClickMeButtonChangesHelloWorldText() throws Exception {
        assertThat(mActivity.mHelloWorldTextView).hasText("Hello world!");
        mActivity.mClickMeButton.performClick();
        assertThat(mActivity.mHelloWorldTextView).hasText("You clicked on button!");
    }

}
```

* Lưu ý: Tất cả các phương thức được implement để chạy unit test phải được khai báo ở dạng public.

Để chạy được unit test này, tui định nghĩa một TextView và một Button ở MainActivity như sau:
File MainActivity.java:

```
public class MainActivity extends Activity {

    Button mClickMeButton;
    TextView mHelloWorldTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mClickMeButton = (Button) findViewById(R.id.btn_click_me);
        mHelloWorldTextView = (TextView) findViewById(R.id.tv_hello_world);

        mClickMeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mHelloWorldTextView.setText("You clicked on button!");
            }
        });
    }
}
```
File activity_main.xml:
```
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:paddingBottom="@dimen/activity_vertical_margin"
    android:orientation="vertical"
    tools:context=".MainActivity">

    <TextView
        android:id="@+id/tv_hello_world"
        android:text="@string/hello_world"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

    <Button
        android:id="@+id/btn_click_me"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/click_me"/>

</LinearLayout>
```
File values/strings.xml:
```
<resources>
    <string name="app_name">robolectric-example</string>

    <string name="hello_world">Hello world!</string>
    <string name="click_me">Click Me!</string>
    <string name="action_settings">Settings</string>
</resources>
```

Kịch bản test ở đây là, ban đầu TextView hiển thị nội dung là “Hello world!”, khi tui click vào button “Click Me!”, TextView sẽ cập nhật nội dung thành “You clicked on button!”.

Chúng ta tiến hành xem lại các phương thức đã được implement ở file :
Trước tiên, tui khởi tạo một đối tượng MainActivity kiểu private và chưa gán giá trị:

```
private MainActivity mActivity;
```

Tiếp theo, tui viết phương thức setUp() và cho throw Exception nếu  phương thức này không chạy được và có lỗi xảy ra. Lưu ý phương thức này có gắn annotation là @Before, tức là nó sẽ được chạy trước khi chạy các  phương thức có gắn annotations là @Test. Phương thức này thường được dùng để khai báo, định nghĩa các dữ liệu cần thiết trước khi tiến hành kiểm thử.
Lưu ý: Phương thức được gắn annotation @Before sẽ được gọi trước mỗi lần chạy một unit test

```
@Before
public void setUp() throws Exception {
    // setup
    mActivity = Robolectric.buildActivity(MainActivity.class).create().get();
}
```

Ở đây, tui tiến hành tạo và gán giá trị cho đối tượng mActivity để chắc rằng đối tượng mActivity có giá trị khác null trước khi tiến hành kiểm thử 

Các phương thức được viết để chạy unit test sẽ được gắn annotation là @Test.
Tiếp theo là phương thức chạy kiểm thử xem MainActivity mà tui đã khởi tạo ban đầu có chạy đúng như mong đợi của tui không. Nếu không, throw Exception và thông báo lỗi:

```
@Test
public void myActivityAppearsAsExpectedInitially() throws Exception {
    // Check if button mClickMeButton has text = "Click Me!" or not
    assertThat(mActivity.mClickMeButton).hasText("Click Me!");
    // Check if text view mHelloWorldTextView has text = "Hello world!" or not
    assertThat(mActivity.mHelloWorldTextView).hasText("Hello world!");
}
```

Tui viết thêm một unit test nữa để kiểm tra xem kết quả mong đợi khi thực hiện việc click vào button để so sánh kết quả trả về và kết quả mong đợi:

```
@Test
public void clickingClickMeButtonChangesHelloWorldText() throws Exception {
    // Text view before click
    assertThat(mActivity.mHelloWorldTextView).hasText("Hello world!");
    // Perform click action
    mActivity.mClickMeButton.performClick();
    // Text view after click
    assertThat(mActivity.mHelloWorldTextView).hasText("You clicked on button!");
}
```

Việc chuẩn bị đã xong, thứ tự chạy của unit test sẽ được gọi như sau:

```
setUp()
myActivityAppearsAsExpectedInitially()
setUp()
clickingClickMeButtonChangesHelloWorldText()
```

Để tiến hành chạy các Unit Test trên, trước tiên bạn vào Build Variants, và chỉnh Test Artifact thành Unit Tests:

{{% img src="/images/2015-07-31-android-unitest-tutorial-5.png" class="third right" %}}

Sau đó, bạn right-click vào package trong thư mục src/test và chọn Run:

{{% img src="/images/2015-07-31-android-unitest-tutorial-6.png" class="third right" %}}

Android Studio tiến hành chạy kiểm thử:

{{% img src="/images/2015-07-31-android-unitest-tutorial-7.png" class="third right" %}}

Kết quả chạy unit test là SUCESSFUL, tức là expected result đúng với actual result:

{{% img src="/images/2015-07-31-android-unitest-tutorial-8.png" class="third right" %}}

Ngoài ra, bạn có thể xem kết quả chạy unit test trên web  bằng cách mở file index.html trong folder build/reports/tests/debug:

{{% img src="/images/2015-07-31-android-unitest-tutorial-9.png" class="third right" %}}

Nội dung file index.html:

{{% img src="/images/2015-07-31-android-unitest-tutorial-10.png" class="third right" %}}

Bây giờ, tui sẽ tiến hành cho unit test chạy failed trong case thứ hai, bằng cách chỉnh sửa lại nội dung text view tui expect sau khi nhấn vào button “Click Me!”

```
@Test
public void clickingClickMeButtonChangesHelloWorldText() throws Exception {
    // Text view before click
    assertThat(mActivity.mHelloWorldTextView).hasText("Hello world!");
    // Perform click action
    mActivity.mClickMeButton.performClick();
    // Text view after click
    assertThat(mActivity.mHelloWorldTextView).hasText("Wrong content!");
}
```

Tiến hành chạy lại unit test:

{{% img src="/images/2015-07-31-android-unitest-tutorial-11.png" class="third right" %}}

Kết quả cho thấy có 1 unit test bị failed, mở lại file index.html ta sẽ thấy kết quả như sau:
Nhấn vào test case bên dưới Failed tests, sẽ thấy lỗi sai của test case này:

{{% img src="/images/2015-07-31-android-unitest-tutorial-12.png" class="third right" %}}

Kết quả mong đợi trong test case là “Wrong content!” trong khi kết quả khi chạy lại là “You clicked on button!” nên test case này bị failed và throw exception. 

Source code sample các bạn có thể lấy về ở https://github.com/dwarvesf/robolectric-example 

## Conclusion
Trên đây, tui đã giới thiệu với các bạn một ví dụ đơn giản để chạy unit test trên Android. Hy vọng bài viết giúp ích cho các bạn trong việc xây dựng và kiểm thử ứng dụng trên môi trường Android. Cảm ơn các bạn đã theo dõi, hẹn gặp lại trong các bài viết kế tiếp về Testing trên Android.
