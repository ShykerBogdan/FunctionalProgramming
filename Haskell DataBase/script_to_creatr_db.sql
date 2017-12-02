create database if not exists haskell;

use haskell;

create table if not exists people (
	id int primary key auto_increment not null,
    name varchar(50) unique not null,
    dateOfBirdth date not null
);

CREATE TABLE if not exists phones (
	name varchar(50) NOT NULL,
    phone_number varchar(50) unique NOT NULL,
    constraint foreign key(name) references people(name) on delete cascade on update cascade
);

CREATE TABLE if not exists meets (
	id int primary key auto_increment not null,
	dateWithTime datetime not null,
    meetingPoint varchar(50) NOT NULL,
	description varchar(50) NOT NULL,
    isHappened bool NOT NULL,
    constraint foreign key(id) references people(id) on delete cascade on update cascade
);
 
 select people.name, phone_number, day(dateOfBirdth) as BDay, month(dateOfBirdth) as BMonth, day(dateWithTime) as Day, month(dateWithTime) as Month, hour(dateWithTime) as Hour, minute(dateWithTime) as Minutes, meets.description, meets.meetingPoint, meets.isHappened from people left join phones on people.name = phones.name left join meets on people.id = meets.id;
 
 drop table meets;