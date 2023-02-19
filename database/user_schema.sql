-- need to install extention to use uuid data type
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- create user table
CREATE TABLE user_info (
    user_id UUID DEFAULT uuid_generate_v4 (),
    username TEXT,
    user_password TEXT,
    info TEXT,
    PRIMARY KEY (user_id)
);