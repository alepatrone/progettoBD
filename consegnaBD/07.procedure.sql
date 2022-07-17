
--scarico inventario
CREATE FUNCTION scarico_inventario()
RETURNS void
AS
$$ 

declare 
	randVolontario varchar(14);
begin


randVolontario:= (SELECT codicefiscale FROM socialmarket.volontario  		--scelta randomica di un volontario dalla tabella dei volontari
ORDER BY RANDOM()  
LIMIT 1);


INSERT INTO socialmarket.scarica (codicefiscale,dataora,nome, scadenza,quantita)
SELECT randVolontario,CURRENT_TIMESTAMP, nome, scadenza, quantita FROM socialmarket.prodotto
where scadenza <= CURRENT_TIMESTAMP;
end;
$$

LANGUAGE plpgsql ;


--turnicheck

CREATE FUNCTION turni_check(volontario varchar(14),data1 TIMESTAMP, data2 TIMESTAMP)
RETURNS SETOF socialmarket.turni
AS
$$ 

begin

RETURN QUERY EXECUTE '										
SELECT *
FROM socialmarket.turni
WHERE (codicefiscale = $1 AND  dataora >= $2 AND dataora <= $3)' USING volontario,data1,data2 ;		--dato un volontario e due date, determino i turni assegnati al volontario in quel periodo

end;
$$

LANGUAGE plpgsql ;
