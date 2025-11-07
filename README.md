# Minimundo
-- README.md
-- Projeto: Modelagem de Banco de Dados - Mini-mundo: Ótica / Loja de Óculos (Turma_005)
-- Autor: Samuel Alves Doria (exemplo)
-- Conteúdo: scripts SQL para criação do esquema, inserção de dados, consultas (SELECT), updates e deletes.
-- Instruções: copiar as seções para arquivos separados ou executar este arquivo completo em MySQL Workbench ou PGAdmin (Postgres minor adaptações: `AUTO_INCREMENT` -> `SERIAL`, `ENGINE`/`CHARSET` removidos).

/* ==============================
   6 - README rápido (instruções para GitHub)
   ============================== */
-- Sugestão de organização de arquivos para o repositório GitHub:
-- /sql/
--   01_create_tables.sql    (contendo apenas os CREATE TABLE e DROPs iniciais)
--   02_insert_data.sql      (contendo os INSERTs populando as tabelas)
--   03_queries.sql          (contendo os SELECTs pedidos)
--   04_updates_deletes.sql  (contendo UPDATEs e DELETEs)
--   05_transactions.sql     (exemplos de transações e procedimentos)
-- README.md                (instruções de execução, dependências e contato)

-- Observações finais:
-- - Se for usar PostgreSQL, trocar AUTO_INCREMENT por SERIAL, LAST_INSERT_ID() por RETURNING id, e ajustar tipos/funcionalidades.
-- - Para testes em MySQL Workbench: abra um novo SQL script, cole o conteúdo por partes (create -> inserts -> queries) para evitar constraints temporárias.

-- FIM
