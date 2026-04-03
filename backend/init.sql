create database kltn;
Create table users(
	id bigint auto_increment primary key,
    email varchar(255) not null,
    
    password_hash varchar(255) null,
    is_active boolean not null default true,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    email_verified_at DATETIME NULL,
    create_at datetime not null default current_timestamp,
    update_at datetime not null default current_timestamp on update current_timestamp,
    
    constraint uq_users_email unique(email)
);

Create table external_logins(
	id bigint auto_increment primary key,
    
    user_id bigint not null,
    provider varchar(50) not null,
    provider_user_id varchar(255) not null,
    create_at datetime not null default current_timestamp,
    email varchar(255) not null,
    
    constraint fk_external_users
		foreign key(user_id) references users(id)
        on delete cascade,
        
	constraint uq_provider_user unique (provider, provider_user_id)
);

create table passkeys(
	id bigint auto_increment primary key,
    user_id bigint not null,
    credential_id text not null,
    public_key text not null,
    sign_count int not null default 0,
    device_name varchar(255) null,
    create_at datetime not null default current_timestamp,
    constraint fk_passkey_user
		foreign key (user_id) references users(id)
        on delete cascade,
	constraint uq_credential unique (credential_id(255))
);

create table refresh_token(
	id bigint auto_increment primary key,
    user_id bigint not null,
    token_hash varchar(255) not null,
    expires_at datetime not null,
    is_revoked boolean not null default false,
    revoked_at datetime null,
    device_info varchar(255) null,
    ip_address varchar(255) null,
    create_at datetime not null default current_timestamp,
    constraint fk_refresh_user
		foreign key (user_id) references users(id)
        on delete cascade,
	constraint uq_refresh_token unique (token_hash)
);

create table sessions(
	id bigint auto_increment primary key,
    user_id bigint not null,
    refresh_token_id bigint not null,
    device_info varchar(255) null,
    ip_address varchar(255) null,
    last_active_at datetime not null default current_timestamp,
    create_at datetime not null default current_timestamp,
    constraint fk_session_user
		foreign key (user_id) references users(id)
        on delete cascade,
	constraint fk_session_refresh
		foreign key (refresh_token_id) references refresh_token(id)
        on delete cascade
);

create table password_reset_tokens(
	id bigint auto_increment primary key,
    user_id bigint not null,
    token_hash varchar(255) not null,
    expires_at datetime not null,
    is_used boolean not null default false,
    create_at datetime not null default current_timestamp,
    constraint fk_reset_user
		foreign key (user_id) references users(id)
        on delete cascade,
	constraint uq_reset_token unique (token_hash)
);

create table email_verification_tokens(
	id bigint auto_increment primary key,
    user_id bigint not null,
    token varchar(255) not null,
    expires_at datetime not null,
    used boolean not null default false,
    created_at datetime not null default current_timestamp,

    constraint fk_ev_user foreign key(user_id) references users(id) on delete cascade,
    constraint uq_ev_token unique(token)
);

CREATE INDEX idx_refresh_user ON refresh_token(user_id);
CREATE INDEX idx_session_user ON sessions(user_id);
CREATE INDEX idx_passkey_user ON passkeys(user_id);
CREATE INDEX idx_external_user ON external_logins(user_id);

create table roles(
    id bigint auto_increment primary key,

    name varchar(50) not null,
    description varchar(255),

    create_at datetime default current_timestamp,

    constraint uq_role_name unique(name)
);
create table user_roles(
    user_id bigint not null,
    role_id bigint not null,

    primary key(user_id, role_id),

    constraint fk_userrole_user
        foreign key(user_id) references users(id)
        on delete cascade,

    constraint fk_userrole_role
        foreign key(role_id) references roles(id)
        on delete cascade
);

create table user_profiles(
    id bigint auto_increment primary key,
    user_id bigint not null,
    full_name varchar(255),
    phone varchar(20),
    avatar_url varchar(500),
    date_of_birth date,
    gender varchar(10),

    create_at datetime default current_timestamp,
    update_at datetime default current_timestamp on update current_timestamp,

    constraint fk_profile_user
        foreign key(user_id) references users(id)
        on delete cascade
);
create table user_addresses(
    id bigint auto_increment primary key,
    user_id bigint not null,

    receiver_name varchar(255),
    phone varchar(20),

    province varchar(100),
    district varchar(100),
    ward varchar(100),
    address_detail varchar(255),

    is_default boolean default false,

    create_at datetime default current_timestamp,

    constraint fk_address_user
        foreign key(user_id) references users(id)
        on delete cascade
);
create table categories(
    id bigint auto_increment primary key,

    name varchar(255) not null,
    slug varchar(255) unique,
    description text,

    parent_id bigint null,

    create_at datetime default current_timestamp,

    constraint fk_category_parent
        foreign key(parent_id) references categories(id)
        on delete set null
);
create table products(
    id bigint auto_increment primary key,

    name varchar(255) not null,
    slug varchar(255) unique,

    category_id bigint not null,

    brand varchar(100),
    description text,

    price decimal(12,2) not null,
    discount_price decimal(12,2) null,

    thumbnail varchar(500),

    rating_avg decimal(3,2) default 0,
    rating_count int default 0,

    is_active boolean default true,

    create_at datetime default current_timestamp,
    update_at datetime default current_timestamp on update current_timestamp,

    constraint fk_product_category
        foreign key(category_id) references categories(id)
);
create table product_images(
    id bigint auto_increment primary key,

    product_id bigint not null,
    image_url varchar(500) not null,

    is_main boolean default false,
    sort_order int default 0,

    constraint fk_product_image
        foreign key(product_id) references products(id)
        on delete cascade
);
create table product_specifications(
    id bigint auto_increment primary key,

    product_id bigint not null,

    spec_name varchar(255),
    spec_value varchar(255),

    constraint fk_spec_product
        foreign key(product_id) references products(id)
        on delete cascade
);
create table carts(
    id bigint auto_increment primary key,
    user_id bigint not null,

    create_at datetime default current_timestamp,

    constraint fk_cart_user
        foreign key(user_id) references users(id)
        on delete cascade
);
create table cart_items(
    id bigint auto_increment primary key,

    cart_id bigint not null,
    product_id bigint not null,

    quantity int not null,

    constraint fk_cartitem_cart
        foreign key(cart_id) references carts(id)
        on delete cascade,

    constraint fk_cartitem_product
        foreign key(product_id) references products(id)
);
create table orders(
    id bigint auto_increment primary key,

    user_id bigint not null,

    address_id bigint not null,

    total_amount decimal(12,2),

    status varchar(50) not null,

    payment_method varchar(50),
    payment_status varchar(50),

    create_at datetime default current_timestamp,

    constraint fk_order_user
        foreign key(user_id) references users(id),

    constraint fk_order_address
        foreign key(address_id) references user_addresses(id)
);
create table order_items(
    id bigint auto_increment primary key,

    order_id bigint not null,
    product_id bigint not null,

    price decimal(12,2),
    quantity int,

    constraint fk_orderitem_order
        foreign key(order_id) references orders(id)
        on delete cascade,

    constraint fk_orderitem_product
        foreign key(product_id) references products(id)
);
create table payments(
    id bigint auto_increment primary key,

    order_id bigint not null,

    payment_method varchar(50),
    amount decimal(12,2),

    status varchar(50),

    transaction_id varchar(255),

    create_at datetime default current_timestamp,

    constraint fk_payment_order
        foreign key(order_id) references orders(id)
);
create table inventory(
    id bigint auto_increment primary key,

    product_id bigint not null,

    quantity int not null,

    last_updated datetime default current_timestamp on update current_timestamp,

    constraint fk_inventory_product
        foreign key(product_id) references products(id)
);
create table inventory_logs(
    id bigint auto_increment primary key,

    product_id bigint not null,

    change_type varchar(50), 
    -- import / export / order

    quantity_change int,

    note varchar(255),

    create_at datetime default current_timestamp,

    constraint fk_inventorylog_product
        foreign key(product_id) references products(id)
);
create table reviews(
    id bigint auto_increment primary key,

    product_id bigint not null,
    user_id bigint not null,

    rating int,
    comment text,

    create_at datetime default current_timestamp,

    constraint fk_review_product
        foreign key(product_id) references products(id),

    constraint fk_review_user
        foreign key(user_id) references users(id)
);
create table ai_chat_sessions(
    id bigint auto_increment primary key,

    user_id bigint,

    create_at datetime default current_timestamp,

    constraint fk_ai_chat_user
        foreign key(user_id) references users(id)
        on delete set null
);
create table ai_chat_messages(
    id bigint auto_increment primary key,

    session_id bigint not null,

    role varchar(20), 
    -- user / assistant

    message text,

    create_at datetime default current_timestamp,

    constraint fk_ai_message_session
        foreign key(session_id) references ai_chat_sessions(id)
        on delete cascade
);
create table product_embeddings(
    product_id bigint primary key,

    embedding json,

    created_at datetime default current_timestamp,

    constraint fk_embedding_product
        foreign key(product_id) references products(id)
        on delete cascade
);
create table ai_recommendations(
    id bigint auto_increment primary key,

    user_id bigint,
    product_id bigint,

    score float,

    create_at datetime default current_timestamp
);
create table product_views(
    id bigint auto_increment primary key,

    product_id bigint,
    user_id bigint,

    view_time datetime default current_timestamp
);

