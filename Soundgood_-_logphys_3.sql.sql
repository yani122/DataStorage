CREATE TABLE instructor (
 instructor_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (instructor_id);


CREATE TABLE instructor_instrument (
 instructor_id INT NOT NULL,
 instrument_kind VARCHAR(500) NOT NULL
);

ALTER TABLE instructor_instrument ADD CONSTRAINT PK_instructor_instrument PRIMARY KEY (instructor_id,instrument_kind);


CREATE TABLE instructor_payment (
 instructor_id INT NOT NULL,
 amount INT
);

ALTER TABLE instructor_payment ADD CONSTRAINT PK_instructor_payment PRIMARY KEY (instructor_id);


CREATE TABLE instrument_rental (
 id INT NOT NULL,
 brand VARCHAR(500) NOT NULL,
 price INT NOT NULL,
 instrument_type VARCHAR(500) NOT NULL,
 is_rented BIT(1),
 kind VARCHAR(500) NOT NULL
);

ALTER TABLE instrument_rental ADD CONSTRAINT PK_instrument_rental PRIMARY KEY (id);


CREATE TABLE level (
 id INT NOT NULL,
 beginner BIT(1),
 intermediate BIT(1),
 advanced BIT(1)
);

ALTER TABLE level ADD CONSTRAINT PK_level PRIMARY KEY (id);


CREATE TABLE student (
 id INT NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE student_application (
 student_id INT NOT NULL,
 level_id INT NOT NULL,
 keep_application BIT(1) NOT NULL
);

ALTER TABLE student_application ADD CONSTRAINT PK_student_application PRIMARY KEY (student_id,level_id);


CREATE TABLE student_payment (
 student_id INT NOT NULL,
 amount INT
);

ALTER TABLE student_payment ADD CONSTRAINT PK_student_payment PRIMARY KEY (student_id);


CREATE TABLE time_availability (
 date_start_time TIMESTAMP(6) NOT NULL,
 date_end_time TIMESTAMP(6) NOT NULL,
 instructor_id INT NOT NULL
);

ALTER TABLE time_availability ADD CONSTRAINT PK_time_availability PRIMARY KEY (date_start_time,date_end_time,instructor_id);


CREATE TABLE audition (
 student_id INT NOT NULL,
 level_id INT NOT NULL,
 passed BIT(1)
);

ALTER TABLE audition ADD CONSTRAINT PK_audition PRIMARY KEY (student_id,level_id);


CREATE TABLE discount (
 student_id INT NOT NULL,
 has_sibling BIT(1) NOT NULL
);

ALTER TABLE discount ADD CONSTRAINT PK_discount PRIMARY KEY (student_id);


CREATE TABLE ensemble_lesson (
 id INT NOT NULL,
 date_start_time TIMESTAMP(6) NOT NULL,
 date_end_time TIMESTAMP(6) NOT NULL,
 level_id INT,
 instructor_id INT NOT NULL,
 expensive_day BIT(1) NOT NULL,
 genre VARCHAR(500),
 price INT,
 max_no_of_students INT NOT NULL,
 min_no_of_students INT NOT NULL
);

ALTER TABLE ensemble_lesson ADD CONSTRAINT PK_ensemble_lesson PRIMARY KEY (id);


CREATE TABLE ensemble_sic (
 student_id INT NOT NULL,
 ensemble_id INT NOT NULL
);

ALTER TABLE ensemble_sic ADD CONSTRAINT PK_ensemble_sic PRIMARY KEY (student_id,ensemble_id);


CREATE TABLE group_lesson (
 id INT NOT NULL,
 date_start_time TIMESTAMP(6) NOT NULL,
 date_end_time TIMESTAMP(6) NOT NULL,
 level_id INT NOT NULL,
 instructor_id INT NOT NULL,
 expensive_day BIT(1) NOT NULL,
 instrument_kind VARCHAR(500),
 price INT,
 max_no_of_students INT NOT NULL,
 min_no_of_students INT NOT NULL
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (id);


CREATE TABLE group_sic (
 student_id INT NOT NULL,
 group_lesson_id INT NOT NULL
);

ALTER TABLE group_sic ADD CONSTRAINT PK_group_sic PRIMARY KEY (student_id,group_lesson_id);


CREATE TABLE individual_lesson (
 id INT NOT NULL,
 date_start_time TIMESTAMP(6) NOT NULL,
 date_end_time TIMESTAMP(6) NOT NULL,
 level_id INT NOT NULL,
 instructor_id INT NOT NULL,
 student_id INT NOT NULL,
 instrument_kind VARCHAR(500),
 price INT,
 expensive_day BIT(1)
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (id);


CREATE TABLE personal_information (
 id INT NOT NULL,
 personal_number  INT,
 name VARCHAR(30) NOT NULL,
 age INT NOT NULL,
 street VARCHAR(50) NOT NULL,
 city VARCHAR(50) NOT NULL,
 zip VARCHAR(50) NOT NULL,
 student_id INT,
 instructor_id INT
);

ALTER TABLE personal_information ADD CONSTRAINT PK_personal_information PRIMARY KEY (id);


CREATE TABLE rental_lease (
 id INT NOT NULL,
 instrument_rental_id INT NOT NULL,
 student_id INT NOT NULL,
 date_start_time TIMESTAMP(6) NOT NULL,
 date_end_time TIMESTAMP(6),
 is_terminated BIT(1)
);

ALTER TABLE rental_lease ADD CONSTRAINT PK_rental_lease PRIMARY KEY (id);


CREATE TABLE contact_details (
 personal_information_id INT NOT NULL,
 phone_number  INT NOT NULL,
 email  VARCHAR(50) NOT NULL
);

ALTER TABLE contact_details ADD CONSTRAINT PK_contact_details PRIMARY KEY (personal_information_id);


CREATE TABLE parents_contact_details (
 personal_information_id INT NOT NULL,
 name VARCHAR(30) NOT NULL,
 phone_number  INT NOT NULL,
 email  VARCHAR(50) NOT NULL
);

ALTER TABLE parents_contact_details ADD CONSTRAINT PK_parents_contact_details PRIMARY KEY (personal_information_id);


ALTER TABLE instructor_instrument ADD CONSTRAINT FK_instructor_instrument_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE instructor_payment ADD CONSTRAINT FK_instructor_payment_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE student_application ADD CONSTRAINT FK_student_application_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE student_application ADD CONSTRAINT FK_student_application_1 FOREIGN KEY (level_id) REFERENCES level (id);


ALTER TABLE student_payment ADD CONSTRAINT FK_student_payment_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE time_availability ADD CONSTRAINT FK_time_availability_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE audition ADD CONSTRAINT FK_audition_0 FOREIGN KEY (student_id,level_id) REFERENCES student_application (student_id,level_id);


ALTER TABLE discount ADD CONSTRAINT FK_discount_0 FOREIGN KEY (student_id) REFERENCES student_payment (student_id);


ALTER TABLE ensemble_lesson ADD CONSTRAINT FK_ensemble_lesson_0 FOREIGN KEY (level_id) REFERENCES level (id);
ALTER TABLE ensemble_lesson ADD CONSTRAINT FK_ensemble_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE ensemble_sic ADD CONSTRAINT FK_ensemble_sic_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE ensemble_sic ADD CONSTRAINT FK_ensemble_sic_1 FOREIGN KEY (ensemble_id) REFERENCES ensemble_lesson (id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (level_id) REFERENCES level (id);
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE group_sic ADD CONSTRAINT FK_group_sic_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE group_sic ADD CONSTRAINT FK_group_sic_1 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (id);


ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_0 FOREIGN KEY (level_id) REFERENCES level (id);
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_2 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE personal_information ADD CONSTRAINT FK_personal_information_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE personal_information ADD CONSTRAINT FK_personal_information_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE rental_lease ADD CONSTRAINT FK_rental_lease_0 FOREIGN KEY (instrument_rental_id) REFERENCES instrument_rental (id);
ALTER TABLE rental_lease ADD CONSTRAINT FK_rental_lease_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE contact_details ADD CONSTRAINT FK_contact_details_0 FOREIGN KEY (personal_information_id) REFERENCES personal_information (id);


ALTER TABLE parents_contact_details ADD CONSTRAINT FK_parents_contact_details_0 FOREIGN KEY (personal_information_id) REFERENCES personal_information (id);


