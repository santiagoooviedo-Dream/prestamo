create or replace function public.eliminar_cuenta_usuario(p_id_usuario bigint)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
    ids_prestamos bigint[];
    ids_conversaciones bigint[];
begin
    perform 1
    from public.usuarios
    where id_usuario = p_id_usuario
    for update;

    if not found then
        return false;
    end if;

    select coalesce(array_agg(id_prestamo::bigint), '{}')
    into ids_prestamos
    from public.prestamos
    where id_usuario = p_id_usuario;

    select coalesce(array_agg(id_conversacion::bigint), '{}')
    into ids_conversaciones
    from public.conversaciones
    where id_usuario = p_id_usuario;

    delete from public.mensajes
    where id_usuario = p_id_usuario
       or id_conversacion = any(ids_conversaciones);

    delete from public.pagos
    where id_prestamos = any(ids_prestamos)
       or id_cuota in (
           select id_cuota
           from public.cuotas
           where id_prestamo = any(ids_prestamos)
       );

    delete from public.cuotas
    where id_prestamo = any(ids_prestamos);

    delete from public.movimientos
    where id_usuario = p_id_usuario;

    delete from public.notificaciones
    where id_usuario = p_id_usuario;

    delete from public.codigos
    where id_usuario = p_id_usuario;

    delete from public.conversaciones
    where id_usuario = p_id_usuario;

    delete from public.prestamos
    where id_usuario = p_id_usuario;

    delete from public.solicitudes
    where id_usuario = p_id_usuario;

    delete from public.usuarios
    where id_usuario = p_id_usuario;

    return true;
end;
$$;

revoke all on function public.eliminar_cuenta_usuario(bigint) from public;
revoke all on function public.eliminar_cuenta_usuario(bigint) from anon, authenticated;
grant execute on function public.eliminar_cuenta_usuario(bigint) to service_role;
