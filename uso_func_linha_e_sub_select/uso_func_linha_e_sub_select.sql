select
    a.nr_sequencia,
    c.nr_seq_fila_espera nr_seq_fila,
    c.dt_saida dt_transferencia,
    a.nr_prioridade,
    a.nr_sequencia nr_sequencia,
    a.cd_senha_gerada cd_senha,
    a.dt_inutilizacao dt_inutilizacao,
	c.dt_entrada dt_entrada,
	nvl(c.dt_saida, a.dt_fim_atendimento) dt_saida,
	a.dt_fim_atendimento dt_fim_atendimento,
	b.ie_perm_transf_sem_atend,
	a.dt_vinculacao_senha,
	a.nm_usuario_inutilizacao,
	a.ds_maquina_inutilizacao,
	a.dt_primeira_chamada dt_primeira_chamada,
	c.nm_usuario_chamada nm_usuario_chamada,
	a.qt_chamadas qt_chamadas,
	e.nr_atendimento,
    nvl(b.qt_tempo_medio,0) qt_tempo_medio,
    nvl(b.qt_tempo_maximo,0) qt_tempo_maximo,
    busca_ultima_transf(c.nr_seq_pac_senha_fila, c.nr_seq_fila_espera, c.dt_atualizacao) testando,
	substr(obter_tempo_atend_senhas_an(a.nr_sequencia,c.nr_sequencia,'HH'),1,30) qt_tempo_atendimento,
	substr(obter_tempo_atend_senhas_an(a.nr_sequencia,c.nr_sequencia,'MM'),1,30) qt_tempo_atendimento_min,
	substr(obter_clinica_atend(e.nr_atendimento,'D'), 1, 100) ds_clinica,
--utilização funções de linhas simples aninhadas
    substr(obter_letra_verifacao_senha(nvl(a.nr_seq_fila_senha_origem, a.nr_seq_fila_senha)),1,10) || a.cd_senha_gerada cd_senha_gerada,
    substr(obter_desc_fila(c.nr_seq_fila_espera), 1, 255) ds_fila,	
    substr(obter_dif_data(c.dt_entrada,(obter_data_atend_senha(a.nr_sequencia,'AF',c.nr_seq_fila_espera)),''),1,10) qt_tempo_espera,
    substr(obter_dif_espera_senha_min(a.nr_sequencia, 'A', obter_data_atend_senha(a.nr_sequencia,'I')), 1, 10) qt_tempo_espera_min,
    substr(obter_dif_espera_senha(a.nr_sequencia, 'H', obter_data_atend_senha(a.nr_sequencia,'F')), 1, 10) qt_tempo_hospital,
    substr(nvl(obter_min_entre_datas(a.dt_entrada_fila, sysdate,1),0),1,30) qt_min_dif,
    substr(nvl(obter_nome_pf_oculto_senhas(a.cd_pessoa_fisica, 'O'),a.nm_paciente),1,250) nm_paciente,
--utilização de sub consulta como coluna da consulta principal
    (select decode(count(*),0,'N','S') 
	from paciente_senha_fila x ,
        movimentacao_senha_fila z
    where z.nr_seq_fila_espera = x.nr_seq_fila_senha
        and z.nr_seq_pac_senha_fila = x.nr_sequencia
        and x.nr_sequencia = a.nr_sequencia
        and x.nr_seq_fila_senha = c.nr_seq_fila_espera
        and z.dt_saida is null
        and x.dt_inicio_atendimento is null
        and x.dt_inutilizacao is null
        and c.dt_saida is null) ie_pendente,
	(select max(d.dt_atualizacao_nrec)
	from paciente_senha_fila_hist d
	where d.nr_seq_senha = a.nr_sequencia
        and	c.dt_entrada < d.dt_atualizacao_nrec
        and	d.dt_atualizacao_nrec < nvl(c.dt_saida,sysdate)) dt_chamada,
	(select	max(s.nm_usuario_inicio)
	from atendimentos_senha s
	where s.nr_seq_pac_senha_fila = a.nr_sequencia
        and	s.dt_inicio_atendimento between c.dt_entrada and nvl(c.dt_saida, sysdate)) nm_usuario_atend,
	(select	max(z.nm_usuario)
    from paciente_senha_transf_hist z 
	where z.nr_seq_senha = c.nr_seq_pac_senha_fila
		and	((z.nr_fila_origem = c.nr_seq_fila_espera) or (c.dt_saida is null and z.nr_fila_origem is null))
		and	z.dt_atualizacao = nvl(c.dt_saida, a.dt_fim_atendimento)) nm_usuario_transferencia,
	(select	substr(max(m.ds_local),1,100)
	from atendimentos_senha s,
        maquina_local_senha m
	where s.nr_seq_pac_senha_fila = a.nr_sequencia
        and m.nr_sequencia = s.nr_seq_local_chamada
        and s.dt_inicio_atendimento between c.dt_entrada and nvl(c.dt_saida, sysdate)) ds_guiche
--tabela de registro de senhas geradas
from paciente_senha_fila a
--tabela cadastro de fila de atendimento
    inner join fila_espera_senha b
        on nvl(a.nr_seq_fila_senha, a.nr_seq_fila_senha_origem) = b.nr_sequencia
--tabela de registro de transferencia de fila da senha
    inner join movimentacao_senha_fila c
        on a.nr_sequencia = c.nr_seq_pac_senha_fila
--tabela registro do atendimento
    left join atendimento e
        on a.nr_sequencia = e.nr_seq_pac_senha_fila
--condições
where upper(substr(obter_letra_verifacao_senha(nvl(a.nr_seq_fila_senha_origem, a.nr_seq_fila_senha)),1,10) || a.cd_senha_gerada) = upper('52840') 
    and a.dt_geracao_senha between to_date('12/12/2022 ','dd/mm/yyyy hh24:mi:ss') and to_date('12/12/2022 23:59:59','dd/mm/yyyy hh24:mi:ss') 
    and a.dt_inutilizacao is null
    and busca_ultima_transf(c.nr_seq_pac_senha_fila, c.nr_seq_fila_espera, c.dt_atualizacao) = c.nr_sequencia
order by a.nr_sequencia, c.dt_entrada;

