---

title: Back stack và Notification trong Android
draft: false
date: "2016-07-25T22:45:19+07:00"
categories: android, notification, back stack

coverimage: 2016-07-25-android-cover.jpg

excerpt: "Control back stack"

authorname: Nam Bui Vu
authorlink: https://www.facebook.com/namvu.bui
authorgithub: nambv
authorbio: Scouting Unit
authorimage: inhel.png

---

**1. Tình huống**

Khi xây dựng ứng dụng cho phép hiển thị Notification, sẽ có trường hợp có thể khi click vào notification đó để navigate tới một Activity nằm "sâu" trong app (qua >= 2 thao tác mới có thể mở được màn hình này). Ví dụ: 

```
SplashScreenActivity --> ListActivity --> DetailActivity
```

Khi nhấn button "Back", bạn chắc chắn không muốn thoát khỏi app ngay và luôn mà sẽ muốn app navigate tới màn hình "cha" tương ứng mà mình chỉ định

**2. Vì sao lại xảy ra tình trạng này?**

Xảy ra khi PendingIntent mà bạn cung cấp cho Notification luôn chạy một task mới với một Acitivity tương ứng:

```
Intent detailIntent = new Intent(this, DetailActivity.class);
PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, detailIntent, PendingIntent.FLAG_UPDATE_CURRENT);
```
**3. Giải pháp**

Sử dụng TaskStackBuilder: một class đặc biệt dùng để xử lý flag và back stack cho notification trong Android:

```
// Khai báo intent cho Activity tương ứng
Intent detailIntent = new Intent(this, DetailActivity.class);

// Khai báo TaskStackBuilder
TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
stackBuilder.addNextIntentWithParentStack(detailIntent);

// Khai báo PendingIntent cho Notification
PendingIntent pendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);
```

Trong đoạn code trên, ta thấy TaskStackBuilder có gọi phương thức addNextIntentWithParentStack() - đây là một cách ngắn gọn để điều chỉnh cho Acitivity được mở ra từ Notification hoạt động theo cách bạn muốn: mở Parent Activity khi nhấn back button. Như đã tháy ở trên, việc implement cực kỳ đơn giản, chỉ cần truyền param cho phương thức trên là Intent tương ứng đã được khai báo.

Tuy nhiên để chạy được đoạn code trên chính xác, ta cần phải vào AndroidManifest.xml và khai báo parent Activity cho DetailActivity để xác định Activity sẽ navigate tới sau khi đóng DetailActivity:

```
<activity
    android:name=".DetailActivity"
    android:label="@string/title_activity_order_detail"
    android:launchMode="singleTask"
    android:parentActivityName=".view.activity.MainActivity_"/>
```

Việc khai báo `android:launchMode="singleTask"` để đảm bảo chỉ có một DetailActivity được chạy, ngăn ngừa việc duplicate Activity

**4. Lời kết**

Hy vọng bài viết này có thể giúp mọi người làm việc và xử lý back stack trong notfication hiệu quả hơn
