-- Proboy Studio: game-file uploads
-- Run once in Supabase Dashboard > SQL Editor as project owner.
-- Creates a public-read bucket; only users listed in public.admin_users can write.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('game-files', 'game-files', true, 104857600, null)
on conflict (id) do update
set public = true, file_size_limit = 104857600, allowed_mime_types = null;

drop policy if exists "Proboy game files are publicly readable" on storage.objects;
create policy "Proboy game files are publicly readable"
on storage.objects for select
using (bucket_id = 'game-files');

drop policy if exists "Approved Proboy admins can upload game files" on storage.objects;
create policy "Approved Proboy admins can upload game files"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'game-files'
  and exists (
    select 1 from public.admin_users au
    where lower(au.email) = lower(auth.jwt() ->> 'email')
  )
);

drop policy if exists "Approved Proboy admins can update game files" on storage.objects;
create policy "Approved Proboy admins can update game files"
on storage.objects for update to authenticated
using (
  bucket_id = 'game-files'
  and exists (select 1 from public.admin_users au where lower(au.email) = lower(auth.jwt() ->> 'email'))
)
with check (
  bucket_id = 'game-files'
  and exists (select 1 from public.admin_users au where lower(au.email) = lower(auth.jwt() ->> 'email'))
);

drop policy if exists "Approved Proboy admins can delete game files" on storage.objects;
create policy "Approved Proboy admins can delete game files"
on storage.objects for delete to authenticated
using (
  bucket_id = 'game-files'
  and exists (select 1 from public.admin_users au where lower(au.email) = lower(auth.jwt() ->> 'email'))
);
