CREATE OR REPLACE FUNCTION somaCusto()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Cadastro
SET
    custo_itens = custo_itens + NEW.preco
WHERE
    id = NEW.id_cadastro;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;;

CREATE OR REPLACE FUNCTION subtraiCusto()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Cadastro
SET
    custo_itens = custo_itens - OLD.preco
WHERE
    id = OLD.id_cadastro;
RETURN OLD;

END;

$$ LANGUAGE plpgsql;;

CREATE OR REPLACE FUNCTION atualizarCusto()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Cadastro
SET
    custo_itens = custo_itens - OLD.preco + NEW.preco
WHERE
    id = NEW.id_cadastro;
RETURN NEW;

END;

$$ LANGUAGE plpgsql;;

CREATE TRIGGER incrementarTotalCustoCadastro
AFTER
    INSERT ON Item FOR EACH ROW
    WHEN (NEW.id_cadastro IS NOT NULL) EXECUTE FUNCTION somaCusto();

CREATE TRIGGER decrementarTotalCustoCadastro
AFTER
    DELETE ON Item FOR EACH ROW
    WHEN (OLD.id_cadastro IS NOT NULL) EXECUTE FUNCTION subtraiCusto();

CREATE TRIGGER atualizarTotalCustoCadastro
AFTER
    UPDATE OF preco ON Item FOR EACH ROW
    WHEN (NEW.id_cadastro IS NOT NULL) EXECUTE FUNCTION atualizarCusto();