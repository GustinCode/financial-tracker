🗂️ BACKLOG JIRA — App de Gerenciamento Financeiro
EPIC 01 — Onboarding & Autenticação
US-101 — Criar conta com e-mail e senha

Como usuário
Quero criar uma conta usando e-mail e senha
Para acessar o app de forma segura

Critérios de Aceite

Deve validar formato do e-mail.

Senha deve ter mínimo de 8 caracteres.

Exibir mensagens claras de erro.

Registrar usuário no backend e manter sessão ativa após criação.

US-102 — Fazer login com e-mail e senha

Como usuário
Quero fazer login
Para acessar meus dados

Critérios de Aceite

Login deve verificar credenciais e retornar token.

Exibir mensagem para credenciais inválidas.

Manter sessão com refresh automático.

US-103 — Recuperar senha

Como usuário
Quero redefinir a senha
Para recuperar acesso ao app

Critérios de Aceite

Enviar e-mail com link/token.

Permitir criar nova senha.

Notificar o usuário após redefinir.

US-104 — Login com biometria

Como usuário
Quero acessar com biometria (digital/face)
Para entrar rapidamente

Critérios de Aceite

Solicitar permissão do dispositivo.

Biometria deve substituir o e-mail/senha após configurado.

EPIC 02 — Gestão de Transações
US-201 — Registrar transação manualmente

Como usuário
Quero adicionar uma transação manualmente
Para manter controle das minhas finanças

Critérios de Aceite

Campos obrigatórios: valor, tipo (entrada/saída), categoria, data.

Campos opcionais: notas, tags, conta.

Atualizar saldo imediatamente após salvar.

US-202 — Editar transação

Como usuário
Quero editar uma transação existente
Para corrigir informações

Critérios de Aceite

Deve permitir alterar qualquer campo.

Atualizar saldo e relatórios após edição.

US-203 — Excluir transação

Como usuário
Quero excluir uma transação
Para remover dados errados

Critérios de Aceite

Exigir confirmação antes de excluir.

Atualizar saldo automaticamente.

US-204 — Importar transações via arquivo CSV

Como usuário
Quero importar transações usando CSV
Para agilizar o registro de dados

Critérios de Aceite

Validar formato do arquivo.

Mostrar pré-visualização antes de importar.

Permitir corrigir categorias antes de finalizar.

US-205 — Listar transações

Como usuário
Quero visualizar todas as minhas transações
Para acompanhar gastos e entradas

Critérios de Aceite

Permitir filtrar por categoria, período e conta.

Permitir buscar por palavra-chave.

EPIC 03 — Integração Financeira / Open Finance (Pós-MVP)
US-301 — Conectar conta bancária

Como usuário
Quero conectar minha conta bancária ao app
Para importar transações automaticamente

Critérios de Aceite

Exibir tela de consentimento claro.

Registrar quando o consentimento expira.

Mostrar status da conexão.

US-302 — Importar transações automaticamente

Como usuário
Quero ver transações atualizadas
Para não precisar registrar manualmente

Critérios de Aceite

Importar novas transações diariamente.

Evitar duplicatas.

Log de erros visível ao usuário.

US-303 — Notificar expiração de conexão

Como usuário
Quero ser avisado quando a conexão expirar
Para não perder importações bancárias

Critérios de Aceite

Enviar push + aviso dentro do app.

Botão “reconectar” deve ser exibido.

EPIC 04 — Orçamentos e Metas
US-401 — Criar orçamento mensal por categoria

Como usuário
Quero definir limites de gasto por categoria
Para ter controle mensal

Critérios de Aceite

Usuário escolhe categoria e valor limite.

Exibir barra de progresso.

Alertar quando atingir 80% e 100%.

US-402 — Criar metas financeiras

Como usuário
Quero criar metas (ex: juntar R$5000)
Para acompanhar meu progresso

Critérios de Aceite

Definir valor e prazo estimado.

Exibir progresso atualizado automaticamente.

Permitir vincular transações de poupança.

EPIC 05 — Dashboard & Relatórios
US-501 — Exibir saldo geral

Como usuário
Quero ver meu saldo consolidado
Para entender minha situação financeira

Critérios de Aceite

Considerar todas as contas e transações.

Atualização em tempo real.

US-502 — Gráfico mensal de gastos e entradas

Como usuário
Quero visualizar gráficos mensais
Para comparar períodos

Critérios de Aceite

Gráfico de barras ou linha.

Permitir selecionar o mês.

Atualização automática.

US-503 — Comparar meses anteriores

Como usuário
Quero comparar períodos
Para medir melhora ou piora financeira

Critérios de Aceite

Exibir diferença percentual entre meses.

Mostrar categorias que mais variaram.

EPIC 06 — Privacidade, Segurança & LGPD
US-601 — Tela de consentimento de dados

Como usuário
Quero ver exatamente quais dados o app usa
Para ter segurança sobre minha privacidade

Critérios de Aceite

Texto claro sobre retenção e finalidade.

“Aceitar” e “Não aceitar”.

Rejeitar impede funcionalidades que precisam dos dados.

US-602 — Revogar consentimento

Como usuário
Quero remover permissões
Para ter controle dos meus dados

Critérios de Aceite

Revogação deve interromper coletas.

Notificar o usuário das consequências.

US-603 — Solicitar exclusão da conta

Como usuário
Quero poder deletar minha conta
Para remover todos meus dados

Critérios de Aceite

Exige confirmação.

Excluir dados local e backend.

Enviar e-mail confirmando encerramento.

EPIC 07 — Notificações
US-701 — Alertar sobre orçamento estourado

Como usuário
Quero receber alerta quando ultrapassar orçamento
Para ajustar meus gastos

Critérios de Aceite

Notificação push + alerta no app.

Mostrar categoria responsável.

US-702 — Alertar movimentações suspeitas

Como usuário
Quero ser avisado sobre valores incomuns
Para evitar fraudes

Critérios de Aceite

Detectar variações incomuns de gasto.

Permitir marcar notificação como “ok” ou “pendente”.

EPIC 08 — Exportação de Dados
US-801 — Exportar transações em CSV

Como usuário
Quero exportar meus dados em CSV
Para usar fora do app

Critérios de Aceite

Selecionar período.

Gerar arquivo e permitir download/compartilhar.

US-802 — Exportar relatório PDF

Como usuário
Quero gerar PDF do extrato ou gráfico
Para usar em auditorias e controles pessoais

Critérios de Aceite

PDF com logo, data e resumo.

Disponível para salvar ou enviar.

EPIC 09 — Suporte & Confiabilidade
US-901 — Central de ajuda

Como usuário
Quero acessar uma base de conhecimento
Para resolver dúvidas rapidamente

Critérios de Aceite

Artigos categorizados.

Busca por palavras-chave.

US-902 — Suporte via formulário

Como usuário
Quero abrir chamados
Para solicitar ajuda

Critérios de Aceite

Enviar descrição + anexos.

Receber protocolo e resposta.