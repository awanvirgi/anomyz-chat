--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'full',
    'available'
);


ALTER TYPE public.status OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: match_users_create_room_2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_users_create_room_2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$declare
  user1 record;
  user2 record;
  new_room_id uuid;
begin
  if new.max != 2 then
    return new;
  end if;

  select * into user1
  from waiting_list
  where max = 2
  order by created_at asc
  offset 0 limit 1;

  select * into user2
  from waiting_list
  where max = 2
  order by created_at asc
  offset 1 limit 1;

  if user1 is not null and user2 is not null then
    insert into room (max) values (2) returning room_id into new_room_id;

    insert into member_room (room_id, user_id, allias, status)
    values
      (new_room_id, user1.user_id, user1.allias, 'Online'),
      (new_room_id, user2.user_id, user2.allias, 'Online');

    delete from waiting_list
    where id in (user1.id, user2.id);
  end if;

  return new;
end;$$;


ALTER FUNCTION public.match_users_create_room_2() OWNER TO postgres;

--
-- Name: match_users_fill_room_5(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_users_fill_room_5() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  target_room record;
  current_member_count int;
begin
  -- Hanya untuk user yang ingin room 5 orang
  if new.max != 5 then
    return new;
  end if;

  -- Cari room yang max = 5 dan belum penuh (member < 5)
  select r.room_id, count(m.user_id) as member_count
  into target_room
  from room r
  left join member_room m on m.room_id = r.room_id
  where r.max = 5
  group by r.room_id
  having count(m.user_id) < 5
  order by member_count asc
  limit 1;

  if found then
    -- Masukkan ke room yang belum penuh
    insert into member_room (room_id, user_id, allias, status)
    values (target_room.room_id, new.user_id, new.allias, 'Ready');
  else
    -- Buat room baru
    insert into room (max) values (5) returning room_id into target_room.room_id;

    -- Masukkan user ke room baru
    insert into member_room (room_id, user_id, allias, status)
    values (target_room.room_id, new.user_id, new.allias, 'Ready');
  end if;

  -- Hapus dari waiting_list
  delete from waiting_list where id = new.id;

  return null; -- Karena sudah diproses
end;
$$;


ALTER FUNCTION public.match_users_fill_room_5() OWNER TO postgres;

--
-- Name: match_users_fill_room_7(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_users_fill_room_7() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  target_room record;
  current_member_count int;
begin
  -- Hanya untuk user yang ingin room 7 orang
  if new.max != 7 then
    return new;
  end if;

  -- Cari room yang max = 7 dan belum penuh (member < 7)
  select r.room_id, count(m.user_id) as member_count
  into target_room
  from room r
  left join member_room m on m.room_id = r.room_id
  where r.max = 7
  group by r.room_id
  having count(m.user_id) < 7
  order by member_count asc
  limit 1;

  if found then
    -- Masukkan ke room yang belum penuh
    insert into member_room (room_id, user_id, allias, status)
    values (target_room.room_id, new.user_id, new.allias, 'Ready');
  else
    -- Buat room baru
    insert into room (max) values (7) returning room_id into target_room.room_id;

    -- Masukkan user ke room baru
    insert into member_room (room_id, user_id, allias, status)
    values (target_room.room_id, new.user_id, new.allias, 'Ready');
  end if;

  -- Hapus dari waiting_list
  delete from waiting_list where id = new.id;

  return null; -- Karena sudah diproses
end;
$$;


ALTER FUNCTION public.match_users_fill_room_7() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: member_room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member_room (
    join_at timestamp with time zone DEFAULT now() NOT NULL,
    room_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    allias text,
    status text,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.member_room OWNER TO postgres;

--
-- Name: room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room (
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    max smallint DEFAULT '2'::smallint NOT NULL,
    room_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.room OWNER TO postgres;

--
-- Name: waiting_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waiting_list (
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid DEFAULT auth.uid(),
    allias text,
    max bigint,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.waiting_list OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_07_16; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_16 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_17; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_17 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_18; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_18 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_19; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_19 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_19 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_20; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_20 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_20 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_21; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_21 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_21 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_22; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_22 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_22 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: messages_2025_07_16; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_16 FOR VALUES FROM ('2025-07-16 00:00:00') TO ('2025-07-17 00:00:00');


--
-- Name: messages_2025_07_17; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_17 FOR VALUES FROM ('2025-07-17 00:00:00') TO ('2025-07-18 00:00:00');


--
-- Name: messages_2025_07_18; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_18 FOR VALUES FROM ('2025-07-18 00:00:00') TO ('2025-07-19 00:00:00');


--
-- Name: messages_2025_07_19; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_19 FOR VALUES FROM ('2025-07-19 00:00:00') TO ('2025-07-20 00:00:00');


--
-- Name: messages_2025_07_20; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_20 FOR VALUES FROM ('2025-07-20 00:00:00') TO ('2025-07-21 00:00:00');


--
-- Name: messages_2025_07_21; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_21 FOR VALUES FROM ('2025-07-21 00:00:00') TO ('2025-07-22 00:00:00');


--
-- Name: messages_2025_07_22; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_22 FOR VALUES FROM ('2025-07-22 00:00:00') TO ('2025-07-23 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	48fbb286-573e-41cf-9a38-b84366e77fdc	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"f25f8337-f56c-4a88-a020-e3159a3d70b1","user_phone":""}}	2025-07-02 05:53:16.23691+00	
00000000-0000-0000-0000-000000000000	b296bbad-1577-42f7-81e3-d53e66a6dfc0	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e56a6db4-5434-4086-b67c-2c1b7b6141c9","user_phone":""}}	2025-07-02 05:54:08.391417+00	
00000000-0000-0000-0000-000000000000	4a5dce05-2c4c-4d14-96d9-1d3858562c92	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e50cd55d-f86b-4d52-ac1b-95f4dde76ea0","user_phone":""}}	2025-07-02 05:58:11.915897+00	
00000000-0000-0000-0000-000000000000	4de64d75-ac53-4c58-9207-d92803e8ccf0	{"action":"token_refreshed","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-03 23:17:00.405513+00	
00000000-0000-0000-0000-000000000000	dc916ba9-be36-4efb-a98b-e594d3841354	{"action":"token_revoked","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-03 23:17:00.416611+00	
00000000-0000-0000-0000-000000000000	365d08ca-5edc-498b-8e9e-a2a00ccb1b39	{"action":"token_refreshed","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-04 00:25:59.985797+00	
00000000-0000-0000-0000-000000000000	7e27bc75-edae-4ece-bfea-bcd7480d3df3	{"action":"token_revoked","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-04 00:25:59.986542+00	
00000000-0000-0000-0000-000000000000	8fcf25d4-7f78-4935-91f0-cefa0c42c1b4	{"action":"token_refreshed","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-04 01:39:27.098593+00	
00000000-0000-0000-0000-000000000000	e9fe0549-839e-447d-ac6d-1bce6775edad	{"action":"token_revoked","actor_id":"07614634-1cc2-43d2-89f7-597526360689","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-04 01:39:27.099422+00	
00000000-0000-0000-0000-000000000000	1deae213-a3b8-40e9-a0cd-e0be33187b36	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"ffdfd8ee-13b6-4324-a214-d4ff155496a9","user_phone":""}}	2025-07-04 02:38:22.667522+00	
00000000-0000-0000-0000-000000000000	01448529-fbad-4152-b771-7f11e15899fe	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"07614634-1cc2-43d2-89f7-597526360689","user_phone":""}}	2025-07-04 02:38:22.667497+00	
00000000-0000-0000-0000-000000000000	96eaf261-290e-4c46-9959-76b1745ded87	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"f4540366-9a94-4569-a2ca-1780f87694d0","user_phone":""}}	2025-07-04 02:46:50.891955+00	
00000000-0000-0000-0000-000000000000	4ca2057c-0958-476c-96be-07de8a6f86fa	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"eb39154c-defc-49dd-89d8-8428e90bad46","user_phone":""}}	2025-07-04 02:46:51.013863+00	
00000000-0000-0000-0000-000000000000	5fd6b633-b0c9-4deb-8439-7735fa64300c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"23a07df5-cd74-4c8a-8421-1146bc5f5256","user_phone":""}}	2025-07-04 03:45:30.485368+00	
00000000-0000-0000-0000-000000000000	8026ca92-94e5-42c6-8169-902beb601924	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"14a3124b-35be-4db4-8fe9-a4ce8533c542","user_phone":""}}	2025-07-04 03:45:30.493348+00	
00000000-0000-0000-0000-000000000000	3381698b-932c-43c0-b6ef-0294c11d9454	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"0ea3022c-739e-40af-9470-25102c11d25e","user_phone":""}}	2025-07-04 04:07:05.600122+00	
00000000-0000-0000-0000-000000000000	61c258f9-2d8f-40b0-a634-0fd30ad1fe1c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e3a9f4af-f273-41c5-a466-022ec47189a8","user_phone":""}}	2025-07-04 04:07:05.613065+00	
00000000-0000-0000-0000-000000000000	5bf20581-b345-400c-96f9-62f1972f6c1c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"35c9b0eb-c9fc-4754-9c7b-972fb77fd266","user_phone":""}}	2025-07-04 04:14:55.99161+00	
00000000-0000-0000-0000-000000000000	40cc22fa-8e55-43f1-8869-77580e3f4ef2	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"3e2c9bb7-f482-4d3d-a3a5-e549c3174f4e","user_phone":""}}	2025-07-04 04:14:56.109618+00	
00000000-0000-0000-0000-000000000000	4246b329-0b01-4c4a-9c41-1b1bdb9552ee	{"action":"token_refreshed","actor_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 11:58:38.248101+00	
00000000-0000-0000-0000-000000000000	37ba58dc-32df-4e07-9644-16bc2f61bfa6	{"action":"token_revoked","actor_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 11:58:38.26768+00	
00000000-0000-0000-0000-000000000000	59eea24c-351f-47b5-8aee-d68f54db2414	{"action":"token_refreshed","actor_id":"0ad2dc04-80f0-43bb-a3c2-89e6f2562d87","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 13:04:46.766428+00	
00000000-0000-0000-0000-000000000000	6e5f0241-8238-41d1-891a-0feacf5cb453	{"action":"token_revoked","actor_id":"0ad2dc04-80f0-43bb-a3c2-89e6f2562d87","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 13:04:46.768316+00	
00000000-0000-0000-0000-000000000000	5e5b102f-d5c7-487b-a582-acf3f85b26e4	{"action":"token_refreshed","actor_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 13:04:47.119519+00	
00000000-0000-0000-0000-000000000000	426d53ea-f1c2-4726-b63c-7afa0b4bf78d	{"action":"token_revoked","actor_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 13:04:47.120086+00	
00000000-0000-0000-0000-000000000000	46306803-e508-4e54-ac91-6206c2385de2	{"action":"logout","actor_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-06 13:52:12.990058+00	
00000000-0000-0000-0000-000000000000	c42412a3-342d-4a70-b9e5-bd2a8720200a	{"action":"token_refreshed","actor_id":"0ad2dc04-80f0-43bb-a3c2-89e6f2562d87","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 14:03:28.104706+00	
00000000-0000-0000-0000-000000000000	3c1ec0b9-71c1-46cb-840a-8ca716de9f90	{"action":"token_revoked","actor_id":"0ad2dc04-80f0-43bb-a3c2-89e6f2562d87","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-06 14:03:28.106801+00	
00000000-0000-0000-0000-000000000000	3d9859ed-3ef2-41a8-89d6-6d6876e6d955	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"0ad2dc04-80f0-43bb-a3c2-89e6f2562d87","user_phone":""}}	2025-07-07 05:33:59.002157+00	
00000000-0000-0000-0000-000000000000	31d1888e-e202-417d-b3a6-df5f0bf588f5	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"f4dedadf-e204-43d9-95dc-858956dbc9fe","user_phone":""}}	2025-07-07 05:33:59.002155+00	
00000000-0000-0000-0000-000000000000	7effc710-e86b-4017-ae4c-0eb9300d665f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"dc843aa5-873b-41d4-9a4b-daa9fdf5ea4c","user_phone":""}}	2025-07-07 05:33:59.480507+00	
00000000-0000-0000-0000-000000000000	8d842ad3-6425-4252-bec2-4a455297af89	{"action":"logout","actor_id":"72ce47f9-24e5-4ffc-9086-ce56132581e9","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-07 06:01:15.617364+00	
00000000-0000-0000-0000-000000000000	469c9899-1c62-438a-9bb6-170ffc5c41d8	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 02:39:31.73917+00	
00000000-0000-0000-0000-000000000000	692a9869-4d86-407c-a360-516eca957f22	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 02:39:31.745689+00	
00000000-0000-0000-0000-000000000000	8488d66a-aa96-4aaa-bad5-1bfe93c04eda	{"action":"token_refreshed","actor_id":"42e6bcde-7c6e-41b7-8454-0e8093842e11","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 02:47:48.890694+00	
00000000-0000-0000-0000-000000000000	3b365d40-445c-40f3-a962-5411f5444580	{"action":"token_revoked","actor_id":"42e6bcde-7c6e-41b7-8454-0e8093842e11","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 02:47:48.891544+00	
00000000-0000-0000-0000-000000000000	f1df2014-100d-4c87-920a-9492af6f812a	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 03:42:47.831272+00	
00000000-0000-0000-0000-000000000000	143e4492-492e-43d3-8cf6-9292674ec379	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 03:42:47.838739+00	
00000000-0000-0000-0000-000000000000	4b133e47-f8b3-4a97-a06a-6f911570491e	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 05:56:01.598003+00	
00000000-0000-0000-0000-000000000000	ad50124f-ceaf-47ad-a731-f9dd82c26a56	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 05:56:01.600461+00	
00000000-0000-0000-0000-000000000000	bbbe81c6-dd6a-4bfb-aab1-0c43c58c1335	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 07:35:00.391242+00	
00000000-0000-0000-0000-000000000000	b9ecc1a5-d836-45e7-86a1-6925efc9e6f0	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 07:35:00.396333+00	
00000000-0000-0000-0000-000000000000	0d00ca85-4f89-4db2-bbe9-7da0beeedbda	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 08:33:47.057459+00	
00000000-0000-0000-0000-000000000000	d267d1a3-79ab-4774-a022-d0c9966a93b8	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 08:33:47.064188+00	
00000000-0000-0000-0000-000000000000	58b73ce9-2716-4176-9e32-35505bb23388	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 09:32:21.735414+00	
00000000-0000-0000-0000-000000000000	62d8d710-0fef-4395-ad4d-ff513a0d8ad8	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 09:32:21.737347+00	
00000000-0000-0000-0000-000000000000	d4f7175a-35dd-490a-9c01-510b6a775a6b	{"action":"token_refreshed","actor_id":"5f5cd9e1-1283-49c0-9454-3735c5ff8238","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 10:07:47.00503+00	
00000000-0000-0000-0000-000000000000	e2111158-528a-4cc8-9ce2-5d246cf71788	{"action":"token_revoked","actor_id":"5f5cd9e1-1283-49c0-9454-3735c5ff8238","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 10:07:47.007087+00	
00000000-0000-0000-0000-000000000000	2b96a645-3866-4471-970c-37b467696fb0	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 10:31:01.019312+00	
00000000-0000-0000-0000-000000000000	19fa899c-102e-4db1-a6b0-8fea6cae6465	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-08 10:31:01.021313+00	
00000000-0000-0000-0000-000000000000	3eb1f5f8-e1e6-4367-9930-b0183efa7139	{"action":"token_refreshed","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 06:36:14.908614+00	
00000000-0000-0000-0000-000000000000	520609c6-6655-4dd3-8b0b-858ae6ac71dc	{"action":"token_revoked","actor_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 06:36:14.913459+00	
00000000-0000-0000-0000-000000000000	844c1c30-59cb-4445-99a3-63da7ca3be1a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"4ee77db0-3aa4-4b64-b9a8-8b32dee818b3","user_phone":""}}	2025-07-09 06:44:09.954416+00	
00000000-0000-0000-0000-000000000000	a8e7530a-6720-4279-86f1-653a90fd0421	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"ad4677f5-bef9-4fe7-a98e-c234cfb804de","user_phone":""}}	2025-07-09 06:44:09.98535+00	
00000000-0000-0000-0000-000000000000	730b9281-a00e-4d5c-bf6f-22b7975c0095	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"42e6bcde-7c6e-41b7-8454-0e8093842e11","user_phone":""}}	2025-07-09 06:44:09.983968+00	
00000000-0000-0000-0000-000000000000	1ac903a4-9dda-40f2-a637-ce76c735a76f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"5f5cd9e1-1283-49c0-9454-3735c5ff8238","user_phone":""}}	2025-07-09 06:44:09.986473+00	
00000000-0000-0000-0000-000000000000	e81b686b-2ee2-411e-8d84-da084c1a76ec	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"737d7dbc-786a-48dd-b8c2-6ca27396ee32","user_phone":""}}	2025-07-09 06:44:09.994957+00	
00000000-0000-0000-0000-000000000000	e05ab362-43c3-468e-8e92-7e6436b7ef69	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"72ce47f9-24e5-4ffc-9086-ce56132581e9","user_phone":""}}	2025-07-09 06:44:10.005159+00	
00000000-0000-0000-0000-000000000000	22645785-0d42-4c02-8fb8-e3bcec7605e3	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"47867a81-4e12-437d-a222-0b1df0c8fe1d","user_phone":""}}	2025-07-09 06:44:10.007417+00	
00000000-0000-0000-0000-000000000000	00c39c03-cf1c-4adc-a449-0d714ba78205	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8f486917-a282-4ec4-9bda-9ab048d90b03","user_phone":""}}	2025-07-09 06:44:10.016969+00	
00000000-0000-0000-0000-000000000000	497326cd-cfde-4e50-8ae8-5a6a3563a8d7	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 07:44:15.073195+00	
00000000-0000-0000-0000-000000000000	beaaf360-0e56-4a54-be63-825b80977d16	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 07:44:15.074527+00	
00000000-0000-0000-0000-000000000000	4222409e-5e1d-4f24-87ae-b35745b7d5c6	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 07:44:19.029826+00	
00000000-0000-0000-0000-000000000000	7e81d8b6-ac20-4848-be30-0bfed6e69dd7	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 07:44:19.031301+00	
00000000-0000-0000-0000-000000000000	b22e5f0a-b94f-4560-b82b-652e500225e2	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 08:42:58.557354+00	
00000000-0000-0000-0000-000000000000	c06680be-c5f4-40cb-83a7-1bb7b2f0a0ef	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 08:42:58.558672+00	
00000000-0000-0000-0000-000000000000	2da15829-5db5-4a6b-8c8c-145166eae630	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 08:43:04.107112+00	
00000000-0000-0000-0000-000000000000	405663b0-86fb-48fb-bfed-24809342c47c	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 08:43:04.107628+00	
00000000-0000-0000-0000-000000000000	c80a52e6-fdcc-45a2-b9d7-0312d409803f	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 09:41:57.310765+00	
00000000-0000-0000-0000-000000000000	fd11dedd-aa8d-4f63-89ca-20348edfe775	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 09:41:57.312527+00	
00000000-0000-0000-0000-000000000000	55d62f9d-ffc9-411e-bf99-b5b6edd44194	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 09:41:58.006931+00	
00000000-0000-0000-0000-000000000000	92a45c5e-3aeb-42f9-99a3-352dc4155a33	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 09:41:58.007453+00	
00000000-0000-0000-0000-000000000000	c79e7545-4473-43b9-bce9-628cd05abea6	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 10:40:27.067429+00	
00000000-0000-0000-0000-000000000000	2598d612-4ad9-42ab-8a86-96325cb7aa0e	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 10:40:27.069047+00	
00000000-0000-0000-0000-000000000000	6ca26b8d-569c-4b93-aeac-1d7a89445403	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 10:40:43.23932+00	
00000000-0000-0000-0000-000000000000	72bd86ff-52ba-4b07-a9cf-7daabbda3423	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 10:40:43.240334+00	
00000000-0000-0000-0000-000000000000	07cfa692-9050-4dfe-a40c-2e0f38260737	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 11:39:15.876639+00	
00000000-0000-0000-0000-000000000000	9c2eef5e-98db-40ab-b2d9-5ad92ccb79f8	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 11:39:15.877431+00	
00000000-0000-0000-0000-000000000000	47494ed9-ae6b-4c18-a42e-17a5b9e3dde0	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 11:39:22.979765+00	
00000000-0000-0000-0000-000000000000	be5816c7-ac03-4178-977b-620903273b7e	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 11:39:22.980315+00	
00000000-0000-0000-0000-000000000000	05bbeea9-dd14-4288-a81f-499f5af92fad	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 12:37:57.390946+00	
00000000-0000-0000-0000-000000000000	98bf059a-4ab9-4440-8697-df2f68dc0f63	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 12:37:57.39335+00	
00000000-0000-0000-0000-000000000000	3ab2f90a-6919-49b5-9c4c-2315c3d5479d	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 12:37:57.786981+00	
00000000-0000-0000-0000-000000000000	25a3b38f-42e0-40a8-8be7-25fc2204704d	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 12:37:57.7876+00	
00000000-0000-0000-0000-000000000000	b353fff9-948f-418e-8ab8-c8b5dc38761d	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 13:37:08.822182+00	
00000000-0000-0000-0000-000000000000	38e9806b-1af0-47ea-970d-3b2ad37ca4ce	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 13:37:08.824484+00	
00000000-0000-0000-0000-000000000000	3f44e8a2-b83b-4437-baa3-9baa20874632	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 13:37:13.825281+00	
00000000-0000-0000-0000-000000000000	98dbfe8c-db65-4759-a4b8-d843c0f3caef	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 13:37:13.825914+00	
00000000-0000-0000-0000-000000000000	e7ec89a0-32c7-450c-ae6d-c4ed5eb6a0f9	{"action":"token_refreshed","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 14:35:57.988699+00	
00000000-0000-0000-0000-000000000000	e8f9387b-6751-484a-b728-b75285e48060	{"action":"token_revoked","actor_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-09 14:35:57.99004+00	
00000000-0000-0000-0000-000000000000	5c81f730-2dd9-4bc8-952f-0d2cf8abce7e	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 12:41:45.594094+00	
00000000-0000-0000-0000-000000000000	e721c011-20c5-4ee6-8034-be21c3ee845c	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 12:41:45.599501+00	
00000000-0000-0000-0000-000000000000	f0c7549d-b23d-4d51-aa59-0474b321c31f	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 13:40:17.52906+00	
00000000-0000-0000-0000-000000000000	ca65607d-b974-49de-8ec0-387cd7dbecd5	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 13:40:17.533717+00	
00000000-0000-0000-0000-000000000000	fd09a30e-e666-4b8b-b37f-861925a36225	{"action":"token_refreshed","actor_id":"6251df6d-612f-4660-9f62-20566d2bb0f4","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 13:47:42.602178+00	
00000000-0000-0000-0000-000000000000	73933bf9-1ace-400d-a3b6-fa70050606fd	{"action":"token_revoked","actor_id":"6251df6d-612f-4660-9f62-20566d2bb0f4","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 13:47:42.6046+00	
00000000-0000-0000-0000-000000000000	f463c400-68df-4204-b334-d405b7e683e9	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 14:38:18.261493+00	
00000000-0000-0000-0000-000000000000	1ca30e17-ef44-4417-a8ca-d0cdb18e8dce	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 14:38:18.263721+00	
00000000-0000-0000-0000-000000000000	f9219dc3-0492-45af-827c-317981dd69b2	{"action":"token_refreshed","actor_id":"6251df6d-612f-4660-9f62-20566d2bb0f4","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 14:46:15.465237+00	
00000000-0000-0000-0000-000000000000	2b2732de-8abe-46a0-841f-ad10cb4796b8	{"action":"token_revoked","actor_id":"6251df6d-612f-4660-9f62-20566d2bb0f4","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 14:46:15.466884+00	
00000000-0000-0000-0000-000000000000	75b394f9-fc6e-41b5-95de-e609ffd3b5ea	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 16:40:57.229545+00	
00000000-0000-0000-0000-000000000000	7dd799e6-af3a-45ea-8aa5-6b404db3e8b1	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 16:40:57.230308+00	
00000000-0000-0000-0000-000000000000	7d3789cc-a4bf-4629-ba75-4adc546d0e1c	{"action":"token_refreshed","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 17:39:14.154059+00	
00000000-0000-0000-0000-000000000000	0478a72f-0d5d-47a5-9a87-cdb5c3b31219	{"action":"token_revoked","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 17:39:14.158144+00	
00000000-0000-0000-0000-000000000000	72df987b-331c-41ae-ac49-f651cc67bf28	{"action":"token_refreshed","actor_id":"11b62fe6-1204-44a1-87b3-60b767bd5156","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 17:40:26.162444+00	
00000000-0000-0000-0000-000000000000	d34890ed-b014-4039-a2ee-e09611f51905	{"action":"token_revoked","actor_id":"11b62fe6-1204-44a1-87b3-60b767bd5156","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-10 17:40:26.163217+00	
00000000-0000-0000-0000-000000000000	6d442a17-6252-4411-b1cb-8b923238f17c	{"action":"logout","actor_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-10 17:49:14.594952+00	
00000000-0000-0000-0000-000000000000	c9845a5f-05b9-4307-9401-0f47d14edadb	{"action":"token_refreshed","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 03:42:44.976833+00	
00000000-0000-0000-0000-000000000000	8dc62a41-64c2-46e8-aafd-606e0d80a619	{"action":"token_revoked","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 03:42:44.988167+00	
00000000-0000-0000-0000-000000000000	9d739927-7acf-4236-bcf0-556b78e6c9a2	{"action":"token_refreshed","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 03:42:45.00084+00	
00000000-0000-0000-0000-000000000000	73914283-cb0a-4d42-9176-842371695a2a	{"action":"token_revoked","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 03:42:45.002213+00	
00000000-0000-0000-0000-000000000000	bc352676-6bda-4f95-ab9b-5e38042f64fe	{"action":"token_refreshed","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 04:41:30.930401+00	
00000000-0000-0000-0000-000000000000	8522878f-86dd-4f68-8dd9-9092eed71675	{"action":"token_revoked","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 04:41:30.933255+00	
00000000-0000-0000-0000-000000000000	5556bca1-7758-49ca-9a26-e7f3bf020c28	{"action":"token_refreshed","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 04:41:44.6469+00	
00000000-0000-0000-0000-000000000000	031d2f0a-5bca-4cd8-a314-6f7f6ce4d146	{"action":"token_revoked","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 04:41:44.649225+00	
00000000-0000-0000-0000-000000000000	a97cd307-ac5c-4ff7-bd23-fa4b09b6a432	{"action":"token_refreshed","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 05:40:05.639443+00	
00000000-0000-0000-0000-000000000000	b72404f2-b4c3-4272-a70f-247ab93a88a7	{"action":"token_revoked","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 05:40:05.641594+00	
00000000-0000-0000-0000-000000000000	90ec8452-9099-437d-b579-d10f730d74cd	{"action":"token_refreshed","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 05:40:30.880205+00	
00000000-0000-0000-0000-000000000000	bc2c6796-055d-4d6d-b51b-cd0d7eb6545d	{"action":"token_revoked","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 05:40:30.880816+00	
00000000-0000-0000-0000-000000000000	a87192a0-f662-4bc2-a0a1-b5f13818bd69	{"action":"token_refreshed","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 06:38:51.463565+00	
00000000-0000-0000-0000-000000000000	6b98ef1a-e883-4e17-9795-a0f62f715ec3	{"action":"token_revoked","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 06:38:51.466219+00	
00000000-0000-0000-0000-000000000000	faa4e943-4c1b-4ab3-a4a8-fdb937bada2c	{"action":"token_refreshed","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 06:39:18.739297+00	
00000000-0000-0000-0000-000000000000	7718e93b-f8a5-4b96-9d48-f732e64392a3	{"action":"token_revoked","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 06:39:18.739941+00	
00000000-0000-0000-0000-000000000000	69f68fc9-28ab-462a-a744-6a4570b51254	{"action":"logout","actor_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-12 07:02:04.408765+00	
00000000-0000-0000-0000-000000000000	48f705fa-1c85-4c35-8ef8-cd65ff56d383	{"action":"logout","actor_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-12 07:02:10.559794+00	
00000000-0000-0000-0000-000000000000	42ebf66a-b5c1-4f8f-bc7d-bfa4f1e5c6d4	{"action":"token_refreshed","actor_id":"c38b442f-b3d8-44b0-8ad2-e2357c2ec894","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 08:13:20.851281+00	
00000000-0000-0000-0000-000000000000	887daf76-afa3-45c4-a6d0-547fdf090dac	{"action":"token_revoked","actor_id":"c38b442f-b3d8-44b0-8ad2-e2357c2ec894","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 08:13:20.858757+00	
00000000-0000-0000-0000-000000000000	f7247513-8247-43fd-8d9d-0e1dad86c500	{"action":"token_refreshed","actor_id":"c4f50a9d-0823-4812-a916-8364956d4fba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 08:13:29.237033+00	
00000000-0000-0000-0000-000000000000	c65bae31-c25c-4172-9e50-9510cc9939ae	{"action":"token_revoked","actor_id":"c4f50a9d-0823-4812-a916-8364956d4fba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 08:13:29.237552+00	
00000000-0000-0000-0000-000000000000	c8f4d272-0068-4b76-8002-5c7fa7d52549	{"action":"token_refreshed","actor_id":"c4f50a9d-0823-4812-a916-8364956d4fba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 10:09:49.142803+00	
00000000-0000-0000-0000-000000000000	5fdffd1c-7e35-4fa8-b4c7-cc30ded9e96b	{"action":"token_revoked","actor_id":"c4f50a9d-0823-4812-a916-8364956d4fba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 10:09:49.144859+00	
00000000-0000-0000-0000-000000000000	dba4ed8f-ebdc-470a-9559-ad42c2144f82	{"action":"logout","actor_id":"c4f50a9d-0823-4812-a916-8364956d4fba","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-12 10:10:17.754397+00	
00000000-0000-0000-0000-000000000000	f20b6523-c09a-4aa2-a481-0da26882962c	{"action":"token_refreshed","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 12:13:55.274438+00	
00000000-0000-0000-0000-000000000000	e15b5f53-ae06-4a59-bc0d-cb06111f00ff	{"action":"token_revoked","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 12:13:55.275253+00	
00000000-0000-0000-0000-000000000000	c81f7e80-df2f-49b5-8838-4de9370fd284	{"action":"token_refreshed","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 13:12:43.263388+00	
00000000-0000-0000-0000-000000000000	70d3279e-88e5-4b6c-93f9-64bd04fe654a	{"action":"token_revoked","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 13:12:43.271028+00	
00000000-0000-0000-0000-000000000000	f55cda19-7e98-4f92-a9c8-2fa4aef6ab69	{"action":"token_refreshed","actor_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 13:17:07.599714+00	
00000000-0000-0000-0000-000000000000	3617255c-3005-449a-8f52-6ba9f80419de	{"action":"token_revoked","actor_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 13:17:07.602896+00	
00000000-0000-0000-0000-000000000000	9f9eacfa-3e63-4c14-aa7b-806d0dc90689	{"action":"token_refreshed","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 14:11:05.179395+00	
00000000-0000-0000-0000-000000000000	47f9b443-9e8a-4451-9241-acc87d42f79e	{"action":"token_revoked","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 14:11:05.18068+00	
00000000-0000-0000-0000-000000000000	d5f11c6e-c87f-4740-bb6a-9e80366f37d1	{"action":"token_refreshed","actor_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 14:21:49.631542+00	
00000000-0000-0000-0000-000000000000	5413957c-ca96-4713-a611-b285705ffbe8	{"action":"token_revoked","actor_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-12 14:21:49.633022+00	
00000000-0000-0000-0000-000000000000	4839d060-2ac5-4c92-bdb7-dfc99d539911	{"action":"logout","actor_id":"ebb8928e-6627-444c-81ba-cfb57466c818","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-12 14:24:36.663774+00	
00000000-0000-0000-0000-000000000000	d00580ce-2c6d-4bd5-89fb-a5643d4a8b7e	{"action":"logout","actor_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-12 14:24:41.735177+00	
00000000-0000-0000-0000-000000000000	f9fba880-48bf-434d-942e-e6260e412ec7	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"c38b442f-b3d8-44b0-8ad2-e2357c2ec894","user_phone":""}}	2025-07-13 04:09:17.838386+00	
00000000-0000-0000-0000-000000000000	108a84a8-8884-44cc-8507-b7ed3d4c20b5	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"11b62fe6-1204-44a1-87b3-60b767bd5156","user_phone":""}}	2025-07-13 04:09:17.838485+00	
00000000-0000-0000-0000-000000000000	ed287345-d229-43e1-9f68-e133af396094	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"1a4a64ec-184d-49a0-9f9f-f69d2411200c","user_phone":""}}	2025-07-13 04:09:17.913849+00	
00000000-0000-0000-0000-000000000000	41ba069a-0475-4b43-9b05-e10e71e778b8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e348c30f-43f7-4ed0-b6bb-69759312b928","user_phone":""}}	2025-07-13 04:09:17.913913+00	
00000000-0000-0000-0000-000000000000	672e5ad9-d5e4-47d1-9f27-5ed7fd922b72	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"ebb8928e-6627-444c-81ba-cfb57466c818","user_phone":""}}	2025-07-13 04:09:18.024187+00	
00000000-0000-0000-0000-000000000000	c2c8b38e-f242-40f4-9d91-7c7cbb4828bb	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"f2ca5f53-739b-44ce-8602-ebca69c523e8","user_phone":""}}	2025-07-13 04:09:18.033331+00	
00000000-0000-0000-0000-000000000000	07a6ee41-83c2-4003-8eb8-6464be052c33	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"c4f50a9d-0823-4812-a916-8364956d4fba","user_phone":""}}	2025-07-13 04:09:18.051744+00	
00000000-0000-0000-0000-000000000000	cdb69409-d276-4017-9cfc-13f3267f8346	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"deae8d0f-f48b-4a45-b3aa-48deae4b1e44","user_phone":""}}	2025-07-13 04:09:18.141557+00	
00000000-0000-0000-0000-000000000000	8d4f7ff1-7cca-41f7-8f4e-bccadbe4486b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"dad5d8fe-f669-4931-ba30-64a5a1b972ca","user_phone":""}}	2025-07-13 04:09:18.150224+00	
00000000-0000-0000-0000-000000000000	6931bb13-2da3-4710-950f-7c3413e529d6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"6251df6d-612f-4660-9f62-20566d2bb0f4","user_phone":""}}	2025-07-13 04:09:18.159617+00	
00000000-0000-0000-0000-000000000000	2c225634-562f-4ac0-be64-be9257851fca	{"action":"token_refreshed","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-13 08:00:20.891924+00	
00000000-0000-0000-0000-000000000000	dc3e943c-bb9a-490e-9456-5cfeacf110f1	{"action":"token_revoked","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-13 08:00:20.907361+00	
00000000-0000-0000-0000-000000000000	46ec95f0-bddf-45f2-905a-d5227e8bfc9a	{"action":"token_refreshed","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-13 09:46:00.323523+00	
00000000-0000-0000-0000-000000000000	6177fafb-aa37-4448-9138-96d6459858f4	{"action":"token_revoked","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-13 09:46:00.325289+00	
00000000-0000-0000-0000-000000000000	8bd4dc10-9a89-4ff9-9395-a6b311c9da24	{"action":"token_refreshed","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 03:37:00.906813+00	
00000000-0000-0000-0000-000000000000	19ae9ee9-fedf-4dc3-897c-1b5e238f1869	{"action":"token_refreshed","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 07:50:24.984581+00	
00000000-0000-0000-0000-000000000000	528a4487-3606-464e-82c8-70069066b6f3	{"action":"token_revoked","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 07:50:24.989204+00	
00000000-0000-0000-0000-000000000000	b8e8eac2-7434-465e-bd90-8502aab98a65	{"action":"logout","actor_id":"cc020d4f-eeee-47ad-8f3b-993f9f43ddf3","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 08:33:42.651566+00	
00000000-0000-0000-0000-000000000000	e4b0150e-7013-4a3b-a129-db2524f6dc14	{"action":"logout","actor_id":"de992cbd-edd2-4dfc-b15c-2496f1b4fa1b","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 08:35:44.911639+00	
00000000-0000-0000-0000-000000000000	4c419e1a-0d8f-46b9-84e2-843a0b09446d	{"action":"logout","actor_id":"fd1f884d-7050-456a-856c-8ca8e711bdd1","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 08:42:32.416722+00	
00000000-0000-0000-0000-000000000000	f88a85f4-fa3e-4b10-974d-a09a82d837db	{"action":"logout","actor_id":"04c9a59f-416b-4d89-be6e-495e3e2c00c1","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 08:42:35.545965+00	
00000000-0000-0000-0000-000000000000	4d511d9c-3406-48e6-b522-51149ababe19	{"action":"logout","actor_id":"c087e71f-db7d-46af-821a-e923b89e228f","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 08:59:47.579383+00	
00000000-0000-0000-0000-000000000000	8141a6e3-0b10-49af-99a0-ea3afb15ca31	{"action":"logout","actor_id":"15c1300c-9a01-47ab-bb7c-7b4c81abbc26","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 09:00:23.624147+00	
00000000-0000-0000-0000-000000000000	cbad4ba9-46bc-4542-8f7f-45c5b38cfff0	{"action":"logout","actor_id":"de5a1f38-4b4a-438a-8de0-65a977fb3762","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 09:03:13.694264+00	
00000000-0000-0000-0000-000000000000	ffe1cde1-d4fe-4775-bacd-859c1964c672	{"action":"logout","actor_id":"df39ad65-135e-40d0-a1ee-d42e8ef42c1d","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 09:06:39.501336+00	
00000000-0000-0000-0000-000000000000	654962cf-4a23-415f-bfe8-5219ad05e3c4	{"action":"logout","actor_id":"4c5a0c26-36d6-424c-a7bc-22ce9af689d6","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 09:06:42.648802+00	
00000000-0000-0000-0000-000000000000	0eff780b-edbe-49b2-9331-df6cccdb27bc	{"action":"logout","actor_id":"58d52b04-4278-40c0-8caf-ce878d6bc76f","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-14 11:58:28.447123+00	
00000000-0000-0000-0000-000000000000	ca18049d-2118-4c2c-a3e3-769781336487	{"action":"token_refreshed","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 13:21:50.134329+00	
00000000-0000-0000-0000-000000000000	43c4236d-9fe7-403a-93ed-7f075ef2e582	{"action":"token_revoked","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 13:21:50.135886+00	
00000000-0000-0000-0000-000000000000	bbe03f2f-9351-4f34-89ca-16bccb70cd2e	{"action":"token_refreshed","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 14:20:23.486359+00	
00000000-0000-0000-0000-000000000000	78564b3c-81f5-4733-a0d1-cbe7b6cd3fd5	{"action":"token_revoked","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 14:20:23.487896+00	
00000000-0000-0000-0000-000000000000	d5438714-415a-41c4-a073-3847fbbc16fc	{"action":"token_refreshed","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 14:43:30.82783+00	
00000000-0000-0000-0000-000000000000	ad83a129-cd17-43df-adc9-1dc0aca1075e	{"action":"token_revoked","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 14:43:30.828674+00	
00000000-0000-0000-0000-000000000000	32282d86-8ebf-47a0-a6c0-181c79c4f677	{"action":"token_refreshed","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 15:19:08.43261+00	
00000000-0000-0000-0000-000000000000	16703e4e-f932-4a5d-9bc9-f1e792e59e73	{"action":"token_revoked","actor_id":"9dbd964b-5533-4a33-b8da-7811445ed557","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 15:19:08.434922+00	
00000000-0000-0000-0000-000000000000	56667ec1-7346-4910-82d1-9fc6fcd7adab	{"action":"token_refreshed","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 15:42:03.688282+00	
00000000-0000-0000-0000-000000000000	238a43a5-ff1e-4fb0-8f57-3991cbcd46df	{"action":"token_revoked","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-14 15:42:03.691769+00	
00000000-0000-0000-0000-000000000000	1b43e49c-159f-410f-beb8-7637084ba54e	{"action":"token_refreshed","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 05:10:14.101428+00	
00000000-0000-0000-0000-000000000000	6e4d5b10-fa4a-4621-a9f8-088d87261fdc	{"action":"token_revoked","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 05:10:14.105077+00	
00000000-0000-0000-0000-000000000000	e9214a1f-4705-46d9-94d3-7446dd61d39d	{"action":"logout","actor_id":"6dfb9d5f-dc04-4e17-8872-03008fee337c","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 05:18:28.650264+00	
00000000-0000-0000-0000-000000000000	d9c88677-07e0-4510-9861-049df0f8660f	{"action":"logout","actor_id":"782304ba-60ca-4c58-8057-6807a8d68b79","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 05:19:10.310304+00	
00000000-0000-0000-0000-000000000000	ae14baa9-cd18-48ec-9783-dd66e9fb5828	{"action":"logout","actor_id":"a5ba1c2a-6f36-4539-923f-91d896337f7e","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 05:59:18.253649+00	
00000000-0000-0000-0000-000000000000	31edf67e-29ef-446f-8505-4b522f1dc6c9	{"action":"logout","actor_id":"7252ca8e-a2b6-4a0f-8b23-29611e697362","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 05:59:49.034887+00	
00000000-0000-0000-0000-000000000000	4f96d131-27ae-4e38-a040-a87f66652c5d	{"action":"logout","actor_id":"9d43267f-92fc-4801-8cb6-34a8d3f777a1","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:02:20.73715+00	
00000000-0000-0000-0000-000000000000	d1ef9024-f4c1-4994-97cd-d61485764efa	{"action":"logout","actor_id":"e5206d23-a7e3-4564-a376-833dab0a6723","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:03:29.266577+00	
00000000-0000-0000-0000-000000000000	32748528-d982-4ef5-9406-df256ef15c31	{"action":"logout","actor_id":"b5f206db-df21-4b05-b882-2558c608a39c","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:10:53.247264+00	
00000000-0000-0000-0000-000000000000	e45bbd80-f4d5-452a-8179-1267e82cfdae	{"action":"logout","actor_id":"63b6d62e-574d-4ab1-bc53-065be917b06b","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:11:14.740482+00	
00000000-0000-0000-0000-000000000000	f24fc8a2-599b-47ba-8f30-342315464744	{"action":"logout","actor_id":"9c273a01-7fce-4193-906d-7465f5247d23","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:11:20.384794+00	
00000000-0000-0000-0000-000000000000	1e79e6a7-75c2-45a4-be60-731dc64bc687	{"action":"logout","actor_id":"c9a85f61-ea2d-4852-a4a3-318b623d4236","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:13:24.29043+00	
00000000-0000-0000-0000-000000000000	aef93edb-72da-4780-97f1-b6c0791679e1	{"action":"logout","actor_id":"8ca79ce0-5ee5-4b25-9eae-0367c9ff2cd6","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:13:25.897368+00	
00000000-0000-0000-0000-000000000000	4f534da9-11d7-4868-8b76-7ee1045a7745	{"action":"logout","actor_id":"97c772bd-1f46-4548-a6a4-af8398ceddac","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:13:31.438386+00	
00000000-0000-0000-0000-000000000000	e3a760a0-05ec-4369-b8e3-90632642a036	{"action":"logout","actor_id":"3cdc5b15-9041-441e-a224-554ecf002a6e","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:26:47.969119+00	
00000000-0000-0000-0000-000000000000	e2de9f38-656b-47f4-8549-296324847a9b	{"action":"logout","actor_id":"37783ada-b13d-40dd-b4ff-081e35510d81","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:27:07.731989+00	
00000000-0000-0000-0000-000000000000	7873833a-a1e2-4c05-aa00-3e0c7930ca24	{"action":"logout","actor_id":"8c40af95-508c-4590-ac28-34bd8ea83ac7","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:27:12.482938+00	
00000000-0000-0000-0000-000000000000	a4e64fdd-7c7b-4820-85bb-4a5f5c84fce2	{"action":"logout","actor_id":"087de327-605c-4663-80fb-510a2cf1b66c","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:27:35.133091+00	
00000000-0000-0000-0000-000000000000	4e701585-65cc-45bd-8c40-31ddb2d146df	{"action":"logout","actor_id":"a77e4c15-2542-481d-8b0f-d2528747702b","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:27:36.849841+00	
00000000-0000-0000-0000-000000000000	de3869d0-b561-420e-9f77-030ec1076ee2	{"action":"logout","actor_id":"88c029ca-e0f2-4a34-93f1-bbe801990c9d","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:27:38.630348+00	
00000000-0000-0000-0000-000000000000	ed2f62e6-2a2b-4ec5-91b6-6bfc0478c630	{"action":"logout","actor_id":"e0a1bd1f-20a4-4b3b-9ecc-9328e78e54f1","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:28:10.218101+00	
00000000-0000-0000-0000-000000000000	fc4b1ced-b9c0-4e0d-82a2-261a78fd0b0a	{"action":"logout","actor_id":"2a5ee764-67bf-4246-b1c3-b9bb8a78d113","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:28:12.843225+00	
00000000-0000-0000-0000-000000000000	28885571-5cd5-4015-85c6-83a85b24445f	{"action":"logout","actor_id":"aa73103a-92b1-4200-8a42-c4e44edb8b28","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:34:52.382503+00	
00000000-0000-0000-0000-000000000000	c64d02db-ff41-4eb7-b13d-220290240644	{"action":"logout","actor_id":"3cea0c2f-f71b-4829-ad5d-2d4129f84557","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:35:16.958053+00	
00000000-0000-0000-0000-000000000000	5c1a28e2-083d-42ad-a4ff-d3406735c930	{"action":"logout","actor_id":"a48c9bf5-6716-43f6-a206-1d06b92f86bb","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:35:34.811448+00	
00000000-0000-0000-0000-000000000000	b71649f2-23e4-405d-ba5d-c300ad5eed72	{"action":"logout","actor_id":"ceb4b972-b8cc-403e-818d-4aba2d8ebdf5","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:35:39.430335+00	
00000000-0000-0000-0000-000000000000	f557b916-53c1-4405-9857-ef5856ee5ea9	{"action":"logout","actor_id":"438f5cb8-61e1-4da4-a592-0950f7084630","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:35:42.651516+00	
00000000-0000-0000-0000-000000000000	fd7ec32e-ccc3-450b-8efe-129fe2d78479	{"action":"logout","actor_id":"a16278df-78f0-4e24-93d9-2ad0af131e99","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 06:35:48.198725+00	
00000000-0000-0000-0000-000000000000	43a61883-f056-40da-bb3a-8258ff12cf9b	{"action":"logout","actor_id":"a3596eac-61e6-4ab2-a19d-8863caf85cd3","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 07:50:29.710285+00	
00000000-0000-0000-0000-000000000000	2c1a7566-867d-496e-a42b-873e236bc486	{"action":"logout","actor_id":"3ffcefa4-b88b-4acb-a60c-d4ad8d27d704","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-15 07:50:32.005893+00	
00000000-0000-0000-0000-000000000000	131244c1-66f8-4969-aca0-55c03e9b2622	{"action":"token_refreshed","actor_id":"b309c595-70fd-400f-85d7-acda6c6a5efa","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 08:51:15.02638+00	
00000000-0000-0000-0000-000000000000	56c2bbe8-b3d0-4005-86fe-c2a16e1ce9f2	{"action":"token_revoked","actor_id":"b309c595-70fd-400f-85d7-acda6c6a5efa","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 08:51:15.02892+00	
00000000-0000-0000-0000-000000000000	192fc6fd-6fd1-4af6-8559-8de1429b0c41	{"action":"token_refreshed","actor_id":"97eb3c46-d3a9-4f37-9d6c-0c502b9a8a41","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 08:51:37.27763+00	
00000000-0000-0000-0000-000000000000	a2d51161-f5b5-4018-879e-0b7447680e82	{"action":"token_revoked","actor_id":"97eb3c46-d3a9-4f37-9d6c-0c502b9a8a41","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 08:51:37.27816+00	
00000000-0000-0000-0000-000000000000	c31c4d45-fd0a-47e6-b5cd-c1a0934a5759	{"action":"token_refreshed","actor_id":"b309c595-70fd-400f-85d7-acda6c6a5efa","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 09:49:44.949948+00	
00000000-0000-0000-0000-000000000000	60d462c0-4f65-492f-b7e9-1b2bd5d61654	{"action":"token_revoked","actor_id":"b309c595-70fd-400f-85d7-acda6c6a5efa","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 09:49:44.952581+00	
00000000-0000-0000-0000-000000000000	90bd69fe-46a0-4724-8a5b-dc66cf6b56b6	{"action":"token_refreshed","actor_id":"97eb3c46-d3a9-4f37-9d6c-0c502b9a8a41","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 10:16:04.487763+00	
00000000-0000-0000-0000-000000000000	b156619d-9676-40ce-ad18-4adc6fcda280	{"action":"token_revoked","actor_id":"97eb3c46-d3a9-4f37-9d6c-0c502b9a8a41","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-15 10:16:04.490187+00	
00000000-0000-0000-0000-000000000000	678f1d8b-810b-4be0-b065-da965c57f7eb	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"3ffcefa4-b88b-4acb-a60c-d4ad8d27d704","user_phone":""}}	2025-07-15 10:42:19.448396+00	
00000000-0000-0000-0000-000000000000	2d7ee19c-19fd-4aaf-99ab-e261b690db5f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a563a18f-e5db-469f-9349-a22e5e29f566","user_phone":""}}	2025-07-15 10:42:19.465493+00	
00000000-0000-0000-0000-000000000000	c5ee020e-b1fb-47ef-97cf-223537158ef6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"ceb4b972-b8cc-403e-818d-4aba2d8ebdf5","user_phone":""}}	2025-07-15 10:42:19.466298+00	
00000000-0000-0000-0000-000000000000	9cd66443-9d4b-4a66-8e96-d23f34affe38	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"aa73103a-92b1-4200-8a42-c4e44edb8b28","user_phone":""}}	2025-07-15 10:42:19.47565+00	
00000000-0000-0000-0000-000000000000	b4f44e5e-270f-4258-9b0b-ce61d813b13c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a3596eac-61e6-4ab2-a19d-8863caf85cd3","user_phone":""}}	2025-07-15 10:42:19.481288+00	
00000000-0000-0000-0000-000000000000	3713078a-6dac-4adb-bf23-dc0d9000915a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"97c772bd-1f46-4548-a6a4-af8398ceddac","user_phone":""}}	2025-07-15 10:42:19.483373+00	
00000000-0000-0000-0000-000000000000	11a695a2-647f-4dbe-b546-c57b556089e7	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"97eb3c46-d3a9-4f37-9d6c-0c502b9a8a41","user_phone":""}}	2025-07-15 10:42:19.555725+00	
00000000-0000-0000-0000-000000000000	90a4c91c-ff9c-49c0-9716-d1fe75cc5b48	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"3cdc5b15-9041-441e-a224-554ecf002a6e","user_phone":""}}	2025-07-15 10:42:19.576961+00	
00000000-0000-0000-0000-000000000000	40a1f656-2023-4864-9bda-4e9be66c4337	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e0a1bd1f-20a4-4b3b-9ecc-9328e78e54f1","user_phone":""}}	2025-07-15 10:42:19.675663+00	
00000000-0000-0000-0000-000000000000	46fd8bbb-301c-4e3c-bb14-aa7dfdf579ad	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"438f5cb8-61e1-4da4-a592-0950f7084630","user_phone":""}}	2025-07-15 10:42:19.69386+00	
00000000-0000-0000-0000-000000000000	dd6b32af-a1f1-4c3a-8281-4a7f56ba834f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"3cea0c2f-f71b-4829-ad5d-2d4129f84557","user_phone":""}}	2025-07-15 10:42:19.795748+00	
00000000-0000-0000-0000-000000000000	f5c83cd5-7fbc-4d7a-8e9e-90ec09232c85	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a48c9bf5-6716-43f6-a206-1d06b92f86bb","user_phone":""}}	2025-07-15 10:42:19.810919+00	
00000000-0000-0000-0000-000000000000	351d2aa6-1d14-48a8-8293-3d7cfc9c667e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"88c029ca-e0f2-4a34-93f1-bbe801990c9d","user_phone":""}}	2025-07-15 10:42:19.812144+00	
00000000-0000-0000-0000-000000000000	544fffe7-8250-44a6-b4a7-dc02156890ac	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8c40af95-508c-4590-ac28-34bd8ea83ac7","user_phone":""}}	2025-07-15 10:42:19.812609+00	
00000000-0000-0000-0000-000000000000	de3c3be2-982f-4c01-8cf5-777bafc6aa5a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a16278df-78f0-4e24-93d9-2ad0af131e99","user_phone":""}}	2025-07-15 10:42:19.821841+00	
00000000-0000-0000-0000-000000000000	3edd0c1c-f667-4825-9900-2311269337df	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"37783ada-b13d-40dd-b4ff-081e35510d81","user_phone":""}}	2025-07-15 10:42:19.821892+00	
00000000-0000-0000-0000-000000000000	3ab19135-3e82-4d1f-9116-9d39b676af7c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a77e4c15-2542-481d-8b0f-d2528747702b","user_phone":""}}	2025-07-15 10:42:19.831114+00	
00000000-0000-0000-0000-000000000000	6d90ed72-3254-40b3-b462-8eee4cc147f8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9dbd964b-5533-4a33-b8da-7811445ed557","user_phone":""}}	2025-07-15 10:42:37.387419+00	
00000000-0000-0000-0000-000000000000	f82b7d74-70a0-42d0-9fb3-49fb6fd6e228	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"6dfb9d5f-dc04-4e17-8872-03008fee337c","user_phone":""}}	2025-07-15 10:42:37.401019+00	
00000000-0000-0000-0000-000000000000	0f3d48eb-fbbe-43c1-afb7-4904a8f4a434	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"2f367354-b5f2-4dd4-8d87-0368ac3ce58a","user_phone":""}}	2025-07-15 10:42:37.404136+00	
00000000-0000-0000-0000-000000000000	ddbfc9fe-9fba-4b1c-b68f-21233349d15c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"81aef81a-5cc6-47ec-8453-d9a7d63be27e","user_phone":""}}	2025-07-15 10:42:37.472448+00	
00000000-0000-0000-0000-000000000000	0c0e0a3e-d52f-4927-9954-de471d08f0f5	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"782304ba-60ca-4c58-8057-6807a8d68b79","user_phone":""}}	2025-07-15 10:42:37.553118+00	
00000000-0000-0000-0000-000000000000	c2498497-13ce-4cbc-9787-3077bc9d5abf	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9c273a01-7fce-4193-906d-7465f5247d23","user_phone":""}}	2025-07-15 10:42:50.841524+00	
00000000-0000-0000-0000-000000000000	9b99d5d6-ebb4-4dec-b76e-408933c308a4	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"c9a85f61-ea2d-4852-a4a3-318b623d4236","user_phone":""}}	2025-07-15 10:42:50.86248+00	
00000000-0000-0000-0000-000000000000	a81a1e48-9d43-43e2-b4d7-ef4502f7a535	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"2a5ee764-67bf-4246-b1c3-b9bb8a78d113","user_phone":""}}	2025-07-15 10:42:19.8338+00	
00000000-0000-0000-0000-000000000000	e3af7e0c-28ff-4ccf-a4a7-3cb02ae4bbe6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"22402fcd-0bae-4c95-884c-c06a20ef1b3a","user_phone":""}}	2025-07-15 10:42:50.864238+00	
00000000-0000-0000-0000-000000000000	448b28da-d8a2-4f56-b607-abb69378908b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"087de327-605c-4663-80fb-510a2cf1b66c","user_phone":""}}	2025-07-15 10:42:19.834702+00	
00000000-0000-0000-0000-000000000000	5c77186a-dcf7-4f45-8555-4c8e2ed6558d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"7252ca8e-a2b6-4a0f-8b23-29611e697362","user_phone":""}}	2025-07-15 10:42:37.384807+00	
00000000-0000-0000-0000-000000000000	52491ece-ad59-4742-aa87-0ca9ff9f9599	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"63b6d62e-574d-4ab1-bc53-065be917b06b","user_phone":""}}	2025-07-15 10:42:50.839394+00	
00000000-0000-0000-0000-000000000000	3b85dd9a-def2-4ffd-ab07-0f6c9ae5797f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"b5f206db-df21-4b05-b882-2558c608a39c","user_phone":""}}	2025-07-15 10:42:50.860369+00	
00000000-0000-0000-0000-000000000000	d99399ad-8ac6-49df-9b39-898b7fbd54a1	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"b309c595-70fd-400f-85d7-acda6c6a5efa","user_phone":""}}	2025-07-15 10:42:19.834355+00	
00000000-0000-0000-0000-000000000000	6e1eebca-27c9-4260-8d30-1016645c69b8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a5ba1c2a-6f36-4539-923f-91d896337f7e","user_phone":""}}	2025-07-15 10:42:37.353047+00	
00000000-0000-0000-0000-000000000000	8efd84d4-bc94-43e5-8585-33ba5543c421	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9d43267f-92fc-4801-8cb6-34a8d3f777a1","user_phone":""}}	2025-07-15 10:42:37.362581+00	
00000000-0000-0000-0000-000000000000	9994be98-fb64-4003-927f-1af7e4b93e65	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"58d52b04-4278-40c0-8caf-ce878d6bc76f","user_phone":""}}	2025-07-15 10:42:37.368394+00	
00000000-0000-0000-0000-000000000000	787296bc-13c8-4f79-9cbc-87b023dbdd89	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"4aed88b3-27e6-4c83-a5dc-44e9e4072ccb","user_phone":""}}	2025-07-15 10:42:37.383014+00	
00000000-0000-0000-0000-000000000000	1b47dedf-cccb-496d-93f4-890939ddb823	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8ca79ce0-5ee5-4b25-9eae-0367c9ff2cd6","user_phone":""}}	2025-07-15 10:42:50.842142+00	
00000000-0000-0000-0000-000000000000	27850476-3fc7-4057-a395-06b940ddd13d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e5206d23-a7e3-4564-a376-833dab0a6723","user_phone":""}}	2025-07-15 10:42:50.862064+00	
00000000-0000-0000-0000-000000000000	5e52aead-0356-409a-83d6-40f26fa45835	{"action":"logout","actor_id":"8972dfb5-b9e8-42c9-b9f8-12f9564467b8","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:31:22.916467+00	
00000000-0000-0000-0000-000000000000	cb55aa7c-2f96-4cb5-83f2-18a639402fed	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8972dfb5-b9e8-42c9-b9f8-12f9564467b8","user_phone":""}}	2025-07-18 03:33:35.726673+00	
00000000-0000-0000-0000-000000000000	b9ad1ed0-9591-4c2d-aba7-e911bbfa5c80	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"486f357e-d27e-4e0d-ab4f-101cc84b8b52","user_phone":""}}	2025-07-18 03:33:35.836667+00	
00000000-0000-0000-0000-000000000000	88e83aef-631f-41ea-8e6e-31136cefc7f2	{"action":"logout","actor_id":"74e78fc8-13b7-4e23-8438-5f47b10de343","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:34:40.908843+00	
00000000-0000-0000-0000-000000000000	9b0fcb84-7b8b-4287-87d9-e1877b710780	{"action":"logout","actor_id":"d53eb32e-b033-433c-91dc-fd51d5e554ed","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:34:44.999629+00	
00000000-0000-0000-0000-000000000000	4311fe59-576c-46b0-a078-9e6d086f787e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"d53eb32e-b033-433c-91dc-fd51d5e554ed","user_phone":""}}	2025-07-18 03:35:28.652043+00	
00000000-0000-0000-0000-000000000000	0deedbb8-70bc-42b1-a9de-66ee9bb8b66f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"74e78fc8-13b7-4e23-8438-5f47b10de343","user_phone":""}}	2025-07-18 03:35:28.659217+00	
00000000-0000-0000-0000-000000000000	8ea8902e-5b27-414b-8ba2-d0b4d8bd93a4	{"action":"logout","actor_id":"c6099732-7105-4894-b838-35fb424a81e3","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:36:04.556879+00	
00000000-0000-0000-0000-000000000000	1624a60d-e01a-48ce-8b8b-5d6e00c77d5d	{"action":"logout","actor_id":"8aab3d44-1326-4b8b-ac9e-a65141b5abdb","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:36:22.029113+00	
00000000-0000-0000-0000-000000000000	282fb03a-d214-4599-b80a-d87e6aa94f0c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"c6099732-7105-4894-b838-35fb424a81e3","user_phone":""}}	2025-07-18 03:39:50.745614+00	
00000000-0000-0000-0000-000000000000	fe3ae0bc-4ba4-4ff3-ac55-84ed798d24bd	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8aab3d44-1326-4b8b-ac9e-a65141b5abdb","user_phone":""}}	2025-07-18 03:39:50.755587+00	
00000000-0000-0000-0000-000000000000	53e289a4-e4b7-42e3-9740-f1847c0fa305	{"action":"logout","actor_id":"a05c3c50-4500-4ed0-ba81-840bc2979bfe","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:40:34.538373+00	
00000000-0000-0000-0000-000000000000	72baf0f9-ee6b-46e7-9787-2d8c5a5fb50f	{"action":"logout","actor_id":"32e7b975-8a28-4bd3-a542-dd1a742047af","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 03:40:53.317811+00	
00000000-0000-0000-0000-000000000000	e0fc3755-b9ef-4178-b71c-f3706d9c5059	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"32e7b975-8a28-4bd3-a542-dd1a742047af","user_phone":""}}	2025-07-18 03:45:32.900593+00	
00000000-0000-0000-0000-000000000000	9ba0f481-4091-4264-8d9b-da5697a9c94a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a05c3c50-4500-4ed0-ba81-840bc2979bfe","user_phone":""}}	2025-07-18 03:45:32.902148+00	
00000000-0000-0000-0000-000000000000	3bdebcae-c917-409d-84c6-0bb5b55c6631	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8daa111b-056d-4217-8b8b-0ad08357d38f","user_phone":""}}	2025-07-18 03:49:06.186653+00	
00000000-0000-0000-0000-000000000000	4eeb7f65-572a-4fe9-926b-bb79d0638494	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"480aba07-dbe5-47a6-9313-08d71220ce1d","user_phone":""}}	2025-07-18 03:49:06.698303+00	
00000000-0000-0000-0000-000000000000	2fae5d3b-d366-4c9d-a028-ccf4f3d79e62	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"d347a81c-aa3b-479b-ac5f-7a5c12fbfc91","user_phone":""}}	2025-07-18 03:54:50.611627+00	
00000000-0000-0000-0000-000000000000	bf8f3441-41fb-415d-bcf5-8c9fcfd8fff6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"18d638b1-cef5-453d-ab70-f54a5051ab8d","user_phone":""}}	2025-07-18 03:54:57.195102+00	
00000000-0000-0000-0000-000000000000	c429170e-faca-41bb-9eac-12db0f306a57	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"1394b6e0-a80b-49e9-9497-09d692988896","user_phone":""}}	2025-07-18 04:09:25.768535+00	
00000000-0000-0000-0000-000000000000	03a2aae4-a7b7-4482-8767-8bc45590c773	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"aa5deaf6-42e1-4504-92b8-af5e32115235","user_phone":""}}	2025-07-18 04:09:30.676477+00	
00000000-0000-0000-0000-000000000000	03cf7d07-cc36-4458-8b28-3572bae3f74d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9ee1cbb1-05ef-4cd0-83da-d991acb6beb1","user_phone":""}}	2025-07-18 04:11:44.131048+00	
00000000-0000-0000-0000-000000000000	d2c55c3a-2cba-4f78-9ab1-25955920dbe2	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"34172c83-6d3c-46b5-b4f9-92017c95b742","user_phone":""}}	2025-07-18 04:12:15.394115+00	
00000000-0000-0000-0000-000000000000	5b9b4494-2084-4cb2-aa61-104aedf1500f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"597cc385-21d8-4104-9046-762437d41bd6","user_phone":""}}	2025-07-18 07:41:33.209857+00	
00000000-0000-0000-0000-000000000000	18298cf0-fc20-4c04-8f22-23cf5565c700	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"68762be5-f908-4cc6-bdcb-e3e1b8611323","user_phone":""}}	2025-07-18 07:41:36.738134+00	
00000000-0000-0000-0000-000000000000	11f7e118-772a-4fdc-904a-ca76c1bdb933	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"5c7f0d7e-7df7-4de1-9687-c7c18ceb7b8c","user_phone":""}}	2025-07-18 07:44:23.709596+00	
00000000-0000-0000-0000-000000000000	9e46e661-b072-4c18-b8c4-c1f1ad72dc27	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"67f9ce8d-cc41-4c9c-a64e-9dee48ca5293","user_phone":""}}	2025-07-18 07:44:28.281775+00	
00000000-0000-0000-0000-000000000000	12420e88-8e3d-44ad-832f-e535d1c00ab8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"4aa6b118-f155-4a0d-9ec3-b63427eaac3b","user_phone":""}}	2025-07-18 07:46:26.166348+00	
00000000-0000-0000-0000-000000000000	b8e71522-e17c-460a-833b-b53f9661c6fe	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9179fbef-8889-4c0a-b9ac-0f5cb8de898a","user_phone":""}}	2025-07-18 07:46:34.881344+00	
00000000-0000-0000-0000-000000000000	b70cf42b-9e2b-4200-8d46-879006ce7d7e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"d98e54c6-e77d-43f8-b0c7-9762c7ac1340","user_phone":""}}	2025-07-18 07:49:27.950344+00	
00000000-0000-0000-0000-000000000000	5059683f-f29d-4450-9877-919a9a28b957	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"4a60623b-5aac-4cd1-bd3d-d659e07730dc","user_phone":""}}	2025-07-18 07:49:38.972245+00	
00000000-0000-0000-0000-000000000000	f3489a6c-3d30-4c95-ab46-f27f8ebe3985	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"1c40b237-a72e-428d-86cc-9f3adc54b8c4","user_phone":""}}	2025-07-18 07:50:19.219668+00	
00000000-0000-0000-0000-000000000000	d5d92077-b860-4943-95af-9f027961fb6e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"caf2ccd2-da61-42d9-b4af-2e550cdc405c","user_phone":""}}	2025-07-18 07:50:29.35588+00	
00000000-0000-0000-0000-000000000000	9633afe6-72db-403d-ba59-b56d637b1c89	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"9e640784-5b77-41fe-94bc-13958cb705a7","user_phone":""}}	2025-07-18 08:05:54.77536+00	
00000000-0000-0000-0000-000000000000	26636580-5a84-4a48-ad9f-e4aa9def4cee	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"86ca8397-5ab8-4bd3-ad50-c61b763be3c5","user_phone":""}}	2025-07-18 08:06:26.275415+00	
00000000-0000-0000-0000-000000000000	b62d5d4f-384b-44dc-9660-43e1849e208a	{"action":"logout","actor_id":"193d728f-0bb0-43e2-8114-cd9c0801ed45","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 08:33:34.213739+00	
00000000-0000-0000-0000-000000000000	ab12331d-3414-4c22-b63c-708cc42c5912	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"193d728f-0bb0-43e2-8114-cd9c0801ed45","user_phone":""}}	2025-07-18 08:33:34.574025+00	
00000000-0000-0000-0000-000000000000	a55d45e6-6d0d-4597-b12e-c3aeba4913f2	{"action":"logout","actor_id":"707f6d18-7abb-46d0-b2d2-c3c76eb2f339","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 08:36:52.436253+00	
00000000-0000-0000-0000-000000000000	4fd41c57-c8d8-4a89-8214-426a417241be	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"707f6d18-7abb-46d0-b2d2-c3c76eb2f339","user_phone":""}}	2025-07-18 08:36:52.786054+00	
00000000-0000-0000-0000-000000000000	4250f73b-d093-46c3-a248-214815806563	{"action":"token_refreshed","actor_id":"79a33199-b288-40e0-b635-bceeda03b53a","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-18 09:08:19.50874+00	
00000000-0000-0000-0000-000000000000	705c9eb9-b791-4828-be14-c353687b99e4	{"action":"token_revoked","actor_id":"79a33199-b288-40e0-b635-bceeda03b53a","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-18 09:08:19.510224+00	
00000000-0000-0000-0000-000000000000	c696c8f9-777c-4d37-a2da-2cb6aaaf560a	{"action":"logout","actor_id":"79a33199-b288-40e0-b635-bceeda03b53a","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 09:57:07.841853+00	
00000000-0000-0000-0000-000000000000	86fd5888-3e23-48fa-b09c-f2d0008b0f06	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"79a33199-b288-40e0-b635-bceeda03b53a","user_phone":""}}	2025-07-18 09:57:08.286592+00	
00000000-0000-0000-0000-000000000000	2a315891-3cfb-4d7d-b5c0-3a19d27653cb	{"action":"logout","actor_id":"5c93764c-e8ae-4de8-a030-65ae6e026dc2","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:00:04.116669+00	
00000000-0000-0000-0000-000000000000	63a0cfb3-9f77-45c4-b7ad-3bfd9279cdc5	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"5c93764c-e8ae-4de8-a030-65ae6e026dc2","user_phone":""}}	2025-07-18 10:00:04.427788+00	
00000000-0000-0000-0000-000000000000	2af5c8fe-7f94-4be9-aecb-0f119560df0a	{"action":"logout","actor_id":"d1dcd599-1051-4094-8b11-301899015faa","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:00:07.050309+00	
00000000-0000-0000-0000-000000000000	3c34ea31-2c96-4a6a-b5ba-29b5977a61f3	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"d1dcd599-1051-4094-8b11-301899015faa","user_phone":""}}	2025-07-18 10:00:07.364159+00	
00000000-0000-0000-0000-000000000000	5748af7d-bae8-425d-8a90-bc5a2a6c5939	{"action":"logout","actor_id":"22838614-0360-4ae6-b275-6eecbce4d48a","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:05:34.601101+00	
00000000-0000-0000-0000-000000000000	0160ca0e-eb53-4f30-b524-32808bd78194	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"22838614-0360-4ae6-b275-6eecbce4d48a","user_phone":""}}	2025-07-18 10:05:34.993615+00	
00000000-0000-0000-0000-000000000000	742621f3-1b39-472f-a13d-f1f3e2ce2a23	{"action":"logout","actor_id":"fcc863ae-f99e-4967-8d9f-4aec31113ac1","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:05:39.596991+00	
00000000-0000-0000-0000-000000000000	03e4c619-d3fb-47b8-96d4-959b190953c9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"fcc863ae-f99e-4967-8d9f-4aec31113ac1","user_phone":""}}	2025-07-18 10:05:39.978325+00	
00000000-0000-0000-0000-000000000000	ccc8acaa-1cf0-4a19-a3c1-ba1a74d04dad	{"action":"logout","actor_id":"3c3bdaee-baa3-4c23-8e74-019eb3e36bd0","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:43:33.564332+00	
00000000-0000-0000-0000-000000000000	2b71f7d4-fb6c-464f-92fb-da8d44c532c7	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"3c3bdaee-baa3-4c23-8e74-019eb3e36bd0","user_phone":""}}	2025-07-18 10:43:33.894574+00	
00000000-0000-0000-0000-000000000000	d06ac520-bb91-42f6-bea6-3a5f4ef14acd	{"action":"logout","actor_id":"e41731f8-8f1f-41ba-ab2d-9ebc844ac520","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 10:43:36.586898+00	
00000000-0000-0000-0000-000000000000	4d0c8ff8-62be-4a7e-8fe3-a8509f9853f6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"e41731f8-8f1f-41ba-ab2d-9ebc844ac520","user_phone":""}}	2025-07-18 10:43:36.820891+00	
00000000-0000-0000-0000-000000000000	a8e7ef64-9498-42be-bc82-79e9b4de4e23	{"action":"logout","actor_id":"8ece6d47-ca38-4e42-8a7b-458401f300ef","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 15:10:59.171476+00	
00000000-0000-0000-0000-000000000000	8ca76285-a364-4084-9d12-4cc45286706c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8ece6d47-ca38-4e42-8a7b-458401f300ef","user_phone":""}}	2025-07-18 15:10:59.509435+00	
00000000-0000-0000-0000-000000000000	b1a5a594-73d3-4485-9bc0-b683f6669878	{"action":"logout","actor_id":"7ab89914-62a8-4f66-9c29-a5c31a12cbe4","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-18 15:11:15.463774+00	
00000000-0000-0000-0000-000000000000	8a5def30-3aee-4447-944a-d84a1960e620	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"7ab89914-62a8-4f66-9c29-a5c31a12cbe4","user_phone":""}}	2025-07-18 15:11:15.862852+00	
00000000-0000-0000-0000-000000000000	7b222adc-89fd-4b71-8887-5b187420476c	{"action":"logout","actor_id":"4d9ba012-3b3e-44a9-a456-8dcc08a69a42","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 07:41:26.039576+00	
00000000-0000-0000-0000-000000000000	f74265c2-d057-4501-8a3a-ef99ce171cd6	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"4d9ba012-3b3e-44a9-a456-8dcc08a69a42","user_phone":""}}	2025-07-19 07:41:26.378932+00	
00000000-0000-0000-0000-000000000000	8a34762f-af9b-4abc-9bcc-3b5919b28a03	{"action":"token_refreshed","actor_id":"cb8a60f0-1d1e-437c-8ddb-32ac3196dcb0","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-19 08:38:23.530182+00	
00000000-0000-0000-0000-000000000000	4f4d2233-5ddd-4e29-b279-1a117bdd72bc	{"action":"token_revoked","actor_id":"cb8a60f0-1d1e-437c-8ddb-32ac3196dcb0","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-19 08:38:23.531945+00	
00000000-0000-0000-0000-000000000000	39268c54-5cb3-4d36-9aa3-bc42abe27fa5	{"action":"token_refreshed","actor_id":"184002e7-dca5-4dab-92d2-6e85a0ab83ba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-19 08:40:12.509106+00	
00000000-0000-0000-0000-000000000000	63df686b-7f98-4a2f-bb77-0c19f6cb01b9	{"action":"token_revoked","actor_id":"184002e7-dca5-4dab-92d2-6e85a0ab83ba","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-19 08:40:12.511196+00	
00000000-0000-0000-0000-000000000000	b282a985-0a09-489c-8300-33c9911afa37	{"action":"logout","actor_id":"184002e7-dca5-4dab-92d2-6e85a0ab83ba","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:02:55.871283+00	
00000000-0000-0000-0000-000000000000	1acaeed5-6054-4eb9-8d3b-54d53e2eb28e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"184002e7-dca5-4dab-92d2-6e85a0ab83ba","user_phone":""}}	2025-07-19 09:02:56.178002+00	
00000000-0000-0000-0000-000000000000	04c56e8d-d94b-4656-9a56-f73ee48044f5	{"action":"logout","actor_id":"cb8a60f0-1d1e-437c-8ddb-32ac3196dcb0","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:03:01.741573+00	
00000000-0000-0000-0000-000000000000	89872ff2-9807-45a1-80bd-193010d10542	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"cb8a60f0-1d1e-437c-8ddb-32ac3196dcb0","user_phone":""}}	2025-07-19 09:03:02.083295+00	
00000000-0000-0000-0000-000000000000	615ddb00-6e8c-4613-91bc-e79162f51b9e	{"action":"logout","actor_id":"75d4a4dd-bf7f-440e-9920-11108e7adc4a","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:22:49.012813+00	
00000000-0000-0000-0000-000000000000	3c22e9ab-489a-49e1-b76d-042db2fa0a40	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"75d4a4dd-bf7f-440e-9920-11108e7adc4a","user_phone":""}}	2025-07-19 09:22:49.35328+00	
00000000-0000-0000-0000-000000000000	9479b721-e041-4593-b3a7-db6e54ebd067	{"action":"logout","actor_id":"8731967a-b407-49c8-8129-bdaaae4288e3","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:22:52.659764+00	
00000000-0000-0000-0000-000000000000	cfbc0f03-da49-497a-822f-878eb1ea80a8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"8731967a-b407-49c8-8129-bdaaae4288e3","user_phone":""}}	2025-07-19 09:22:52.94512+00	
00000000-0000-0000-0000-000000000000	8567ff1b-0119-41f4-851c-dd2f6e4e65d7	{"action":"logout","actor_id":"5ddbef34-6d47-4116-af6f-94560ed46269","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:36:45.561411+00	
00000000-0000-0000-0000-000000000000	2274c926-c5fb-4147-8354-fdf78d796a59	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"5ddbef34-6d47-4116-af6f-94560ed46269","user_phone":""}}	2025-07-19 09:36:45.863912+00	
00000000-0000-0000-0000-000000000000	e90d9b6c-613b-4f92-920d-8bd445cccde1	{"action":"logout","actor_id":"30932b12-2938-4487-b2cb-1489140b6d11","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 09:40:29.031924+00	
00000000-0000-0000-0000-000000000000	d801f3c7-9363-4811-9009-454c1fd3093a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"30932b12-2938-4487-b2cb-1489140b6d11","user_phone":""}}	2025-07-19 09:40:29.376737+00	
00000000-0000-0000-0000-000000000000	8c84f349-1e01-4323-a361-9e21c5d17ff5	{"action":"logout","actor_id":"0c8fd7e5-b6a0-4ae0-b0d1-6ed54474a7a6","actor_username":"","actor_via_sso":false,"log_type":"account"}	2025-07-19 10:08:37.847256+00	
00000000-0000-0000-0000-000000000000	d6dee3b6-37cb-45c5-84b3-814ca99eff99	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"0c8fd7e5-b6a0-4ae0-b0d1-6ed54474a7a6","user_phone":""}}	2025-07-19 10:08:38.192915+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
64d03eff-f7ea-40c9-a95e-f43df1e6209a	2025-07-18 10:51:41.922619+00	2025-07-18 10:51:41.922619+00	anonymous	368da804-e2f7-43e2-a73d-47650c4f01ab
76227bbe-3571-41e3-a093-aec592050627	2025-07-19 07:39:41.580078+00	2025-07-19 07:39:41.580078+00	anonymous	1ca7f2e6-044d-4e50-99f0-510383e44078
1b24840b-cffb-4709-b2d7-8dddedb6c20f	2025-07-19 09:25:57.048397+00	2025-07-19 09:25:57.048397+00	anonymous	60fc7d02-cf3b-47ae-9f0d-41f95e30af86
0a5ab5bf-2a8b-4ef2-a4b6-acc7e2cf353b	2025-07-19 10:06:23.713444+00	2025-07-19 10:06:23.713444+00	anonymous	0307baef-ceff-4441-9cd1-a606543b587e
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	205	kbny2emloffj	a01638bd-f606-4e86-97a8-e08343cdc569	f	2025-07-19 10:06:23.710802+00	2025-07-19 10:06:23.710802+00	\N	0a5ab5bf-2a8b-4ef2-a4b6-acc7e2cf353b
00000000-0000-0000-0000-000000000000	191	y7iafrte2fmx	e2afbb2e-3627-4b0a-a77a-171e4f8257be	f	2025-07-18 10:51:41.919101+00	2025-07-18 10:51:41.919101+00	\N	64d03eff-f7ea-40c9-a95e-f43df1e6209a
00000000-0000-0000-0000-000000000000	195	fnvo3ajanwad	6d0f6beb-8522-4c5f-8ede-66fb6d6ce50a	f	2025-07-19 07:39:41.561494+00	2025-07-19 07:39:41.561494+00	\N	76227bbe-3571-41e3-a093-aec592050627
00000000-0000-0000-0000-000000000000	204	mkp5dnsb635g	2653072f-8259-443d-b6ff-573c7369bc88	f	2025-07-19 09:25:57.047271+00	2025-07-19 09:25:57.047271+00	\N	1b24840b-cffb-4709-b2d7-8dddedb6c20f
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
64d03eff-f7ea-40c9-a95e-f43df1e6209a	e2afbb2e-3627-4b0a-a77a-171e4f8257be	2025-07-18 10:51:41.916618+00	2025-07-18 10:51:41.916618+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	114.141.51.172	\N
76227bbe-3571-41e3-a093-aec592050627	6d0f6beb-8522-4c5f-8ede-66fb6d6ce50a	2025-07-19 07:39:41.549528+00	2025-07-19 07:39:41.549528+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	114.141.51.172	\N
1b24840b-cffb-4709-b2d7-8dddedb6c20f	2653072f-8259-443d-b6ff-573c7369bc88	2025-07-19 09:25:57.045284+00	2025-07-19 09:25:57.045284+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	114.141.51.172	\N
0a5ab5bf-2a8b-4ef2-a4b6-acc7e2cf353b	a01638bd-f606-4e86-97a8-e08343cdc569	2025-07-19 10:06:23.708438+00	2025-07-19 10:06:23.708438+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	114.141.51.172	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	e2afbb2e-3627-4b0a-a77a-171e4f8257be	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-18 10:51:41.916553+00	{}	{"name": "Tiger'33"}	\N	2025-07-18 10:51:41.910553+00	2025-07-18 10:51:41.922203+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	6d0f6beb-8522-4c5f-8ede-66fb6d6ce50a	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-19 07:39:41.549433+00	{}	{"name": "Bird'89"}	\N	2025-07-19 07:39:41.503659+00	2025-07-19 07:39:41.579634+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	2653072f-8259-443d-b6ff-573c7369bc88	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-19 09:25:57.045218+00	{}	{"name": "Wolf'30"}	\N	2025-07-19 09:25:57.04275+00	2025-07-19 09:25:57.048103+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	a01638bd-f606-4e86-97a8-e08343cdc569	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-19 10:06:23.708367+00	{}	{"name": "Cat'76"}	\N	2025-07-19 10:06:23.702981+00	2025-07-19 10:06:23.71303+00	\N	\N			\N		0	\N		\N	f	\N	t
\.


--
-- Data for Name: member_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member_room (join_at, room_id, user_id, allias, status, id) FROM stdin;
2025-07-19 09:25:57.117558+00	9771d983-0a83-4bd3-bfef-6fc90517fe13	2653072f-8259-443d-b6ff-573c7369bc88	Wolf'30	Ready	01f94fa7-a208-4830-8fd4-8f92e944b503
2025-07-19 10:06:24.626277+00	154568dc-c22e-414b-ad96-d35e79ba92f5	a01638bd-f606-4e86-97a8-e08343cdc569	Cat'76	Online	b8755d47-65cc-4ab3-865c-0741cd2971f8
\.


--
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room (created_at, max, room_id) FROM stdin;
2025-07-19 09:25:52.006246+00	5	9771d983-0a83-4bd3-bfef-6fc90517fe13
2025-07-19 10:06:24.626277+00	2	154568dc-c22e-414b-ad96-d35e79ba92f5
\.


--
-- Data for Name: waiting_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waiting_list (created_at, user_id, allias, max, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_16; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_16 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_17; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_17 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_18; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_18 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_19; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_19 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_20; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_20 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_21; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_21 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_22; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_22 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-06-23 04:15:56
20211116045059	2025-06-23 04:15:56
20211116050929	2025-06-23 04:15:56
20211116051442	2025-06-23 04:15:56
20211116212300	2025-06-23 04:15:56
20211116213355	2025-06-23 04:15:56
20211116213934	2025-06-23 04:15:56
20211116214523	2025-06-23 04:15:56
20211122062447	2025-06-23 04:15:56
20211124070109	2025-06-23 04:15:56
20211202204204	2025-06-23 04:15:56
20211202204605	2025-06-23 04:15:56
20211210212804	2025-06-23 04:15:56
20211228014915	2025-06-23 04:15:56
20220107221237	2025-06-23 04:15:56
20220228202821	2025-06-23 04:15:56
20220312004840	2025-06-23 04:15:56
20220603231003	2025-06-23 04:15:56
20220603232444	2025-06-23 04:15:56
20220615214548	2025-06-23 04:15:56
20220712093339	2025-06-23 04:15:56
20220908172859	2025-06-23 04:15:56
20220916233421	2025-06-23 04:15:56
20230119133233	2025-06-23 04:15:56
20230128025114	2025-06-23 04:15:56
20230128025212	2025-06-23 04:15:56
20230227211149	2025-06-23 04:15:56
20230228184745	2025-06-23 04:15:56
20230308225145	2025-06-23 04:15:56
20230328144023	2025-06-23 04:15:56
20231018144023	2025-06-23 04:15:56
20231204144023	2025-06-23 04:15:56
20231204144024	2025-06-23 04:15:56
20231204144025	2025-06-23 04:15:56
20240108234812	2025-06-23 04:15:56
20240109165339	2025-06-23 04:15:56
20240227174441	2025-06-23 04:15:56
20240311171622	2025-06-23 04:15:56
20240321100241	2025-06-23 04:15:56
20240401105812	2025-06-23 04:15:56
20240418121054	2025-06-23 04:15:56
20240523004032	2025-06-23 04:15:56
20240618124746	2025-06-23 04:15:56
20240801235015	2025-06-23 04:15:56
20240805133720	2025-06-23 04:15:56
20240827160934	2025-06-23 04:15:56
20240919163303	2025-06-23 04:15:57
20240919163305	2025-06-23 04:15:57
20241019105805	2025-06-23 04:15:57
20241030150047	2025-06-23 04:15:57
20241108114728	2025-06-23 04:15:57
20241121104152	2025-06-23 04:15:57
20241130184212	2025-06-23 04:15:57
20241220035512	2025-06-23 04:15:57
20241220123912	2025-06-23 04:15:57
20241224161212	2025-06-23 04:15:57
20250107150512	2025-06-23 04:15:57
20250110162412	2025-06-23 04:15:57
20250123174212	2025-06-23 04:15:57
20250128220012	2025-06-23 04:15:57
20250506224012	2025-06-23 04:15:57
20250523164012	2025-06-23 04:15:57
20250714121412	2025-07-18 09:51:58
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-06-23 04:15:57.313435
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-06-23 04:15:57.317761
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-06-23 04:15:57.320883
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-06-23 04:15:57.336322
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-06-23 04:15:57.34962
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-06-23 04:15:57.353386
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-06-23 04:15:57.358559
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-06-23 04:15:57.363463
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-06-23 04:15:57.369918
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-06-23 04:15:57.37354
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-06-23 04:15:57.377082
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-06-23 04:15:57.38117
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-06-23 04:15:57.385903
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-06-23 04:15:57.389799
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-06-23 04:15:57.393163
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-06-23 04:15:57.407467
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-06-23 04:15:57.411466
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-06-23 04:15:57.414881
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-06-23 04:15:57.418977
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-06-23 04:15:57.423299
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-06-23 04:15:57.427199
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-06-23 04:15:57.433011
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-06-23 04:15:57.443608
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-06-23 04:15:57.45268
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-06-23 04:15:57.456337
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-06-23 04:15:57.461983
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 206, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1499, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: member_room member_room_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_room
    ADD CONSTRAINT member_room_id_key UNIQUE (id);


--
-- Name: member_room member_room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_room
    ADD CONSTRAINT member_room_pkey PRIMARY KEY (id);


--
-- Name: room room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_id);


--
-- Name: room room_room_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_room_id_key UNIQUE (room_id);


--
-- Name: member_room unique_user_room; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_room
    ADD CONSTRAINT unique_user_room UNIQUE (user_id, room_id);


--
-- Name: waiting_list waiting_list_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_id_key UNIQUE (id);


--
-- Name: waiting_list waiting_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_16 messages_2025_07_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_16
    ADD CONSTRAINT messages_2025_07_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_17 messages_2025_07_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_17
    ADD CONSTRAINT messages_2025_07_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_18 messages_2025_07_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_18
    ADD CONSTRAINT messages_2025_07_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_19 messages_2025_07_19_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_19
    ADD CONSTRAINT messages_2025_07_19_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_20 messages_2025_07_20_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_20
    ADD CONSTRAINT messages_2025_07_20_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_21 messages_2025_07_21_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_21
    ADD CONSTRAINT messages_2025_07_21_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_22 messages_2025_07_22_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_22
    ADD CONSTRAINT messages_2025_07_22_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: messages_2025_07_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_16_pkey;


--
-- Name: messages_2025_07_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_17_pkey;


--
-- Name: messages_2025_07_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_18_pkey;


--
-- Name: messages_2025_07_19_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_19_pkey;


--
-- Name: messages_2025_07_20_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_20_pkey;


--
-- Name: messages_2025_07_21_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_21_pkey;


--
-- Name: messages_2025_07_22_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_22_pkey;


--
-- Name: waiting_list trg_match_users_create_room_2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_match_users_create_room_2 AFTER INSERT ON public.waiting_list FOR EACH ROW EXECUTE FUNCTION public.match_users_create_room_2();


--
-- Name: waiting_list trigger_match_users_fill_room_5; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_match_users_fill_room_5 AFTER INSERT ON public.waiting_list FOR EACH ROW EXECUTE FUNCTION public.match_users_fill_room_5();


--
-- Name: waiting_list trigger_match_users_fill_room_7; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_match_users_fill_room_7 AFTER INSERT ON public.waiting_list FOR EACH ROW EXECUTE FUNCTION public.match_users_fill_room_7();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: member_room member_room_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_room
    ADD CONSTRAINT member_room_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.room(room_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: member_room member_room_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_room
    ADD CONSTRAINT member_room_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: waiting_list waiting_list_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: waiting_list AddWaitingList; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "AddWaitingList" ON public.waiting_list FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: member_room AllMemberRoom; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "AllMemberRoom" ON public.member_room USING (true) WITH CHECK (true);


--
-- Name: room AllRoom; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "AllRoom" ON public.room TO authenticated USING (true) WITH CHECK (true);


--
-- Name: waiting_list CancelSearchJoin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "CancelSearchJoin" ON public.waiting_list FOR DELETE TO authenticated USING (true);


--
-- Name: waiting_list CheckWaitingList; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "CheckWaitingList" ON public.waiting_list FOR SELECT TO authenticated USING (true);


--
-- Name: member_room; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.member_room ENABLE ROW LEVEL SECURITY;

--
-- Name: room; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.room ENABLE ROW LEVEL SECURITY;

--
-- Name: waiting_list; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.waiting_list ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime waiting_list; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.waiting_list;


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;
GRANT ALL ON FUNCTION auth.email() TO postgres;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;
GRANT ALL ON FUNCTION auth.role() TO postgres;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;
GRANT ALL ON FUNCTION auth.uid() TO postgres;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION match_users_create_room_2(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_users_create_room_2() TO anon;
GRANT ALL ON FUNCTION public.match_users_create_room_2() TO authenticated;
GRANT ALL ON FUNCTION public.match_users_create_room_2() TO service_role;


--
-- Name: FUNCTION match_users_fill_room_5(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_users_fill_room_5() TO anon;
GRANT ALL ON FUNCTION public.match_users_fill_room_5() TO authenticated;
GRANT ALL ON FUNCTION public.match_users_fill_room_5() TO service_role;


--
-- Name: FUNCTION match_users_fill_room_7(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_users_fill_room_7() TO anon;
GRANT ALL ON FUNCTION public.match_users_fill_room_7() TO authenticated;
GRANT ALL ON FUNCTION public.match_users_fill_room_7() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION can_insert_object(bucketid text, name text, owner uuid, metadata jsonb); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) TO postgres;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION get_size_by_bucket(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.get_size_by_bucket() TO postgres;


--
-- Name: FUNCTION list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) TO postgres;


--
-- Name: FUNCTION list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) TO postgres;


--
-- Name: FUNCTION operation(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.operation() TO postgres;


--
-- Name: FUNCTION search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) TO postgres;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.update_updated_at_column() TO postgres;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE member_room; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.member_room TO anon;
GRANT ALL ON TABLE public.member_room TO authenticated;
GRANT ALL ON TABLE public.member_room TO service_role;


--
-- Name: TABLE room; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.room TO anon;
GRANT ALL ON TABLE public.room TO authenticated;
GRANT ALL ON TABLE public.room TO service_role;


--
-- Name: TABLE waiting_list; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.waiting_list TO anon;
GRANT ALL ON TABLE public.waiting_list TO authenticated;
GRANT ALL ON TABLE public.waiting_list TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_07_16; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_16 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_16 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_17; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_17 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_17 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_18; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_18 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_18 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_19; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_19 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_19 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_20; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_20 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_20 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_21; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_21 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_21 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_22; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_22 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_22 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads TO postgres;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO postgres;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

