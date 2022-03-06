

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.posts DISABLE TRIGGER ALL;

INSERT INTO public.posts (id, title, body) VALUES ('3b6786ca-e56a-47d4-b8a5-6df02a72e1cd', 'HelloWorld', 'First IHP Post');
INSERT INTO public.posts (id, title, body) VALUES ('900fb36e-9791-4d5a-9597-e5a63a66ea91', 'Validate', 'Lorem Ipsum');


ALTER TABLE public.posts ENABLE TRIGGER ALL;


ALTER TABLE public.schema_migrations DISABLE TRIGGER ALL;

INSERT INTO public.schema_migrations (revision) VALUES (1646446127);


ALTER TABLE public.schema_migrations ENABLE TRIGGER ALL;


