--
-- PostgreSQL database dump
--

-- Dumped from database version 13.8
-- Dumped by pg_dump version 13.8

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

--
-- Name: _check_(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public._check_() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
	IF new.kolvo_st > 40 THEN
	RAISE EXCEPTION 'Kolichectvo studentov must be lower then 40';
	end if;
	return new;
END

$$;


ALTER FUNCTION public._check_() OWNER TO postgres;

--
-- Name: ft_publ(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ft_publ(grup_kod character varying, kolvo_st integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
	begin
		return grup_kod || ' находится в городе ' || kolvo_st;
    end;
$$;


ALTER FUNCTION public.ft_publ(grup_kod character varying, kolvo_st integer) OWNER TO postgres;

--
-- Name: grup_p(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.grup_p(grup_kod character varying, kolvo_st integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
	begin
		return kolvo_st || ' студента зачислено в группу ' || grup_kod;
    end;
$$;


ALTER FUNCTION public.grup_p(grup_kod character varying, kolvo_st integer) OWNER TO postgres;

--
-- Name: return_cursor(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_cursor(mykey integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE -- блок с переменными
curs1 refcursor := 'curs1';
BEGIN
OPEN curs1 FOR SELECT * FROM sesion WHERE sesia_id = mykey;
RETURN curs1;
END;
$$;


ALTER FUNCTION public.return_cursor(mykey integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: grup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grup (
    grup_id integer NOT NULL,
    facl character varying(64) NOT NULL,
    grup_kod character varying(64) NOT NULL,
    kolvo_st integer NOT NULL,
    kurs integer
);


ALTER TABLE public.grup OWNER TO postgres;

--
-- Name: sesion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sesion (
    sesia_id integer NOT NULL,
    prep_name character varying(64) NOT NULL,
    typeofcntr character varying(64) NOT NULL,
    dateofcntr date NOT NULL,
    grup_kod character varying(64) NOT NULL,
    kafed character varying(64) NOT NULL
);


ALTER TABLE public.sesion OWNER TO postgres;

--
-- Name: poisk; Type: VIEW; Schema: public; Owner: test
--

CREATE VIEW public.poisk AS
 SELECT sesion.prep_name,
    grup.facl,
    count(grup.kolvo_st) AS count
   FROM public.sesion,
    public.grup
  WHERE ((sesion.grup_kod)::text = (grup.grup_kod)::text)
  GROUP BY sesion.prep_name, grup.facl;


ALTER TABLE public.poisk OWNER TO test;

--
-- Name: predmet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predmet (
    pedmet_id integer NOT NULL,
    name_pr character varying(64) NOT NULL,
    kafed character varying(64) NOT NULL,
    kolvo_chas integer NOT NULL,
    infor text
);


ALTER TABLE public.predmet OWNER TO postgres;

--
-- Name: prepod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prepod (
    prepod_id integer NOT NULL,
    name_prepod character varying(64) NOT NULL,
    kafed character varying(64) NOT NULL,
    zp integer[]
);


ALTER TABLE public.prepod OWNER TO postgres;

--
-- Name: stud; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stud (
    stud_id integer NOT NULL,
    grub_kod character varying(64) NOT NULL,
    dopusk character varying(64) NOT NULL,
    name_stud jsonb
);


ALTER TABLE public.stud OWNER TO postgres;

--
-- Name: grup grup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grup
    ADD CONSTRAINT grup_pkey PRIMARY KEY (grup_kod);


--
-- Name: predmet predmet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predmet
    ADD CONSTRAINT predmet_pkey PRIMARY KEY (kafed);


--
-- Name: prepod prepod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prepod
    ADD CONSTRAINT prepod_pkey PRIMARY KEY (prepod_id);


--
-- Name: sesion sesion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_pkey PRIMARY KEY (sesia_id);


--
-- Name: stud stud_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stud
    ADD CONSTRAINT stud_pkey PRIMARY KEY (stud_id);


--
-- Name: kolvo_st; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX kolvo_st ON public.grup USING btree (kolvo_st);


--
-- Name: predmets; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX predmets ON public.predmet USING btree (name_pr);


--
-- Name: grup _check_; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER _check_ BEFORE INSERT OR UPDATE ON public.grup FOR EACH ROW EXECUTE FUNCTION public._check_();


--
-- Name: stud grup_kod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stud
    ADD CONSTRAINT grup_kod FOREIGN KEY (grub_kod) REFERENCES public.grup(grup_kod);


--
-- Name: prepod kafed; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prepod
    ADD CONSTRAINT kafed FOREIGN KEY (kafed) REFERENCES public.predmet(kafed);


--
-- Name: sesion sesion_grup_kod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_grup_kod_fkey FOREIGN KEY (grup_kod) REFERENCES public.grup(grup_kod);


--
-- Name: sesion sesion_kafed_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_kafed_fkey FOREIGN KEY (kafed) REFERENCES public.predmet(kafed);


--
-- Name: TABLE grup; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.grup TO test;


--
-- Name: TABLE sesion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.sesion TO test;


--
-- Name: TABLE predmet; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.predmet TO test;


--
-- PostgreSQL database dump complete
--

