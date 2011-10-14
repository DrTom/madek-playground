--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mediaresources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mediaresources (
    id integer NOT NULL,
    name character varying(255),
    perm_public_view boolean DEFAULT false,
    perm_public_download boolean DEFAULT false,
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: usergrouppermisionsets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usergrouppermisionsets (
    id integer NOT NULL,
    view boolean DEFAULT false,
    highres boolean DEFAULT false,
    edit boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    mediaresource_id integer,
    usergroup_id integer
);


--
-- Name: usergrouppermisionsets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usergrouppermisionsets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usergrouppermisionsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE usergrouppermisionsets_id_seq OWNED BY usergrouppermisionsets.id;


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
-- Name: userpermissionsets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userpermissionsets (
    id integer NOT NULL,
    mediaresource_id integer NOT NULL,
    user_id integer NOT NULL,
    view boolean DEFAULT false,
    not_view boolean DEFAULT false,
    download boolean DEFAULT false,
    not_download boolean DEFAULT false,
    edit boolean DEFAULT false,
    not_edit boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: userpermissionsets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userpermissionsets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userpermissionsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE userpermissionsets_id_seq OWNED BY userpermissionsets.id;


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

ALTER TABLE mediaresources ALTER COLUMN id SET DEFAULT nextval('mediaresources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE usergrouppermisionsets ALTER COLUMN id SET DEFAULT nextval('usergrouppermisionsets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE usergroups ALTER COLUMN id SET DEFAULT nextval('usergroups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE userpermissionsets ALTER COLUMN id SET DEFAULT nextval('userpermissionsets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: mediaresources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mediaresources
    ADD CONSTRAINT mediaresources_pkey PRIMARY KEY (id);


--
-- Name: usergrouppermisionsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usergrouppermisionsets
    ADD CONSTRAINT usergrouppermisionsets_pkey PRIMARY KEY (id);


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
-- Name: userpermissionsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userpermissionsets
    ADD CONSTRAINT userpermissionsets_pkey PRIMARY KEY (id);


--
-- Name: userpermissionsets_user_id_mediaresource_id_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userpermissionsets
    ADD CONSTRAINT userpermissionsets_user_id_mediaresource_id_unique UNIQUE (user_id, mediaresource_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_usergroup_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_usergroup_idx ON usergroups_users USING btree (user_id, usergroup_id);


--
-- Name: usergrouppermisionsets_mediaresource_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX usergrouppermisionsets_mediaresource_id_idx ON usergrouppermisionsets USING btree (mediaresource_id);


--
-- Name: usergrouppermisionsets_usergroup_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX usergrouppermisionsets_usergroup_id_idx ON usergrouppermisionsets USING btree (usergroup_id);


--
-- Name: userpermissionsets_mediaresource_id_user_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX userpermissionsets_mediaresource_id_user_id_idx ON userpermissionsets USING btree (mediaresource_id, user_id);


--
-- Name: userpermissionsets_user_id_mediaresource_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX userpermissionsets_user_id_mediaresource_id_idx ON userpermissionsets USING btree (user_id, mediaresource_id);


--
-- Name: usergrouppermisionsets_mediaresource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usergrouppermisionsets
    ADD CONSTRAINT usergrouppermisionsets_mediaresource_id_fkey FOREIGN KEY (mediaresource_id) REFERENCES mediaresources(id) ON DELETE CASCADE;


--
-- Name: usergrouppermisionsets_usergroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usergrouppermisionsets
    ADD CONSTRAINT usergrouppermisionsets_usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES usergroups(id) ON DELETE CASCADE;


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
-- Name: userpermissionsets_mediaresources_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userpermissionsets
    ADD CONSTRAINT userpermissionsets_mediaresources_id_fkey FOREIGN KEY (mediaresource_id) REFERENCES mediaresources(id) ON DELETE CASCADE;


--
-- Name: userpermissionsets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userpermissionsets
    ADD CONSTRAINT userpermissionsets_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20111007130508');

INSERT INTO schema_migrations (version) VALUES ('20111007171527');

INSERT INTO schema_migrations (version) VALUES ('20111007172913');

INSERT INTO schema_migrations (version) VALUES ('20111012110126');

INSERT INTO schema_migrations (version) VALUES ('20111012110806');

INSERT INTO schema_migrations (version) VALUES ('20111012111218');