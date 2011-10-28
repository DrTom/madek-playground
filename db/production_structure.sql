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
-- Name: collectiongrouppermissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collectiongrouppermissions (
    id integer NOT NULL,
    collection_id integer NOT NULL,
    usergroup_id integer NOT NULL,
    may_view_metadata boolean DEFAULT false,
    may_edit_metadata boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collectiongrouppermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collectiongrouppermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collectiongrouppermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collectiongrouppermissions_id_seq OWNED BY collectiongrouppermissions.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections (
    id integer NOT NULL,
    name character varying(255),
    owner_id integer NOT NULL,
    perm_public_may_view_metadata boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: collections_mediaresources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections_mediaresources (
    collection_id integer NOT NULL,
    mediaresource_id integer NOT NULL
);


--
-- Name: collections_parent_child_joins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections_parent_child_joins (
    parent_id integer NOT NULL,
    child_id integer NOT NULL
);


--
-- Name: collectionuserpermissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collectionuserpermissions (
    id integer NOT NULL,
    collection_id integer NOT NULL,
    user_id integer NOT NULL,
    may_view_metadata boolean DEFAULT false,
    maynot_view_metadata boolean DEFAULT false,
    may_edit_metadata boolean DEFAULT false,
    maynot_edit_metadata boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collectionuserpermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collectionuserpermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collectionuserpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collectionuserpermissions_id_seq OWNED BY collectionuserpermissions.id;


--
-- Name: mediaresourcegrouppermissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mediaresourcegrouppermissions (
    id integer NOT NULL,
    mediaresource_id integer NOT NULL,
    usergroup_id integer NOT NULL,
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

ALTER TABLE collectiongrouppermissions ALTER COLUMN id SET DEFAULT nextval('collectiongrouppermissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE collectionuserpermissions ALTER COLUMN id SET DEFAULT nextval('collectionuserpermissions_id_seq'::regclass);


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
-- Name: collectiongrouppermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collectiongrouppermissions
    ADD CONSTRAINT collectiongrouppermissions_pkey PRIMARY KEY (id);


--
-- Name: collections_parent_child_joins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections_parent_child_joins
    ADD CONSTRAINT collections_parent_child_joins_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: collectionuserpermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collectionuserpermissions
    ADD CONSTRAINT collectionuserpermissions_pkey PRIMARY KEY (id);


--
-- Name: collectionuserpermissions_user_id_collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collectionuserpermissions
    ADD CONSTRAINT collectionuserpermissions_user_id_collection_id_unique UNIQUE (user_id, collection_id);


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
-- Name: collectiongrouppermissions_collection_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX collectiongrouppermissions_collection_id_idx ON collectiongrouppermissions USING btree (collection_id);


--
-- Name: collectiongrouppermissions_usergroup_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX collectiongrouppermissions_usergroup_id_idx ON collectiongrouppermissions USING btree (usergroup_id);


--
-- Name: collections_parent_child_joins_invidx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX collections_parent_child_joins_invidx ON collections_parent_child_joins USING btree (child_id, parent_id);


--
-- Name: collectionuserpermissions_collection_id_user_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX collectionuserpermissions_collection_id_user_id_idx ON collectionuserpermissions USING btree (collection_id, user_id);


--
-- Name: collectionuserpermissions_user_id_collection_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX collectionuserpermissions_user_id_collection_id_idx ON collectionuserpermissions USING btree (user_id, collection_id);


--
-- Name: mediaresourcegrouppermissions_mediaresource_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourcegrouppermissions_mediaresource_id_idx ON mediaresourcegrouppermissions USING btree (mediaresource_id);


--
-- Name: mediaresourcegrouppermissions_usergroup_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresourcegrouppermissions_usergroup_id_idx ON mediaresourcegrouppermissions USING btree (usergroup_id);


--
-- Name: mediaresources_collections_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mediaresources_collections_idx ON collections_mediaresources USING btree (mediaresource_id, collection_id);


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
-- Name: collection_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collection_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: collectiongrouppermissions_collections_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collectiongrouppermissions
    ADD CONSTRAINT collectiongrouppermissions_collections_id_fkey FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE;


--
-- Name: collectiongrouppermissions_usergroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collectiongrouppermissions
    ADD CONSTRAINT collectiongrouppermissions_usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES usergroups(id) ON DELETE CASCADE;


--
-- Name: collections_mediaresources_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_mediaresources
    ADD CONSTRAINT collections_mediaresources_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE;


--
-- Name: collections_mediaresources_mediaresource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_mediaresources
    ADD CONSTRAINT collections_mediaresources_mediaresource_id_fkey FOREIGN KEY (mediaresource_id) REFERENCES mediaresources(id) ON DELETE CASCADE;


--
-- Name: collections_parent_child_joins_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_parent_child_joins
    ADD CONSTRAINT collections_parent_child_joins_child_id_fkey FOREIGN KEY (child_id) REFERENCES collections(id) ON DELETE CASCADE;


--
-- Name: collections_parent_child_joins_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_parent_child_joins
    ADD CONSTRAINT collections_parent_child_joins_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES collections(id) ON DELETE CASCADE;


--
-- Name: collectionuserpermissions_collections_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collectionuserpermissions
    ADD CONSTRAINT collectionuserpermissions_collections_id_fkey FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE;


--
-- Name: collectionuserpermissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collectionuserpermissions
    ADD CONSTRAINT collectionuserpermissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


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

INSERT INTO schema_migrations (version) VALUES ('20111025131413');

INSERT INTO schema_migrations (version) VALUES ('20111026080926');

INSERT INTO schema_migrations (version) VALUES ('20111026084623');

INSERT INTO schema_migrations (version) VALUES ('20111026104950');

INSERT INTO schema_migrations (version) VALUES ('20111028111742');