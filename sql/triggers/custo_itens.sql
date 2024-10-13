CREATE FUNCTION somaCustoCadastro()
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

CREATE FUNCTION somaCustoVenda()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Venda
SET
    custo_itens = custo_itens + NEW.preco
WHERE
    id = NEW.id_cadastro;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;;

CREATE FUNCTION subtraiCustoCadastro()
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

CREATE FUNCTION subtraiCustoVenda()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Venda
SET
    custo_itens = custo_itens - OLD.preco
WHERE
    id = OLD.id_cadastro;
RETURN OLD;

END;

$$ LANGUAGE plpgsql;;

CREATE FUNCTION atualizarCustoCadastro()
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

CREATE FUNCTION atualizarCustoVenda()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Venda
SET
    custo_itens = custo_itens - OLD.preco + NEW.preco
WHERE
    id = NEW.id_cadastro;
RETURN NEW;

END;

$$ LANGUAGE plpgsql;;

CREATE TRIGGER incrementarTotalCustoCadastro
    AFTER INSERT
    ON Item FOR EACH ROW
    WHEN (NEW.id_cadastro IS NOT NULL)
    EXECUTE FUNCTION somaCustoCadastro();

CREATE TRIGGER incrementarTotalCustoVenda
    AFTER INSERT
    ON Item FOR EACH ROW
    WHEN (NEW.id_venda IS NOT NULL)
    EXECUTE FUNCTION somaCustoVenda();

CREATE TRIGGER decrementarTotalCustoCadastro
    AFTER DELETE
    ON Item FOR EACH ROW
    WHEN (OLD.id_cadastro IS NOT NULL)
    EXECUTE FUNCTION subtraiCustoCadastro();

CREATE TRIGGER decrementarTotalCustoVenda
    AFTER DELETE
    ON Item FOR EACH ROW
    WHEN (OLD.id_venda IS NOT NULL)
    EXECUTE FUNCTION subtraiCustoVenda();

CREATE TRIGGER atualizarTotalCustoCadastro
    AFTER UPDATE
    OF preco ON Item
    FOR EACH ROW
    WHEN (NEW.id_cadastro IS NOT NULL)
    EXECUTE FUNCTION atualizarCustoCadastro();

CREATE TRIGGER atualizarTotalCustoVenda
    AFTER UPDATE
    OF preco ON Item FOR EACH ROW
    WHEN (NEW.id_venda IS NOT NULL)
    EXECUTE FUNCTION atualizarCustoVenda();