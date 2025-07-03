--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: children; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.children (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    photo_url text
);


ALTER TABLE public.children OWNER TO postgres;

--
-- Name: survey_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_answers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question_id uuid,
    answer_text text NOT NULL
);


ALTER TABLE public.survey_answers OWNER TO postgres;

--
-- Name: survey_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_questions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    survey_id uuid,
    question_text text NOT NULL
);


ALTER TABLE public.survey_questions OWNER TO postgres;

--
-- Name: survey_response_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_response_answers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    response_id uuid,
    question_id uuid,
    answer_id uuid
);


ALTER TABLE public.survey_response_answers OWNER TO postgres;

--
-- Name: survey_responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_responses (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    survey_id uuid,
    user_id uuid,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.survey_responses OWNER TO postgres;

--
-- Name: surveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surveys (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


ALTER TABLE public.surveys OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    password text NOT NULL,
    photo_url text,
    confirmed boolean,
    death_confirmed boolean,
    deactivation_note text,
    is_active boolean,
    father_id uuid,
    mother_id uuid,
    children_count integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: children; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.children (id, user_id, first_name, last_name, photo_url) FROM stdin;
a2e4d539-10e2-4be0-91f1-ca9d24cbb247	696d7c59-cf64-414d-81ba-edc21b841410	Руслан	Хаджуков	\N
\.


--
-- Data for Name: survey_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_answers (id, question_id, answer_text) FROM stdin;
070437a1-b70b-492f-a498-46a99099fbec	2da387ca-be5d-412a-b29e-a9af55565cb2	Регистрация пользователей
b40b9bcb-8c43-4d89-b8b0-7f4354f105ff	2da387ca-be5d-412a-b29e-a9af55565cb2	Оповещения о родственниках
f1ddf2b2-20df-4e40-a04e-f7474043333a	2da387ca-be5d-412a-b29e-a9af55565cb2	Пожертвования
ff2da461-236b-44fb-80a2-73f44c7d2820	f2bffeda-cde2-46f1-9475-801c22ba98e2	Да
7f4903f7-fe7b-4b66-b984-8e66dde39a55	f2bffeda-cde2-46f1-9475-801c22ba98e2	Нет
0a65a7e8-3a54-4066-b2c2-d35b275dfa54	f2bffeda-cde2-46f1-9475-801c22ba98e2	Зависит от условий
\.


--
-- Data for Name: survey_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_questions (id, survey_id, question_text) FROM stdin;
2da387ca-be5d-412a-b29e-a9af55565cb2	68bb5f83-baf2-4143-b954-9323c49441dc	Какая функция для вас самая важная?
f2bffeda-cde2-46f1-9475-801c22ba98e2	68bb5f83-baf2-4143-b954-9323c49441dc	Готовы ли вы поддержать проект финансово?
\.


--
-- Data for Name: survey_response_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_response_answers (id, response_id, question_id, answer_id) FROM stdin;
\.


--
-- Data for Name: survey_responses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_responses (id, survey_id, user_id, submitted_at) FROM stdin;
\.


--
-- Data for Name: surveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surveys (id, title, description, created_at, is_active) FROM stdin;
68bb5f83-baf2-4143-b954-9323c49441dc	Опрос: Будущее проекта Cherkess.net	Помогите определить, что делать дальше.	2025-06-20 01:36:32.950467	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, photo_url, confirmed, death_confirmed, deactivation_note, is_active, father_id, mother_id, children_count) FROM stdin;
cb36c4f4-3333-40fa-9459-c33c0ba25c8a	Арсен	Тлеуж	arsen1@example.com	+79990000001	hashed_password	\N	\N	\N	\N	\N	\N	\N	2
3ba0961f-0c13-45ce-a758-74566343c1c4	Зарема	Хагурова	zarema@example.com	+79990000002	hashed_password	\N	\N	\N	\N	\N	\N	\N	3
8e46f9d8-9935-4fd3-a77d-f56a56f31c5f	Батыр	Ачмизов	batyr@example.com	+79990000003	hashed_password	\N	\N	\N	\N	\N	\N	\N	1
bdfd4c25-237b-4a38-8b14-59f7b4edab68	Фатима	Схаляхо	fatima@example.com	+79990000004	hashed_password	\N	\N	\N	\N	\N	\N	\N	0
7d0ec3be-d107-4b34-b2e8-2df363d7d339	Мурат	Пшеунов	murat@example.com	+79990000005	hashed_password	\N	\N	\N	\N	\N	\N	\N	4
696d7c59-cf64-414d-81ba-edc21b841410	Аслан	Хаджуков	aslan@example.com	+79990000000	hashed_password	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Name: children children_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_pkey PRIMARY KEY (id);


--
-- Name: survey_answers survey_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_answers
    ADD CONSTRAINT survey_answers_pkey PRIMARY KEY (id);


--
-- Name: survey_questions survey_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_pkey PRIMARY KEY (id);


--
-- Name: survey_response_answers survey_response_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_response_answers
    ADD CONSTRAINT survey_response_answers_pkey PRIMARY KEY (id);


--
-- Name: survey_responses survey_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_pkey PRIMARY KEY (id);


--
-- Name: surveys surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: children children_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: survey_answers survey_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_answers
    ADD CONSTRAINT survey_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.survey_questions(id) ON DELETE CASCADE;


--
-- Name: survey_questions survey_questions_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- Name: survey_response_answers survey_response_answers_answer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_response_answers
    ADD CONSTRAINT survey_response_answers_answer_id_fkey FOREIGN KEY (answer_id) REFERENCES public.survey_answers(id) ON DELETE CASCADE;


--
-- Name: survey_response_answers survey_response_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_response_answers
    ADD CONSTRAINT survey_response_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.survey_questions(id) ON DELETE CASCADE;


--
-- Name: survey_response_answers survey_response_answers_response_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_response_answers
    ADD CONSTRAINT survey_response_answers_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.survey_responses(id) ON DELETE CASCADE;


--
-- Name: survey_responses survey_responses_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- Name: survey_responses survey_responses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_father_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_father_id_fkey FOREIGN KEY (father_id) REFERENCES public.users(id);


--
-- Name: users users_mother_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mother_id_fkey FOREIGN KEY (mother_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

