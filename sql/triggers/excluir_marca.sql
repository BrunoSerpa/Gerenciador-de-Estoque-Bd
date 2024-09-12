CREATE OR REPLACE FUNCTION deletarMarca()
RETURNS TRIGGER AS $$ BEGIN
IF NOT EXISTS (
    SELECT 1 FROM
        Produto
    WHERE
        id_marca = OLD.id_marca
) THEN
DELETE FROM
    Marca
WHERE
    id = OLD.id_marca;

END IF;

RETURN OLD;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER deletarMarca
AFTER
    DELETE ON Produto FOR EACH ROW
    WHEN (OLD.id_marca IS NOT NULL) EXECUTE FUNCTION deletarMarca();