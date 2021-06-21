-- customers
-- customers table creation
CREATE TABLE IF NOT EXISTS public.customers
(
    customer_id bigint NOT NULL,
    customer_name character varying(250),
    phone_number character varying(100),
    address_1 character varying(250),
    address_2 character varying(250),
    address_city character varying(100),
    address_state character varying(100),
    address_postal character varying(100),
    address_country character varying(100),
    territory character varying(100),
    last_name character varying(100),
    first_name character varying(100),
    PRIMARY KEY (customer_id)
);

ALTER TABLE public.customers
    OWNER to postgres;


-- products
-- products table creation
CREATE TABLE IF NOT EXISTS public.products
(
    product_id character varying(25) NOT NULL,
    product_line character varying(250) NOT NULL,
    msrp integer NOT NULL,
    PRIMARY KEY (product_id)
);

ALTER TABLE public.products
    OWNER to postgres;



-- sales
-- create sales data types
DO $$ BEGIN
    CREATE TYPE deal_size_type AS ENUM('Small', 'Medium', 'Large');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE status_type AS enum('Shipped', 'In Process', 'Cancelled', 'Disputed', 'On Hold', 'Resolved');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- sales table creation
CREATE TABLE IF NOT EXISTS public.sales
(
    order_id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price decimal(12,2) NOT NULL,
    line_item integer NOT NULL,
    deal_size deal_size_type NOT NULL,
    order_date timestamp without time zone NOT NULL,
    status status_type NOT NULL,
    quarter smallint NOT NULL,
    month_num smallint NOT NULL,
    year smallint NOT NULL,
    product_id character varying(25) NOT NULL,
    customer_id bigint NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

ALTER TABLE public.sales
    OWNER to postgres;
