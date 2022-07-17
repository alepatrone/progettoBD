--- Transaction

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM socialmarket.prodotto
WHERE nome = 'Assorted Desserts';

UPDATE socialmarket.prodotto
SET quantita= quantita + 5
WHERE nome = 'Assorted Desserts';

SELECT nome, quantita
FROM socialmarket.prodotto
WHERE nome = 'Assorted Desserts' OR quantita = '100';

COMMIT;
