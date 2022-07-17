--Controllo privilegi

CREATE USER alice;
CREATE USER roberto;

GRANT insert ON socialmarket.compra TO roberto
GRANT insert ON socialmarket.rifornisce TO roberto
GRANT select ON socialmarket.turni TO roberto
GRANT update ON socialmarket.prodotto TO roberto


GRANT select ON socialmarket.recapito to alice
GRANT select ON socialmarket.volontario to alice

GRANT ALL PRIVILEGES ON socialmarket.rifornisce,socialmarket.cliente, socialmarket.turni,socialmarket.donatore, socialmarket.prodotto,socialmarket.prodotto TO alice
WITH GRANT OPTION;