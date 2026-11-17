create table if not exists public.registros_pendientes (
    correo text primary key,
    nombre text not null,
    apellido text not null,
    telefono text not null,
    cedula text not null,
    contrasena text not null,
    codigo_verificacion text,
    codigo_verificacion_expiracion timestamptz,
    created_at timestamptz not null default now()
);

create index if not exists registros_pendientes_cedula_idx
    on public.registros_pendientes (cedula);

insert into public.registros_pendientes (
    correo,
    nombre,
    apellido,
    telefono,
    cedula,
    contrasena,
    codigo_verificacion,
    codigo_verificacion_expiracion
)
select
    lower(trim(correo)),
    nombre,
    apellido,
    telefono,
    cedula,
    contrasena,
    "codigoVerificacion",
    coalesce("codigoVerificacionExpiracion", now())
from public.usuarios
where coalesce("isVerified", false) = false
  and correo is not null
  and trim(correo) <> ''
on conflict (correo) do update set
    nombre = excluded.nombre,
    apellido = excluded.apellido,
    telefono = excluded.telefono,
    cedula = excluded.cedula,
    contrasena = excluded.contrasena,
    codigo_verificacion = excluded.codigo_verificacion,
    codigo_verificacion_expiracion = excluded.codigo_verificacion_expiracion;

delete from public.usuarios as usuario
where coalesce(usuario."isVerified", false) = false
  and usuario.correo is not null
  and lower(trim(usuario.correo)) in (
      select pendiente.correo
      from public.registros_pendientes as pendiente
  );

alter table public.registros_pendientes enable row level security;

revoke all on public.registros_pendientes from anon, authenticated;
grant all on public.registros_pendientes to service_role;
