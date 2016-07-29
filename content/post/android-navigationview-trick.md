---

title: Trick replace fragment khi dùng NavigationView
draft: false
date: "2016-07-25T22:45:19+07:00"
categories: android, trick

coverimage: 2016-21-07-private-containers.png

excerpt: "Tip nhỏ với NavigationView"

authorname: Nam Bui Vu
authorlink: https://www.facebook.com/namvu.bui
authorgithub: nambv
authorbio: Scouting Unit
authorimage: inhel.png

---

Bài viết này giới thiệu một trick nhỏ chỉ cách khi dùng NavigationView thay một Fragment bên trong Activity mà giao diện trên app không bị chậm, giật.

Trước tiên, cần dựng view cho ```main_activity.xml``` như sau:

```
<android.support.v4.widget.DrawerLayout
    android:id="@+id/drawer_layout"
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <FrameLayout
        android:id="@+id/main_container"
        android:layout_width="match_parent"
        android:layout_height="match_parent"/>

    <android.support.design.widget.NavigationView
        android:id="@+id/navigation_view"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:layout_gravity="start"
        android:background="@color/colorSlideMenuBackground"
        app:itemTextColor="@drawable/selector_text_menu_item"
        app:menu="@menu/navigation_items"
        app:theme="@style/NavigationViewStyle"/>

</android.support.v4.widget.DrawerLayout>
```

`MainActivty` sẽ kế thừa interface `OnNavigationItemSelectedListener:` 

```
public class MainActivity extends AppCompatActivity implements OnNavigationItemSelectedListener {

	//....

	/**
	* Phương thức này sẽ được gọi chạy khi một item bên trong NavigationView được chọn
	*
	* @param menuItem
	*/
	@Override
    public boolean onNavigationItemSelected(final MenuItem menuItem) {
    	return false;
    }	
}

```

Trong `MainActivty` khai báo view `DrawerLayout` ở dạng global variable:

```
DrawerLayout mDrawerLayout;
```

Trong phương thức `onCreate()` của Activity, tiến hành define view:

```
mNavigationView = findViewById(R.id.navigation_view);
mDrawerLayout = findViewById(R.id.drawer_layout);
```

Tiếp theo, tiến hành xử lý khi một item trong NavigationView được chọn bằng cách thêm các hàm xử lý vào bên trong phương thức `onNavigationItemSelected`:

```
/**
* Phương thức này sẽ được gọi chạy khi một item bên trong NavigationView được chọn
*
* @param menuItem
*/
@Override
public boolean onNavigationItemSelected(final MenuItem menuItem) {

    // Kiểm tra và set trạng thái cho item là checked khi được chọn
    if (menuItem.isChecked()) 
    	menuItem.setChecked(false);
    else 
    	menuItem.setChecked(true);

    // Đóng drawer_layout sau khi được chọn
    mDrawerLayout.closeDrawers();

    new Handler().postDelayed(new Runnable() {
        @Override
        public void run() {

        	// Xử lý action sau khi đã chọn item trong NavigationView
            performActionItemSelected(menuItem.getItemId());
        }
    }, 400);

    return true;
}
```

Trong ví dụ này, có bốn fragment tương ứng với 4 action item ta thêm code xử lý trong phương thức performActionItemSelected

```
/* Perform appropriate action
 *
 * @param itemId
 */
private void performActionItemSelected(int itemId) {

    Fragment fragment = null;

    switch (itemId) {

        case R.id.menu_1:
            fragment = new Fragment1();
            break;

        case R.id.menu_2:
            fragment = new Fragment2();
            break;

        case R.id.menu_3:
            fragment = new Fragment3();
            break;

        default:
        	fragment = new Fragment4();
    }

	// Use fragment transaction to replace fragment
    FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
    transaction.replace(R.id.main_container, fragment).commit();
}
```

Việc ta đặt phương thức performActionItemSelected bên trong một Handler để cho việc xử lý action sau khi chọn menu item chạy trên một Thread phụ khác mà không gọi ngay trên MainThread, vì MainThread lúc đó đang perform action cho sự kiện ```mDrawerLayout.closeDrawers();``` , tránh được hiện tượng giật / chậm ở giao diện màn hình. Handler này sẽ thực hiện sau 400ms, lúc đó drawer layout đã đóng thì fragment mới được thay thế. Nhờ vậy sẽ tạo cho người dùng cảm giác trải nghiệm trên giao diện mượt mà hơn.







