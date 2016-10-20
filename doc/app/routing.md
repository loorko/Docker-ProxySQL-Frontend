# Routing #

| Modul             | HTTP Req. Meth. | Url                    | Controller       | Action     | Route Name                 | Description                 |
| ----------------- | --------------- | ---------------------- | ---------------- | ---------- | -------------------------- | --------------------------- |
| Dashboard         | GET             | /main                  | main             | main       | main_main                  | Dashboard page              |
| Software Settings | GET             | /software_setting      | software_setting | show       | software_setting_show      |     |
|                   | GET             | /software_setting/edit | software_setting | edit       | software_setting_edit_form |     |
|                   | POST            | /software_setting/edit | software_setting | update     | software_setting_update    |     |
| Users             | GET             | /users                 | user             | list       | user_list                  | List users                  |