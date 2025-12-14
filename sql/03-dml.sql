INSERT INTO dim_customer (
    customer_id, first_name, last_name, age, email, country, postal_code
)
SELECT
    sale_customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code
FROM (
    SELECT DISTINCT ON (sale_customer_id)
        sale_customer_id,
        customer_first_name,
        customer_last_name,
        customer_age,
        customer_email,
        customer_country,
        customer_postal_code
    FROM mock_data WHERE sale_customer_id IS NOT NULL
) ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dim_product (
    product_id, name, category, weight, color, size, brand,
    material, description, rating, reviews, release_date,
    expiry_date, price
)
SELECT
    sale_product_id,
    product_name,
    product_category,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    product_price
FROM (
    SELECT DISTINCT ON (sale_product_id)
        sale_product_id,
        product_name,
        product_category,
        product_weight,
        product_color,
        product_size,
        product_brand,
        product_material,
        product_description,
        product_rating,
        product_reviews,
        product_release_date,
        product_expiry_date,
        product_price
    FROM mock_data WHERE sale_product_id IS NOT NULL
) ON CONFLICT (product_id) DO NOTHING;

INSERT INTO dim_seller (
    seller_id, first_name, last_name, email, country, postal_code
)
SELECT
    sale_seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM (
    SELECT DISTINCT ON (sale_seller_id)
        sale_seller_id,
        seller_first_name,
        seller_last_name,
        seller_email,
        seller_country,
        seller_postal_code
    FROM mock_data WHERE sale_seller_id IS NOT NULL
) ON CONFLICT (seller_id) DO NOTHING;

INSERT INTO dim_store (
    name, location, city, state, country, phone, email
)
SELECT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM (
    SELECT DISTINCT ON (store_name)
        store_name,
        store_location,
        store_city,
        store_state,
        store_country,
        store_phone,
        store_email
    FROM mock_data WHERE store_name IS NOT NULL
) ON CONFLICT (name) DO NOTHING;

INSERT INTO dim_supplier (
    name, contact, email, phone, address, city, country
)
SELECT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM (
    SELECT DISTINCT ON (supplier_name)
        supplier_name,
        supplier_contact,
        supplier_email,
        supplier_phone,
        supplier_address,
        supplier_city,
        supplier_country
    FROM mock_data WHERE supplier_name IS NOT NULL
) ON CONFLICT (name) DO NOTHING;

INSERT INTO fact_sales (
    customer_sk,
    seller_sk,
    product_sk,
    store_sk,
    supplier_sk,
    sale_date,
    sale_quantity,
    sale_total_price
)
SELECT
    d_c.customer_sk,
    d_s.seller_sk,
    d_p.product_sk,
    d_st.store_sk,
    d_sup.supplier_sk,
    mock.sale_date,
    mock.sale_quantity,
    mock.sale_total_price
FROM mock_data mock
JOIN dim_customer d_c ON mock.sale_customer_id = d_c.customer_id
JOIN dim_seller d_s ON mock.sale_seller_id = d_s.seller_id
JOIN dim_product d_p ON mock.sale_product_id = d_p.product_id
JOIN dim_store d_st ON mock.store_name = d_st.name
JOIN dim_supplier d_sup ON mock.supplier_name = d_sup.name
WHERE mock.sale_customer_id IS NOT NULL AND mock.sale_seller_id IS NOT NULL AND mock.sale_product_id IS NOT NULL;