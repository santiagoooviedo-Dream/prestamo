alter table public.usuarios
    add column if not exists fcm_installation_ids text[] not null default '{}';
