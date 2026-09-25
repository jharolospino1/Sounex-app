-- Sounex · configuración de Supabase. Pégalo completo en SQL Editor y ejecútalo (se puede repetir).

create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  artist text not null,
  album text,
  genre text,
  year int,
  description text,
  audio_path text not null,
  cover_path text,
  created_at timestamptz not null default now()
);

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create or replace function public.is_admin() returns boolean
language sql security definer set search_path = public stable
as $$ select exists (select 1 from public.admins where user_id = auth.uid()) $$;

alter table public.songs enable row level security;
alter table public.admins enable row level security;

drop policy if exists "songs: todos leen" on public.songs;
drop policy if exists "songs: admin inserta" on public.songs;
drop policy if exists "songs: admin edita" on public.songs;
drop policy if exists "songs: admin elimina" on public.songs;
create policy "songs: todos leen" on public.songs for select to anon, authenticated using (true);
create policy "songs: admin inserta" on public.songs for insert to authenticated with check (public.is_admin());
create policy "songs: admin edita" on public.songs for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "songs: admin elimina" on public.songs for delete to authenticated using (public.is_admin());

drop policy if exists "admins: ver el propio" on public.admins;
create policy "admins: ver el propio" on public.admins for select to authenticated using (user_id = auth.uid());

-- Almacenamiento: lectura pública (para reproducir), escritura solo admin.
insert into storage.buckets (id, name, public, file_size_limit) values
  ('audio', 'audio', true, 52428800),
  ('covers', 'covers', true, 5242880)
on conflict (id) do nothing;

drop policy if exists "storage: admin sube" on storage.objects;
drop policy if exists "storage: admin edita" on storage.objects;
drop policy if exists "storage: admin borra" on storage.objects;
create policy "storage: admin sube" on storage.objects for insert to authenticated
  with check (bucket_id in ('audio','covers') and public.is_admin());
create policy "storage: admin edita" on storage.objects for update to authenticated
  using (bucket_id in ('audio','covers') and public.is_admin()) with check (bucket_id in ('audio','covers') and public.is_admin());
create policy "storage: admin borra" on storage.objects for delete to authenticated
  using (bucket_id in ('audio','covers') and public.is_admin());

-- DESPUÉS de crear tu usuario en Authentication → Users, ejecuta esto con TU correo:
-- insert into public.admins (user_id) select id from auth.users where email = 'TU_CORREO@ejemplo.com';
