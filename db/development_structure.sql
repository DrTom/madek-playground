--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mediaresourcegrouppermissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mediaresourcegrouppermissions (
    id integer NOT NULL,
    mediaresource_id integer,
    usergroup_id integer,
    may_view boolean DEFAULT false,
    may_download boolean DEFAULT false,
    may_edit_metadata boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mediaresourcegrouppermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mediaresourcegrouppermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mediaresourcegrouppermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mediaresourcegrouppermissions_id_seq OWNED BY mediaresourcegrouppermissions.id;


--
-- Name: mediaresources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mediaresources (
    id integer NOT NULL,
    name character varying(255),
    owner_id integer NOT NULL,
    perm_public_may_view boolean DEFAULT false,
    perm_public_may_download boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mediaresources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mediaresources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mediaresources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mediaresources_id_seq OWNED BY mediaresources.id;


--
-- Name: mediaresourceuserpermissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mediaresourceuserpermissions (
    id integer NOT NULL,
    mediaresource_id integer NOT NULL,
    user_id integer NOT NULL,
    may_view boolean DEFAULT false,
    maynot_view boolean DEFAULT false,
    may_download boolean DEFAULT false,
    maynot_download boolean DEFAULT false,
    may_edit_metadata boolean DEFAULT false,
    maynot_edit_metadata boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mediaresourceuserpermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mediaresourceuserpermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mediaresourceuserpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mediaresourceuserpermissions_id_seq OWNED BY mediaresourceuserpermissions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: usergroups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usergroups (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usergroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE usergroups_id_seq OWNED BY usergroups.id;


--
-- Name: usergroups_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usergroups_users (
    usergroup_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    login character varying(40),
    email character varying(100),
    usage_terms_accepted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mediaresourcegrouppermissions ALTER COLUMN id SET DEFAULT nextval('mediaresourcegrouppermissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mediaresources ALTER COLUMN id SET DEFAULT nextval('mediaresources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mediaresourceuserpermissions ALTER COLUMN id SET DEFAULT nextval('mediaresourceuserpermissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE usergroups ALTER COLUMN id SET DEFAULT nextval('usergroups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: mediaresourcegrouppermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mediaresourcegrouppermissions
    ADD CONSTRAINT mediaresourcegrouppermissions_pkey PRIMARY KEY (id);


--
-- Name: mediaresources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mediaresources
    ADD CONSTRAINT mediaresources_pkey PRIMARY KEY (id);


--
-- Name: mediaresourceuserpermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mediaresourceuserpermissions
    ADD CONSTRAINT mediaresourceuserpermissions_pkey PRIMARY KEY (id);


--
-- Name: mediaresourceuserpermissions_user_id_mediaresource_id_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mediaresourceuserpermissions
    ADD CONSTRAINT mediaresourceuserpermissions_user_id_mediaresource_id_unique UNIQUE (user_id, mediaresource_id);


--
-- Name: usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (id);


--
-- Name: usergroups_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usergroups_users
    ADD CONSTRAINT usergroups_users_pkey PRIMARY KEY (usergroup_id, user_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: mediaresourcegrouppermissions_mediaresource_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourcegrouppermissions_mediaresource_id_idx ON mediaresourcegrouppermissions USING btree (mediaresource_id);


--
-- Name: mediaresourcegrouppermissions_usergroup_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourcegrouppermissions_usergroup_id_idx ON mediaresourcegrouppermissions USING btree (usergroup_id);


--
-- Name: mediaresourceuserpermissions_mediaresource_id_user_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourceuserpermissions_mediaresource_id_user_id_idx ON mediaresourceuserpermissions USING btree (mediaresource_id, user_id);


--
-- Name: mediaresourceuserpermissions_user_id_mediaresource_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourceuserpermissions_user_id_mediaresource_id_idx ON mediaresourceuserpermissions USING btree (user_id, mediaresource_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_usergroup_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_usergroup_idx ON usergroups_users USING btree (user_id, usergroup_id);


--
-- Name: mediaresource_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mediaresources
    ADD CONSTRAINT mediaresource_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: mediaresourcegrouppermissions_mediaresources_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mediaresourcegrouppermissions
    ADD CONSTRAINT mediaresourcegrouppermissions_mediaresources_id_fkey FOREIGN KEY (mediaresource_id) REFERENCES mediaresources(id) ON DELETE CASCADE;


--
-- Name: mediaresourcegrouppermissions_usergroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mediaresourcegrouppermissions
    ADD CONSTRAINT mediaresourcegrouppermissions_usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES usergroups(id) ON DELETE CASCADE;


--
-- Name: mediaresourceuserpermissions_mediaresources_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mediaresourceuserpermissions
    ADD CONSTRAINT mediaresourceuserpermissions_mediaresources_id_fkey FOREIGN KEY (mediaresource_id) REFERENCES mediaresources(id) ON DELETE CASCADE;


--
-- Name: mediaresourceuserpermissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mediaresourceuserpermissions
    ADD CONSTRAINT mediaresourceuserpermissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: usergroups_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usergroups_users
    ADD CONSTRAINT usergroups_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: usergroups_users_usergroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usergroups_users
    ADD CONSTRAINT usergroups_users_usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES usergroups(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20111007130508');

INSERT INTO schema_migrations (version) VALUES ('20111007171527');

INSERT INTO schema_migrations (version) VALUES ('20111007172913');

INSERT INTO schema_migrations (version) VALUES ('20111012110126');

INSERT INTO schema_migrations (version) VALUES ('20111012110806');

INSERT INTO schema_migrations (version) VALUES ('20111012111218');