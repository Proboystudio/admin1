-- Run this in Supabase Dashboard > SQL Editor AFTER creating your admin user
-- in Authentication > Users. Replace the example email with the exact admin email.
-- Never put a database password or service_role key in the HTML page.
insert into public.admin_users(email)
values (lower('YOUR_ADMIN_EMAIL_HERE'))
on conflict (email) do nothing;
