# Icon Replacement Mapping

This document maps Material Icons to their Lucide equivalents for the UI modernization.

## Common Icon Mappings

| Material Icon | Lucide Icon | Usage |
|--------------|-------------|-------|
| `Icons.arrow_back` | `LucideIcons.arrowLeft` | Back navigation |
| `Icons.notifications_none` | `LucideIcons.bell` | Notifications |
| `Icons.notifications_off_outlined` | `LucideIcons.bellOff` | No notifications |
| `Icons.home` | `LucideIcons.home` | Home navigation |
| `Icons.search` | `LucideIcons.search` | Search |
| `Icons.person` | `LucideIcons.user` | User/Profile |
| `Icons.mail` | `LucideIcons.mail` | Email |
| `Icons.lock` | `LucideIcons.lock` | Password |
| `Icons.eye` | `LucideIcons.eye` | Show password |
| `Icons.eyeOff` | `LucideIcons.eyeOff` | Hide password |
| `Icons.phone` | `LucideIcons.phone` | Phone |
| `Icons.location_on` | `LucideIcons.mapPin` | Location |
| `Icons.calendar_today` | `LucideIcons.calendar` | Calendar |
| `Icons.event` | `LucideIcons.calendarDays` | Event |
| `Icons.access_time` | `LucideIcons.clock` | Time |
| `Icons.edit` | `LucideIcons.edit` | Edit |
| `Icons.delete` | `LucideIcons.trash2` | Delete |
| `Icons.add` | `LucideIcons.plus` | Add |
| `Icons.remove` | `LucideIcons.minus` | Remove |
| `Icons.close` | `LucideIcons.x` | Close |
| `Icons.check` | `LucideIcons.check` | Check/Confirm |
| `Icons.check_circle` | `LucideIcons.checkCircle` | Success |
| `Icons.error_outline` | `LucideIcons.alertCircle` | Error |
| `Icons.info_outline` | `LucideIcons.info` | Info |
| `Icons.upload_file` | `LucideIcons.upload` | Upload |
| `Icons.download` | `LucideIcons.download` | Download |
| `Icons.image` | `LucideIcons.image` | Image |
| `Icons.camera` | `LucideIcons.camera` | Camera |
| `Icons.send` | `LucideIcons.send` | Send |
| `Icons.chat` | `LucideIcons.messageCircle` | Chat |
| `Icons.call` | `LucideIcons.phone` | Call |
| `Icons.more_vert` | `LucideIcons.moreVertical` | More options |
| `Icons.arrow_forward` | `LucideIcons.arrowRight` | Forward |
| `Icons.receipt` | `LucideIcons.receipt` | Receipt |
| `Icons.payment` | `LucideIcons.creditCard` | Payment |
| `Icons.wallet` | `LucideIcons.wallet` | Wallet |
| `Icons.history` | `LucideIcons.history` | History |
| `Icons.bed` | `LucideIcons.bed` | Bedroom |
| `Icons.bathtub` | `LucideIcons.bath` | Bathroom |
| `Icons.building` | `LucideIcons.building` | Building |
| `Icons.home_work` | `LucideIcons.building2` | Property |
| `Icons.pie_chart` | `LucideIcons.pieChart` | Statistics |
| `Icons.report` | `LucideIcons.fileText` | Report |

## Files Processed

- [x] lib/common/widget/custom_app_bar.dart
- [x] lib/common/screen/navigation_container.dart
- [x] lib/role/tenant/presentation/widget/home/search_and_sort_widget.dart
- [x] lib/role/lanlord/presentation/pages/dashboard.dart
- [x] lib/features/auth/presentation/screen/choose_role_screen.dart
- [x] lib/features/notification/presentation/pages/notification_page.dart

## Files Remaining (46 total)

### Auth Screens (6 files)
- [ ] lib/features/auth/presentation/pages/profile_pages.dart
- [ ] lib/features/auth/presentation/pages/trust_index_page.dart
- [ ] lib/features/auth/presentation/screen/camera_screen.dart
- [ ] lib/features/auth/presentation/screen/edit_profile_screen.dart
- [ ] lib/features/auth/presentation/screen/otp_verification_screen.dart
- [ ] lib/features/auth/presentation/screen/verify_ikyc_screen.dart

### Feature Pages (7 files)
- [ ] lib/features/bookings/presentation/widget/property_availability_widget.dart
- [ ] lib/features/chat/presentation/pages/chat_list_page.dart
- [ ] lib/features/chat/presentation/pages/chat_room_page_view.dart
- [ ] lib/features/map/presentation/screen/open_map_screen.dart
- [ ] lib/features/review/presentation/widget/property_reviews_widget.dart
- [ ] lib/features/wallet/presentation/pages/my_wallet.dart
- [ ] lib/features/wallet/presentation/pages/request_payout_page.dart

### Landlord Pages (14 files)
- [ ] lib/role/lanlord/presentation/pages/add_property_basic.dart
- [ ] lib/role/lanlord/presentation/pages/booking_detail.dart
- [ ] lib/role/lanlord/presentation/pages/detail_property.dart
- [ ] lib/role/lanlord/presentation/pages/edit_property.dart
- [ ] lib/role/lanlord/presentation/pages/part_add_property.dart
- [ ] lib/role/lanlord/presentation/pages/pricing_and_amenity_property.dart
- [ ] lib/role/lanlord/widget/add_property/map_handling.dart
- [ ] lib/role/lanlord/widget/booking/land_lord_booking_view.dart
- [ ] lib/role/lanlord/widget/dashboard/property_being_proposed.dart
- [ ] lib/role/lanlord/widget/dashboard/rented_property.dart
- [ ] lib/role/lanlord/widget/dashboard/stats_widget.dart
- [ ] lib/role/lanlord/widget/my_property/land_lord_property_view.dart
- [ ] lib/role/lanlord/widget/my_property/property_components.dart
- [ ] lib/role/lanlord/widget/my_property/submission_tab.dart

### Tenant Pages (17 files)
- [ ] lib/role/tenant/presentation/pages/nav/rent.dart
- [ ] lib/role/tenant/presentation/pages/property/booking_property.dart
- [ ] lib/role/tenant/presentation/pages/property/detail_property.dart
- [ ] lib/role/tenant/presentation/pages/rent/detail_active_rent.dart
- [ ] lib/role/tenant/presentation/pages/rent/midtrans_payment_page.dart
- [ ] lib/role/tenant/presentation/pages/rent/midtrans_payment_snap_page.dart
- [ ] lib/role/tenant/presentation/widget/detail_property/accessorise_widget.dart
- [ ] lib/role/tenant/presentation/widget/detail_property/amenities_widget.dart
- [ ] lib/role/tenant/presentation/widget/detail_property/booking_button.dart
- [ ] lib/role/tenant/presentation/widget/detail_property/owner_contact.dart
- [ ] lib/role/tenant/presentation/widget/home/city_carousel.dart
- [ ] lib/role/tenant/presentation/widget/midtrans/card_property.dart
- [ ] lib/role/tenant/presentation/widget/property/list_property.dart
- [ ] lib/role/tenant/presentation/widget/property/search_and_sort_widget_in_property.dart
- [ ] lib/role/tenant/presentation/widget/receipt_booking/nav_bar_receipt.dart
- [ ] lib/role/tenant/presentation/widget/receipt_booking/property_rent_details.dart
- [ ] lib/role/tenant/presentation/widget/review/review_widget.dart

### Main Files (2 files)
- [ ] lib/main.dart
- [ ] lib/main_test.dart
