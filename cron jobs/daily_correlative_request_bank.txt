CREATE SEQUENCE daily_correlative_request_bank
INCREMENT BY 1  -- Define el incremento entre cada número de la secuencia
START WITH 1    -- Define el primer valor de la secuencia
NO MINVALUE     -- No se especifica un valor mínimo
NO MAXVALUE     -- No se especifica un valor máximo
CACHE 1;        -- Especifica cuántos números de secuencia guardar en caché

SELECT NEXTVAL('daily_correlative_request_bank') AS correlativetoday;

ALTER SEQUENCE daily_correlative_request_bank RESTART;