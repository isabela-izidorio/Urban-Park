# UrbanPark | Sistema de Gestão de Estacionamento Rotativo

Plataforma desenvolvida para automatizar a gestão, fiscalização e controle de permanência em vagas de estacionamento rotativo.

Esta é uma **implementação inicial** focada nas partes principais descritas na documentação:
- ⚙️ **API:** Estrutura central para gerenciamento de dados e integração de serviços.
- 🗺️ **Painel Visual de Vagas:** Interface para monitoramento e consulta da disponibilidade de vagas em tempo real.

> **Projeto Acadêmico** | Desenvolvido para a disciplina de Projeto de Tecnologia Informação e Comunicação.<br>
Novas implementações e expansões do escopo poderão ser integradas no futuro.

---

### Escopo da Implementação Inicial

- **API de Gerenciamento:** Processamento e integração das regras do sistema.
- **Monitoramento e Controle de Ocupação:** Consulta visual de disponibilidade das vagas.

### Fluxo de Trabalho e Branches (Gitflow)

O desenvolvimento segue o padrão **Gitflow** para garantir a estabilidade do código e organização da equipe:

#### Branches Principais

- **`main`:** Armazena o código estável e pronto para produção. Recebe integrações vindas das branches de `release` e `hotfix`.
- **`develop`:** Branch central de integração para o desenvolvimento de novas funcionalidades.

#### Branches de Suporte

- **`feature/*`:** Criadas a partir de `develop` para o desenvolvimento isolado de novas funcionalidades (ex: `feature/api-vagas`).
- **`release/*`:** Criadas a partir de `develop` para a fase de testes finais, pequenos ajustes e homologação antes de integrar com a `main` e com a `develop`.
- **`hotfix/*`:** Criadas a partir da `main` para correções urgentes diretamente no ambiente de produção.

