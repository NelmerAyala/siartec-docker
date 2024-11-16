CREATE SEQUENCE annual_correlative_tax_stamps
  INCREMENT BY 1  -- Define el incremento entre cada número de la secuencia
  START WITH 1    -- Define el primer valor de la secuencia
  NO MINVALUE     -- No se especifica un valor mínimo
  NO MAXVALUE     -- No se especifica un valor máximo
  CACHE 1;        -- Especifica cuántos números de secuencia guardar en caché
  
SELECT NEXTVAL('annual_correlative_tax_stamps') AS correlativetoday;
 
ALTER SEQUENCE annual_correlative_tax_stamps RESTART;