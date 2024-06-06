alter session set container = XEPDB1;

-- SEQUENCES
CREATE SEQUENCE JAWS_OWNER.PRIORITY_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
    NOCACHE
    ORDER;

CREATE SEQUENCE JAWS_OWNER.COMPONENT_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
    NOCACHE
    ORDER;

CREATE SEQUENCE JAWS_OWNER.TEAM_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
    NOCACHE
    ORDER;

CREATE SEQUENCE JAWS_OWNER.ACTION_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
    NOCACHE
    ORDER;

CREATE SEQUENCE JAWS_OWNER.ALARM_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
	NOCACHE
	ORDER;

CREATE SEQUENCE JAWS_OWNER.LOCATION_ID
    INCREMENT BY 1
    START WITH 1
    NOCYCLE
    NOCACHE
    ORDER;

-- TABLES
CREATE TABLE JAWS_OWNER.TEAM
(
    TEAM_ID INTEGER NOT NULL,
    NAME    VARCHAR2(64 CHAR) NOT NULL,
    CONSTRAINT TEAM_PK PRIMARY KEY (TEAM_ID),
    CONSTRAINT TEAM_AK1 UNIQUE (NAME)
);

CREATE TABLE JAWS_OWNER.COMPONENT
(
    COMPONENT_ID INTEGER NOT NULL,
    TEAM_ID      INTEGER NOT NULL,
    NAME         VARCHAR2(64 CHAR) NOT NULL,
    CONSTRAINT COMPONENT_PK PRIMARY KEY (COMPONENT_ID),
    CONSTRAINT COMPONENT_FK1 FOREIGN KEY (TEAM_ID) REFERENCES JAWS_OWNER.TEAM (TEAM_ID) ON DELETE SET NULL,
    CONSTRAINT COMPONENT_AK1 UNIQUE (NAME)
);

CREATE TABLE JAWS_OWNER.PRIORITY
(
    PRIORITY_ID INTEGER NOT NULL,
    NAME        VARCHAR2(64 CHAR) NOT NULL,
    WEIGHT      INTEGER NULL,
    CONSTRAINT PRIORITY_PK PRIMARY KEY (PRIORITY_ID),
    CONSTRAINT PRIORITY_AK1 UNIQUE (NAME)
);

CREATE TABLE JAWS_OWNER.ACTION
(
    ACTION_ID         INTEGER NOT NULL,
    COMPONENT_ID      INTEGER NOT NULL,
    PRIORITY_ID       INTEGER NOT NULL,
    NAME              VARCHAR2(64 CHAR) NOT NULL,
    CORRECTIVE_ACTION CLOB NOT NULL,
    RATIONALE         CLOB NOT NULL,
    FILTERABLE        CHAR(1 CHAR) DEFAULT 'Y' NOT NULL,
    LATCHABLE         CHAR(1 CHAR) DEFAULT 'N' NOT NULL,
    ON_DELAY_SECONDS  INTEGER NULL,
    OFF_DELAY_SECONDS INTEGER NULL,
    CONSTRAINT ACTION_PK PRIMARY KEY (ACTION_ID),
    CONSTRAINT ACTION_FK1 FOREIGN KEY (COMPONENT_ID) REFERENCES JAWS_OWNER.COMPONENT (COMPONENT_ID) ON DELETE SET NULL,
    CONSTRAINT ACTION_FK3 FOREIGN KEY (PRIORITY_ID) REFERENCES JAWS_OWNER.PRIORITY (PRIORITY_ID) ON DELETE SET NULL,
    CONSTRAINT ACTION_AK1 UNIQUE (NAME),
    CONSTRAINT ACTION_CK1 CHECK (FILTERABLE IN ('Y', 'N')),
    CONSTRAINT ACTION_CK2 CHECK (LATCHABLE IN ('Y', 'N'))
);


CREATE TABLE JAWS_OWNER.ALARM
(
    ALARM_ID             INTEGER NOT NULL,
    ACTION_ID            INTEGER NOT NULL,
    NAME                 VARCHAR2(64 CHAR) NOT NULL,
    DEVICE               VARCHAR2(64 CHAR) NULL,
    SCREEN_COMMAND       VARCHAR2(512 CHAR) NULL,
    MASKED_BY            VARCHAR2(64 CHAR) NULL,
    PV                   VARCHAR2(64 CHAR) NULL,
    CONSTRAINT ALARM_PK PRIMARY KEY (ALARM_ID),
    CONSTRAINT ALARM_AK1 UNIQUE (NAME),
    CONSTRAINT ALARM_FK1 FOREIGN KEY (ACTION_ID) REFERENCES JAWS_OWNER.ACTION (ACTION_ID) ON DELETE SET NULL
);

CREATE TABLE JAWS_OWNER.LOCATION
(
    LOCATION_ID INTEGER NOT NULL,
    PARENT_ID   INTEGER NULL,
    NAME        VARCHAR2(64 CHAR) NOT NULL,
    WEIGHT      INTEGER NULL,
    CONSTRAINT LOCATION_PK PRIMARY KEY (LOCATION_ID),
    CONSTRAINT LOCATION_FK1 FOREIGN KEY (PARENT_ID) REFERENCES JAWS_OWNER.LOCATION (LOCATION_ID) ON DELETE SET NULL,
    CONSTRAINT LOCATION_AK1 UNIQUE (NAME)
);

CREATE TABLE JAWS_OWNER.ALARM_LOCATION
(
    ALARM_ID    INTEGER NOT NULL,
    LOCATION_ID INTEGER NOT NULL,
    CONSTRAINT ALARM_LOCATION_PK PRIMARY KEY (ALARM_ID, LOCATION_ID)
);

CREATE TABLE JAWS_OWNER.NOTIFICATION
(
    NAME                 VARCHAR2(64 CHAR) NOT NULL,
    STATE                VARCHAR2(64 CHAR) NOT NULL,
    SINCE                TIMESTAMP(0) WITH LOCAL TIME ZONE NOT NULL,
    ACTIVE_OVERRIDE      VARCHAR2(32 CHAR) NULL,
    ACTIVATION_TYPE      VARCHAR2(64 CHAR) NOT NULL,
    ACTIVATION_NOTE      VARCHAR2(128 CHAR) NULL,
    ACTIVATION_SEVR      VARCHAR2(32 CHAR) NULL,
    ACTIVATION_STAT      VARCHAR2(32 CHAR) NULL,
    ACTIVATION_ERROR     VARCHAR2(128 CHAR) NULL,
    CONSTRAINT NOTIFICATION_PK PRIMARY KEY (NAME),
    CONSTRAINT NOTIFICATION_CK1 CHECK (STATE IN ('Active', 'Normal')),
    CONSTRAINT NOTIFICATION_CK2 CHECK (ACTIVE_OVERRIDE IN ('Disabled', 'Filtered', 'Masked', 'OnDelayed', 'OffDelayed', 'Shelved', 'Latched'))
);

CREATE TABLE JAWS_OWNER.OVERRIDE
(
    NAME             VARCHAR2(64 CHAR) NOT NULL,
    TYPE             VARCHAR2(32 CHAR) NOT NULL,
    COMMENTS         VARCHAR2(512 CHAR) NULL,
    ONESHOT          CHAR(1 CHAR) DEFAULT 'N' NOT NULL,
    EXPIRATION       TIMESTAMP(0) WITH LOCAL TIME ZONE NULL,
    SHELVED_REASON   VARCHAR2(32 CHAR) NULL,
    CONSTRAINT OVERRIDE_PK PRIMARY KEY (NAME, TYPE),
    CONSTRAINT OVERRIDE_CK1 CHECK (TYPE IN ('Disabled', 'Filtered', 'Masked', 'OnDelayed', 'OffDelayed', 'Shelved', 'Latched')),
    CONSTRAINT OVERRIDE_CK2 CHECK (ONESHOT IN ('Y', 'N')),
    CONSTRAINT OVERRIDE_CK3 CHECK (SHELVED_REASON IN ('Stale_Alarm', 'Chattering_Fleeting_Alarm', 'Other'))
);

CREATE TABLE JAWS_OWNER.NOTIFICATION_HISTORY
(
    NAME                 VARCHAR2(64 CHAR) NOT NULL,
    ACTIVE_START         TIMESTAMP(3) WITH LOCAL TIME ZONE NOT NULL,
    ACTIVE_END           TIMESTAMP(3) WITH LOCAL TIME ZONE NULL,
    ACTIVATION_TYPE      VARCHAR2(64 CHAR) NOT NULL,
    ACTIVATION_NOTE      VARCHAR2(128 CHAR) NULL,
    ACTIVATION_SEVR      VARCHAR2(32 CHAR) NULL,
    ACTIVATION_STAT      VARCHAR2(32 CHAR) NULL,
    ACTIVATION_ERROR     VARCHAR2(128 CHAR) NULL,
    CONSTRAINT NOTIFICATION_HISTORY_PK PRIMARY KEY (NAME, ACTIVE_START),
    CONSTRAINT NOTIFICATION_HISTORY_AK1 UNIQUE (NAME, ACTIVE_END)
);

-- This table exists solely to provide a mechanism to lock a parent row with "for update" to serialize
-- merge_notification_history
CREATE TABLE JAWS_OWNER.NOTIFICATION_NAME
(
    NAME                 VARCHAR2(64 CHAR) NOT NULL,
    CONSTRAINT NOTIFICATION_NAME_PK PRIMARY KEY (NAME)
);

-- Procedures
create or replace procedure JAWS_OWNER.MERGE_NOTIFICATION_HISTORY_WITH_LOCK (
    nameIn in varchar2, dateIn in timestamp with local time zone, updateIn in char, typeIn varchar2,
    noteIn varchar2, sevrIn varchar2, statIn varchar2, errorIn varchar2) as
    var1 integer;
begin
    insert
    when not exists (select 1 from JAWS_OWNER.NOTIFICATION_NAME where name = nameIn)
    then
    into JAWS_OWNER.NOTIFICATION_NAME (name) select nameIn from dual;

    -- Lock parent row with for update
    select 1 into var1 from JAWS_OWNER.NOTIFICATION_NAME where name = nameIn for update;

    if updateIn = 'Y' then
        update JAWS_OWNER.NOTIFICATION_HISTORY set active_end = dateIn where name = nameIn and active_end is null and
            not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_end = dateIn);
    else
        insert
        when not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_end is null) and
             not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_start = dateIn)
        then
        into JAWS_OWNER.NOTIFICATION_HISTORY (name, active_start, active_end, activation_type, activation_note,
                                              activation_sevr, activation_stat, activation_error) select
                                              nameIn, dateIn, null, typeIn, noteIn, sevrIn, statIn, errorIn from dual;
    end if;
end;
/

create or replace procedure JAWS_OWNER.MERGE_NOTIFICATION_HISTORY (
    nameIn in varchar2, dateIn in timestamp with local time zone, updateIn in char, typeIn varchar2,
    noteIn varchar2, sevrIn varchar2, statIn varchar2, errorIn varchar2) as
begin
    if updateIn = 'Y' then
        update JAWS_OWNER.NOTIFICATION_HISTORY set active_end = dateIn where name = nameIn and active_end is null and
               not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_end = dateIn);
    else
        insert
            when not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_end is null) and
                 not exists (select 1 from JAWS_OWNER.NOTIFICATION_HISTORY where name = nameIn and active_start = dateIn)
            then
            into JAWS_OWNER.NOTIFICATION_HISTORY (name, active_start, active_end, activation_type, activation_note,
                                                  activation_sevr, activation_stat, activation_error) select
                                                   nameIn, dateIn, null, typeIn, noteIn, sevrIn, statIn, errorIn from dual;
    end if;
end;
/