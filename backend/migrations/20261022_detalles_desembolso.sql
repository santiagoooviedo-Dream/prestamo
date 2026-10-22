alter table public.solicitudes
  add column if not exists metodo_desembolso text,
  add column if not exists telefono_nequi text,
  add column if not exists fecha_desembolso timestamptz,
  add column if not exists lugar_recogida text;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'solicitudes_metodo_desembolso_check'
      and conrelid = 'public.solicitudes'::regclass
  ) then
    alter table public.solicitudes
      add constraint solicitudes_metodo_desembolso_check
      check (metodo_desembolso is null or metodo_desembolso in ('efectivo', 'nequi'));
  end if;
end;
$$;
