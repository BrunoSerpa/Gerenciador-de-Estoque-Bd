CREATE OR REPLACE FUNCTION adicionarItem()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Produto
SET
    quantidade = quantidade + 1
WHERE
    id = NEW.id_produto;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;;

CREATE OR REPLACE FUNCTION removerItem()
RETURNS TRIGGER AS $$ BEGIN
UPDATE
    Produto
SET
    quantidade = quantidade - 1
WHERE
    id = OLD.id_produto;

RETURN OLD;

END;

$$ LANGUAGE plpgsql;;

CREATE TRIGGER incrementarQuantidade
AFTER
    INSERT ON Item FOR EACH ROW
    WHEN (NEW.id_produto IS NOT NULL)
    WHEN (NEW.id_venda IS NULL)
    EXECUTE FUNCTION adicionarItem();

CREATE TRIGGER decrementarQuantidade
AFTER
    DELETE ON Item FOR EACH ROW
    WHEN (OLD.id_produto IS NOT NULL)
    WHEN (NEW.id_venda IS NULL)
    EXECUTE FUNCTION removerItem();

CREATE TRIGGER atualizarQuantidadeParaAdicionar
AFTER UPDATE OF id_venda ON Item
FOR EACH ROW
WHEN (NEW.id_venda IS NULL AND OLD.id_venda IS NOT NULL)
EXECUTE FUNCTION adicionarItem();

CREATE TRIGGER atualizarQuantidadeParaRemover
AFTER UPDATE OF id_venda ON Item
FOR EACH ROW
WHEN (NEW.id_venda IS NOT NULL AND OLD.id_venda IS NULL)
EXECUTE FUNCTION removerItem();